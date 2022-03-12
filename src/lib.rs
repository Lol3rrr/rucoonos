#![no_std]
//
#![cfg_attr(test, no_main)]
#![feature(custom_test_frameworks)]
#![test_runner(crate::test_runner)]
#![reexport_test_harness_main = "test_main"]
//
#![feature(abi_x86_interrupt)]
#![feature(alloc_error_handler)]
//
#![feature(const_mut_refs)]
#![feature(const_ptr_write)]
#![feature(const_ptr_offset)]
#![feature(const_maybe_uninit_as_mut_ptr)]
//
#![allow(missing_docs)]
#![deny(unsafe_op_in_unsafe_fn)]

extern crate alloc;

use core::panic::PanicInfo;

mod kernel;
pub use kernel::Kernel;

pub mod acpi;
pub mod allocator;
pub mod gdt;
pub mod interrupts;
pub mod memory;
pub mod serial;
pub mod vga;
pub mod video;

pub mod futures;

pub(crate) const TASKS: usize = 2;
pub(crate) static RUNTIME: rucoon::runtime::Runtime<TASKS> = rucoon::runtime::Runtime::new();

#[alloc_error_handler]
fn alloc_error_handler(layout: alloc::alloc::Layout) -> ! {
    panic!("allocation error: {:?}", layout)
}

pub trait Testable {
    fn run(&self) -> ();
}

impl<T> Testable for T
where
    T: Fn(),
{
    fn run(&self) {
        serial_print!("{}...\t", core::any::type_name::<T>());
        self();
        serial_println!("[ok]");
    }
}

pub fn test_runner(tests: &[&dyn Testable]) {
    serial_println!("Running {} tests", tests.len());
    for test in tests {
        test.run();
    }
    exit_qemu(QemuExitCode::Success);
}

pub fn test_panic_handler(info: &PanicInfo) -> ! {
    serial_println!("[failed]\n");
    serial_println!("Error: {}\n", info);
    exit_qemu(QemuExitCode::Failed);

    hlt_loop()
}

#[cfg(test)]
bootloader::entry_point!(test_kernel_main);

/// Entry point for `cargo test`
#[cfg(test)]
fn test_kernel_main(boot_info: &'static mut bootloader::BootInfo) -> ! {
    init();

    test_main();

    hlt_loop()
}

#[cfg(test)]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    test_panic_handler(info)
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u32)]
pub enum QemuExitCode {
    Success = 0x10,
    Failed = 0x11,
}

pub fn exit_qemu(exit_code: QemuExitCode) {
    use x86_64::instructions::port::Port;

    unsafe {
        let mut port = Port::new(0xf4);
        port.write(exit_code as u32);
    }
}

pub fn init() {
    x86_64::instructions::interrupts::disable();
    gdt::init();
    interrupts::init_idt();
    unsafe { interrupts::PICS.lock().initialize() };
    x86_64::instructions::interrupts::enable();
}

pub fn hlt_loop() -> ! {
    loop {
        x86_64::instructions::hlt();
    }
}

#[macro_export]
macro_rules! print {
    ($($arg:tt)*) => ($crate::serial_print!($($arg)*));
}

#[macro_export]
macro_rules! println {
    () => ($crate::print!("\n"));
    ($($arg:tt)*) => ($crate::print!("{}\n", format_args!($($arg)*)));
}
