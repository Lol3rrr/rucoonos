use x86_64::structures::idt::InterruptStackFrame;

use super::PICS;
use crate::{interrupts::InterruptIndex, println};

pub extern "x86-interrupt" fn keyboard_interrupt_handler(_stack_frame: InterruptStackFrame) {
    use x86_64::instructions::port::Port;

    let mut port = Port::new(0x60);
    let scancode: u8 = unsafe { port.read() };

    let down = scancode & 0x80 == 0;
    let key = match scancode & 0x0f {
        0x02 => Some('1'),
        0x03 => Some('2'),
        0x04 => Some('3'),
        0x05 => Some('4'),
        0x06 => Some('5'),
        0x07 => Some('6'),
        0x08 => Some('7'),
        0x09 => Some('8'),
        0x0a => Some('9'),
        0x0b => Some('0'),
        12 => {
            // Enter
            None
        }
        14 => {
            // Backspace
            None
        }
        15 => {
            // TAB
            None
        }
        //
        16 => Some('q'),
        17 => Some('w'),
        18 => Some('e'),
        19 => Some('r'),
        20 => Some('t'),
        21 => Some('z'),
        22 => Some('u'),
        23 => Some('i'),
        24 => Some('o'),
        25 => Some('p'),
        //
        30 => Some('a'),
        31 => Some('s'),
        32 => Some('d'),
        33 => Some('f'),
        34 => Some('g'),
        35 => Some('h'),
        36 => Some('j'),
        37 => Some('k'),
        38 => Some('l'),
        //
        44 => Some('y'),
        45 => Some('y'),
        46 => Some('y'),
        47 => Some('y'),
        48 => Some('y'),
        49 => Some('y'),
        50 => Some('y'),
        code => {
            println!("Unknown Code: {:?}", code);
            None
        }
    };
    if let Some(key) = key {
        println!("{} {}", key, down);
    }

    unsafe {
        PICS.lock()
            .notify_end_of_interrupt(InterruptIndex::Keyboard.as_u8());
    }
}
