use alloc::boxed::Box;
use x86_64::structures::paging::Translate;

// https://br.mouser.com/datasheet/2/612/i217_ethernet_controller_datasheet-257741.pdf

use crate::{
    kernel::{allocator, networking, pci, MEMORY_MAPPING},
    println,
};

pub struct E1000Card {
    com: Coms,
    has_eeprom: bool,
    rx_ptr: x86_64::VirtAddr,
    tx_ptr: x86_64::VirtAddr,
    cur_tx: u32,
    cur_rx: u32,
    last_reclaimed_tx: u32,
    rx_buffers: [*const u8; RX_DESC],
    tx_buffers: [*const u8; TX_DESC],
    packet_queue: PacketQueueReceiver,
}

unsafe impl Send for E1000Card {}

mod coms;
mod descriptors;
mod regs;
pub(crate) use coms::Coms;

use super::{NetworkingCtx, NetworkingDevice, PacketQueueReceiver};

const REG_CTRL: regs::CTRL = regs::CTRL::new();
const REG_STATUS: regs::STATUS = regs::STATUS::new();
const REG_IMASK: regs::IMASK = regs::IMASK::new();
const REG_ICAUSE: regs::InterruptCause = regs::InterruptCause::new();

const REG_TCTRL: u16 = 0x400;
const REG_TXDESCLO: u16 = 0x3800;
const REG_TXDESCHI: u16 = 0x3804;
const REG_TXDESCLEN: u16 = 0x3808;
const REG_TXDESCHEAD: u16 = 0x3810;
const REG_TXDESCTAIL: u16 = 0x3818;
const REG_TXDESCCTRL: u16 = 0x3828;

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
struct RxDesc {
    addr: u64,
    length: u16,
    checksum: u16,
    status: u8,
    errors: u8,
    special: u16,
}

impl Default for RxDesc {
    fn default() -> Self {
        Self {
            addr: 0,
            length: 0,
            checksum: 0,
            status: 0,
            errors: 0,
            special: 0,
        }
    }
}

#[derive(Debug, Clone, Copy)]
#[repr(packed)]
struct TxDesc {
    addr: u64,
    length: u16,
    cso: u8,
    cmd: u8,
    status: u8,
    css: u8,
    special: u16,
}

impl Default for TxDesc {
    fn default() -> Self {
        Self {
            addr: 0,
            length: 0,
            cso: 0,
            cmd: 0,
            status: 0,
            css: 0,
            special: 0,
        }
    }
}

// The Number of RX Descriptors
const RX_DESC: usize = 32;
// The Number of TX Descriptors
const TX_DESC: usize = 8;

impl E1000Card {
    pub fn init(
        bar: pci::BaseAddressRegister,
        offset: u64,
        packet_queue: PacketQueueReceiver,
    ) -> (Self, impl Fn()) {
        let coms = Coms::new(bar, offset);

        let status = REG_STATUS.read(&coms);

        // Check for EEPROM
        coms.write_command(0x0014, 0x1);
        let has_eeprom = (0..1000).any(|_| coms.read_command(0x0014) & 0x10 > 0);

        // initialize RX stuff
        let (rx_desc_ptrs, rx_buffers) = {
            let mut descriptors = [RxDesc::default(); RX_DESC + 1];

            let mut rx_buffers = [0 as *const u8; RX_DESC];

            for (index, desc) in descriptors.iter_mut().enumerate() {
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

                if let Some(target) = rx_buffers.get_mut(index) {
                    *target = raw_ptr as *const u8;
                }
            }

            // We manually allocate here as we must garantue the correct Layout (size +
            // alignment)
            let raw_desc_ptr = descriptors::allocate_buffer(descriptors, &allocator::ALLOCATOR);
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

            (desc_virt_ptr, rx_buffers)
        };

        // initialize TX stuff
        let tx_desc_ptr = {
            let mut descriptors = [TxDesc::default(); TX_DESC + 1];

            for desc in descriptors.iter_mut() {
                desc.addr = 0;
                desc.cmd = 0;
                desc.status = TSTA_DD;
            }

            let raw_desc_ptr = descriptors::allocate_buffer(descriptors, &allocator::ALLOCATOR);
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

        (
            Self {
                com: coms.clone(),
                has_eeprom,
                rx_ptr: rx_desc_ptrs,
                tx_ptr: tx_desc_ptr,
                cur_tx: 0,
                cur_rx: 0,
                last_reclaimed_tx: 0,
                rx_buffers,
                tx_buffers: [0 as *const u8; TX_DESC],
                packet_queue,
            },
            move || {
                let mut cause = regs::InterruptCauseRegister::default();
                cause.set_txd_low(true).set_asserted(false);

                coms.write_command(0xc8, cause.into());
            },
        )
    }

    pub fn enable_interrupts(&mut self) {
        //coms.write_command(0x00d0, 0x04 | 0x80);
        //coms.read_command(0xc0);

        // Set the TX-Threshold to 1
        self.com.write_command(REG_TXDESCCTRL, 0 | (2 << 25));

        // Throttle to 500 * 256ns
        // self.com.write_command(0xc4, 500);

        let mut imask_value = regs::IMaskRegister::default();

        imask_value
            .set_txdw(true)
            .set_txqe(false)
            .set_lsc(true)
            .set_rxdmto(false)
            .set_rxo(false)
            .set_rxto(true)
            .set_txd_low(true);

        REG_IMASK.write(&self.com, imask_value);

        self.com.read_command(0xc0);
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

    pub fn get_intterupt_cause(&self) -> regs::InterruptCauseRegister {
        REG_ICAUSE.read(&self.com)
    }

    unsafe fn enqueue_packet(&mut self, data_ptr: *mut [u8], len: usize) {
        let raw_address = self.tx_ptr.as_u64();
        let base_ptr = unsafe {
            &mut *(((raw_address as usize) as *const TxDesc as *mut TxDesc)
                .add(self.cur_tx as usize))
        };

        base_ptr.addr = MEMORY_MAPPING
            .get()
            .unwrap()
            .translate_addr(x86_64::VirtAddr::from_ptr(data_ptr as *mut u8))
            .unwrap()
            .as_u64();
        base_ptr.length = len as u16;
        base_ptr.cmd = CMD_EOP | CMD_IFCS | CMD_RS;
        base_ptr.status = 0;

        self.tx_buffers[self.cur_tx as usize] = data_ptr as *const u8;

        let next_tail = (self.cur_tx + 1) % 8;

        self.com.write_command(REG_TXDESCTAIL, next_tail);
        self.cur_tx = next_tail;
    }
}

impl NetworkingDevice for E1000Card {
    fn handles_interrupt(&self, irq_offset: u8) -> bool {
        irq_offset == 0xb
    }

    fn handle_interrupt(&mut self, ctx: &mut NetworkingCtx) {
        let cause = self.get_intterupt_cause();

        if cause.rxt {
            loop {
                let target_ptr =
                    unsafe { self.rx_ptr.as_ptr::<RxDesc>().add(self.cur_rx as usize) };
                let mut desc = unsafe { target_ptr.read_volatile() };

                if (desc.status & 0b01) == 0 {
                    break;
                }

                let len = desc.length;

                let addr = self.rx_buffers[self.cur_rx as usize];
                let slice = unsafe { core::slice::from_raw_parts(addr, len as usize) };

                ctx.handle_packet(slice);

                desc.status = 0;
                unsafe {
                    (target_ptr as *mut RxDesc).write_volatile(desc);
                }

                let old_rx = self.cur_rx;
                self.cur_rx = (self.cur_rx + 1) % (RX_DESC as u32);
                self.com.write_command(REG_RXDESCTAIL, old_rx);
            }
        }

        let cur_tx_head = self.com.read_command(REG_TXDESCHEAD);
        let cur_tx_tail = self.com.read_command(REG_TXDESCTAIL);

        if cur_tx_head == cur_tx_tail && (cause.txd_low || cause.txdw) {
            for _ in 0..TX_DESC {
                match unsafe { self.packet_queue.dequeue() } {
                    Some(packet) => {
                        let buffer = packet.into_buffer();
                        let (data_ptr, len) = buffer.into_raw();
                        unsafe {
                            self.enqueue_packet(data_ptr, len);
                        }
                    }
                    None => {
                        break;
                    }
                };
            }
        }

        if cause.txdw {
            for tx_index in (0..8u32)
                .cycle()
                .skip(self.last_reclaimed_tx as usize)
                .take_while(|i| *i != cur_tx_head)
            {
                let raw_address = self.tx_ptr.as_u64();
                let base_ptr = unsafe {
                    &mut *(((raw_address as usize) as *const TxDesc as *mut TxDesc)
                        .add(tx_index as usize))
                };

                if base_ptr.status != 1 {
                    continue;
                }

                let tx_data_ptr = self.tx_buffers[tx_index as usize];
                let buffer = unsafe {
                    networking::Buffer::from_raw(tx_data_ptr as *mut u8 as *mut [u8; 2048], 0)
                };
                drop(buffer);

                self.tx_buffers[tx_index as usize] = 0 as *const u8;
                self.last_reclaimed_tx = (tx_index + 1) % TX_DESC as u32;
            }
        }
    }
}
