use crate::println;

// https://wiki.osdev.org/PCI#Enumerating_PCI_Buses

const PCI_COMMAND: u8 = 0x4;

const CONFIG_ADDRESS: u16 = 0xCF8;
const CONFIG_DATA: u16 = 0xCFC;

fn address(bus: u8, slot: u8, func: u8, offset: u8) -> u32 {
    let lbus = bus as u32;
    let lslot = slot as u32;
    let lfunc = func as u32;
    let offset = offset as u32;

    (lbus << 16) | (lslot << 11) | (lfunc << 8) | (offset & 0xFC) | (0x80000000)
}

pub fn read_32bit(bus: u8, slot: u8, func: u8, offset: u8) -> u32 {
    let address = address(bus, slot, func, offset);
    let mut outport = x86_64::instructions::port::Port::new(CONFIG_ADDRESS);
    unsafe {
        outport.write(address);
    }

    let mut inport: x86_64::instructions::port::Port<u32> =
        x86_64::instructions::port::Port::new(CONFIG_DATA);
    let raw_result: u32 = unsafe { inport.read() };

    raw_result
}

pub fn read_word(bus: u8, slot: u8, func: u8, offset: u8) -> u16 {
    let address = address(bus, slot, func, offset);

    let offset = offset as u32;

    let mut outport = x86_64::instructions::port::Port::new(0xCF8);
    unsafe {
        outport.write(address);
    }

    let mut inport: x86_64::instructions::port::Port<u32> =
        x86_64::instructions::port::Port::new(0xCFC);
    let raw_result: u32 = unsafe { inport.read() };

    let result: u32 = (raw_result >> ((offset & 2) * 8)) & 0xffff;

    result as u16
}

#[derive(Debug)]
pub struct GenericHeader {
    pub id: u16,
    pub vendor_id: u16,
    pub status: u16,
    pub command: u16,
    pub class: DeviceClass,
    pub revision_id: u8,
    pub bist: u8,
    pub latency_timer: u8,
    pub cache_line_size: u8,
}

#[derive(Debug)]
pub struct Device {
    pub bus: u8,
    pub slot: u8,
    pub func: u8,
    pub generic: GenericHeader,
    pub header_type: HeaderType,
}

impl Device {
    pub fn enable_bus_mastering(&self) {
        let address = address(self.bus, self.slot, self.func, PCI_COMMAND);
        let mut address_port = x86_64::instructions::port::Port::new(CONFIG_ADDRESS);
        unsafe {
            address_port.write(address);
        }

        let mut data_port = x86_64::instructions::port::Port::<u32>::new(CONFIG_DATA);
        let previous = unsafe { data_port.read() };
        unsafe {
            data_port.write(previous | (1 << 2));
        }
    }
}

#[derive(Debug, Clone)]
pub enum BaseAddressRegister {
    MemorySpace {
        address: u32,
        prefetchable: bool,
        ty: u8,
    },
    IOSpace {
        address: u32,
    },
}

impl From<u32> for BaseAddressRegister {
    fn from(raw: u32) -> Self {
        match raw & 0x1 {
            0 => {
                let address = raw & 0xfffffff0;

                let raw_ty = raw & 0b110;

                let prefetchable = (raw & 0b1000) == 1;

                Self::MemorySpace {
                    address,
                    prefetchable,
                    ty: raw_ty as u8,
                }
            }
            1 => {
                println!("IO Address");
                Self::IOSpace { address: 0 }
            }
            _ => unreachable!(""),
        }
    }
}

#[derive(Debug)]
pub enum HeaderType {
    Generic {
        base_addresses: [BaseAddressRegister; 6],
        cardbus_cis_pointer: u32,
        interrupt_line: u8,
    },
    Unknown {
        ty: u8,
    },
}

#[derive(Debug)]
pub enum DeviceClass {
    NetworkController(NetworkContollerClass),
    DisplayController(DisplayControllerClass),
    Unknown { class: u16, subclass: u16 },
}

#[derive(Debug)]
pub enum NetworkContollerClass {
    Ethernet,
    Unknown { subclass: u16 },
}

#[derive(Debug)]
pub enum DisplayControllerClass {
    VGACompatible {},
    Unknown { subclass: u16 },
}

fn load_device(bus: u8, device: u8) -> Option<Device> {
    let function: u8 = 0;

    let vendorid = read_word(bus, device, function, 0x0);
    if vendorid == 0xffff {
        return None;
    }

    let device_id = read_word(bus, device, function, 0x2);

    let second_row = read_32bit(bus, device, function, 0x4);

    let baseclass = (read_word(bus, device, function, 0xa) & 0xff00) >> 8;
    let subclass = read_word(bus, device, function, 0xa) & 0x00ff;

    let prog_if = (read_word(bus, device, function, 0x8) & 0xff00) >> 8;
    let revision_id = (read_word(bus, device, function, 0x8) & 0x00ff) as u8;

    let bist = ((read_word(bus, device, function, 0xE) & 0xff00) >> 8) as u8;
    let raw_header_type = (read_word(bus, device, function, 0xE) & 0x00ff) as u8;

    let class = match (baseclass, subclass) {
        (0x2, sub) => {
            let network_class = match sub {
                0x0 => NetworkContollerClass::Ethernet,
                s => NetworkContollerClass::Unknown { subclass: s },
            };
            DeviceClass::NetworkController(network_class)
        }
        (0x3, sub) => {
            let display_class = match sub {
                0x0 => DisplayControllerClass::VGACompatible {},
                s => DisplayControllerClass::Unknown { subclass: s },
            };
            println!("PROG_IF: 0x{:x}", prog_if);
            DeviceClass::DisplayController(display_class)
        }
        (b, s) => DeviceClass::Unknown {
            class: b,
            subclass: s,
        },
    };

    let header_type = match raw_header_type {
        0x00 => {
            let base_addresses = [
                read_32bit(bus, device, function, 0x10).into(),
                read_32bit(bus, device, function, 0x14).into(),
                read_32bit(bus, device, function, 0x18).into(),
                read_32bit(bus, device, function, 0x1C).into(),
                read_32bit(bus, device, function, 0x20).into(),
                read_32bit(bus, device, function, 0x24).into(),
            ];
            let cis_poiner = read_32bit(bus, device, function, 0x28);

            let last_line = read_32bit(bus, device, function, 0x3c);

            HeaderType::Generic {
                base_addresses,
                cardbus_cis_pointer: cis_poiner,
                interrupt_line: (last_line & 0x000000ff) as u8,
            }
        }
        other => HeaderType::Unknown { ty: other },
    };

    Some(Device {
        bus,
        slot: device,
        func: function,
        generic: GenericHeader {
            id: device_id,
            vendor_id: vendorid,
            status: 0,
            command: 0,
            class,
            revision_id,
            bist,
            latency_timer: 0,
            cache_line_size: 0,
        },
        header_type,
    })
}

pub fn bruteforce() -> impl Iterator<Item = Device> {
    (0..255)
        .flat_map(|bus| (0..32).map(move |device| (bus, device)))
        .filter_map(|(bus, device)| load_device(bus, device))
}
