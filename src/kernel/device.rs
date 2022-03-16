use core::sync::atomic::{AtomicBool, Ordering};

use alloc::{boxed::Box, collections::VecDeque, sync::Arc};

use crate::{kernel::networking::arp, println};

use super::{
    networking::{self, ethernet::EthType},
    pci,
};

mod e1000;

pub enum Device {
    Network(NetworkDevice),
    Graphics(),
}

pub struct NetworkDevice {
    /// A handle to the actual underlying Device/Driver
    pub device: Box<dyn NetworkingDevice + Send + 'static>,
    /// The Queue to enqueue Packets on to send out over the Queue
    pub packet_queue: PacketQueueSender,
    pub metadata: NetworkingMetadata,
}

pub struct NetworkingMetadata {
    pub mac: [u8; 6],
    pub ip: Option<[u8; 4]>,
    dhcp: DHCPExchange,
}

pub enum DHCPExchange {
    Initial,
    Discover {
        indicator: Arc<AtomicBool>,
        transaction_id: u32,
    },
    Requested {
        indicator: Arc<AtomicBool>,
        transaction_id: u32,
        own_ip: [u8; 4],
        server_ip: [u8; 4],
    },
    Done,
}

pub trait NetworkingDevice {
    /// Checks if the Networking Device is registered for a given interrupt
    fn handles_interrupt(&self, irq_offset: u8) -> bool;

    /// Gets called if an interrupt occurs for the Networking Device
    fn handle_interrupt(&mut self, ctx: &mut NetworkingCtx);
}

pub struct NetworkingCtx<'m> {
    pub meta: &'m mut NetworkingMetadata,
    pub queue: &'m PacketQueueSender,
}

pub struct E1000Driver {}

impl E1000Driver {
    pub fn new(
        device: pci::Device,
        offset: u64,
    ) -> Result<(impl NetworkingDevice, NetworkingMetadata, PacketQueueSender), ()> {
        device.enable_bus_mastering();

        let (mut card, sender) = match device.header_type {
            pci::HeaderType::Generic { base_addresses, .. } => {
                let bar = base_addresses[0].clone();

                let (sender, receiver) = create_packetqueue();
                let (card, send_notify) = e1000::E1000Card::init(bar, offset, receiver);
                (card, sender(send_notify))
            }
            _ => return Err(()),
        };

        card.enable_interrupts();

        let meta = NetworkingMetadata {
            mac: card.read_mac_address(),
            ip: None,
            dhcp: DHCPExchange::Initial,
        };

        Ok((card, meta, sender))
    }
}

impl NetworkDevice {
    pub fn blocking_init(&mut self) -> Result<impl FnOnce(), ()> {
        if self.metadata.ip.is_some() {
            return Err(());
        }

        let indicator = Arc::new(AtomicBool::new(false));

        let tx_id = 0x12345678;
        self.metadata.dhcp = DHCPExchange::Discover {
            indicator: indicator.clone(),
            transaction_id: tx_id,
        };

        self.packet_queue
            .enqueue(networking::dhcp::discover_message(self.metadata.mac.clone(), tx_id).unwrap());

        Ok(move || loop {
            if indicator.load(Ordering::SeqCst) {
                return;
            }

            x86_64::instructions::hlt();
        })
    }
}

impl<'m> NetworkingCtx<'m> {
    pub fn handle_packet(&mut self, raw_packet: &[u8]) {
        let buffer = networking::Buffer::new(raw_packet);

        let eth_packet = networking::ethernet::Packet::new(buffer);

        let destination = eth_packet.destination_mac();
        if destination != [0xff, 0xff, 0xff, 0xff, 0xff, 0xff] && destination != self.meta.mac {
            return;
        }

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
                let ip_packet = networking::ipv4::Packet::new(eth_packet);

                match ip_packet.header().protocol {
                    networking::ipv4::Protocol::Icmp => {
                        println!("ICMP-Packet");
                    }
                    networking::ipv4::Protocol::Udp => {
                        let udp_packet = networking::udp::Packet::new(ip_packet);

                        let udp_header = udp_packet.header();
                        if udp_header.source_port == 67 && udp_header.destination_port == 68 {
                            let dhcp_packet = networking::dhcp::Packet::new(udp_packet);
                            let dhcp_data = dhcp_packet.get();

                            match (
                                core::mem::replace(&mut self.meta.dhcp, DHCPExchange::Initial),
                                &dhcp_data.operation,
                            ) {
                                (
                                    DHCPExchange::Discover {
                                        transaction_id,
                                        indicator,
                                    },
                                    networking::dhcp::Operation::Offer,
                                ) if transaction_id == dhcp_data.xid => {
                                    let offered_ip = dhcp_data.yiaddr;
                                    let server_ip = dhcp_data.siaddr;

                                    self.queue.enqueue(
                                        networking::dhcp::request_message(
                                            self.meta.mac.clone(),
                                            transaction_id,
                                            offered_ip.clone(),
                                            server_ip.clone(),
                                        )
                                        .unwrap(),
                                    );

                                    self.meta.dhcp = DHCPExchange::Requested {
                                        indicator,
                                        transaction_id,
                                        own_ip: offered_ip,
                                        server_ip,
                                    };
                                }
                                (
                                    DHCPExchange::Requested {
                                        indicator,
                                        transaction_id,
                                        own_ip,
                                        ..
                                    },
                                    networking::dhcp::Operation::Ack,
                                ) if transaction_id == dhcp_data.xid => {
                                    self.meta.dhcp = DHCPExchange::Done;
                                    self.meta.ip = Some(own_ip);

                                    indicator.store(true, Ordering::SeqCst);
                                }
                                (dhcp, _) => {
                                    println!("Unexpected DHCP-Packet: {:?}", dhcp_data);

                                    self.meta.dhcp = dhcp;
                                }
                            };
                        } else {
                            println!("UDP-Header: {:?}", udp_header);
                            println!("UDP-Packet: {:?}", udp_packet.payload());
                        }
                    }
                    networking::ipv4::Protocol::Tcp => {
                        println!("TCP-Packet");
                    }
                    networking::ipv4::Protocol::Unknown(unknown) => {
                        println!("Unknown({:?})-Packet", unknown);
                    }
                };
            }
            EthType::Ipv6 => {
                // println!("IPv6: {:?}", eth_packet.content());
            }
            EthType::Unknown(_tag) => {
                // println!("Unknown({:?}): {:?}", tag, eth_packet.content());
            }
        };
    }
}

pub struct PacketQueueSender {
    queue: Arc<spin::Mutex<VecDeque<networking::ethernet::Packet>>>,
    notify: Box<dyn Fn() + 'static + Send>,
}
pub struct PacketQueueReceiver {
    queue: Arc<spin::Mutex<VecDeque<networking::ethernet::Packet>>>,
}

fn create_packetqueue<F>() -> (impl FnOnce(F) -> PacketQueueSender, PacketQueueReceiver)
where
    F: Fn() + 'static + Send,
{
    let queue = Arc::new(spin::Mutex::new(VecDeque::new()));

    let recv_queue = queue.clone();
    (
        move |sender| PacketQueueSender {
            queue,
            notify: Box::new(sender),
        },
        PacketQueueReceiver { queue: recv_queue },
    )
}

impl PacketQueueSender {
    pub fn enqueue(&self, packet: networking::ethernet::Packet) {
        x86_64::instructions::interrupts::without_interrupts(|| {
            let mut locked = self.queue.lock();
            locked.push_back(packet);
            if locked.len() == 1 {
                (self.notify)();
            }
        });
    }
}

impl PacketQueueReceiver {
    pub unsafe fn dequeue(&mut self) -> Option<networking::ethernet::Packet> {
        self.queue.lock().pop_front()
    }
}
