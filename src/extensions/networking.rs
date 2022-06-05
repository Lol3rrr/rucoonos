use core::sync::atomic::AtomicBool;

/// The Network extensions contains all the Logic for Networking.
/// It consists of two Parts, the Interrupt-Handler and the Handler
///
/// # Purpose
/// The Networking Extension provides all the functionality needed for basic Network Operation
///
/// # Interrupt Handler
/// The Interrupt Handler is responsible for taking all the Packet to send out from the
/// Packet-Queue and actually sending them over the Network-Card.
/// The Interrupt Handler is also responsible for loading all the received Packets into extra
/// Buffers and enqueue them to be handled by the Handler, this simply boils down to allocating
/// the correct Buffer size and copying all the Data over and enqueuing said Buffer.
///
/// # Handler
/// The Handler receives two different Types of Events from its Queue.
/// ## Packet-Event
/// A Packet event simply inidcates that the Network Card received a Packet and that now needs to
/// be parsed and handled accordingly.
///
/// ## Action-Event
/// An Action Event indicates an Event initiated by a User to perform some Action
///
/// # API Implementation
/// The API mainly works by sending Action events to the Handler, which then register some form
/// of listener or Callback
use alloc::{boxed::Box, collections::BTreeMap, sync::Arc, vec::Vec};

use kernel::Kernel;
use x86_64::structures::idt::InterruptStackFrame;

use crate::{
    hardware::{
        self,
        device::{NetworkingDevice, PacketQueueSender},
    },
    interrupts, println, Hardware,
};

mod api;
pub use api::*;

mod cards;
mod handler;
mod interrupt;

pub mod protocols;

static HANDLE_QUEUE: spin::Once<nolock::queues::mpsc::jiffy::AsyncSender<HandlerMessage>> =
    spin::Once::new();
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
        _kernel: &Kernel<&Hardware>,
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

        let (network_devices, devices): (
            Vec<_>,
            Vec<Box<dyn NetworkingDevice + Send + Sync + 'static>>,
        ) = hardware
            .pci_devices()
            .enumerate()
            .filter_map(|(id, header)| {
                if header.generic.id == 0x100E && header.generic.vendor_id == 0x8086 {
                    match hardware::device::E1000Driver::new(id, header, offset) {
                        Ok((n_device, meta, n_queue)) => Some((
                            hardware::device::NetworkDevice {
                                id: n_device.id(),
                                mac: n_device.mac_address(),
                                metadata: meta,
                                packet_queue: n_queue,
                                udp_bindings: spin::Mutex::new(BTreeMap::new()),
                            },
                            Box::new(n_device) as Box<dyn NetworkingDevice + Send + Sync + 'static>,
                        )),
                        Err(_) => None,
                    }
                } else {
                    None
                }
            })
            .unzip();

        interrupt::init_devices(devices);

        DEVICE_QUEUES.call_once(|| {
            network_devices
                .iter()
                .map(|dev| (dev.id, dev.packet_queue.clone()))
                .collect()
        });

        let (paket_recv, paket_sender) = nolock::queues::mpsc::jiffy::async_queue();
        HANDLE_QUEUE.call_once(|| paket_sender);

        IPS.call_once(|| protocols::IpMap::new());

        // We need to enable the Networking Intterupt for the Network Card
        unsafe {
            interrupts::set_interrupt(interrupts::PIC_1_OFFSET as usize + 0xb, network_interrupt);
        }

        // We return our new Handler
        Box::pin(handler::network_handler(network_devices, paket_recv))
    }
}

/// The Interrupt Handler for networking Interrupts
extern "x86-interrupt" fn network_interrupt(_stack_frame: InterruptStackFrame) {
    let span = tracing::error_span!("Networking-Interrupt");
    span.in_scope(|| interrupt::handle_interrupt(HANDLE_QUEUE.get()));

    unsafe {
        interrupts::PICS
            .lock()
            .notify_end_of_interrupt(interrupts::PIC_1_OFFSET + 0xb);
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
        /// This should be set to true if the Response was received
        result: Arc<AtomicBool>,
    },
}
