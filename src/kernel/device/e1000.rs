use alloc::boxed::Box;
use x86_64::{structures::paging::Translate, VirtAddr};

// https://br.mouser.com/datasheet/2/612/i217_ethernet_controller_datasheet-257741.pdf

use crate::{
    kernel::{pci, MEMORY_MAPPING},
    println,
};

pub struct E1000Card {
    com: Coms,
    has_eeprom: bool,
    rx_ptr: x86_64::VirtAddr,
    tx_ptr: x86_64::VirtAddr,
    cur_tx: u32,
}

const REG_CTRL: u16 = 0x0000;
const REG_STATUS: u16 = 0x0008;
const REG_IMASK: u16 = 0x00D0;

const REG_TCTRL: u16 = 0x400;
const REG_TXDESCLO: u16 = 0x3800;
const REG_TXDESCHI: u16 = 0x3804;
const REG_TXDESCLEN: u16 = 0x3808;
const REG_TXDESCHEAD: u16 = 0x3810;
const REG_TXDESCTAIL: u16 = 0x3818;

const REG_RCTRL: u16 = 0x0100;
const REG_RXDESCLO: u16 = 0x2800;
const REG_RXDESCHI: u16 = 0x2804;
const REG_RXDESCLEN: u16 = 0x2808;
const REG_RXDESCHEAD: u16 = 0x2810;
const REG_RXDESCTAIL: u16 = 0x2818;

const REG_TIPG: u16 = 0x0410;

const RCTL_EN: u32 = 1 << 1;
const RCTL_SBP: u32 = 1 << 2;
const RCTL_UPE: u32 = 1 << 3;
const RCTL_MPE: u32 = 1 << 4;
const RCTL_LPE: u32 = 1 << 6;
const RCTL_LBM_NONE: u32 = 0 << 7;
const RTCL_RDMTS_HALF: u32 = 0 << 8;
const RCTL_BAM: u32 = 1 << 15;
const RCTL_SECRC: u32 = 1 << 26;

const RCTL_BSIZE_2048: u32 = 0 << 16;

const TCTL_EN: u32 = 1 << 1;
const TCTL_PSP: u32 = 1 << 3;
const TCTL_CT_SHIFT: u32 = 4;
const TCTL_COLD_SHIFT: u32 = 12;
const TCTL_RTLC: u32 = 1 << 24;

const TSTA_DD: u8 = 1 << 0;

const CMD_EOP: u8 = 1 << 0;
const CMD_IFCS: u8 = 1 << 1;
const CMD_RS: u8 = 1 << 3;

#[derive(Debug, Clone, Copy)]
#[repr(packed)]
struct rx_desc {
    addr: u64,
    length: u16,
    checksum: u16,
    status: u8,
    errors: u8,
    special: u16,
}

#[derive(Debug, Clone, Copy)]
#[repr(packed)]
struct tx_desc {
    addr: u64,
    length: u16,
    cso: u8,
    cmd: u8,
    status: u8,
    css: u8,
    special: u16,
}

/// A small Abstraction for the Read/Write interactions with the Card
struct Coms {
    bar: pci::BaseAddressRegister,
    offset: u64,
}

impl Coms {
    pub fn write_command(&self, p_address: u16, value: u32) {
        match &self.bar {
            pci::BaseAddressRegister::MemorySpace { address, .. } => {
                let target_address = *address as u64 + p_address as u64 + self.offset;
                let target_ptr = target_address as *mut u32;
                unsafe {
                    target_ptr.write_volatile(value);
                }
            }
            pci::BaseAddressRegister::IOSpace { address } => {
                todo!("Write Command to IOSpace Bar");
            }
        };
    }

    pub fn read_command(&self, p_address: u16) -> u32 {
        match &self.bar {
            pci::BaseAddressRegister::MemorySpace { address, .. } => {
                let target_address = *address as u64 + p_address as u64 + self.offset;
                let target_ptr = target_address as *mut u32;
                unsafe { target_ptr.read_volatile() }
            }
            pci::BaseAddressRegister::IOSpace { address } => {
                todo!("Read Command to IOSpace Bar")
            }
        }
    }
}

impl E1000Card {
    pub fn init(bar: pci::BaseAddressRegister, offset: u64) -> Self {
        let coms = Coms { bar, offset };

        let status = coms.read_command(REG_STATUS);
        println!("Status: 0b{:032b}", status);

        // Check for EEPROM
        coms.write_command(0x0014, 0x1);
        let has_eeprom = (0..1000).any(|_| coms.read_command(0x0014) & 0x10 > 0);

        const RX_DESC: usize = 32;
        const TX_DESC: usize = 8;

        // initialize RX stuff
        let rx_desc_ptrs = {
            let mut descriptors = [rx_desc {
                addr: 0,
                length: 0,
                checksum: 0,
                status: 0,
                errors: 0,
                special: 0,
            }; RX_DESC + 1];

            for desc in descriptors.iter_mut() {
                let buffer = Box::new([0u8; 2048 + 16]);
                let raw_ptr = Box::into_raw(buffer);
                let virt_ptr = x86_64::VirtAddr::from_ptr(raw_ptr as *const u8);
                let phys_addr = MEMORY_MAPPING
                    .get()
                    .unwrap()
                    .translate_addr(virt_ptr.clone())
                    .unwrap();

                desc.addr = phys_addr.as_u64();
                desc.status = 0;
            }

            let boxed_desc = Box::new(descriptors);
            let raw_desc_ptr = Box::into_raw(boxed_desc);
            let desc_virt_ptr = x86_64::VirtAddr::from_ptr(raw_desc_ptr);
            let desc_phys_addr = MEMORY_MAPPING
                .get()
                .unwrap()
                .translate_addr(desc_virt_ptr.clone())
                .unwrap();

            let ptr = desc_phys_addr.as_u64();

            coms.write_command(REG_TXDESCLO, (ptr >> 32) as u32);
            coms.write_command(REG_TXDESCHI, ptr as u32);

            coms.write_command(REG_RXDESCLO, ptr as u32);
            coms.write_command(REG_RXDESCHI, 0);

            coms.write_command(REG_RXDESCLEN, RX_DESC as u32 * 16);

            coms.write_command(REG_RXDESCHEAD, 0);
            coms.write_command(REG_RXDESCTAIL, RX_DESC as u32 - 1);

            coms.write_command(
                REG_RCTRL,
                RCTL_EN
                    | RCTL_SBP
                    | RCTL_UPE
                    | RCTL_MPE
                    | RCTL_LBM_NONE
                    | RTCL_RDMTS_HALF
                    | RCTL_BAM
                    | RCTL_SECRC
                    | RCTL_BSIZE_2048,
            );

            desc_virt_ptr
        };

        // initialize TX stuff
        let tx_desc_ptr = {
            let mut descriptors = [tx_desc {
                addr: 0,
                length: 0,
                status: 0,
                cso: 0,
                cmd: 0,
                css: 0,
                special: 0,
            }; TX_DESC + 1];

            for desc in descriptors.iter_mut() {
                desc.addr = 0;
                desc.cmd = 0;
                desc.status = TSTA_DD;
            }

            let boxed_desc = Box::new(descriptors);
            let raw_desc_ptr = Box::into_raw(boxed_desc);
            let desc_virt_ptr = x86_64::VirtAddr::from_ptr(raw_desc_ptr);
            let desc_phys_addr = MEMORY_MAPPING
                .get()
                .unwrap()
                .translate_addr(desc_virt_ptr.clone())
                .unwrap();

            let ptr = desc_phys_addr.as_u64();

            coms.write_command(REG_TXDESCHI, (ptr >> 32) as u32);
            coms.write_command(REG_TXDESCLO, ptr as u32);

            coms.write_command(REG_TXDESCLEN, TX_DESC as u32 * 16);

            coms.write_command(REG_TXDESCHEAD, 0);
            coms.write_command(REG_TXDESCTAIL, 0);

            coms.write_command(
                REG_TCTRL,
                TCTL_EN | TCTL_PSP | (15 << TCTL_CT_SHIFT) | (64 << TCTL_COLD_SHIFT) | TCTL_RTLC,
            );
            //coms.write_command(REG_TCTRL, 0b0110000000000111111000011111010);
            coms.write_command(REG_TIPG, 0x0060200A);

            desc_virt_ptr
        };

        {
            /*
            coms.write_command(REG_IMASK, 0x1F6DC);
            coms.write_command(REG_IMASK, 0xff & !4);
            coms.read_command(0xc0);
            */

            coms.write_command(0x00d0, 0x04 | 0x80);
            coms.read_command(0xc0);
        }

        Self {
            com: coms,
            has_eeprom,
            rx_ptr: rx_desc_ptrs,
            tx_ptr: tx_desc_ptr,
            cur_tx: 0,
        }
    }

    pub fn read_eeprom(&self, addr: u8) -> u16 {
        if self.has_eeprom {
            self.com.write_command(0x0014, 1 | ((addr as u32) << 8));
            let mut tmp;
            loop {
                tmp = self.com.read_command(0x0014);

                if tmp & (1 << 4) > 0 {
                    break;
                }
            }

            ((tmp >> 16) & 0xFFFF) as u16
        } else {
            todo!("Read from EEPROM without eeprom")
        }
    }

    pub fn read_mac_address(&self) -> [u8; 6] {
        if self.has_eeprom {
            let first2 = self.read_eeprom(0);
            let second2 = self.read_eeprom(1);
            let third2 = self.read_eeprom(2);

            let first_parts = first2.to_le_bytes();
            let second_parts = second2.to_le_bytes();
            let third_parts = third2.to_le_bytes();

            let address = [
                (first2 & 0xff) as u8,
                (first2 >> 8) as u8,
                (second2 & 0xff) as u8,
                (second2 >> 8) as u8,
                (third2 & 0xff) as u8,
                (third2 >> 8) as u8,
            ];

            address
        } else {
            todo!("Read MacAddress without EEPROM")
        }
    }

    pub fn send_packet(&mut self, data: &[u8]) {
        let raw_address = self.tx_ptr.as_u64();
        let base_ptr = unsafe {
            &mut *(((raw_address as usize) as *const tx_desc as *mut tx_desc)
                .add(self.cur_tx as usize))
        };

        base_ptr.addr = MEMORY_MAPPING
            .get()
            .unwrap()
            .translate_addr(x86_64::VirtAddr::from_ptr(data.as_ptr()))
            .unwrap()
            .as_u64();
        base_ptr.length = data.len() as u16;
        base_ptr.cmd = CMD_EOP | CMD_IFCS | CMD_RS;
        base_ptr.status = 0;

        let next_tail = (self.cur_tx + 1) % 8;

        self.com.write_command(REG_TXDESCTAIL, next_tail);
        while base_ptr.status & 0xff == 0 {}

        self.cur_tx = next_tail;
    }
}
