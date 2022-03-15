use alloc::{boxed::Box, collections::VecDeque, sync::Arc};

use crate::{kernel::networking::arp, println};

use super::{
    networking::{self, ethernet::EthType},
    pci,
};

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
}

pub struct NetworkingCtx {}

pub struct E1000Driver {}

impl E1000Driver {
    pub fn new(device: pci::Device, offset: u64) -> Result<impl NetworkingDevice, ()> {
        device.enable_bus_mastering();

        let (mut card, sender) = match device.header_type {
            pci::HeaderType::Generic { base_addresses, .. } => {
                let bar = base_addresses[0].clone();

                let (sender, receiver) = create_packetqueue();
                let card = e1000::E1000Card::init(bar, offset, receiver);
                (card, sender)
            }
            _ => return Err(()),
        };

        card.enable_interrupts();

        sender.enqueue(
            networking::arp::PacketBuilder::new()
                .sender(card.read_mac_address(), [0, 0, 0, 0])
                .destination([0, 0, 0, 0, 0, 0], [192, 168, 1, 1])
                .operation(1)
                .finish()
                .unwrap(),
        );

        Ok(card)
    }
}

impl NetworkingCtx {
    pub fn handle_packet(&self, raw_packet: &[u8], nic_mac: [u8; 6]) {
        let buffer = networking::Buffer::new(raw_packet);

        let eth_packet = networking::ethernet::Packet::new(buffer);

        let destination = eth_packet.destination_mac();
        if destination != [0xff, 0xff, 0xff, 0xff, 0xff, 0xff] && destination != nic_mac {
            return;
        }

        /*
        println!(
            "Src: {:?} - Dest: {:?}",
            eth_packet.source_mac(),
            eth_packet.destination_mac(),
        );
        */

        let ty = eth_packet.ether_type();
        match ty {
            EthType::Arp => {
                let arp_packet = networking::arp::Packet::new(eth_packet).unwrap();

                match arp_packet.operation() {
                    arp::Operation::Request => {
                        println!("Arp-Request for IP: {:?}", arp_packet.dest_ip());
                    }
                    arp::Operation::Response => {
                        println!("Arp-Response");
                    }
                    arp::Operation::Unknown(unknown) => {
                        println!("Unknown ARP-Operation: {:?}", unknown);
                    }
                };
            }
            EthType::WakeOnLan => {
                println!("WakeOnLan: {:?}", eth_packet.content());
            }
            EthType::Ipv4 => {
                println!("IPv4: {:?}", eth_packet.content());
            }
            EthType::Ipv6 => {
                println!("IPv6: {:?}", eth_packet.content());
            }
            EthType::Unknown(_tag) => {
                // println!("Unknown({:?}): {:?}", tag, eth_packet.content());
            }
        };
    }
}

pub struct PacketQueueSender {
    queue: Arc<spin::Mutex<VecDeque<networking::ethernet::Packet>>>,
}
// TODO
pub struct PacketQueueReceiver {
    queue: Arc<spin::Mutex<VecDeque<networking::ethernet::Packet>>>,
}

fn create_packetqueue() -> (PacketQueueSender, PacketQueueReceiver) {
    let queue = Arc::new(spin::Mutex::new(VecDeque::new()));

    (
        PacketQueueSender {
            queue: queue.clone(),
        },
        PacketQueueReceiver { queue },
    )
}

impl PacketQueueSender {
    pub fn enqueue(&self, packet: networking::ethernet::Packet) {
        x86_64::instructions::interrupts::without_interrupts(|| {
            self.queue.lock().push_back(packet);
        });
    }
}

impl PacketQueueReceiver {
    pub unsafe fn dequeue(&mut self) -> Option<networking::ethernet::Packet> {
        self.queue.lock().pop_front()
    }
}
