use super::{ethernet, ipv4, udp};

pub struct Packet {
    datagram: udp::Packet,
}

#[derive(Debug, Clone, Copy)]
pub enum Operation {
    Discover,
    Offer,
    Request,
    Ack,
    Unknown(u8),
}

impl From<u8> for Operation {
    fn from(raw: u8) -> Self {
        match raw {
            1 => Self::Discover,
            2 => Self::Offer,
            3 => Self::Request,
            5 => Self::Ack,
            unknown => Self::Unknown(unknown),
        }
    }
}

#[derive(Debug)]
pub struct Data {
    op: u8,
    htype: u8,
    hlen: u8,
    hops: u8,
    pub xid: u32,
    secs: u16,
    flags: u16,
    pub ciaddr: [u8; 4],
    pub yiaddr: [u8; 4],
    pub siaddr: [u8; 4],
    pub giaddr: [u8; 4],
    pub chaddr: [u8; 16],
    pub operation: Operation,
}

impl TryFrom<&[u8]> for Data {
    type Error = ();

    fn try_from(value: &[u8]) -> Result<Self, Self::Error> {
        if value.len() < 244 {
            return Err(());
        }

        let raw_op = {
            let mut iter = value.iter().copied().skip(44 + 192 + 4);
            loop {
                let option_code = iter.next().unwrap();
                if option_code == 53 {
                    let _ = iter.next();
                    break iter.next().unwrap();
                }

                let len = iter.next().unwrap();
                let _ = iter.by_ref().skip((len - 1) as usize).next();
            }
        };

        Ok(Self {
            op: value[0],
            htype: value[1],
            hlen: value[2],
            hops: value[3],
            xid: u32::from_be_bytes(value[4..8].try_into().unwrap()),
            secs: u16::from_be_bytes(value[8..10].try_into().unwrap()),
            flags: u16::from_be_bytes(value[10..12].try_into().unwrap()),
            ciaddr: value[12..16].try_into().unwrap(),
            yiaddr: value[16..20].try_into().unwrap(),
            siaddr: value[20..24].try_into().unwrap(),
            giaddr: value[24..28].try_into().unwrap(),
            chaddr: value[28..44].try_into().unwrap(),
            operation: raw_op.into(),
        })
    }
}

impl Packet {
    pub fn new(datagram: udp::Packet) -> Self {
        Self { datagram }
    }

    pub fn get(&self) -> Data {
        self.datagram.payload().try_into().unwrap()
    }
}

pub fn discover_message(own_mac: [u8; 6], xid: u32) -> Result<ethernet::Packet, ()> {
    udp::PacketBuilder::new()
        .source_port(68)
        .destination_port(67)
        .finish(
            ipv4::PacketBuilder::new()
                .dscp(0)
                .identification(0x1234)
                .ttl(20)
                .protocol(ipv4::Protocol::Udp)
                .source([0, 0, 0, 0], own_mac.clone())
                .destination([255, 255, 255, 255], [0xff, 0xff, 0xff, 0xff, 0xff, 0xff]),
            |payload| {
                payload[0] = 0x1;
                payload[1] = 0x1;
                payload[2] = 0x6;
                payload[3] = 0x0;

                (&mut payload[4..8]).copy_from_slice(&xid.to_be_bytes());
                (&mut payload[8..10]).copy_from_slice(&[0, 0]);
                (&mut payload[10..12]).copy_from_slice(&[0x80, 0]);

                (&mut payload[12..16]).copy_from_slice(&[0, 0, 0, 0]);
                (&mut payload[16..20]).copy_from_slice(&[0, 0, 0, 0]);
                (&mut payload[20..24]).copy_from_slice(&[0, 0, 0, 0]);
                (&mut payload[24..28]).copy_from_slice(&[0, 0, 0, 0]);

                (&mut payload[28..34]).copy_from_slice(&own_mac);

                (&mut payload[236..240]).copy_from_slice(&0x63825363u32.to_be_bytes());

                payload[240] = 53;
                payload[241] = 1;
                payload[242] = 1;
                payload[243] = 0xff;

                Ok(244)
            },
            || 244,
        )
}

pub fn request_message(
    own_mac: [u8; 6],
    xid: u32,
    ip: [u8; 4],
    server_ip: [u8; 4],
) -> Result<ethernet::Packet, ()> {
    udp::PacketBuilder::new()
        .source_port(68)
        .destination_port(67)
        .finish(
            ipv4::PacketBuilder::new()
                .dscp(0)
                .identification(0x1234)
                .ttl(20)
                .protocol(ipv4::Protocol::Udp)
                .source([0, 0, 0, 0], own_mac.clone())
                .destination([255, 255, 255, 255], [0xff, 0xff, 0xff, 0xff, 0xff, 0xff]),
            |payload| {
                payload[0] = 0x1;
                payload[1] = 0x1;
                payload[2] = 0x6;
                payload[3] = 0x0;

                (&mut payload[4..8]).copy_from_slice(&xid.to_be_bytes());
                (&mut payload[8..10]).copy_from_slice(&[0, 0]);
                (&mut payload[10..12]).copy_from_slice(&[0x80, 0]);

                (&mut payload[12..16]).copy_from_slice(&ip);
                (&mut payload[16..20]).copy_from_slice(&[0, 0, 0, 0]);
                (&mut payload[20..24]).copy_from_slice(&server_ip);
                (&mut payload[24..28]).copy_from_slice(&[0, 0, 0, 0]);

                (&mut payload[28..34]).copy_from_slice(&own_mac);

                (&mut payload[236..240]).copy_from_slice(&0x63825363u32.to_be_bytes());

                payload[240] = 53;
                payload[241] = 1;
                payload[242] = 3;

                payload[243] = 54;
                payload[244] = 4;
                (&mut payload[245..249]).copy_from_slice(&server_ip);

                payload[250] = 50;
                payload[251] = 4;
                (&mut payload[252..256]).copy_from_slice(&ip);

                payload[257] = 0xff;

                Ok(257)
            },
            || 257,
        )
}
