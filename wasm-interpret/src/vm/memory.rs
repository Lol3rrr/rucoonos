use core::ops::{Index, IndexMut, Range};

/// Memory should represent a linear Section of Memory available to a WASM Module
///
/// This abstraction allows for more flexible and accurate representations depending on the Context
pub trait Memory:
    Index<usize, Output = u8>
    + IndexMut<usize, Output = u8>
    + Index<Range<usize>, Output = [u8]>
    + IndexMut<Range<usize>, Output = [u8]>
{
    fn size(&self) -> usize;

    fn grow(&mut self, size: usize);
}

impl Memory for alloc::vec::Vec<u8> {
    fn size(&self) -> usize {
        self.len()
    }

    fn grow(&mut self, size: usize) {
        if self.len() >= size {
            return;
        }

        self.resize(size, 0);
    }
}
