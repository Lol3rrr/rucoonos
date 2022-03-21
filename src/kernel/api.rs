pub mod networking {
    use crate::{
        futures,
        kernel::{
            self,
            device::{NetworkDevice, NetworkingDeviceHandle, PacketQueueSender},
            networking,
        },
    };

    const GATEWAY_IP: [u8; 4] = [192, 168, 178, 1];

    pub struct UDPListener {
        port: u16,
        sender: PacketQueueSender,
        receiver: nolock::queues::mpmc::bounded::scq::Receiver<networking::udp::Packet>,
    }

    impl UDPListener {
        pub fn bind(port: u16, device: &NetworkDevice) -> Result<Self, ()> {
            let receiver = x86_64::instructions::interrupts::without_interrupts(|| {
                let mut existing_bindings = device.udp_bindings.lock();
                if existing_bindings.contains_key(&port) {
                    return Err(());
                }

                let (recv, sender) = nolock::queues::mpmc::bounded::scq::queue(128);
                existing_bindings.insert(port, sender);

                Ok(recv)
            })?;

            Ok(Self {
                port,
                receiver,
                sender: device.packet_queue.clone(),
            })
        }

        pub fn try_recv(&self) -> Option<networking::udp::Packet> {
            self.receiver.try_dequeue().ok()
        }

        pub async fn a_recv(&self) -> Option<networking::udp::Packet> {
            loop {
                if let Some(p) = self.try_recv() {
                    return Some(p);
                }

                crate::futures::sleep_ms(1).await;
            }
        }
    }

    pub async fn ping(target_ip: [u8; 4], device: &NetworkingDeviceHandle) -> Result<(), ()> {
        let kernel = kernel::KERNEL_INSTANCE.get().ok_or(())?;

        let target_address = networking::ipv4::Address::from(target_ip.clone());
        let (ip, mac) = match target_address.address_ty() {
            networking::ipv4::AddressType::Lan => {
                let m = futures::get_mac(kernel, target_ip, device).await;
                (target_ip, m)
            }
            networking::ipv4::AddressType::Loopback => (target_ip, device.mac.clone()),
            networking::ipv4::AddressType::Wan => {
                let m = futures::get_mac(kernel, GATEWAY_IP.clone(), device).await;
                (target_ip, m)
            }
        };

        let rand_number = kernel.get_rand();
        device.p_queue.enqueue(
            networking::icmp::PacketBuilder::new()
                .set_type(networking::icmp::Type::EchoRequest {
                    identifier: (rand_number >> 48) as u16,
                    sequence: (rand_number >> 32) as u16,
                })
                .finish(
                    networking::ipv4::PacketBuilder::new()
                        .dscp(0)
                        .identification((rand_number >> 16) as u16)
                        .ttl(64)
                        .protocol(networking::ipv4::Protocol::Icmp)
                        .source(device.ip.unwrap_or([0, 0, 0, 0]), device.mac)
                        .destination(ip, mac),
                    |_| Ok(0),
                    || 0,
                )
                .unwrap(),
        );

        Ok(())
    }
}
