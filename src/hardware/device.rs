use core::sync::atomic::{AtomicBool, Ordering};

use alloc::{
    boxed::Box,
    collections::{BTreeMap, VecDeque},
    sync::Arc,
    vec::Vec,
};

use crate::{extensions::protocols, println};

use super::pci;

mod e1000;

pub enum Device {
    Network(NetworkDevice),
    Graphics(),
}

pub struct NetworkDevice {
    pub mac: [u8; 6],
    /// A handle to the actual underlying Device/Driver
    pub device: Box<dyn NetworkingDevice + Send + 'static>,
    /// The Queue to enqueue Packets on to send out over the Queue
    pub packet_queue: PacketQueueSender,
    pub metadata: NetworkingMetadata,
    pub udp_bindings: spin::Mutex<
        BTreeMap<u16, nolock::queues::mpmc::bounded::scq::Sender<protocols::udp::Packet>>,
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
    pub dhcp: DHCPExchange,
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
    fn id(&self) -> usize;

    fn mac_address(&self) -> [u8; 6];

    /// Checks if the Networking Device is registered for a given interrupt
    fn handles_interrupt(&self, irq_offset: u8) -> bool;

    /// Gets called if an interrupt occurs for the Networking Device
    fn handle_interrupt(
        &mut self,
        ctx: &mut NetworkingCtx,
        queue: &nolock::queues::mpsc::jiffy::AsyncSender<crate::extensions::HandlerMessage>,
    );
}

pub struct NetworkingCtx<'m> {
    pub meta: &'m mut NetworkingMetadata,
    pub queue: &'m PacketQueueSender,
    pub ips: &'m protocols::IpMap,
    pub udp_bindings:
        &'m BTreeMap<u16, nolock::queues::mpmc::bounded::scq::Sender<protocols::udp::Packet>>,
}

pub struct E1000Driver {}

impl E1000Driver {
    pub fn new(
        id: usize,
        device: pci::Device,
        offset: u64,
    ) -> Result<(impl NetworkingDevice, NetworkingMetadata, PacketQueueSender), ()> {
        device.enable_bus_mastering();

        let (mut card, sender) = match device.header_type {
            pci::HeaderType::Generic { base_addresses, .. } => {
                let bar = base_addresses[0].clone();

                let (sender, receiver) = create_packetqueue();
                let (card, send_notify) = e1000::E1000Card::init(id, bar, offset, receiver);
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

#[derive(Clone)]
pub struct PacketQueueSender {
    queue: Arc<nolock::queues::mpsc::jiffy::Sender<crate::extensions::protocols::ethernet::Packet>>,
    notify: Arc<dyn Fn() + 'static + Send + Sync>,
}
pub struct PacketQueueReceiver {
    queue: nolock::queues::mpsc::jiffy::Receiver<crate::extensions::protocols::ethernet::Packet>,
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
    pub fn enqueue(&self, packet: protocols::ethernet::Packet) {
        let _ = self.queue.enqueue(packet);
        (self.notify)();
    }
}

impl PacketQueueReceiver {
    pub unsafe fn dequeue(&mut self) -> Option<protocols::ethernet::Packet> {
        self.queue.try_dequeue().ok()
    }
}
