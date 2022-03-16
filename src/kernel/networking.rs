use core::fmt::Debug;

use alloc::boxed::Box;

pub struct Buffer {
    data: Box<[u8; 2048]>,
    len: usize,
}

impl Buffer {
    pub fn new(data: &[u8]) -> Self {
        let mut target_data = Box::new([0u8; 2048]);

        for (target, src) in target_data.iter_mut().zip(data.iter()) {
            *target = *src;
        }

        Self {
            data: target_data,
            len: data.len(),
        }
    }

    pub fn len(&self) -> usize {
        self.len
    }

    pub fn into_raw(self) -> (*mut [u8], usize) {
        (Box::into_raw(self.data), self.len)
    }
}

impl Debug for Buffer {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_list()
            .entries(self.data.iter().take(self.len))
            .finish()
    }
}

impl AsRef<[u8]> for Buffer {
    fn as_ref(&self) -> &[u8] {
        self.data.as_ref()
    }
}

pub mod arp;
pub mod dhcp;
pub mod ethernet;
pub mod ipv4;
pub mod udp;
