use super::ethernet;

/// A Wrapper to simplify the interaction with IPv4-Addresses
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub struct Address([u8; 4]);

/// The Type of the Address, so whether it is LAN, WAN, or Loopback
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum AddressType {
    Lan,
    Wan,
    Loopback,
}

impl From<[u8; 4]> for Address {
    fn from(raw: [u8; 4]) -> Self {
        Self(raw)
    }
}
impl Into<[u8; 4]> for Address {
    fn into(self) -> [u8; 4] {
        self.0
    }
}

impl Address {
    /// Get the Address-Type of the current Address
    pub fn address_ty(&self) -> AddressType {
        match (self.0[0], self.0[1], self.0[2]) {
            (127, _, _) => AddressType::Loopback,
            (10, _, _) | (192, 0, 0) | (192, 168, _) => AddressType::Lan,
            _ => AddressType::Wan,
        }
    }
}

pub struct Packet {
    eth_packet: ethernet::Packet,
}

/// The Protocol contained in the Packet
#[derive(Debug, Clone, Copy)]
pub enum Protocol {
    Icmp,
    Udp,
    Tcp,
    Unknown(u8),
}

impl Into<u8> for Protocol {
    fn into(self) -> u8 {
        match self {
            Self::Icmp => 1,
            Self::Udp => 17,
            Self::Tcp => 6,
            Self::Unknown(proto) => proto,
        }
    }
}
impl From<u8> for Protocol {
    fn from(raw: u8) -> Self {
        match raw {
            1 => Self::Icmp,
            6 => Self::Tcp,
            17 => Self::Udp,
            unknown => Self::Unknown(unknown),
        }
    }
}

#[derive(Debug, Clone, Copy)]
pub struct PacketHeader {
    version: u8,
    ihl: u8,
    dscp: u8,
    ecn: u8,
    total_length: u16,
    pub identification: u16,
    flags: u8,
    fragment_offset: u16,
    ttl: u8,
    pub protocol: Protocol,
    header_checksum: u16,
    pub source_ip: [u8; 4],
    pub destination_ip: [u8; 4],
}

impl PacketHeader {
    /// Calculates the Checksum for the Header and returns a Header with the Checksum set to the correct value
    pub fn set_checksum(mut self) -> Self {
        self.header_checksum = 0;

        let mut raw_bytes = [0u8; 20];
        let _ = self.to_bytes(&mut raw_bytes);

        let raw_result = raw_bytes
            .chunks_exact(2)
            .map(|raw| u16::from_be_bytes(raw.try_into().unwrap()))
            .fold(0u32, |acc, elem| acc + elem as u32);

        let overflows = (raw_result >> 16) as u16;
        let raw_checksum = (raw_result & 0xffff) as u16;

        // TODO
        // does not handle multiple overflows
        self.header_checksum = !(raw_checksum + overflows);

        self
    }

    /// Write the Header to the provided Buffer
    pub fn to_bytes(&self, target: &mut [u8]) -> Result<(), ()> {
        if target.len() < 20 {
            return Err(());
        }

        target[0] = 0 | (self.version << 4) | (self.ihl & 0x0f);
        target[1] = 0 | (self.dscp << 1) | (self.ecn & 0x01);
        (&mut target[2..4]).copy_from_slice(&self.total_length.to_be_bytes());
        (&mut target[4..6]).copy_from_slice(&self.identification.to_be_bytes());
        (&mut target[6..8]).copy_from_slice(&self.fragment_offset.to_be_bytes());
        target[6] |= self.flags << 5;
        target[8] = self.ttl;
        target[9] = self.protocol.into();
        (&mut target[10..12]).copy_from_slice(&self.header_checksum.to_be_bytes());
        (&mut target[12..16]).copy_from_slice(&self.source_ip);
        (&mut target[16..20]).copy_from_slice(&self.destination_ip);

        Ok(())
    }
}

impl Packet {
    /// Create an IPv4 Packet from an ethernet Packet
    pub fn new(raw: ethernet::Packet) -> Self {
        Self { eth_packet: raw }
    }

    /// Load the Header of the Packet
    pub fn header(&self) -> PacketHeader {
        let raw_data = self.eth_packet.content();
        let ihl = (raw_data[0] & 0x0f) as usize;
        let header_size = ihl * 4;

        let header_data = &raw_data[0..header_size];

        PacketHeader {
            version: header_data[0] >> 4,
            ihl: header_data[0] & 0x0f,
            dscp: header_data[1] >> 2,
            ecn: header_data[1] & 0x03,
            total_length: u16::from_be_bytes(header_data[2..4].try_into().unwrap()),
            identification: u16::from_be_bytes(header_data[4..6].try_into().unwrap()),
            flags: header_data[7] >> 5,
            fragment_offset: u16::from_be_bytes([header_data[7] & 0x1f, header_data[8]]),
            ttl: header_data[8],
            protocol: (header_data[9]).into(),
            header_checksum: u16::from_be_bytes(header_data[10..12].try_into().unwrap()),
            source_ip: header_data[12..16].try_into().unwrap(),
            destination_ip: header_data[16..20].try_into().unwrap(),
        }
    }

    /// Get the underlying ethernet Packet
    pub fn eth(&self) -> &ethernet::Packet {
        &self.eth_packet
    }

    /// Get the Payload of the Packet
    pub fn payload(&self) -> &[u8] {
        let raw_data = self.eth_packet.content();
        let ihl = (raw_data[0] & 0x0f) as usize;
        let header_size = ihl * 4;
        &raw_data[header_size..]
    }
}

pub struct InitialState {}
pub struct DSCPState {
    dscp: u8,
}
pub struct IdentificationState {
    dscp: u8,
    ident: u16,
}
pub struct TTLState {
    dscp: u8,
    ident: u16,
    ttl: u8,
}
pub struct ProtocolState {
    dscp: u8,
    ident: u16,
    ttl: u8,
    protocol: Protocol,
}
pub struct SourceState {
    dscp: u8,
    ident: u16,
    ttl: u8,
    protocol: Protocol,
    source: [u8; 4],
    source_mac: [u8; 6],
}
pub struct DestinationState {
    dscp: u8,
    ident: u16,
    ttl: u8,
    protocol: Protocol,
    source: [u8; 4],
    source_mac: [u8; 6],
    destination: [u8; 4],
    destination_mac: [u8; 6],
}

pub struct PacketBuilder<S> {
    state: S,
}

impl PacketBuilder<InitialState> {
    pub fn new() -> Self {
        Self {
            state: InitialState {},
        }
    }

    pub fn dscp(self, dscp: u8) -> PacketBuilder<DSCPState> {
        PacketBuilder {
            state: DSCPState { dscp },
        }
    }
}
impl PacketBuilder<DSCPState> {
    pub fn identification(self, ident: u16) -> PacketBuilder<IdentificationState> {
        PacketBuilder {
            state: IdentificationState {
                dscp: self.state.dscp,
                ident,
            },
        }
    }
}
impl PacketBuilder<IdentificationState> {
    pub fn ttl(self, ttl: u8) -> PacketBuilder<TTLState> {
        PacketBuilder {
            state: TTLState {
                dscp: self.state.dscp,
                ident: self.state.ident,
                ttl,
            },
        }
    }
}
impl PacketBuilder<TTLState> {
    pub fn protocol(self, protocol: Protocol) -> PacketBuilder<ProtocolState> {
        PacketBuilder {
            state: ProtocolState {
                dscp: self.state.dscp,
                ident: self.state.ident,
                ttl: self.state.ttl,
                protocol,
            },
        }
    }
}
impl PacketBuilder<ProtocolState> {
    pub fn source(self, source: [u8; 4], source_mac: [u8; 6]) -> PacketBuilder<SourceState> {
        PacketBuilder {
            state: SourceState {
                dscp: self.state.dscp,
                ident: self.state.ident,
                ttl: self.state.ttl,
                protocol: self.state.protocol,
                source,
                source_mac,
            },
        }
    }
}
impl PacketBuilder<SourceState> {
    pub fn destination(
        self,
        destination: [u8; 4],
        destination_mac: [u8; 6],
    ) -> PacketBuilder<DestinationState> {
        PacketBuilder {
            state: DestinationState {
                dscp: self.state.dscp,
                ident: self.state.ident,
                ttl: self.state.ttl,
                protocol: self.state.protocol,
                source: self.state.source,
                source_mac: self.state.source_mac,
                destination,
                destination_mac,
            },
        }
    }
}
impl PacketBuilder<DestinationState> {
    pub fn finish<F, S>(self, payload: F, payload_size: S) -> Result<ethernet::Packet, ()>
    where
        F: FnOnce(&mut [u8]) -> Result<usize, ()>,
        S: Fn() -> usize,
    {
        ethernet::PacketBuilder::new()
            .source(self.state.source_mac.clone())
            .destination(self.state.destination_mac.clone())
            .ether_ty(ethernet::EthType::Ipv4)
            .finish(|eth_payload| {
                let header = PacketHeader {
                    version: 4,
                    ihl: 5,
                    dscp: self.state.dscp,
                    ecn: 0,
                    total_length: (20 + payload_size()) as u16,
                    identification: self.state.ident,
                    flags: 0,
                    fragment_offset: 0,
                    ttl: self.state.ttl,
                    protocol: self.state.protocol,
                    header_checksum: 0,
                    source_ip: self.state.source,
                    destination_ip: self.state.destination,
                }
                .set_checksum();

                header.to_bytes(&mut eth_payload[0..20]).unwrap();

                let size = payload(&mut eth_payload[20..])?;
                assert_eq!(size, payload_size());

                Ok(20 + payload_size())
            })
    }
}
