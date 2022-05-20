use crate::hardware::pci;

/// A small Abstraction for the Read/Write interactions with the Card
#[derive(Debug, Clone)]
pub struct Coms {
    bar: pci::BaseAddressRegister,
    offset: u64,
}

impl Coms {
    pub fn new(bar: pci::BaseAddressRegister, offset: u64) -> Self {
        Self { bar, offset }
    }

    pub fn write_command(&self, p_address: u16, value: u32) {
        match &self.bar {
            pci::BaseAddressRegister::MemorySpace { address, .. } => {
                let target_address = *address as u64 + p_address as u64 + self.offset;
                let target_ptr = target_address as *mut u32;
                unsafe {
                    target_ptr.write_volatile(value);
                }
            }
            pci::BaseAddressRegister::IOSpace { address } => {
                todo!("Write Command to IOSpace Bar");
            }
        };
    }

    pub fn read_command(&self, p_address: u16) -> u32 {
        match &self.bar {
            pci::BaseAddressRegister::MemorySpace { address, .. } => {
                let target_address = *address as u64 + p_address as u64 + self.offset;
                let target_ptr = target_address as *mut u32;
                unsafe { target_ptr.read_volatile() }
            }
            pci::BaseAddressRegister::IOSpace { address } => {
                todo!("Read Command to IOSpace Bar")
            }
        }
    }
}
