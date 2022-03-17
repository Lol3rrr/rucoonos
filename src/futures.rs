use crate::{kernel::networking, Kernel};

pub fn sleep_ms(duration: usize) -> impl core::future::Future<Output = ()> {
    rucoon::extensions::time::sleep(
        &crate::interrupts::TIMER,
        core::time::Duration::from_millis(duration as u64),
    )
}

pub async fn get_mac(
    kernel: &Kernel,
    ip: [u8; 4],
    device: &crate::kernel::device::NetworkingDeviceHandle,
) -> [u8; 6] {
    let ips = &kernel.ips;
    if let Some(mac) = ips.try_get(&ip) {
        return mac;
    }

    device.p_queue.enqueue(
        networking::arp::PacketBuilder::new()
            .sender(device.mac.clone(), device.ip.unwrap_or([0, 0, 0, 0]))
            .destination([0xff, 0xff, 0xff, 0xff, 0xff, 0xff], ip.clone())
            .operation(networking::arp::Operation::Request)
            .finish()
            .unwrap(),
    );

    loop {
        if let Some(mac) = ips.try_get(&ip) {
            return mac;
        }

        rucoon::extensions::time::sleep(
            &crate::interrupts::TIMER,
            core::time::Duration::from_millis(2),
        )
        .await;
    }
}
