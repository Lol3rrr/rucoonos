use core::future::Future;

use crate::{
    acpi::{self, OffsetMapper, RSDT},
    gdt, interrupts,
    memory::{self, BootInfoFrameAllocator},
    println, RUNTIME,
};

use alloc::{boxed::Box, vec::Vec};
use bootloader::boot_info::Optional;
use rucoon::runtime::{AddTaskError, RunError, TaskID};
use x86_64::{structures::paging::OffsetPageTable, VirtAddr};

mod allocator;
pub mod device;
pub mod networking;
mod pci;

static MEMORY_MAPPING: spin::Once<OffsetPageTable> = spin::Once::new();

pub static KERNEL_INSTANCE: spin::Once<Kernel> = spin::Once::new();

pub struct Kernel {
    rsdt: Option<(RSDT<OffsetMapper>, OffsetMapper)>,
    devices: spin::Mutex<Vec<device::Device>>,
    pub ips: networking::IpMap,
}

impl Kernel {
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

    /// This is used to obtain configuration about PCI
    fn setup_pci(physical_memory_offset: Optional<u64>) -> Vec<device::Device> {
        let offset = match physical_memory_offset {
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
                if header.generic.id == 0x100E && header.generic.vendor_id == 0x8086 {
                    println!("E1000 Networking Controller: {:?}", header);

                    match device::E1000Driver::new(header, offset) {
                        Ok((n_device, meta, n_queue)) => {
                            Some(device::Device::Network(device::NetworkDevice {
                                device: Box::new(n_device),
                                metadata: meta,
                                packet_queue: n_queue,
                            }))
                        }
                        Err(_) => None,
                    }
                } else {
                    println!("Unknown Networking-Device: {:?}", header);
                    None
                }
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
            ips: networking::IpMap::new(),
        };
        KERNEL_INSTANCE.call_once(|| instance)
    }

    pub fn add_task<F>(&self, fut: F) -> Result<TaskID, AddTaskError>
    where
        F: Future + 'static,
    {
        RUNTIME.add_task(fut)
    }

    pub fn start_runtime(&self) -> Result<(), RunError> {
        RUNTIME.run()
    }

    pub fn get_rsdt_entries(&self) -> Option<impl Iterator<Item = acpi::acpi::AcipEntry> + '_> {
        let (rsdt, mapper) = self.rsdt.as_ref()?;

        Some(
            rsdt.iter()
                .map(|(header, ptr)| acpi::acpi::AcipEntry::load(header, ptr, mapper)),
        )
    }

    pub fn handle_networking_interrupt(&self) {
        // println!("Kernel handle Networking Interrupt");

        let mut devices = self.devices.lock();
        for device in devices.iter_mut() {
            let (n_device, meta, queue) = match device {
                device::Device::Network(device::NetworkDevice {
                    device,
                    metadata,
                    packet_queue,
                    ..
                }) => (device, metadata, packet_queue),
                _ => continue,
            };

            if !n_device.handles_interrupt(0xb) {
                continue;
            }

            let mut ctx = device::NetworkingCtx {
                meta,
                queue,
                ips: &self.ips,
            };
            n_device.handle_interrupt(&mut ctx);
        }
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
}
