pub mod networking {
    use crate::{
        extensions::protocols,
        hardware::device::{NetworkDevice, PacketQueueSender},
    };

    pub struct UDPListener {
        port: u16,
        sender: PacketQueueSender,
        receiver: nolock::queues::mpmc::bounded::scq::Receiver<protocols::udp::Packet>,
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

        pub fn try_recv(&self) -> Option<protocols::udp::Packet> {
            self.receiver.try_dequeue().ok()
        }

        pub async fn a_recv(&self) -> Option<protocols::udp::Packet> {
            loop {
                if let Some(p) = self.try_recv() {
                    return Some(p);
                }

                crate::futures::sleep_ms(1).await;
            }
        }
    }
}
