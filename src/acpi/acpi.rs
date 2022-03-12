use crate::{
    acpi::{VirtualPtr, RSDT},
    println,
};

use super::{Mapper, PhysicalPtr, RSDTHeader};

mod aml;

pub mod raw {
    #[derive(Debug)]
    #[repr(packed)]
    pub struct GenericAddressStructure {
        AddressSpace: u8,
        BitWidth: u8,
        BitOffset: u8,
        AccessSize: u8,
        Address: u64,
    }

    #[derive(Debug)]
    #[repr(packed)]
    pub struct FADT {
        FirmwareCtrl: u32,
        pub Dsdt: u32,
        Reserved: u8,
        PreferredPowerManagementProfile: u8,
        SCI_Interrupt: u16,
        SMI_CommandPort: u32,
        AcpiEnable: u8,
        AcpiDisable: u8,
        S4BIOS_REQ: u8,
        PSTATE_Control: u8,
        PM1aEventBlock: u32,
        PM1bEventBlock: u32,
        PM1aControlBlock: u32,
        PM1bControlBlock: u32,
        PM2ControlBlock: u32,
        PMTimerBlock: u32,
        GPE0Block: u32,
        GPE1Block: u32,
        PM1EventLength: u8,
        PM1ControlLength: u8,
        PM2ControlLength: u8,
        PMTimerLength: u8,
        GPE0Length: u8,
        GPE1Length: u8,
        GPE1Base: u8,
        CStateControl: u8,
        WorstC2Latency: u16,
        WorstC3Latency: u16,
        FlushSize: u16,
        FlushStride: u16,
        DutyOffset: u8,
        DutyWidth: u8,
        DayAlarm: u8,
        MonthAlarm: u8,
        Century: u8,
        BootArchitectureFlags: u16,
        Reserved2: u8,
        Flags: u32,
        ResetReg: GenericAddressStructure,
        ResetValue: u8,
        Reserved3: [u8; 3],
        X_FirmwareControl: u64,
        X_Dsdt: u64,
        X_PM1aEventBlock: GenericAddressStructure,
        X_PM1bEventBlock: GenericAddressStructure,
        X_PM1aControlBlock: GenericAddressStructure,
        X_PM1bControlBlock: GenericAddressStructure,
        X_PM2ControlBlock: GenericAddressStructure,
        X_PMTimerBlock: GenericAddressStructure,
        X_GPE0Block: GenericAddressStructure,
        X_GPE1Block: GenericAddressStructure,
    }
}

pub enum AcipEntry {
    Apic(AcipApicEntry),
    FADT(raw::FADT),
    HighPrecisionEventTimer {
        header: RSDTHeader,
        ptr: PhysicalPtr,
    },
    WindowsACPIEmulatedDevices {
        header: RSDTHeader,
        ptr: PhysicalPtr,
    },
    Unknown {
        header: RSDTHeader,
        ptr: PhysicalPtr,
    },
}

impl AcipEntry {
    pub fn load<M>(header: RSDTHeader, other: PhysicalPtr, mapping: &M) -> Self
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
                    remaining: header.length - 8 - (core::mem::size_of::<RSDTHeader>() as u32),
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
