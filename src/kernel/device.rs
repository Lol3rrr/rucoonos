use crate::println;

use super::pci::{self, Device};

mod e1000;

pub struct NetworkingDevice {}

pub struct E1000Driver {}

impl E1000Driver {
    pub fn new(device: Device, offset: u64) -> Result<(), ()> {
        println!("Creating Driver based on Device: {:?}", device);

        let card = match device.header_type {
            pci::HeaderType::Generic {
                BaseAddresses,
                CardbusCISPointer,
            } => {
                let bar = BaseAddresses[0].clone();

                e1000::E1000Card::init(bar, offset)
            }
            _ => return Err(()),
        };

        let macaddress = card.read_mac_address();
        println!("Mac-Address: {:?}", macaddress);

        /*
        card.send_packet(&[
            0xf, 0xff, 0xff, 0xff, 0xff, 0xff, //
            0x52, 0x54, 0x00, 0x12, 0x34, 0x56, //
            0x08, 0x06, //
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0,
        ]);
        */

        Ok(())
    }
}
