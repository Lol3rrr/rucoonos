use super::{ethernet, ipv4};

pub struct Packet {
    ip_packet: ipv4::Packet,
}

pub struct PacketHeader {
    source_port: u16,
    destination_port: u16,
    length: u16,
    checksum: u16,
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

pub struct InitialState {}
pub struct SourcePort {
    source_mac: [u8; 6],
    source_ip: [u8; 4],
    source_port: u16,
}
pub struct DestinationPort {
    source_mac: [u8; 6],
    source_ip: [u8; 4],
    source_port: u16,
    destination_mac: [u8; 6],
    destination_ip: [u8; 4],
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

    pub fn source_port(self, mac: [u8; 6], ip: [u8; 4], port: u16) -> PacketBuilder<SourcePort> {
        PacketBuilder {
            state: SourcePort {
                source_mac: mac,
                source_ip: ip,
                source_port: port,
            },
        }
    }
}
impl PacketBuilder<SourcePort> {
    pub fn destination_port(
        self,
        mac: [u8; 6],
        ip: [u8; 4],
        port: u16,
    ) -> PacketBuilder<DestinationPort> {
        PacketBuilder {
            state: DestinationPort {
                source_mac: self.state.source_mac,
                source_ip: self.state.source_ip,
                source_port: self.state.source_port,
                destination_mac: mac,
                destination_ip: ip,
                destination_port: port,
            },
        }
    }
}
impl PacketBuilder<DestinationPort> {
    pub fn finish<P, S>(self, payload: P, payload_size: S) -> Result<ethernet::Packet, ()>
    where
        P: FnOnce(&mut [u8]) -> Result<usize, ()>,
        S: Fn() -> usize,
    {
        ipv4::PacketBuilder::new()
            .dscp(0)
            .identification(0x1234)
            .ttl(20)
            .protocol(17)
            .source(self.state.source_ip, self.state.source_mac)
            .destination(self.state.destination_ip, self.state.destination_mac)
            .finish(
                |ip_payload| {
                    let header = PacketHeader {
                        source_port: self.state.source_port,
                        destination_port: self.state.destination_port,
                        length: (8 + payload_size()) as u16,
                        checksum: 0,
                    };

                    let _ = header.to_bytes(&mut ip_payload[0..8]);

                    let _ = payload(&mut ip_payload[8..]);

                    Ok(8 + payload_size())
                },
                || 8 + payload_size(),
            )
    }
}
