use core::arch::asm;

use x86_64::structures::idt::InterruptStackFrame;

use crate::TASKS;

use super::{InterruptIndex, PICS};

const FREQUENCY: usize = 100;
const MSTIME: usize = 1000 / FREQUENCY;
const DIVISOR: u16 = (1193182 / FREQUENCY) as u16;

pub(crate) static TIMER: rucoon::extensions::time::Timer<TASKS> =
    rucoon::extensions::time::Timer::new(MSTIME as u128);

pub extern "x86-interrupt" fn timer_interrupt_handler(_stack_frame: InterruptStackFrame) {
    TIMER.update();

    unsafe {
        PICS.lock()
            .notify_end_of_interrupt(InterruptIndex::Timer.as_u8());
    }
}

pub unsafe fn configure_pit() {
    let [high, low] = DIVISOR.to_be_bytes();

    // Source: https://en.wikibooks.org/wiki/X86_Assembly/Programmable_Interval_Timer
    unsafe {
        asm!(
            "mov al, 0x36",
            "out 0x43, al", // tell the PIT which channel we're setting
            "mov al, {divisor_low}",
            "out 0x40, al", // send low byte
            "mov al, {divisor_high}",
            "out 0x40, al", // send high byte
            divisor_low = in(reg_byte) low,
            divisor_high = in(reg_byte) high,
        );
    }
}
