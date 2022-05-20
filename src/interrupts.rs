use alloc::boxed::Box;
use lazy_static::lazy_static;
use pic8259::ChainedPics;
use spin;
use x86_64::structures::idt::{
    Entry, HandlerFunc, InterruptDescriptorTable, InterruptStackFrame, PageFaultErrorCode,
};

use crate::{gdt, hlt_loop, println};

mod keyboard;
mod timer;
pub(crate) use timer::TIMER;

pub const PIC_1_OFFSET: u8 = 0x20;
pub const PIC_2_OFFSET: u8 = 0x28;

pub static PICS: spin::Mutex<ChainedPics> =
    spin::Mutex::new(unsafe { ChainedPics::new(PIC_1_OFFSET, PIC_2_OFFSET) });

enum IDTStorage {
    Initial(&'static InterruptDescriptorTable),
    Heaped { idt: *mut InterruptDescriptorTable },
}

impl IDTStorage {
    fn initial() -> Self {
        Self::Initial(&InitialIDT)
    }

    fn new(idt: Box<InterruptDescriptorTable>) -> Self {
        let idt_ptr = Box::into_raw(idt);
        Self::Heaped { idt: idt_ptr }
    }

    fn idt(&self) -> InterruptDescriptorTable {
        match self {
            Self::Initial(idt) => (*idt).clone(),
            Self::Heaped { idt } => {
                let refed: &InterruptDescriptorTable = unsafe { &**idt };
                InterruptDescriptorTable::clone(refed)
            }
        }
    }

    fn load(&self) {
        match self {
            Self::Initial(idt) => {
                idt.load();
            }
            Self::Heaped { idt } => {
                let refed: &InterruptDescriptorTable = unsafe { &**idt };
                unsafe {
                    refed.load_unsafe();
                }
            }
        }
    }
}

unsafe impl Sync for IDTStorage {}
unsafe impl Send for IDTStorage {}

impl Drop for IDTStorage {
    fn drop(&mut self) {
        match self {
            Self::Initial(_) => {}
            Self::Heaped { idt } => {
                let boxed = unsafe { Box::from_raw(*idt) };
                drop(boxed);
            }
        }
    }
}

lazy_static! {
    static ref InitialIDT: InterruptDescriptorTable = {
        let mut idt = InterruptDescriptorTable::new();

        idt.breakpoint.set_handler_fn(breakpoint_handler);
        unsafe {
            idt.double_fault
                .set_handler_fn(double_fault_handler)
                .set_stack_index(gdt::DOUBLE_FAULT_IST_INDEX);
        }
        idt.page_fault.set_handler_fn(page_fault_handler);
        idt.general_protection_fault
            .set_handler_fn(general_protection_handler);
        idt[InterruptIndex::Timer.as_usize()].set_handler_fn(timer::timer_interrupt_handler);
        idt[InterruptIndex::Keyboard.as_usize()]
            .set_handler_fn(keyboard::keyboard_interrupt_handler);

        idt
    };
    static ref IDT: spin::RwLock<IDTStorage> = spin::RwLock::new(IDTStorage::initial());
}

pub fn init_idt() {
    IDT.read().load();

    // Simply allow ALL the Interrupts
    unsafe {
        PICS.lock().write_masks(0x00, 0x00);
    }

    unsafe {
        timer::configure_pit();
    }
}

pub unsafe fn set_interrupt(line: usize, entry: HandlerFunc) {
    let mut n_idt = IDT.read().idt();

    n_idt[line].set_handler_fn(entry);

    x86_64::instructions::interrupts::without_interrupts(|| {
        let mut writer = IDT.write();
        let old_idt: IDTStorage = core::mem::replace(&mut writer, IDTStorage::new(Box::new(n_idt)));

        writer.load();

        drop(old_idt);
    });
}

extern "x86-interrupt" fn breakpoint_handler(stack_frame: InterruptStackFrame) {
    println!("EXCEPTION: BREAKPOINT\n{:#?}", stack_frame);
}

extern "x86-interrupt" fn double_fault_handler(
    stack_frame: InterruptStackFrame,
    _error_code: u64,
) -> ! {
    panic!("EXCEPTION: DOUBLE FAULT\n{:#?}", stack_frame);
}

extern "x86-interrupt" fn page_fault_handler(
    stack_frame: InterruptStackFrame,
    error_code: PageFaultErrorCode,
) {
    use x86_64::registers::control::Cr2;

    println!("EXCEPTION: PAGE FAULT");
    println!("Accessed Address: {:?}", Cr2::read());
    println!("Error Code: {:?}", error_code);
    println!("{:#?}", stack_frame);

    hlt_loop();
}

extern "x86-interrupt" fn general_protection_handler(
    stack_frame: InterruptStackFrame,
    error_code: u64,
) {
    let external = error_code & 0x1 != 0;
    let tbl = (error_code & 0x3) >> 1;
    let index = (error_code & 0xfff8) >> 3;

    println!("Raw: {:08x}", error_code);
    println!("External: {} - TBL: {} - Index: {}", external, tbl, index);

    panic!(
        "General Protection Exception: {} \n {:?}",
        error_code, stack_frame
    );
}

#[derive(Debug, Clone, Copy)]
#[repr(u8)]
pub enum InterruptIndex {
    Timer = PIC_1_OFFSET,
    Keyboard,
}

impl InterruptIndex {
    fn as_u8(self) -> u8 {
        self as u8
    }

    fn as_usize(self) -> usize {
        usize::from(self.as_u8())
    }
}

#[test_case]
fn test_breakpoint_exception() {
    // invoke a breakpoint exception
    x86_64::instructions::interrupts::int3();
}
