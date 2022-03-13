use alloc::vec::Vec;

use crate::println;

use super::pci::{self, Device};

mod e1000;

pub struct NetworkingDevice {}

pub struct E1000Driver {}

impl E1000Driver {
    pub fn new(device: Device, offset: u64) -> Result<(), ()> {
        println!("Creating Driver based on Device: {:?}", device);

        device.enable_bus_mastering();

        let card = match device.header_type {
            pci::HeaderType::Generic {
                BaseAddresses,
                CardbusCISPointer,
                interrupt_line,
            } => {
                println!("Interrupt-Line: 0x{:x}", interrupt_line);
                let bar = BaseAddresses[0].clone();

                e1000::E1000Card::init(bar, offset)
            }
            _ => return Err(()),
        };

        let macaddress = card.read_mac_address();
        println!("Mac-Address: {:?}", macaddress);

        let mut eth = Ethernet::new(card);

        // Send ARP Requests for IP-Address 192.168.178.20
        for _ in 0..20 {
            send_arp(&mut eth, [192, 168, 178, 20]);
        }

        Ok(())
    }
}

pub struct Ethernet {
    mac_address: [u8; 6],
    card: e1000::E1000Card,
}

impl Ethernet {
    pub fn new(card: e1000::E1000Card) -> Self {
        let mac = card.read_mac_address();

        Self {
            mac_address: mac,
            card,
        }
    }

    pub fn get_mac(&self) -> &[u8; 6] {
        &self.mac_address
    }

    pub fn send_packet(&mut self, target: [u8; 6], ty: [u8; 2], data: &[u8]) {
        let mut final_buffer = Vec::with_capacity(data.len() + 14);

        final_buffer.extend(target);
        final_buffer.extend(&self.mac_address);
        final_buffer.extend(ty);

        final_buffer.extend(data);

        self.card.send_packet(&final_buffer);
    }
}

pub fn send_arp(eth: &mut Ethernet, ip: [u8; 4]) {
    let mac = eth.get_mac();

    eth.send_packet(
        [0xff, 0xff, 0xff, 0xff, 0xff, 0xff],
        [0x08, 0x06],
        &[
            0, 1, // HType
            0x08, 0x00, // PType
            6, 4, // HLen, PLen
            0, 1, // Request
            mac[0], mac[1], mac[2], mac[3], mac[4], mac[5], // SHA
            0, 0, 0, 0, // SPA
            0, 0, 0, 0, 0, 0, // THA
            ip[0], ip[1], ip[2], ip[3], // TPA
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //
            0, 0, 0, 0, 0, 0, 0, 0,
        ],
    );
}
