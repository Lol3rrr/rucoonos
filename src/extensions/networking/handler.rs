use core::sync::atomic::{AtomicBool, Ordering};

use alloc::{collections::BTreeMap, sync::Arc, vec::Vec};

use crate::{
    extensions::networking::{protocols, ActionRequest},
    hardware::device::{DHCPExchange, NetworkDevice},
    println,
};

use super::{
    protocols::{arp, ethernet::EthType},
    HandlerMessage, RawPacket, IPS,
};

struct Bindings<'m> {
    udp: &'m mut BTreeMap<u16, nolock::queues::mpmc::bounded::scq::Sender<protocols::udp::Packet>>,
    arp: &'m mut BTreeMap<[u8; 4], nolock::queues::spsc::bounded::AsyncBoundedSender<[u8; 6]>>,
    ping: &'m mut BTreeMap<[u8; 4], (core::task::Waker, Arc<AtomicBool>)>,
}

/// This handler will actually properly handle all the Packets that were received by the Network Card
#[tracing::instrument(name = "network_handler", skip(devices, paket_recv))]
pub async fn network_handler(
    mut devices: Vec<NetworkDevice>,
    mut paket_recv: nolock::queues::mpsc::jiffy::AsyncReceiver<HandlerMessage>,
) {
    x86_64::instructions::interrupts::without_interrupts(|| {
        for device in devices.iter_mut() {
            let indicator = Arc::new(AtomicBool::new(false));

            let tx_id = 0x12345678;
            device.metadata.dhcp = DHCPExchange::Discover {
                indicator: indicator.clone(),
                transaction_id: tx_id,
            };

            device.packet_queue.enqueue(
                protocols::dhcp::discover_message(device.metadata.mac.clone(), tx_id, 13).unwrap(),
            );
        }
    });

    tracing::info!("After Init");

    let mut udp_bindings: BTreeMap<
        u16,
        nolock::queues::mpmc::bounded::scq::Sender<protocols::udp::Packet>,
    > = BTreeMap::new();

    let mut arp_bindings: BTreeMap<
        [u8; 4],
        nolock::queues::spsc::bounded::AsyncBoundedSender<[u8; 6]>,
    > = BTreeMap::new();

    let mut ping_bindings: BTreeMap<[u8; 4], (core::task::Waker, Arc<AtomicBool>)> =
        BTreeMap::new();

    // We loop forever because there can always be new packets
    // TODO
    // Probably add something to cancel this when the extension is "unloaded" (although not yet possible)
    loop {
        // Get the Raw Packet information from the Queue
        let raw_message = match paket_recv.dequeue().await {
            Ok(p) => p,
            Err(e) => {
                tracing::error!("Getting Packet {:?}", e);
                return;
            }
        };

        match raw_message {
            HandlerMessage::Packet(raw_paket) => {
                tracing::debug!("Raw-Packet");

                x86_64::instructions::interrupts::without_interrupts(|| {
                    handle_packet_(
                        raw_paket,
                        &mut devices,
                        Bindings {
                            udp: &mut udp_bindings,
                            arp: &mut arp_bindings,
                            ping: &mut ping_bindings,
                        },
                    );
                });
            }
            HandlerMessage::Action(action) => {
                tracing::debug!("Action Message");

                match action {
                    ActionRequest::SendArpRequest { ip, ret_queue } => {
                        tracing::debug!("Sending ARP");

                        arp_bindings.insert(ip, ret_queue);

                        x86_64::instructions::interrupts::without_interrupts(|| {
                            for device in devices.iter() {
                                device.packet_queue.enqueue(
                                    protocols::arp::PacketBuilder::new()
                                        .sender(
                                            device.metadata.mac.clone(),
                                            device.metadata.ip.unwrap_or([0, 0, 0, 0]),
                                        )
                                        .destination(
                                            [0xff, 0xff, 0xff, 0xff, 0xff, 0xff],
                                            ip.clone(),
                                        )
                                        .operation(protocols::arp::Operation::Request)
                                        .finish()
                                        .unwrap(),
                                );
                            }
                        });
                    }
                    ActionRequest::PingRequest {
                        waker,
                        ip,
                        mac,
                        result,
                    } => {
                        tracing::info!("Send Ping");

                        ping_bindings.insert(ip.clone(), (waker, result));

                        x86_64::instructions::interrupts::without_interrupts(|| {
                            for device in devices.iter() {
                                let packet = protocols::icmp::PacketBuilder::new()
                                    .set_type(protocols::icmp::Type::EchoRequest {
                                        identifier: 0x1234,
                                        sequence: 0x2345,
                                    })
                                    .finish(
                                        protocols::ipv4::PacketBuilder::new()
                                            .dscp(0)
                                            .identification(0x1234)
                                            .ttl(20)
                                            .protocol(protocols::ipv4::Protocol::Icmp)
                                            .source(
                                                device.metadata.ip.unwrap_or([0, 0, 0, 0]),
                                                device.metadata.mac,
                                            )
                                            .destination(ip, mac),
                                        |_| Ok(0),
                                        || 0,
                                    )
                                    .expect("");

                                device.packet_queue.enqueue(packet);
                            }
                        });
                    }
                };
            }
        };
    }
}

fn handle_packet_(raw: RawPacket, devices: &mut Vec<NetworkDevice>, bindings: Bindings<'_>) {
    let buffer = raw.buffer;

    let device = devices.iter_mut().find(|d| d.id == raw.id).unwrap();

    let eth_packet = protocols::ethernet::Packet::new(buffer);

    let destination = eth_packet.destination_mac();
    if destination != [0xff, 0xff, 0xff, 0xff, 0xff, 0xff] && destination != device.metadata.mac {
        return;
    }

    let ty = eth_packet.ether_type();
    match ty {
        EthType::Arp => {
            let arp_packet = protocols::arp::Packet::new(eth_packet).unwrap();

            match arp_packet.operation() {
                arp::Operation::Request => {
                    let ip = match device.metadata.ip.as_ref() {
                        Some(i) => i,
                        None => return,
                    };
                    if ip != arp_packet.dest_ip() {
                        return;
                    }

                    device.packet_queue.enqueue(
                        protocols::arp::PacketBuilder::new()
                            .sender(device.metadata.mac.clone(), ip.clone())
                            .destination(arp_packet.src_mac, arp_packet.src_ip)
                            .operation(protocols::arp::Operation::Response)
                            .finish()
                            .unwrap(),
                    );
                }
                arp::Operation::Response => {
                    IPS.get()
                        .expect("")
                        .set(arp_packet.src_ip, arp_packet.src_mac);

                    tracing::debug!("Received ARP for {:?}", arp_packet.src_ip);

                    if let Some(mut listeners) = bindings.arp.remove(&arp_packet.src_ip) {
                        listeners.try_enqueue(arp_packet.src_mac).expect("");
                    }
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
            let ip_packet = protocols::ipv4::Packet::new(eth_packet);

            match ip_packet.header().protocol {
                protocols::ipv4::Protocol::Icmp => {
                    let icmp_packet = protocols::icmp::Packet::new(ip_packet);

                    match icmp_packet.get_type() {
                        protocols::icmp::Type::EchoRequest {
                            sequence,
                            identifier,
                        } => {
                            let ip_packet = icmp_packet.ipv4_packet();
                            let ip_header = ip_packet.header();

                            /*
                            let resp_ip_builder = networking::ipv4::PacketBuilder::new()
                                .dscp(0)
                                .identification(0x3456)
                                .ttl(10)
                                .protocol(networking::ipv4::Protocol::Icmp)
                                .source(ip_header.destination_ip, self.meta.mac.clone())
                                .destination(ip_header.source_ip, ip_packet.eth().source_mac());
                                */

                            let req_payload = icmp_packet.payload();

                            /*
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
                            */
                            todo!("")
                        }
                        protocols::icmp::Type::EchoReply { .. } => {
                            if let Some((waker, result)) = bindings
                                .ping
                                .remove(&icmp_packet.ipv4_packet().header().source_ip)
                            {
                                result.store(true, core::sync::atomic::Ordering::SeqCst);
                                waker.wake();
                            }
                        }
                        protocols::icmp::Type::Unknown(d) => {
                            println!("Unknown ICMP: {:?}", d);
                        }
                    };
                }
                protocols::ipv4::Protocol::Udp => {
                    let udp_packet = protocols::udp::Packet::new(ip_packet);

                    let udp_header = udp_packet.header();
                    if udp_header.source_port == 67 && udp_header.destination_port == 68 {
                        let dhcp_packet = protocols::dhcp::Packet::new(udp_packet);
                        let dhcp_data = dhcp_packet.get();

                        match (
                            core::mem::replace(&mut device.metadata.dhcp, DHCPExchange::Initial),
                            &dhcp_data.operation,
                        ) {
                            (
                                DHCPExchange::Discover {
                                    transaction_id,
                                    indicator,
                                },
                                protocols::dhcp::Operation::Offer,
                            ) if transaction_id == dhcp_data.xid => {
                                let offered_ip = dhcp_data.yiaddr;
                                let server_ip = dhcp_data.siaddr;

                                device.packet_queue.enqueue(
                                    protocols::dhcp::request_message(
                                        device.metadata.mac.clone(),
                                        transaction_id,
                                        offered_ip.clone(),
                                        server_ip.clone(),
                                        0,
                                    )
                                    .unwrap(),
                                );

                                device.metadata.dhcp = DHCPExchange::Requested {
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
                                protocols::dhcp::Operation::Ack,
                            ) if transaction_id == dhcp_data.xid => {
                                device.metadata.dhcp = DHCPExchange::Done;
                                device.metadata.ip = Some(own_ip);

                                indicator.store(true, Ordering::SeqCst);
                            }
                            (dhcp, _) => {
                                println!("Unexpected DHCP-Packet: {:?}", dhcp_data);

                                device.metadata.dhcp = dhcp;
                            }
                        };
                    } else {
                        match bindings.udp.get(&udp_header.destination_port) {
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
                protocols::ipv4::Protocol::Tcp => {
                    println!("TCP-Packet");
                }
                protocols::ipv4::Protocol::Unknown(unknown) => {
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
