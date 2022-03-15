use core::marker::PhantomData;

use super::Coms;

/// Marks a Register as Writeable
pub trait WriteableRegister {}
/// Marks a Register as Readable
pub trait ReadableRegister {}

/// Marker that a Register is Read-Write
pub struct RegisterRW {}
/// Marker that a Register is Read-Only
pub struct RegisterRO {}
/// Marker that a Register is Write-Only
pub struct RegisterWO {}

// The corresponding Trait-impsl to get the Markers working correctly
impl WriteableRegister for RegisterWO {}
impl WriteableRegister for RegisterRW {}
impl ReadableRegister for RegisterRW {}
impl ReadableRegister for RegisterRO {}

/// A generic Register that enables a more Type-Safe way of interacting with the underlying
/// Registers of the E1000
///
/// # Generics
/// * ADDR: The Address of the Register
/// * T: The Type of the Content stored in the Register
/// * RT: Marker for the capabilities of the Register (RO/RW/WO)
pub struct Register<const ADDR: u16, T, RT> {
    _phantom: PhantomData<T>,
    _access: PhantomData<RT>,
}

impl<const N: u16, T, RT> Register<N, T, RT> {
    /// Creates a new Instance of the Register
    pub const fn new() -> Self {
        Self {
            _phantom: PhantomData {},
            _access: PhantomData {},
        }
    }
}

impl<const N: u16, T, RT> Register<N, T, RT>
where
    T: From<u32>,
    RT: ReadableRegister,
{
    pub fn read(&self, com: &Coms) -> T {
        com.read_command(N).into()
    }
}

impl<const N: u16, T, RT> Register<N, T, RT>
where
    RT: WriteableRegister,
{
    pub unsafe fn write_raw(&self, com: &Coms, value: u32) {
        com.write_command(N, value);
    }
}
impl<const N: u16, T, RT> Register<N, T, RT>
where
    T: Into<u32>,
    RT: WriteableRegister,
{
    pub fn write(&self, com: &Coms, value: T) {
        unsafe {
            self.write_raw(com, value.into());
        }
    }
}

/// The Control-Register
pub type CTRL = Register<0x0000, CtrlRegister, RegisterRW>;

/// Defined on Pages 170-171
#[derive(Debug)]
pub struct CtrlRegister {
    full_duplex: bool,
    master_disable: bool,
    speed_selection: u8,
    force_speed: bool,
    force_duplex: bool,
    lanphypc_override: bool,
    lanphypc_value: bool,
    lcd_power_down: bool,
    host_to_me_interrupt: bool,
    host_software_reset: bool,
    receive_flow_control_enable: bool,
    transmit_flow_control_enable: bool,
    vlan_mode_enable: bool,
    lan_connected_device_reset: bool,
}

impl From<u32> for CtrlRegister {
    fn from(raw: u32) -> Self {
        Self {
            full_duplex: ((raw >> 0) & 0b01) != 0,
            master_disable: ((raw >> 2) & 0b01) != 0,
            speed_selection: ((raw >> 8) & 0b11) as u8,
            force_speed: ((raw >> 11) & 0b01) != 0,
            force_duplex: ((raw >> 12) & 0b01) != 0,
            lanphypc_override: ((raw >> 16) & 0b01) != 0,
            lanphypc_value: ((raw >> 17) & 0b01) != 0,
            lcd_power_down: ((raw >> 24) & 0b01) != 0,
            host_to_me_interrupt: ((raw >> 25) & 0b01) != 0,
            host_software_reset: ((raw >> 26) & 0b01) != 0,
            receive_flow_control_enable: ((raw >> 27) & 0b01) != 0,
            transmit_flow_control_enable: ((raw >> 28) & 0b01) != 0,
            vlan_mode_enable: ((raw >> 30) & 0b01) != 0,
            lan_connected_device_reset: ((raw >> 31) & 0b01) != 0,
        }
    }
}
impl Into<u32> for CtrlRegister {
    fn into(self) -> u32 {
        let mut result: u32 = 0;

        if self.full_duplex {
            result |= 1 << 0;
        }
        if self.master_disable {
            result |= 1 << 2;
        }
        result |= (self.speed_selection as u32) << 8;
        if self.force_speed {
            result |= 1 << 11;
        }
        if self.force_duplex {
            result |= 1 << 12;
        }
        if self.lanphypc_override {
            result |= 1 << 16;
        }
        if self.lanphypc_value {
            result |= 1 << 17;
        }
        if self.lcd_power_down {
            result |= 1 << 24;
        }
        if self.host_to_me_interrupt {
            result |= 1 << 25;
        }
        if self.host_software_reset {
            result |= 1 << 26;
        }
        if self.receive_flow_control_enable {
            result |= 1 << 27;
        }
        if self.transmit_flow_control_enable {
            result |= 1 << 28;
        }
        if self.vlan_mode_enable {
            result |= 1 << 30;
        }
        if self.lan_connected_device_reset {
            result |= 1 << 31;
        }

        result
    }
}

impl Default for CtrlRegister {
    fn default() -> Self {
        Self {
            full_duplex: true,
            master_disable: false,
            speed_selection: 0b10,
            force_speed: false,
            force_duplex: false,
            lanphypc_override: false,
            lanphypc_value: false,
            lcd_power_down: false,
            host_to_me_interrupt: false,
            host_software_reset: false,
            receive_flow_control_enable: false,
            transmit_flow_control_enable: false,
            vlan_mode_enable: false,
            lan_connected_device_reset: false,
        }
    }
}

/// The Status Register
pub(crate) type STATUS = Register<0x0008, StatusRegister, RegisterRO>;

/// Defined on Pages 172-173
#[derive(Debug)]
pub struct StatusRegister {
    pub full_duplex: bool,
    pub link_up: bool,
    pub phy_type_indication: u8,
    pub transmition_paused: bool,
    pub phy_power_up: bool,
    pub link_speed: u8,
    pub master_read_completions_blocked: bool,
    pub lan_init_done: bool,
    pub phy_reset_asserted: bool,
    pub master_enable_status: bool,
    pub pcim_function_state: bool,
    pub clock_control_quarter: bool,
}

impl From<u32> for StatusRegister {
    fn from(raw: u32) -> Self {
        Self {
            full_duplex: ((raw >> 0) & 0b01) != 0,
            link_up: ((raw >> 1) & 0b01) != 0,
            phy_type_indication: ((raw >> 2) & 0b11) as u8,
            transmition_paused: ((raw >> 4) & 0b01) != 0,
            phy_power_up: ((raw >> 5) & 0b01) == 0,
            link_speed: ((raw >> 6) & 0b11) as u8,
            master_read_completions_blocked: ((raw >> 8) & 0b01) != 0,
            lan_init_done: ((raw >> 9) & 0b01) != 0,
            phy_reset_asserted: ((raw >> 10) & 0b01) != 0,
            master_enable_status: ((raw >> 19) & 0b01) != 0,
            pcim_function_state: ((raw >> 30) & 0b01) != 0,
            clock_control_quarter: ((raw >> 31) & 0b01) != 0,
        }
    }
}

pub(crate) type IMASK = Register<0x00D0, IMaskRegister, RegisterRW>;

/// Page 191-192
#[derive(Debug)]
pub struct IMaskRegister {
    txdw: bool,
    txqe: bool,
    lsc: bool,
    rxdmto: bool,
    dsw: bool,
    rxo: bool,
    rxto: bool,
}

impl From<u32> for IMaskRegister {
    fn from(raw: u32) -> Self {
        Self {
            txdw: ((raw >> 0) & 0b01) != 0,
            txqe: ((raw >> 1) & 0b01) != 0,
            lsc: ((raw >> 2) & 0b01) != 0,
            rxdmto: ((raw >> 4) & 0b01) != 0,
            dsw: ((raw >> 5) & 0b01) != 0,
            rxo: ((raw >> 6) & 0b01) != 0,
            rxto: ((raw >> 7) & 0b01) != 0,
        }
    }
}

impl Into<u32> for IMaskRegister {
    fn into(self) -> u32 {
        let mut result: u32 = 0;

        if self.txdw {
            result |= 1 << 0;
        }
        if self.txqe {
            result |= 1 << 1;
        }
        if self.lsc {
            result |= 1 << 2;
        }
        if self.rxdmto {
            result |= 1 << 4;
        }
        if self.dsw {
            result |= 1 << 5;
        }
        if self.rxo {
            result |= 1 << 6;
        }
        if self.rxto {
            result |= 1 << 7;
        }

        result
    }
}

impl Default for IMaskRegister {
    fn default() -> Self {
        Self {
            txdw: false,
            txqe: false,
            lsc: false,
            rxdmto: false,
            dsw: false,
            rxo: false,
            rxto: false,
        }
    }
}

impl IMaskRegister {
    pub fn set_txdw(&mut self, value: bool) -> &mut Self {
        self.txdw = value;
        self
    }
    pub fn set_txqe(&mut self, value: bool) -> &mut Self {
        self.txqe = value;
        self
    }
    pub fn set_lsc(&mut self, value: bool) -> &mut Self {
        self.lsc = value;
        self
    }
    pub fn set_rxdmto(&mut self, value: bool) -> &mut Self {
        self.rxdmto = value;
        self
    }
    pub fn set_dsw(&mut self, value: bool) -> &mut Self {
        self.dsw = value;
        self
    }
    pub fn set_rxo(&mut self, value: bool) -> &mut Self {
        self.rxo = value;
        self
    }
    pub fn set_rxto(&mut self, value: bool) -> &mut Self {
        self.rxto = value;
        self
    }
}

pub(crate) type InterruptCause = Register<0x00c8, InterruptCauseRegister, RegisterRW>;

#[derive(Debug)]
pub struct InterruptCauseRegister {
    pub txdw: bool,
    pub txqe: bool,
    pub lsc: bool,
    pub rxdmt: bool,
    pub dsw: bool,
    pub rxo: bool,
    /// The Receive Timer Interrupt
    pub rxt: bool,
    pub int_asserted: bool,
}

impl From<u32> for InterruptCauseRegister {
    fn from(raw: u32) -> Self {
        Self {
            txdw: ((raw >> 0) & 0b01) != 0,
            txqe: ((raw >> 1) & 0b01) != 0,
            lsc: ((raw >> 2) & 0b01) != 0,
            rxdmt: ((raw >> 4) & 0b01) != 0,
            dsw: ((raw >> 5) & 0b01) != 0,
            rxo: ((raw >> 6) & 0b01) != 0,
            rxt: ((raw >> 7) & 0b01) != 0,
            int_asserted: ((raw >> 31) & 0b01) != 0,
        }
    }
}

impl Into<u32> for InterruptCauseRegister {
    fn into(self) -> u32 {
        let mut result = 0;

        if self.txdw {
            result |= 1 << 0;
        }
        if self.txqe {
            result |= 1 << 1;
        }
        if self.lsc {
            result |= 1 << 2;
        }
        if self.rxdmt {
            result |= 1 << 4;
        }
        if self.dsw {
            result |= 1 << 5;
        }
        if self.rxo {
            result |= 1 << 6;
        }
        if self.rxt {
            result |= 1 << 7;
        }
        if self.int_asserted {
            result |= 1 << 31;
        }

        result
    }
}

impl Default for InterruptCauseRegister {
    fn default() -> Self {
        Self {
            txdw: false,
            txqe: false,
            lsc: false,
            rxdmt: false,
            dsw: false,
            rxo: false,
            rxt: false,
            int_asserted: false,
        }
    }
}

impl InterruptCauseRegister {
    pub fn set_txdw(&mut self, value: bool) -> &mut Self {
        self.txdw = value;
        self
    }
    pub fn set_txqe(&mut self, value: bool) -> &mut Self {
        self.txqe = value;
        self
    }
}
