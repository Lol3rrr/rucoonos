use super::ethernet;

pub struct Packet {
    hardware_ty: u16,
    protocol_ty: u16,
    hardware_size: u8,
    protocol_size: u8,
    operation: u16,
    pub src_mac: [u8; 6],
    pub src_ip: [u8; 4],
    dest_mac: [u8; 6],
    dest_ip: [u8; 4],
    eth_packet: ethernet::Packet,
}

/// The Operations that an ARP Packet can "perform"/represent
#[derive(Debug)]
pub enum Operation {
    /// It is looking for the Mac-Address of the Destination IP
    Request,
    /// This is send by the Target Machine in response, to notify the requester that we are the
    /// corresponding machine
    Response,
    /// An unknown ARP Operation, which could represent an invalid Operation or an unsupported Operation
    Unknown(u16),
}

impl From<u16> for Operation {
    fn from(raw: u16) -> Self {
        match raw {
            1 => Self::Request,
            2 => Self::Response,
            unknown => Self::Unknown(unknown),
        }
    }
}
impl Into<u16> for Operation {
    fn into(self) -> u16 {
        match self {
            Self::Request => 1,
            Self::Response => 2,
            Self::Unknown(unknown) => unknown,
        }
    }
}

impl Packet {
    /// Attempt to parse the ethernet Packet as an ArpPacket
    ///
    /// # Failure
    /// This will fail if the Ethernet Packet has not enough content to actually hold the Packet
    pub fn new(eth: ethernet::Packet) -> Result<Self, ()> {
        let content = eth.content();
        if content.len() < 28 {
            return Err(());
        }

        let hardware_ty = u16::from_be_bytes(content[0..2].try_into().unwrap());
        let protocol_ty = u16::from_be_bytes(content[2..4].try_into().unwrap());
        let hardware_size = content[4];
        let protocol_size = content[5];
        let operation = u16::from_be_bytes(content[6..8].try_into().unwrap());
        let src_mac = content[8..14].try_into().unwrap();
        let src_ip = content[14..18].try_into().unwrap();
        let dest_mac = content[18..24].try_into().unwrap();
        let dest_ip = content[24..28].try_into().unwrap();

        Ok(Self {
            hardware_ty,
            protocol_ty,
            hardware_size,
            protocol_size,
            operation,
            src_mac,
            src_ip,
            dest_mac,
            dest_ip,
            eth_packet: eth,
        })
    }

    /// Get the Operation of the given ARP Packet
    pub fn operation(&self) -> Operation {
        self.operation.into()
    }

    /// Get the Destination IP of the ARP Packet
    pub fn dest_ip(&self) -> &[u8; 4] {
        &self.dest_ip
    }
}

pub struct InitialState {}
pub struct SenderState {
    mac: [u8; 6],
    ip: [u8; 4],
}
pub struct DestinationState {
    sender: SenderState,
    mac: [u8; 6],
    ip: [u8; 4],
}
pub struct OperationState {
    destination: DestinationState,
    operation: u16,
}

pub struct PacketBuilder<S> {
    state: S,
}

impl PacketBuilder<InitialState> {
    /// An empty Packet Builder with no information stored
    pub fn new() -> Self {
        Self {
            state: InitialState {},
        }
    }

    /// Set the Sender related information, it's IP and MAC-Addresss
    pub fn sender(self, mac: [u8; 6], ip: [u8; 4]) -> PacketBuilder<SenderState> {
        PacketBuilder {
            state: SenderState { mac, ip },
        }
    }
}
impl PacketBuilder<SenderState> {
    /// Set the Destination related information, it's IP and MAC-Address
    pub fn destination(self, mac: [u8; 6], ip: [u8; 4]) -> PacketBuilder<DestinationState> {
        PacketBuilder {
            state: DestinationState {
                sender: self.state,
                mac,
                ip,
            },
        }
    }
}
impl PacketBuilder<DestinationState> {
    /// Set the correct Operation for the Packet
    pub fn operation(self, operation: Operation) -> PacketBuilder<OperationState> {
        PacketBuilder {
            state: OperationState {
                destination: self.state,
                operation: operation.into(),
            },
        }
    }
}
impl PacketBuilder<OperationState> {
    /// Finish the Packet-Builder and return the final ethernet Packet to send out
    pub fn finish(self) -> Result<ethernet::Packet, ()> {
        ethernet::PacketBuilder::new()
            .source(self.state.destination.sender.mac.clone())
            .destination(self.state.destination.mac.clone())
            .ether_ty(ethernet::EthType::Arp)
            .finish(|payload| {
                (&mut payload[0..2]).copy_from_slice(&[0, 1]);
                (&mut payload[2..4]).copy_from_slice(&[0x08, 00]);
                payload[4] = 6;
                payload[5] = 4;
                (&mut payload[6..8]).copy_from_slice(&self.state.operation.to_be_bytes());
                (&mut payload[8..14]).copy_from_slice(&self.state.destination.sender.mac);
                (&mut payload[14..18]).copy_from_slice(&self.state.destination.sender.ip);
                (&mut payload[18..24]).copy_from_slice(&self.state.destination.mac);
                (&mut payload[24..28]).copy_from_slice(&self.state.destination.ip);

                Ok(28)
            })
    }
}
