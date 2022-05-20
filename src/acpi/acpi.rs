use super::{Mapper, PhysicalPtr, SDTHeader};

mod aml;

pub mod raw {
    #[repr(packed)]
    pub struct GenericAddressStructure {
        pub address_space: u8,
        pub bit_width: u8,
        pub bit_offset: u8,
        pub access_size: u8,
        pub address: u64,
    }

    #[repr(packed)]
    pub struct FADT {
        pub firmware_ctrl: u32,
        pub dsdt: u32,
        _reserved: u8,
        pub preferred_power_management_profile: u8,
        pub sci_interrupt: u16,
        pub smi_command_port: u32,
        pub acpi_enable: u8,
        pub acpi_disable: u8,
        pub s4bios_req: u8,
        pub pstate_control: u8,
        pub pm1a_event_block: u32,
        pub pm1b_event_block: u32,
        pub pm1a_control_block: u32,
        pub pm1b_control_block: u32,
        pub pm2_control_block: u32,
        pub pmtimer_block: u32,
        pub gpe0_block: u32,
        pub gpe1_block: u32,
        pub pm1_event_length: u8,
        pub pm1_control_length: u8,
        pub pm2_control_length: u8,
        pub pmtimer_length: u8,
        pub gpe0_length: u8,
        pub gpe1_length: u8,
        pub gpe1_base: u8,
        pub cstate_control: u8,
        pub worst_c2_latency: u16,
        pub worst_c3_latency: u16,
        pub flush_size: u16,
        pub flush_stride: u16,
        pub duty_offset: u8,
        pub duty_width: u8,
        pub day_alarm: u8,
        pub month_alarm: u8,
        pub century: u8,
        pub boot_architecture_flags: u16,
        _reserved2: u8,
        pub flags: u32,
        pub reset_reg: GenericAddressStructure,
        pub reset_value: u8,
        _reserved3: [u8; 3],
        pub x_firmware_control: u64,
        pub x_dsdt: u64,
        pub x_pm1a_event_block: GenericAddressStructure,
        pub x_pm1b_event_block: GenericAddressStructure,
        pub x_pm1a_control_block: GenericAddressStructure,
        pub x_pm1b_control_block: GenericAddressStructure,
        pub x_pm2_control_block: GenericAddressStructure,
        pub x_pmtimer_block: GenericAddressStructure,
        pub x_gpe0_block: GenericAddressStructure,
        pub x_gpe1_block: GenericAddressStructure,
    }
}

pub enum AcipEntry {
    Apic(AcipApicEntry),
    FADT(raw::FADT),
    HighPrecisionEventTimer { header: SDTHeader, ptr: PhysicalPtr },
    WindowsACPIEmulatedDevices { header: SDTHeader, ptr: PhysicalPtr },
    Unknown { header: SDTHeader, ptr: PhysicalPtr },
}

impl AcipEntry {
    pub fn load<M>(header: SDTHeader, other: PhysicalPtr, mapping: &M) -> Self
    where
        M: Mapper + Clone,
    {
        let signature = header.signature();

        match signature {
            "APIC" => {
                let ptr = other.translate(mapping);

                let local_addr = unsafe { ptr.read::<u32>() };
                let flags = unsafe { ptr.add_raw(4).read::<u32>() };

                Self::Apic(AcipApicEntry {
                    local_addr,
                    flags,
                    starting_addr: other.add_raw(8),
                    remaining: header.length - 8 - (core::mem::size_of::<SDTHeader>() as u32),
                })
            }
            "FACP" => {
                // TODO

                let ptr = other.translate(mapping);
                let raw_fadt = unsafe { ptr.read::<raw::FADT>() };

                /*
                println!("Raw-FADT: {:?}", raw_fadt);

                let dsdt_ptr = PhysicalPtr::new(raw_fadt.Dsdt as u64);

                let dsdt_header = unsafe { RSDTHeader::load(dsdt_ptr, mapping) };

                let dsdt_content_start_ptr = dsdt_ptr.add_raw(36).translate(mapping);
                let dsdt_content_length = header.length as usize - 36;

                let content = unsafe {
                    core::slice::from_raw_parts(
                        dsdt_content_start_ptr.as_ptr::<u8>(),
                        dsdt_content_length,
                    )
                };
                */

                Self::FADT(raw_fadt)
            }
            "HPET" => Self::HighPrecisionEventTimer { header, ptr: other },
            "WAET" => Self::WindowsACPIEmulatedDevices { header, ptr: other },
            _ => Self::Unknown { header, ptr: other },
        }
    }
}

#[derive(Debug)]
pub struct AcipApicEntry {
    local_addr: u32,
    flags: u32,
    starting_addr: PhysicalPtr,
    remaining: u32,
}

impl AcipApicEntry {
    pub fn entries<M>(&self, mapper: M) -> APICEntryIter<M> {
        APICEntryIter {
            ptr: self.starting_addr,
            remaining_size: self.remaining,
            mapping: mapper,
        }
    }
}

#[derive(Debug)]
pub enum APICEntry {
    ProcessLocal {
        processor_id: u8,
        apic_id: u8,
        flags: u32,
    },
    IOApic {
        id: u8,
        _reserved: u8,
        address: u32,
        gsi_base: u32,
    },
    IOApicInterruptSourceOverride {
        bus_source: u8,
        irq_source: u8,
        gsi: u32,
        flags: u16,
    },
    LocalApicNonMaskableInterrupts {
        acpi_processor_id: u8,
        flags: u16,
        lint: u8,
    },
    Unknown {
        id: u8,
    },
}

pub struct APICEntryIter<M> {
    ptr: PhysicalPtr,
    remaining_size: u32,
    mapping: M,
}

impl<M> Iterator for APICEntryIter<M>
where
    M: Mapper,
{
    type Item = APICEntry;

    fn next(&mut self) -> Option<Self::Item> {
        if self.remaining_size == 0 {
            return None;
        }

        let ptr = self.ptr.translate(&self.mapping);

        let e_type = unsafe { ptr.read::<u8>() };
        let e_length = unsafe { ptr.add_raw(1).read::<u8>() };

        let entry = match e_type {
            0 => {
                let processor_id = unsafe { ptr.add_raw(2).read::<u8>() };
                let apic_id = unsafe { ptr.add_raw(3).read::<u8>() };
                let flags = unsafe { ptr.add_raw(4).read::<u32>() };

                APICEntry::ProcessLocal {
                    processor_id,
                    apic_id,
                    flags,
                }
            }
            1 => {
                let apic_id = unsafe { ptr.add_raw(2).read::<u8>() };
                let reserved = unsafe { ptr.add_raw(3).read::<u8>() };
                let address = unsafe { ptr.add_raw(4).read::<u32>() };
                let gsi_base = unsafe { ptr.add_raw(8).read::<u32>() };

                APICEntry::IOApic {
                    id: apic_id,
                    _reserved: reserved,
                    address,
                    gsi_base,
                }
            }
            2 => {
                let bus_source = unsafe { ptr.add_raw(2).read::<u8>() };
                let irq_source = unsafe { ptr.add_raw(3).read::<u8>() };
                let gsi = unsafe { ptr.add_raw(4).read::<u32>() };
                let flags = unsafe { ptr.add_raw(8).read::<u16>() };

                APICEntry::IOApicInterruptSourceOverride {
                    bus_source,
                    irq_source,
                    gsi,
                    flags,
                }
            }
            4 => {
                let acpi_processor_id = unsafe { ptr.add_raw(2).read::<u8>() };
                let flags = unsafe { ptr.add_raw(3).read::<u16>() };
                let lint = unsafe { ptr.add_raw(5).read::<u8>() };

                APICEntry::LocalApicNonMaskableInterrupts {
                    acpi_processor_id,
                    flags,
                    lint,
                }
            }
            unknown => APICEntry::Unknown { id: unknown },
        };

        self.ptr = self.ptr.add_raw(e_length as u64);
        self.remaining_size -= e_length as u32;

        Some(entry)
    }
}
