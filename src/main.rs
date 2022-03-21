#![no_std]
#![no_main]
//
#![feature(custom_test_frameworks)]
#![test_runner(crate::test_runner)]
#![reexport_test_harness_main = "test_main"]

extern crate alloc;

use core::panic::PanicInfo;

use alloc::vec::Vec;
use rucoonos::kernel::networking;
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
    let kernel = rucoonos::Kernel::init(boot_info);

    if let Some(iter) = kernel.get_rsdt_entries() {
        for entry in iter {
            match entry {
                acpi::acpi::AcipEntry::Apic(apic_entry) => {
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

    if true {
        let mut tmp = Vec::new();
        kernel.with_networking_device(|dev| {
            let func = dev.blocking_init().unwrap();
            tmp.push(func);
        });

        for init in tmp {
            init();
        }
    }

    let udp_listen = kernel
        .find_apply_device(
            |dev| match dev {
                kernel::device::Device::Network(n_dev) => true,
                _ => false,
            },
            |dev| {
                let n_dev = match dev {
                    kernel::device::Device::Network(n) => n,
                    _ => unreachable!(),
                };

                println!("Device-IP: {:?}", n_dev.metadata.ip);

                kernel::api::networking::UDPListener::bind(8080, n_dev).unwrap()
            },
        )
        .unwrap();

    kernel.with_networking_device(|device| {
        let sender = &device.packet_queue;
        let meta = &device.metadata;

        println!("Device-IP: {:?}", meta.ip);

        // Send an empty UDP Packet
        sender.enqueue(
            networking::udp::PacketBuilder::new()
                .source_port(68)
                .destination_port(67)
                .finish(
                    networking::ipv4::PacketBuilder::new()
                        .dscp(0)
                        .identification(0x2345)
                        .ttl(20)
                        .protocol(networking::ipv4::Protocol::Udp)
                        .source([0, 0, 0, 0], meta.mac.clone())
                        .destination([255, 255, 255, 255], [0xff, 0xff, 0xff, 0xff, 0xff, 0xff]),
                    |buffer| {
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
        kernel.add_task(tetris()).unwrap();
        kernel.add_task(ping_cloudflare_dns()).unwrap();
        kernel.add_task(udp_listener(udp_listen)).unwrap();

        if let Err(_) = kernel.start_runtime() {
            println!("Error running Runtime");
        }
    }

    #[cfg(test)]
    test_main();

    panic!("Done")
}

async fn ping_cloudflare_dns() {
    let kernel = kernel::KERNEL_INSTANCE.get().unwrap();
    let raw_net_dev = kernel
        .find_device_handle(|dev| match dev {
            kernel::device::Device::Network(_) => true,
            _ => false,
        })
        .unwrap();
    let net_dev = match raw_net_dev {
        kernel::device::DeviceHandle::Network(n) => n,
        _ => unreachable!(),
    };

    kernel::api::networking::ping([1, 1, 1, 1], &net_dev).await;
}

async fn udp_listener(udp_listener: kernel::api::networking::UDPListener) {
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

async fn tetris() {
    println!("Starting Tetris");

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
