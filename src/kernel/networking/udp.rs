use super::{ethernet, ipv4};

pub struct Packet {
    ip_packet: ipv4::Packet,
}

#[derive(Debug)]
pub struct PacketHeader {
    pub source_port: u16,
    pub destination_port: u16,
    length: u16,
    checksum: u16,
}

impl TryFrom<&[u8]> for PacketHeader {
    type Error = ();

    fn try_from(value: &[u8]) -> Result<Self, Self::Error> {
        if value.len() < 8 {
            return Err(());
        }

        Ok(Self {
            source_port: u16::from_be_bytes(value[0..2].try_into().unwrap()),
            destination_port: u16::from_be_bytes(value[2..4].try_into().unwrap()),
            length: u16::from_be_bytes(value[4..6].try_into().unwrap()),
            checksum: u16::from_be_bytes(value[6..8].try_into().unwrap()),
        })
    }
}

impl PacketHeader {
    pub fn to_bytes(&self, buffer: &mut [u8]) -> Result<(), ()> {
        if buffer.len() < 8 {
            return Err(());
        }

        (&mut buffer[0..2]).copy_from_slice(&self.source_port.to_be_bytes());
        (&mut buffer[2..4]).copy_from_slice(&self.destination_port.to_be_bytes());
        (&mut buffer[4..6]).copy_from_slice(&self.length.to_be_bytes());
        (&mut buffer[6..8]).copy_from_slice(&self.checksum.to_be_bytes());

        Ok(())
    }
}

impl Packet {
    pub fn new(packet: ipv4::Packet) -> Self {
        Self { ip_packet: packet }
    }

    pub fn header(&self) -> PacketHeader {
        (&self.ip_packet.payload()[0..8]).try_into().unwrap()
    }

    pub fn payload(&self) -> &[u8] {
        &(self.ip_packet.payload())[8..]
    }
}

pub struct InitialState {}
pub struct SourcePort {
    source_port: u16,
}
pub struct DestinationPort {
    source_port: u16,
    destination_port: u16,
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

    pub fn source_port(self, port: u16) -> PacketBuilder<SourcePort> {
        PacketBuilder {
            state: SourcePort { source_port: port },
        }
    }
}
impl PacketBuilder<SourcePort> {
    pub fn destination_port(self, port: u16) -> PacketBuilder<DestinationPort> {
        PacketBuilder {
            state: DestinationPort {
                source_port: self.state.source_port,
                destination_port: port,
            },
        }
    }
}
impl PacketBuilder<DestinationPort> {
    pub fn finish<P, S>(
        self,
        ip_packet_builder: ipv4::PacketBuilder<ipv4::DestinationState>,
        payload: P,
        payload_size: S,
    ) -> Result<ethernet::Packet, ()>
    where
        P: FnOnce(&mut [u8]) -> Result<usize, ()>,
        S: Fn() -> usize,
    {
        ip_packet_builder.finish(
            |ip_payload| {
                let header = PacketHeader {
                    source_port: self.state.source_port,
                    destination_port: self.state.destination_port,
                    length: (8 + payload_size()) as u16,
                    checksum: 0,
                };

                let _ = header.to_bytes(&mut ip_payload[0..8]);

                let size = payload(&mut ip_payload[8..])?;
                assert_eq!(size, payload_size());

                Ok(8 + payload_size())
            },
            || (8 + payload_size()),
        )
    }
}
