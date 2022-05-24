use alloc::{boxed::Box, vec::Vec};

use crate::hardware::device::NetworkingDevice;

use super::HandlerMessage;

static INT_DEVICES: spin::Once<spin::Mutex<Vec<Box<dyn NetworkingDevice + Send + Sync>>>> =
    spin::Once::new();

pub fn init_devices(devices: Vec<Box<dyn NetworkingDevice + Send + Sync>>) {
    INT_DEVICES.call_once(|| spin::Mutex::new(devices));
}

pub fn handle_interrupt(queue: Option<&nolock::queues::mpsc::jiffy::AsyncSender<HandlerMessage>>) {
    let pqueue = match queue {
        Some(q) => q,
        None => {
            tracing::error!("PacketQueue not initialized");
            return;
        }
    };

    let raw_devices = INT_DEVICES.get().expect("");
    let mut devices = match raw_devices.try_lock() {
        Some(d) => d,
        None => {
            tracing::error!("Could not get lock for Devices");
            return;
        }
    };

    for n_device in devices.iter_mut() {
        if !n_device.handles_interrupt(0xb) {
            continue;
        }

        n_device.handle_interrupt(pqueue);
    }
}
