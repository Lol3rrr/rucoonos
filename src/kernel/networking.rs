use core::{cell::UnsafeCell, fmt::Debug, mem::MaybeUninit, ops::Index};

use alloc::boxed::Box;

use crate::println;

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

pub mod ethernet {
    use super::Buffer;

    pub struct Packet {
        buffer: Buffer,
    }

    impl Packet {
        pub fn new(buffer: Buffer) -> Self {
            Self { buffer }
        }

        pub fn destination_mac(&self) -> [u8; 6] {
            self.buffer.as_ref()[0..6].try_into().unwrap()
        }
        pub fn source_mac(&self) -> [u8; 6] {
            self.buffer.as_ref()[6..12].try_into().unwrap()
        }

        pub fn content(&self) -> &[u8] {
            &self.buffer.as_ref()[46..(self.buffer.len())]
        }
    }
}
