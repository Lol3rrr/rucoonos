use alloc::{boxed::Box, collections::BTreeMap, sync::Arc};

mod buffer;
pub use buffer::Buffer;
use kernel::Kernel;
use x86_64::structures::idt::InterruptStackFrame;

use crate::{interrupts, println, Hardware};

pub mod arp;
pub mod dhcp;
pub mod ethernet;
pub mod icmp;
pub mod ipv4;
pub mod udp;

#[derive(Clone)]
pub struct IpMap {
    map: Arc<spin::Mutex<BTreeMap<[u8; 4], [u8; 6]>>>,
}

impl IpMap {
    pub fn new() -> Self {
        Self {
            map: Arc::new(spin::Mutex::new(BTreeMap::new())),
        }
    }

    pub fn try_get(&self, ip: &[u8; 4]) -> Option<[u8; 6]> {
        x86_64::instructions::interrupts::without_interrupts(|| self.map.lock().get(ip).cloned())
    }
    pub fn set(&self, ip: [u8; 4], mac: [u8; 6]) {
        x86_64::instructions::interrupts::without_interrupts(|| {
            self.map.lock().insert(ip, mac);
        });
    }
}

pub struct NetworkExtension {}

impl kernel::Extension<&Hardware> for NetworkExtension {
    fn setup(
        self,
        hardware: &&Hardware,
    ) -> core::pin::Pin<alloc::boxed::Box<dyn core::future::Future<Output = ()>>> {
        println!("Setting up Networking Extension");

        let (paket_recv, paket_sender) = nolock::queues::mpsc::jiffy::async_queue();
        HANDLE_QUEUE.call_once(|| paket_sender);

        // We need to enable the Networking Intterupt for the Network Card
        unsafe {
            interrupts::set_interrupt(interrupts::PIC_1_OFFSET as usize + 0xb, network_interrupt);
        }

        Box::pin(network_handler(paket_recv))
    }
}

async fn network_handler(mut paket_recv: nolock::queues::mpsc::jiffy::AsyncReceiver<()>) {
    loop {
        let raw_paket = match paket_recv.dequeue().await {
            Ok(p) => p,
            Err(e) => {
                println!("Error getting Paket: {:?}", e);
                return;
            }
        };

        println!("Inside Network Extension handler");
    }
}

static HANDLE_QUEUE: spin::Once<nolock::queues::mpsc::jiffy::AsyncSender<()>> = spin::Once::new();

pub extern "x86-interrupt" fn network_interrupt(_stack_frame: InterruptStackFrame) {
    let kernel = match Hardware::try_get() {
        Some(k) => k,
        None => {
            unsafe {
                interrupts::PICS
                    .lock()
                    .notify_end_of_interrupt(interrupts::PIC_1_OFFSET + 0xb);
            }

            return;
        }
    };

    handle_interrupt(kernel);

    match HANDLE_QUEUE.get() {
        Some(sender) => {
            // Send the Raw-Paket to the Networking Task
            let _ = sender.enqueue(());
        }
        None => {
            // This should basically never happen, because we only enable the Handler if we also
            // iniatilized the Queue beforehand
        }
    };

    unsafe {
        interrupts::PICS
            .lock()
            .notify_end_of_interrupt(interrupts::PIC_1_OFFSET + 0xb);
    }
}

fn handle_interrupt(kernel: &Hardware) {
    let mut devices = kernel.devices.lock();
    for device in devices.iter_mut() {
        let (n_device, meta, queue, raw_udp_bindings) = match device {
            crate::hardware::device::Device::Network(crate::hardware::device::NetworkDevice {
                device,
                metadata,
                packet_queue,
                udp_bindings,
                ..
            }) => (device, metadata, packet_queue, udp_bindings),
            _ => continue,
        };
        let udp_bindings = raw_udp_bindings.lock();

        if !n_device.handles_interrupt(0xb) {
            continue;
        }

        let mut ctx = crate::hardware::device::NetworkingCtx {
            meta,
            queue,
            ips: &kernel.ips,
            udp_bindings: &udp_bindings,
        };
        n_device.handle_interrupt(&mut ctx);
    }
}
