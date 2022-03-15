use x86_64::structures::idt::InterruptStackFrame;

use crate::{interrupts::PIC_1_OFFSET, Kernel};

use super::PICS;

pub extern "x86-interrupt" fn network_interrupt(_stack_frame: InterruptStackFrame) {
    let kernel = match Kernel::try_get() {
        Some(k) => k,
        None => {
            unsafe {
                PICS.lock().notify_end_of_interrupt(PIC_1_OFFSET + 0xb);
            }

            return;
        }
    };

    kernel.handle_networking_interrupt();

    unsafe {
        PICS.lock().notify_end_of_interrupt(PIC_1_OFFSET + 0xb);
    }
}
