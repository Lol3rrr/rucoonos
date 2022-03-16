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

    if false {
        let mut tmp = Vec::new();
        kernel.with_networking_device(|dev| {
            let func = dev.blocking_init().unwrap();
            tmp.push(func);
        });

        for init in tmp {
            init();
        }
    }

    kernel.with_networking_device(|device| {
        let sender = &device.packet_queue;
        let meta = &device.metadata;

        println!("Device-IP: {:?}", meta.ip);

        // Send a basic ARP Probe for 192.168.178.1
        sender.enqueue(
            networking::arp::PacketBuilder::new()
                .sender(meta.mac.clone(), [0, 0, 0, 0])
                .destination([0, 0, 0, 0, 0, 0], [192, 168, 178, 1])
                .operation(networking::arp::Operation::Request)
                .finish()
                .unwrap(),
        );

        // Send an empty UDP Packet
        sender.enqueue(
            networking::udp::PacketBuilder::new()
                .source_port(meta.mac.clone(), [0, 0, 0, 0], 68)
                .destination_port(
                    [0xff, 0xff, 0xff, 0xff, 0xff, 0xff],
                    [255, 255, 255, 255],
                    67,
                )
                .finish(
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

        if let Err(_) = kernel.start_runtime() {
            println!("Error running Runtime");
        }
    }

    #[cfg(test)]
    test_main();

    panic!("Done")
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
