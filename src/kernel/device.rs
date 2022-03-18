use core::sync::atomic::{AtomicBool, Ordering};

use alloc::{
    boxed::Box,
    collections::{BTreeMap, VecDeque},
    sync::Arc,
};

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
    pub udp_bindings: spin::Mutex<
        BTreeMap<u16, nolock::queues::mpmc::bounded::scq::Sender<networking::udp::Packet>>,
    >,
}

pub enum DeviceHandle {
    Network(NetworkingDeviceHandle),
    Graphics(),
}

pub struct NetworkingDeviceHandle {
    pub mac: [u8; 6],
    pub ip: Option<[u8; 4]>,
    pub p_queue: PacketQueueSender,
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
    pub ips: &'m networking::IpMap,
    pub udp_bindings:
        &'m BTreeMap<u16, nolock::queues::mpmc::bounded::scq::Sender<networking::udp::Packet>>,
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
                        let ip = match self.meta.ip.as_ref() {
                            Some(i) => i,
                            None => return,
                        };
                        if ip != arp_packet.dest_ip() {
                            return;
                        }

                        self.queue.enqueue(
                            networking::arp::PacketBuilder::new()
                                .sender(self.meta.mac.clone(), ip.clone())
                                .destination(arp_packet.src_mac, arp_packet.src_ip)
                                .operation(networking::arp::Operation::Response)
                                .finish()
                                .unwrap(),
                        );
                    }
                    arp::Operation::Response => {
                        self.ips.set(arp_packet.src_ip, arp_packet.src_mac);
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
                        let icmp_packet = networking::icmp::Packet::new(ip_packet);

                        match icmp_packet.get_type() {
                            networking::icmp::Type::EchoRequest {
                                sequence,
                                identifier,
                            } => {
                                let ip_packet = icmp_packet.ipv4_packet();
                                let ip_header = ip_packet.header();

                                let resp_ip_builder = networking::ipv4::PacketBuilder::new()
                                    .dscp(0)
                                    .identification(0x3456)
                                    .ttl(10)
                                    .protocol(networking::ipv4::Protocol::Icmp)
                                    .source(ip_header.destination_ip, self.meta.mac.clone())
                                    .destination(ip_header.source_ip, ip_packet.eth().source_mac());

                                let req_payload = icmp_packet.payload();

                                self.queue.enqueue(
                                    networking::icmp::PacketBuilder::new()
                                        .set_type(networking::icmp::Type::EchoReply {
                                            sequence,
                                            identifier,
                                        })
                                        .finish(
                                            resp_ip_builder,
                                            |buffer| {
                                                (&mut buffer[0..(req_payload.len())])
                                                    .copy_from_slice(req_payload);
                                                Ok(req_payload.len())
                                            },
                                            || req_payload.len(),
                                        )
                                        .unwrap(),
                                );
                            }
                            networking::icmp::Type::EchoReply { .. } => {
                                println!("Echo Reply");
                            }
                            networking::icmp::Type::Unknown(d) => {
                                println!("Unknown ICMP: {:?}", d);
                            }
                        };
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
                            match self.udp_bindings.get(&udp_header.destination_port) {
                                Some(bind_queue) => {
                                    let _ = bind_queue.try_enqueue(udp_packet);
                                }
                                None => {
                                    println!("UDP-Header: {:?}", udp_header);
                                    println!("UDP-Packet: {:?}", udp_packet.payload());
                                }
                            };
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

#[derive(Clone)]
pub struct PacketQueueSender {
    queue: Arc<nolock::queues::mpsc::jiffy::Sender<networking::ethernet::Packet>>,
    notify: Arc<dyn Fn() + 'static + Send + Sync>,
}
pub struct PacketQueueReceiver {
    queue: nolock::queues::mpsc::jiffy::Receiver<networking::ethernet::Packet>,
}

fn create_packetqueue<F>() -> (impl FnOnce(F) -> PacketQueueSender, PacketQueueReceiver)
where
    F: Fn() + 'static + Send + Sync,
{
    let (recv, send) = nolock::queues::mpsc::jiffy::queue();

    (
        move |sender| PacketQueueSender {
            queue: Arc::new(send),
            notify: Arc::new(sender),
        },
        PacketQueueReceiver { queue: recv },
    )
}

impl PacketQueueSender {
    pub fn enqueue(&self, packet: networking::ethernet::Packet) {
        let _ = self.queue.enqueue(packet);
        (self.notify)();
    }
}

impl PacketQueueReceiver {
    pub unsafe fn dequeue(&mut self) -> Option<networking::ethernet::Packet> {
        self.queue.try_dequeue().ok()
    }
}
