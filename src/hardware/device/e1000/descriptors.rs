use core::alloc::{GlobalAlloc, Layout};

pub fn allocate_buffer<const N: usize, T, A>(descriptors: [T; N], allocator: &A) -> *mut u8
where
    A: GlobalAlloc,
{
    let raw_ptr = unsafe {
        allocator.alloc(
            Layout::from_size_align(core::mem::size_of::<[T; N]>(), core::mem::size_of::<T>())
                .unwrap(),
        )
    };

    unsafe {
        (raw_ptr as *mut [T; N]).write_volatile(descriptors);
    }

    raw_ptr
}
