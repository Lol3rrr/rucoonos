//! # Plan
//! The Memory for each WASM Program should actually be a region in memory and not a Vec. To do
//! this we will use multiple Page-Tables and specifically, create one for each Program Instance.
//! Then whenever we want to run the Program, we will swap to the Page-Table for that Program,
//! run it and then switch back to the previous Page-Table.
//!
//! # Implementation
//! To imlement this we are going to introduce our own custom Future that wraps the actual
//! execution future for the WASM module and every time our wrapper is polled it will swap
//! to the correct Page-Table, run the WASM module and then swap the previous Page-Table back
//! in.
//! The Page-Table to use will be created when we create the Future and for this we will copy
//! the base Page-Table and then allocate a single Frame for the beginning. All WASM-Instances
//! will have their memory instance mapped at the same location in memory.

use core::{
    future::Future,
    ops::{DerefMut, Index, IndexMut, Range},
    pin::Pin,
};

use alloc::boxed::Box;

use kernel::Extension;
use wasm::Module;
use wasm_interpret::vm;

use x86_64::{
    structures::paging::{
        FrameAllocator, Mapper, OffsetPageTable, Page, PageTable, PageTableFlags, PhysFrame,
    },
    VirtAddr,
};

use crate::{acpi::OffsetMapper, println, Hardware};

/// This Extensions allows you to run any WASM program and allows you to provide custom Handlers
/// for external Functions used by the Handler
pub struct WasmProgram<H> {
    data: &'static [u8],
    handlers: H,
    name: &'static str,
}

impl<H> WasmProgram<H>
where
    H: wasm_interpret::vm::handler::ExternalHandler,
{
    pub fn new(handler: H, data: &'static [u8], func: &'static str) -> Self {
        Self {
            data,
            handlers: handler,
            name: func,
        }
    }
}

impl<HA> Extension<&Hardware> for WasmProgram<HA>
where
    HA: wasm_interpret::vm::handler::ExternalHandler + 'static,
{
    fn setup(
        self,
        kernel: &kernel::Kernel<&Hardware>,
        hardware: &&Hardware,
    ) -> core::pin::Pin<alloc::boxed::Box<dyn core::future::Future<Output = ()>>> {
        tracing::trace!("Setting up WASM-Extension");

        let (memory, n_frame, c_flags) = unsafe { MappedMemory::new(&hardware) };

        let env = vm::Environment::new(self.handlers, memory);
        let module = match Module::parse(self.data) {
            Ok(m) => m,
            Err(e) => {
                tracing::error!("Parsing WASM-Module {:?}", e);
                return Box::pin(async move {});
            }
        };

        tracing::trace!("Parsed WASM Module");

        Box::pin(run_module(self.name, module, env, (n_frame, c_flags)))
    }
}

#[tracing::instrument(name = "WASM-Module", skip(name, module, env))]
fn run_module<EH, M>(
    name: &'static str,
    module: Module,
    env: vm::Environment<EH, M>,
    (p_frame, p_flags): (
        x86_64::structures::paging::PhysFrame,
        x86_64::registers::control::Cr3Flags,
    ),
) -> WasmFuture<impl Future<Output = ()>>
where
    EH: vm::handler::ExternalHandler,
    M: vm::memory::Memory,
{
    tracing::info!("Starting...");

    WasmFuture::new(p_frame, p_flags, async move {
        let mut interpreter = vm::Interpreter::new(env, &module);

        tracing::info!("Setup Interpreter");

        let mut count = 0;
        match interpreter
            .run_with_wait(name, || {
                count += 1;
                if count > 10 {
                    count = 0;
                    Some(Box::pin(rucoon::futures::yield_now()))
                } else {
                    None
                }
            })
            .await
        {
            Ok(r) => {
                tracing::debug!("Result: {:?}", r);
            }
            Err(e) => {
                tracing::error!("Running WASM {:?}", e);
            }
        };
    })
}

/// This wraps the actual Future to execute the WASM-Module to perform extra setup/teardown before
/// every execution.
/// This currently mainly consists of configuring the Memory correctly
pub struct WasmFuture<F> {
    program_frame: x86_64::structures::paging::PhysFrame,
    flags: x86_64::registers::control::Cr3Flags,
    future: Pin<Box<F>>,
}

impl<F> WasmFuture<F> {
    pub fn new(
        p_frame: x86_64::structures::paging::PhysFrame,
        flags: x86_64::registers::control::Cr3Flags,
        fut: F,
    ) -> Self {
        Self {
            program_frame: p_frame,
            flags,
            future: Box::pin(fut),
        }
    }
}

impl<F> Future for WasmFuture<F>
where
    F: Future<Output = ()>,
{
    type Output = ();

    fn poll(
        mut self: core::pin::Pin<&mut Self>,
        cx: &mut core::task::Context<'_>,
    ) -> core::task::Poll<Self::Output> {
        // Load the previous PageTable
        let (p_frame, p_flags) = x86_64::registers::control::Cr3::read();

        // Load the PageTable for the current Module
        unsafe {
            x86_64::registers::control::Cr3::write(self.program_frame.clone(), self.flags.clone());
        }

        // Run the module itself
        let res = self.future.as_mut().poll(cx);

        // Restore the previous PageTable
        unsafe {
            x86_64::registers::control::Cr3::write(p_frame, p_flags);
        }

        res
    }
}

/// The Offset at which the Memory for the WASM module will start
const MAPPED_START: usize = 0x_3333_3333_0000;

/// This is the Memory implementation that should be used by the WASM-Interpreter
///
/// This Memory implementation relies on modifying the Page-Table to allow it to directly store
/// the WASM-Memory in the actual memory at a given Offset.
/// This should make it very fast and also means that growing the Memory is just as simple as
/// creating new mappings starting at the end of the current Region, which should be very fast.
pub struct MappedMemory {
    /// The PageTable for this instance
    mapper: OffsetPageTable<'static>,
    /// The Number of Pages currently being
    pages: usize,
}

impl MappedMemory {
    pub unsafe fn new(
        hardware: &Hardware,
    ) -> (Self, PhysFrame, x86_64::registers::control::Cr3Flags) {
        // Get the current PageTable
        let offset_page_table = hardware.get_memory_mapping().expect("");
        let phys_offset = hardware.memory_offset().expect("");

        // Create a new Blank PageTable
        let (c_frame, c_flags) = x86_64::registers::control::Cr3::read();
        let page_table_addr = (c_frame.start_address().as_u64() + phys_offset) as *const PageTable;
        let page_table = unsafe { &*page_table_addr }.clone();

        // Get the Frame Allocator
        let raw_frame_allocator = Hardware::get_frame_allocator().expect("");
        let mut frame_allocator = raw_frame_allocator.lock();

        // Allocate the Frame for the new PageTable
        let n_frame = frame_allocator.allocate_frame().expect("");

        // Store the PageTable in the new Frame
        let n_addr = n_frame.start_address().as_u64() + phys_offset;
        unsafe {
            (n_addr as *mut PageTable).write(page_table);
        }

        // Create the Mapper for the new PageTable
        let n_mapping = unsafe {
            OffsetPageTable::new(
                unsafe { &mut *(n_addr as *mut PageTable) },
                VirtAddr::new(phys_offset),
            )
        };

        (
            Self {
                mapper: n_mapping,
                pages: 0,
            },
            n_frame,
            c_flags,
        )
    }
}

impl wasm_interpret::vm::memory::Memory for MappedMemory {
    fn size(&self) -> usize {
        self.pages * 4096
    }

    fn grow(&mut self, size: usize) {
        let diff = size - self.size();

        let mut n_pages = diff / 4096;
        if diff % 4096 != 0 {
            n_pages += 1;
        }

        let mut allocator = Hardware::get_frame_allocator().expect("").lock();

        for addr in (0..n_pages)
            .into_iter()
            .map(|p_id| MAPPED_START + self.pages * 4096 + p_id * 4096)
        {
            let page = Page::containing_address(VirtAddr::new(addr as u64));
            let frame = allocator.allocate_frame().expect("");
            unsafe {
                self.mapper.map_to(
                    page,
                    frame,
                    PageTableFlags::PRESENT | PageTableFlags::WRITABLE,
                    allocator.deref_mut(),
                );
            }
        }

        self.pages += n_pages;
    }
}

impl Index<usize> for MappedMemory {
    type Output = u8;

    fn index(&self, index: usize) -> &Self::Output {
        let addr = MAPPED_START + index;

        unsafe { &*(addr as *const u8) }
    }
}
impl IndexMut<usize> for MappedMemory {
    fn index_mut(&mut self, index: usize) -> &mut Self::Output {
        let addr = MAPPED_START + index;

        unsafe { &mut *(addr as *mut u8) }
    }
}

impl Index<Range<usize>> for MappedMemory {
    type Output = [u8];

    fn index(&self, index: Range<usize>) -> &Self::Output {
        let addr = MAPPED_START + index.start;

        unsafe { core::slice::from_raw_parts(addr as *const u8, index.len()) }
    }
}
impl IndexMut<Range<usize>> for MappedMemory {
    fn index_mut(&mut self, index: Range<usize>) -> &mut Self::Output {
        let addr = MAPPED_START + index.start;

        unsafe { core::slice::from_raw_parts_mut(addr as *mut u8, index.len()) }
    }
}
