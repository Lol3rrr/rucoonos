use alloc::{boxed::Box, vec::Vec};

use crate::println;

use super::{networking, pci};

mod e1000;

pub enum Device {
    Network(Box<dyn NetworkingDevice + Send + 'static>),
    Graphics(),
}

pub trait NetworkingDevice {
    /// Checks if the Networking Device is registered for a given interrupt
    fn handles_interrupt(&self, irq_offset: u8) -> bool;

    /// Gets called if an interrupt occurs for the Networking Device
    fn handle_interrupt(&mut self, ctx: &NetworkingCtx);

    /// Sends the given Data over the Device
    fn send_packets(&mut self, data: &[u8]);
}

pub struct NetworkingCtx {}

pub struct E1000Driver {}

impl E1000Driver {
    pub fn new(device: pci::Device, offset: u64) -> Result<impl NetworkingDevice, ()> {
        device.enable_bus_mastering();

        let mut card = match device.header_type {
            pci::HeaderType::Generic { BaseAddresses, .. } => {
                let bar = BaseAddresses[0].clone();

                e1000::E1000Card::init(bar, offset)
            }
            _ => return Err(()),
        };

        card.enable_interrupts();

        Ok(card)
    }
}
