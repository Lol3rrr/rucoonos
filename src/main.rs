#![no_std]
#![no_main]
//
#![feature(custom_test_frameworks)]
#![test_runner(crate::test_runner)]
#![reexport_test_harness_main = "test_main"]

extern crate alloc;

use core::panic::PanicInfo;

use kernel::Kernel;
use rucoonos::extensions::networking::protocols;
use rucoonos::*;

/// This function is called on panic.
#[cfg(not(test))]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    rucoonos::hlt_loop()
}

#[cfg(test)]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    rucoonos::test_panic_handler(info)
}

bootloader::entry_point!(kernel_main);

fn kernel_main(boot_info: &'static mut bootloader::BootInfo) -> ! {
    let hardware = rucoonos::Hardware::init(boot_info);

    let kernel = Kernel::setup(hardware);

    // Setup tracing for the Kernel
    kernel.add_extension(crate::extensions::LogExtension::new(
        crate::extensions::logging::LogLevel::Debug,
    ));

    kernel.add_extension(crate::extensions::NetworkExtension::new());

    if let Some(iter) = kernel.hardware().get_rsdt_entries() {
        for entry in iter {
            match entry {
                acpi::acpi::AcipEntry::Apic(_) => {
                    println!(" -> Apic Entry");
                }
                acpi::acpi::AcipEntry::FADT { .. } => {
                    println!(" -> FADT Entry");
                }
                acpi::acpi::AcipEntry::HighPrecisionEventTimer { .. } => {
                    println!(" -> High Precision Event Timer Entry");
                }
                acpi::acpi::AcipEntry::WindowsACPIEmulatedDevices { .. } => {
                    println!(" -> Windows ACPI Emulated Devices Entry");
                }
                acpi::acpi::AcipEntry::Unknown { header, .. } => {
                    println!(" -> Unknown Entry: {:?}", header.signature());
                }
            };
        }
    }

    if false {
        /*
        let mut tmp = Vec::new();
        kernel.hardware().with_networking_device(|dev| {
            let func = dev.blocking_init().unwrap();
            tmp.push(func);
        });

        for init in tmp {
            init();
        }
        */
    }

    /*
    let udp_listen = kernel.hardware().find_apply_device(
        |dev| match dev {
            hardware::device::Device::Network(n_dev) => true,
            _ => false,
        },
        |dev| {
            let n_dev = match dev {
                hardware::device::Device::Network(n) => n,
                _ => unreachable!(),
            };

            println!("Device-IP: {:?}", n_dev.metadata.ip);

            hardware::api::networking::UDPListener::bind(8080, &n_dev).unwrap()
        },
    );
    */

    kernel.hardware().with_networking_device(|device| {
        let sender = &device.packet_queue;
        let meta = &device.metadata;

        println!("Device-IP: {:?}", meta.ip);

        // Send an empty UDP Packet
        sender.enqueue(
            protocols::udp::PacketBuilder::new()
                .source_port(68)
                .destination_port(67)
                .finish(
                    protocols::ipv4::PacketBuilder::new()
                        .dscp(0)
                        .identification(0x2345)
                        .ttl(20)
                        .protocol(protocols::ipv4::Protocol::Udp)
                        .source([0, 0, 0, 0], meta.mac.clone())
                        .destination([255, 255, 255, 255], [0xff, 0xff, 0xff, 0xff, 0xff, 0xff]),
                    |_| {
                        // TODO
                        Ok(0)
                    },
                    || 0,
                )
                .unwrap(),
        );
    });

    #[cfg(not(test))]
    {
        let k_handle = kernel.handle();
        // k_handle.add_task(tetris());
        k_handle.add_task(ping([192, 168, 178, 20]));

        /*
        if let Some(udp_listen) = udp_listen {
            k_handle.add_task(udp_listener(udp_listen));
        }
        */

        kernel.run();
    }

    #[cfg(test)]
    test_main();

    panic!("Done")
}

#[tracing::instrument]
async fn ping(target_ip: [u8; 4]) {
    let mac = crate::extensions::networking::get_mac(target_ip)
        .await
        .expect("");
    tracing::info!("Target-Mac {:?}", mac);

    loop {
        crate::extensions::networking::raw_ping(target_ip, mac).await;

        tracing::info!("Received Ping");

        rucoon::futures::yield_now().await;
    }
}

/*
async fn udp_listener(udp_listener: hardware::api::networking::UDPListener) {
    loop {
        let packet = match udp_listener.a_recv().await {
            Some(p) => p,
            None => {
                x86_64::instructions::hlt();
                continue;
            }
        };

        println!("Received-UDP-Packet: {:?}", packet.header());
    }
}
*/

#[tracing::instrument(name = "tetris")]
async fn tetris() {
    tracing::info!("Starting Tetris");

    let y_steps = 5;
    let color_steps = 2;

    let mut y = 0;
    let mut color = 0x00;

    loop {
        for y_pos in y..y + y_steps {
            for x in 0..100 {
                video::draw(
                    x,
                    y_pos,
                    video::Color {
                        red: color,
                        green: color,
                        blue: color,
                    },
                );
            }
        }

        y += y_steps;
        color = color.overflowing_add(color_steps).0;

        rucoonos::futures::sleep_ms(10).await;
    }
}

#[test_case]
fn trivial_assertion() {
    assert_eq!(1, 1);
}
