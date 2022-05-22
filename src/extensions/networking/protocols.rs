use alloc::{boxed::Box, collections::BTreeMap, sync::Arc};

mod buffer;
pub use buffer::Buffer;
use kernel::Kernel;
use x86_64::structures::idt::InterruptStackFrame;

use crate::{
    interrupts::{self, InterruptDoneGuard},
    println, Hardware,
};

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
