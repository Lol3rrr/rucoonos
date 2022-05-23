use alloc::{boxed::Box, collections::BTreeMap, sync::Arc, vec::Vec};

use kernel::Kernel;
use x86_64::structures::idt::InterruptStackFrame;

use crate::{
    hardware::{
        self,
        device::{NetworkingDevice, PacketQueueSender},
    },
    interrupts::{self, InterruptDoneGuard},
    println, Hardware,
};

mod cards;
mod handler;

pub mod protocols;

static HANDLE_QUEUE: spin::Once<nolock::queues::mpsc::jiffy::AsyncSender<HandlerMessage>> =
    spin::Once::new();
static DEVICES_: spin::Once<spin::Mutex<Vec<hardware::device::NetworkDevice>>> = spin::Once::new();
static IPS: spin::Once<protocols::IpMap> = spin::Once::new();
static DEVICE_QUEUES: spin::Once<BTreeMap<usize, PacketQueueSender>> = spin::Once::new();

pub struct RawPacket {
    pub id: usize,
    pub buffer: protocols::Buffer,
}

pub struct NetworkExtension {}

impl NetworkExtension {
    pub fn new() -> Self {
        Self {}
    }
}

impl kernel::Extension<&Hardware> for NetworkExtension {
    fn setup(
        self,
        hardware: &&Hardware,
    ) -> core::pin::Pin<alloc::boxed::Box<dyn core::future::Future<Output = ()>>> {
        println!("Setting up Networking Extension");

        let offset = match hardware.memory_offset() {
            Some(o) => o,
            None => {
                return Box::pin(async move {
                    println!("Missing Memory mapping offset");
                })
            }
        };

        let network_devices: Vec<_> = hardware
            .pci_devices()
            .enumerate()
            .filter_map(|(id, header)| {
                if header.generic.id == 0x100E && header.generic.vendor_id == 0x8086 {
                    println!("E1000 Networking Controller: {:?}", header);

                    match hardware::device::E1000Driver::new(id, header, offset) {
                        Ok((n_device, meta, n_queue)) => Some(hardware::device::NetworkDevice {
                            mac: n_device.mac_address(),
                            device: Box::new(n_device),
                            metadata: meta,
                            packet_queue: n_queue,
                            udp_bindings: spin::Mutex::new(BTreeMap::new()),
                        }),
                        Err(_) => None,
                    }
                } else {
                    None
                }
            })
            .collect();
        DEVICE_QUEUES.call_once(|| {
            network_devices
                .iter()
                .map(|dev| (dev.device.id(), dev.packet_queue.clone()))
                .collect()
        });
        DEVICES_.call_once(|| spin::Mutex::new(network_devices));

        let (paket_recv, paket_sender) = nolock::queues::mpsc::jiffy::async_queue();
        HANDLE_QUEUE.call_once(|| paket_sender);

        IPS.call_once(|| protocols::IpMap::new());

        // We need to enable the Networking Intterupt for the Network Card
        unsafe {
            interrupts::set_interrupt(interrupts::PIC_1_OFFSET as usize + 0xb, network_interrupt);
        }

        // We return our new Handler
        Box::pin(handler::network_handler(paket_recv))
    }
}

/// The Interrupt Handler for networking Interrupts
extern "x86-interrupt" fn network_interrupt(_stack_frame: InterruptStackFrame) {
    let span = tracing::error_span!("Networking-Interrupt");
    span.in_scope(|| {
        handle_interrupt(HANDLE_QUEUE.get());
    });

    unsafe {
        interrupts::PICS
            .lock()
            .notify_end_of_interrupt(interrupts::PIC_1_OFFSET + 0xb);
    }
}

fn handle_interrupt(queue: Option<&nolock::queues::mpsc::jiffy::AsyncSender<HandlerMessage>>) {
    let pqueue = match queue {
        Some(q) => q,
        None => {
            tracing::error!("PacketQueue not initialized");
            return;
        }
    };

    let raw_devices = DEVICES_.get().expect("");
    let mut devices = raw_devices.lock();

    for device in devices.iter_mut() {
        let hardware::device::NetworkDevice {
            device: n_device,
            metadata: meta,
            packet_queue: queue,
            udp_bindings: raw_udp_bindings,
            ..
        } = device;
        let udp_bindings = raw_udp_bindings.lock();

        if !n_device.handles_interrupt(0xb) {
            continue;
        }

        let mut ctx = crate::hardware::device::NetworkingCtx {
            meta,
            queue,
            ips: IPS.get().expect(""),
            udp_bindings: &udp_bindings,
        };
        n_device.handle_interrupt(&mut ctx, pqueue);
    }
}

pub async fn get_mac_(ip: [u8; 4]) -> [u8; 6] {
    let ips = IPS.get().expect("");
    if let Some(mac) = ips.try_get(&ip) {
        return mac;
    }

    {
        x86_64::instructions::interrupts::without_interrupts(|| {
            for device in DEVICES_.get().expect("").lock().iter() {
                device.packet_queue.enqueue(
                    protocols::arp::PacketBuilder::new()
                        .sender(
                            device.metadata.mac.clone(),
                            device.metadata.ip.unwrap_or([0, 0, 0, 0]),
                        )
                        .destination([0xff, 0xff, 0xff, 0xff, 0xff, 0xff], ip.clone())
                        .operation(protocols::arp::Operation::Request)
                        .finish()
                        .unwrap(),
                );
            }
        });
    }

    loop {
        if let Some(mac) = ips.try_get(&ip) {
            return mac;
        }

        rucoon::extensions::time::sleep(
            &crate::interrupts::TIMER,
            core::time::Duration::from_millis(2),
        )
        .await;
    }
}

pub struct NetworkHandle {
    queues: BTreeMap<usize, PacketQueueSender>,
}

impl NetworkHandle {
    pub fn obtain() -> Option<Self> {
        let raw_queues = DEVICE_QUEUES.get()?;

        Some(Self {
            queues: raw_queues.clone(),
        })
    }

    pub async fn get_mac(&self, ip: [u8; 4]) {}

    pub async fn ping(&self, ip: [u8; 4]) {}
}

pub enum HandlerMessage {
    Packet(RawPacket),
    Action(ActionRequest),
}

/// Represents the Request to perform some Action in the Handler
pub enum ActionRequest {
    /// The Handler should send out an ARP-Request for the given IP address and send the received
    /// Mac Address back over the provided Queue
    SendArpRequest {
        /// The IP-Address to search for
        ip: [u8; 4],
        /// The Queue on which the result should be send over
        ret_queue: nolock::queues::spsc::bounded::AsyncBoundedSender<[u8; 6]>,
    },
    /// THe Handler should send out a Ping for the given IP- and Mac-Address and use the waker
    /// to notify the User when the returning Ping was received
    PingRequest {
        /// The Waker to notify the User of that the Response was received
        waker: core::task::Waker,
        /// The Target IP-Address to ping
        ip: [u8; 4],
        /// The Mac-Address of the Target IP
        mac: [u8; 6],
    },
}

pub async fn get_mac(ip: [u8; 4]) -> Option<[u8; 6]> {
    let queue = HANDLE_QUEUE.get().expect("");

    let (mut recv, send) = nolock::queues::spsc::bounded::async_queue(1);

    queue
        .enqueue(HandlerMessage::Action(ActionRequest::SendArpRequest {
            ip,
            ret_queue: send,
        }))
        .ok()?;

    recv.dequeue().await.ok()
}
