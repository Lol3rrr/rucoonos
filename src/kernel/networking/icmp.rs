use super::{ethernet, ipv4};

pub struct Packet {
    ip_packet: ipv4::Packet,
}

pub enum Type {
    EchoRequest { identifier: u16, sequence: u16 },
    EchoReply { identifier: u16, sequence: u16 },
    Unknown([u8; 2]),
}

impl From<&[u8]> for Type {
    fn from(raw: &[u8]) -> Self {
        match (raw[0], raw[1]) {
            (0, 0) => Self::EchoReply {
                identifier: u16::from_be_bytes((raw[4..6]).try_into().unwrap()),
                sequence: u16::from_be_bytes((raw[6..8]).try_into().unwrap()),
            },
            (8, 0) => Self::EchoRequest {
                identifier: u16::from_be_bytes((raw[4..6]).try_into().unwrap()),
                sequence: u16::from_be_bytes((raw[6..8]).try_into().unwrap()),
            },
            (ty, sub_ty) => Self::Unknown([ty, sub_ty]),
        }
    }
}

impl Into<([u8; 2], [u8; 4])> for Type {
    fn into(self) -> ([u8; 2], [u8; 4]) {
        match self {
            Self::EchoReply {
                sequence,
                identifier,
            } => {
                let seq_bytes = sequence.to_be_bytes();
                let ident_bytes = identifier.to_be_bytes();
                (
                    [0, 0],
                    [ident_bytes[0], ident_bytes[1], seq_bytes[0], seq_bytes[1]],
                )
            }
            Self::EchoRequest {
                sequence,
                identifier,
            } => {
                let seq_bytes = sequence.to_be_bytes();
                let ident_bytes = identifier.to_be_bytes();
                (
                    [8, 0],
                    [ident_bytes[0], ident_bytes[1], seq_bytes[0], seq_bytes[1]],
                )
            }
            Self::Unknown(d) => (d, [0, 0, 0, 0]),
        }
    }
}

impl Packet {
    pub fn new(packet: ipv4::Packet) -> Self {
        Self { ip_packet: packet }
    }

    pub fn get_type(&self) -> Type {
        let raw_data = self.ip_packet.payload();
        raw_data.into()
    }

    pub fn ipv4_packet(&self) -> &ipv4::Packet {
        &self.ip_packet
    }

    pub fn payload(&self) -> &[u8] {
        let raw_payload = self.ip_packet.payload();
        let offset = match self.get_type() {
            Type::EchoReply { .. } => 8,
            Type::EchoRequest { .. } => 8,
            Type::Unknown(_) => 8,
        };

        &raw_payload[offset..]
    }
}

pub struct InitialState {}
pub struct TypeState {
    ty: Type,
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

    pub fn set_type(self, ty: Type) -> PacketBuilder<TypeState> {
        PacketBuilder {
            state: TypeState { ty },
        }
    }
}
impl PacketBuilder<TypeState> {
    pub fn finish<P, S>(
        self,
        builder: ipv4::PacketBuilder<ipv4::DestinationState>,
        payload_func: P,
        payload_size: S,
    ) -> Result<ethernet::Packet, ()>
    where
        P: FnOnce(&mut [u8]) -> Result<usize, ()>,
        S: Fn() -> usize,
    {
        let header_size = match &self.state.ty {
            Type::EchoReply { .. } => 8,
            Type::EchoRequest { .. } => 8,
            Type::Unknown(_) => 8,
        };

        builder.finish(
            |payload| {
                let (type_bytes, rest_header_bytes): ([u8; 2], [u8; 4]) = self.state.ty.into();

                (&mut payload[0..2]).copy_from_slice(&type_bytes);
                (&mut payload[2..4]).copy_from_slice(&[0, 0]);
                (&mut payload[4..8]).copy_from_slice(&rest_header_bytes);
                let _ = payload_func(&mut payload[8..]);

                let raw_checksum: u32 = payload
                    .chunks_exact(2)
                    .take((header_size + payload_size()) / 2)
                    .map(|c| u16::from_be_bytes(c.try_into().unwrap()) as u32)
                    .sum();
                let checksum = !((raw_checksum as u16) + ((raw_checksum >> 16) as u16));

                (&mut payload[2..4]).copy_from_slice(&checksum.to_be_bytes());

                Ok(header_size + payload_size())
            },
            || header_size + payload_size(),
        )
    }
}
