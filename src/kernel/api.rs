pub mod networking {
    use crate::kernel::{
        device::{NetworkDevice, PacketQueueSender},
        networking,
    };

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
    }
}
