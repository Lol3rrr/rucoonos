use crate::{
    acpi::{self, OffsetMapper, RSDT},
    gdt, interrupts,
    memory::{self, BootInfoFrameAllocator},
    println,
};

use alloc::vec::Vec;
use bootloader::boot_info::Optional;
use x86_64::{structures::paging::OffsetPageTable, VirtAddr};

mod allocator;
pub mod device;
mod pci;
mod rng;

static MEMORY_MAPPING: spin::Once<OffsetPageTable> = spin::Once::new();

static KERNEL_INSTANCE: spin::Once<Hardware> = spin::Once::new();

/// This struct contains all the essential Data needed for the running kernel instance
pub struct Hardware {
    /// The parsed out RSDT
    rsdt: Option<(RSDT<OffsetMapper>, OffsetMapper)>,
    /// A list of all loaded Devices
    memory_offset: Option<u64>,
    devices: spin::Mutex<Vec<device::Device>>,
    rng: spin::Mutex<rng::Kiss>,
}

impl Hardware {
    pub fn try_get() -> Option<&'static Self> {
        KERNEL_INSTANCE.get()
    }

    /// This will initialize the IDT, GDT and the PIT
    fn basic_init() {
        x86_64::instructions::interrupts::disable();
        gdt::init();
        interrupts::init_idt();
        unsafe { interrupts::PICS.lock().initialize() };
        x86_64::instructions::interrupts::enable();
    }

    /// Initializes some Video stuff
    fn video_init(boot_info: &'static mut Optional<bootloader::boot_info::FrameBuffer>) {
        if let Optional::Some(buffer) = boot_info {
            println!("Initializing Video...");
            crate::video::init(buffer);
            println!("Initialized Video");
        }
    }

    /// Handles the RSDP and ACIP configuration, which is none at the moment, except trying to
    /// parse it
    fn rsdp_acip_setup(
        rsdp_addr: Optional<u64>,
        physical_memory_offset: Optional<u64>,
    ) -> Option<(RSDT<OffsetMapper>, OffsetMapper)> {
        if let Some(raw_addr) = rsdp_addr.as_ref() {
            let offset = match physical_memory_offset.as_ref() {
                Some(o) => *o,
                None => {
                    panic!("Missing Physical Offset");
                }
            };

            let offset_mapper = acpi::OffsetMapper::new(offset);

            let rsdp =
                unsafe { acpi::RSDP::load(acpi::PhysicalPtr::new(*raw_addr), &offset_mapper) };

            let rsdt = unsafe { rsdp.load_rsdt(offset_mapper.clone()) };

            return Some((rsdt, offset_mapper.clone()));
        }

        None
    }

    /// Sets up the Allocator
    fn memory_setup(
        physical_memory_offset: Optional<u64>,
        memory_regions: &'static mut bootloader::boot_info::MemoryRegions,
    ) -> OffsetPageTable {
        println!("Initialize Memory and Allocator...");

        let mem_offsets = physical_memory_offset.as_ref().unwrap();
        let phys_mem_offset = VirtAddr::new(*mem_offsets);
        let mut mapper = unsafe { memory::init(phys_mem_offset) };
        let mut frame_allocator = unsafe { BootInfoFrameAllocator::init(memory_regions) };

        allocator::init_heap(&mut mapper, &mut frame_allocator)
            .expect("heap initialization failed");

        println!("Initialized Memory and Allocator");

        mapper
    }

    pub fn pci_devices(&self) -> impl Iterator<Item = pci::Device> {
        pci::bruteforce()
    }

    pub fn memory_offset(&self) -> Option<u64> {
        self.memory_offset.clone()
    }

    /// This is used to obtain configuration about PCI
    fn setup_pci(physical_memory_offset: Optional<u64>) -> Vec<device::Device> {
        let _offset = match physical_memory_offset {
            Optional::Some(o) => o,
            _ => return Vec::new(),
        };

        let device_header = pci::bruteforce();
        device_header
            .filter(|d| {
                matches!(
                    d.generic.class,
                    pci::DeviceClass::NetworkController(pci::NetworkContollerClass::Ethernet)
                )
            })
            .filter_map(|header| {
                println!("Unknown PCI-Device: {:?}", header);
                None
            })
            .collect()
    }

    /// Sets up the System to a working state and sets up the Kernel to start running
    pub fn init(boot_info: &'static mut bootloader::BootInfo) -> &Self {
        println!("Initializing Kernel...");
        Self::basic_init();

        let rsdt = Self::rsdp_acip_setup(
            boot_info.rsdp_addr.clone(),
            boot_info.physical_memory_offset.clone(),
        );

        Self::video_init(&mut boot_info.framebuffer);

        let mapper = Self::memory_setup(
            boot_info.physical_memory_offset.clone(),
            &mut boot_info.memory_regions,
        );
        MEMORY_MAPPING.call_once(|| mapper);

        let devices = Self::setup_pci(boot_info.physical_memory_offset.clone());

        println!("Initialized Kernel");

        let instance = Self {
            rsdt,
            devices: spin::Mutex::new(devices),
            memory_offset: boot_info.physical_memory_offset.into(),
            rng: spin::Mutex::new(
                rng::Kiss::new(239812446, 1837621879, 512893, 123873267123).unwrap(),
            ),
        };
        KERNEL_INSTANCE.call_once(|| instance)
    }

    pub fn get_rsdt_entries(&self) -> Option<impl Iterator<Item = acpi::acpi::AcipEntry> + '_> {
        let (rsdt, mapper) = self.rsdt.as_ref()?;

        Some(
            rsdt.iter()
                .map(|(header, ptr)| acpi::acpi::AcipEntry::load(header, ptr, mapper)),
        )
    }

    pub fn with_networking_device<F>(&self, mut func: F)
    where
        F: FnMut(&mut device::NetworkDevice),
    {
        x86_64::instructions::interrupts::without_interrupts(|| {
            let mut devices = self.devices.lock();
            let iter = devices.iter_mut().filter_map(|dev| match dev {
                device::Device::Network(dev) => Some(dev),
                _ => None,
            });

            for dev in iter {
                func(dev);
            }
        });
    }

    pub fn find_device_handle<F>(&self, predicate: F) -> Option<device::DeviceHandle>
    where
        F: Fn(&device::Device) -> bool,
    {
        x86_64::instructions::interrupts::without_interrupts(|| {
            let devices = self.devices.lock();

            let raw_device = devices.iter().find(|d| predicate(d))?;

            let handle = match raw_device {
                device::Device::Network(net_dev) => {
                    device::DeviceHandle::Network(device::NetworkingDeviceHandle {
                        mac: net_dev.metadata.mac,
                        ip: net_dev.metadata.ip,
                        p_queue: net_dev.packet_queue.clone(),
                    })
                }
                device::Device::Graphics() => device::DeviceHandle::Graphics(),
            };
            Some(handle)
        })
    }

    pub fn find_apply_device<F, A, R>(&self, find: F, mut apply: A) -> Option<R>
    where
        F: Fn(&device::Device) -> bool,
        A: FnMut(&device::Device) -> R,
    {
        x86_64::instructions::interrupts::without_interrupts(|| {
            let devices = self.devices.lock();

            let found_device = devices.iter().find(|d| find(d))?;

            Some(apply(found_device))
        })
    }

    pub fn get_rand(&self) -> u64 {
        x86_64::instructions::interrupts::without_interrupts(|| self.rng.lock().rand())
    }
}
