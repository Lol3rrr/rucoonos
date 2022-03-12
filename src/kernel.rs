use core::{arch::asm, future::Future};

use crate::{
    acpi::{self, OffsetMapper, RSDT},
    allocator, gdt, interrupts,
    memory::{self, BootInfoFrameAllocator},
    println, RUNTIME,
};

use bootloader::boot_info::Optional;
use rucoon::runtime::{AddTaskError, RunError, TaskID};
use x86_64::{structures::paging::OffsetPageTable, VirtAddr};

mod device;
mod pci;

static MEMORY_MAPPING: spin::Once<OffsetPageTable> = spin::Once::new();

pub struct Kernel {
    rsdt: Option<(RSDT<OffsetMapper>, OffsetMapper)>,
}

impl Kernel {
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
    fn setup_pci(physical_memory_offset: Optional<u64>) {
        let offset = match physical_memory_offset {
            Optional::Some(o) => o,
            _ => return,
        };

        let device_header = pci::bruteforce();
        for header in device_header.filter(|d| {
            matches!(
                d.generic.class,
                pci::DeviceClass::NetworkController(pci::NetworkContollerClass::Ethernet)
            )
        }) {
            if header.generic.id == 0x100E && header.generic.vendor_id == 0x8086 {
                println!("E1000 Networking Controller: {:?}", header);
                //device::E1000Driver::new(header, offset);
            } else {
                println!("Unknown Networking-Device: {:?}", header);
            }
        }
    }

    /// Sets up the System to a working state and sets up the Kernel to start running
    pub fn init(boot_info: &'static mut bootloader::BootInfo) -> Self {
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

        Self::setup_pci(boot_info.physical_memory_offset.clone());

        println!("Initialized Kernel");

        Self { rsdt }
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
                .map(|(header, ptr)| unsafe { acpi::acpi::AcipEntry::load(header, ptr, mapper) }),
        )
    }
}
