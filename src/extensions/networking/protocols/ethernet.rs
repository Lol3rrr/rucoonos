use super::Buffer;

pub struct Packet {
    buffer: Buffer,
}

/// The Type of Packet contained in the Ethernet Packet
#[derive(Debug)]
pub enum EthType {
    /// It contains an IPv4 Packet
    Ipv4,
    /// It contains an IPv6 Packet
    Ipv6,
    /// It contains an ARP Packet
    Arp,
    /// It contains a WakeOnLan magic Packet
    WakeOnLan,
    /// It contains an unknown or currently unsupported Packet
    Unknown([u8; 2]),
}

impl From<[u8; 2]> for EthType {
    fn from(raw: [u8; 2]) -> Self {
        match raw {
            [0x08, 0x00] => EthType::Ipv4,
            [0x08, 0x06] => EthType::Arp,
            [0x08, 0x42] => EthType::WakeOnLan,
            [0x86, 0xdd] => EthType::Ipv6,
            unknown => EthType::Unknown(unknown),
        }
    }
}
impl Into<[u8; 2]> for EthType {
    fn into(self) -> [u8; 2] {
        match self {
            Self::Ipv4 => [0x08, 0x00],
            Self::Arp => [0x08, 0x06],
            Self::WakeOnLan => [0x08, 0x42],
            Self::Ipv6 => [0x86, 0xdd],
            Self::Unknown(u) => u,
        }
    }
}

impl Packet {
    pub fn new(buffer: Buffer) -> Self {
        Self { buffer }
    }

    /// The MAC-Address of the Destination
    pub fn destination_mac(&self) -> [u8; 6] {
        self.buffer.as_ref()[0..6].try_into().unwrap()
    }
    /// The MAC-Address of the Source
    pub fn source_mac(&self) -> [u8; 6] {
        self.buffer.as_ref()[6..12].try_into().unwrap()
    }

    /// The Type of Packet contained
    pub fn ether_type(&self) -> EthType {
        let bytes: [u8; 2] = self.buffer.as_ref()[12..14].try_into().unwrap();
        bytes.into()
    }

    /// The inner Content of the ethernet Packet
    pub fn content(&self) -> &[u8] {
        &self.buffer.as_ref()[14..(self.buffer.len())]
    }

    /// Turns the Packet back into a Buffer
    pub fn into_buffer(self) -> Buffer {
        self.buffer
    }
}

pub struct InitialState {}
pub struct SourceState {
    source: [u8; 6],
}
pub struct DestinationState {
    source: [u8; 6],
    destination: [u8; 6],
}
pub struct EtherTypeState {
    source: [u8; 6],
    destination: [u8; 6],
    ether_ty: [u8; 2],
}

pub struct PacketBuilder<S> {
    state: S,
}

impl PacketBuilder<InitialState> {
    /// Create the empty Packet Builder
    pub fn new() -> Self {
        Self {
            state: InitialState {},
        }
    }

    /// Set the Source MAC-Address of the Ethernet Packet
    pub fn source(self, mac: [u8; 6]) -> PacketBuilder<SourceState> {
        PacketBuilder {
            state: SourceState { source: mac },
        }
    }
}
impl PacketBuilder<SourceState> {
    /// Set the Destination MAC-Address of the Ethernet Packet
    pub fn destination(self, mac: [u8; 6]) -> PacketBuilder<DestinationState> {
        PacketBuilder {
            state: DestinationState {
                source: self.state.source,
                destination: mac,
            },
        }
    }
}
impl PacketBuilder<DestinationState> {
    /// Set the Type of Packet Contained in the Ethernet Packet
    pub fn ether_ty<T>(self, ty: T) -> PacketBuilder<EtherTypeState>
    where
        T: Into<[u8; 2]>,
    {
        PacketBuilder {
            state: EtherTypeState {
                source: self.state.source,
                destination: self.state.destination,
                ether_ty: ty.into(),
            },
        }
    }
}
impl PacketBuilder<EtherTypeState> {
    /// Finish building the Packet and fill the buffer by running the provided Closure
    ///
    /// # Arguments
    /// * payload: A closure that receives a Buffer of (1500 - 14) Bytes into which it should write its data
    pub fn finish<F>(self, payload: F) -> Result<Packet, ()>
    where
        F: FnOnce(&mut [u8]) -> Result<usize, ()>,
    {
        let mut content = [0u8; 1500];
        (&mut content[0..6]).copy_from_slice(&self.state.destination);
        (&mut content[6..12]).copy_from_slice(&self.state.source);
        (&mut content[12..14]).copy_from_slice(&self.state.ether_ty);

        let written_len = payload(&mut content[14..])?;
        let len = core::cmp::max(written_len, 46);

        let buffer = Buffer::new(&content[0..(len + 14)]);
        Ok(Packet::new(buffer))
    }
}
