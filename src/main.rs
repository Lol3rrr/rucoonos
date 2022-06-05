#![no_std]
#![no_main]
//
#![feature(custom_test_frameworks)]
#![test_runner(crate::test_runner)]
#![reexport_test_harness_main = "test_main"]

extern crate alloc;
use alloc::boxed::Box;
use alloc::vec::Vec;

use core::panic::PanicInfo;

use kernel::Kernel;
use rucoonos::extensions::networking::protocols;
use rucoonos::*;

use wasm_interpret::vm::handler::ExternalHandler;

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

    kernel.add_extension(crate::extensions::wasm_programs::WasmProgram::new(
        wasm_interpret::vm::handler::ExternalHandlerConstant::new(
            "environ_sizes_get",
            |mut args, mut memory| {
                tracing::trace!("Called 'environ_sizes_get' with {:?} Arguments", args.len());

                let env_size = match args.get(1).expect("") {
                    wasm_interpret::vm::StackValue::I32(ptr) => *ptr,
                    _ => todo!(),
                };
                let env_count = match args.get(0).expect("") {
                    wasm_interpret::vm::StackValue::I32(ptr) => *ptr,
                    _ => todo!(),
                };

                tracing::trace!("Arguments ({:?}, {:?})", env_count, env_size);

                memory
                    .writeu32(env_size as u32, "RUST_BACKTRACE=1".len() as u32 + 1)
                    .expect("");
                memory
                    .writeu32(env_count as u32, "RUST_BACKTRACE=1".len() as u32 + 1)
                    .expect("");

                async move {
                    let mut result = Vec::with_capacity(1);
                    result.push(wasm_interpret::vm::StackValue::I32(0));
                    result
                }
            },
        )
        .chain(wasm_interpret::vm::handler::ExternalHandlerConstant::new(
            "environ_get",
            |args, mut memory| {
                let environ = match args.get(0) {
                    Some(wasm_interpret::vm::StackValue::I32(addr)) => *addr,
                    _ => todo!(),
                };
                let environ_buf = match args.get(1) {
                    Some(wasm_interpret::vm::StackValue::I32(addr)) => *addr,
                    _ => todo!(),
                };

                tracing::debug!("Environ: 0x{:x} Environ-Buf: 0x{:x}", environ, environ_buf);

                memory.writestr(environ as u32, "RUST_BACKTRACE=1\0");
                memory.writestr(environ_buf as u32, "RUST_BACKTRACE=1\0");

                async move {
                    let mut result = Vec::with_capacity(1);
                    result.push(wasm_interpret::vm::StackValue::I32(0));
                    result
                }
            },
        ))
        .chain(wasm_interpret::vm::handler::FallibleExternalHandler::new(
            "fd_write",
            |mut args, mut memory| {
                let retptr0 = match args.get(3) {
                    Some(wasm_interpret::vm::StackValue::I32(v)) => *v,
                    _ => todo!(),
                };
                let iovs_len = args.get(2);
                let iovs = match args.get(1) {
                    Some(wasm_interpret::vm::StackValue::I32(v)) => *v,
                    _ => todo!(),
                };
                let fd = match args.get(0) {
                    Some(wasm_interpret::vm::StackValue::I32(v)) => *v,
                    _ => todo!(),
                };

                tracing::trace!(
                    "Called FD_write with fd={:?} iovs={:?} iovs_len={:?} retptr={:?}",
                    fd,
                    iovs,
                    iovs_len,
                    retptr0
                );

                tracing::debug!("Got {:?} IOVs", iovs_len);

                let iovec: &wasm_interpret::wasi::IoVec =
                    unsafe { memory.read_raw(iovs as usize) }.expect("");

                tracing::debug!("IOVec Buffer {:?} with len {:?}", iovec.buf, iovec.len);

                let str_addr = iovec.buf as usize;
                let str_addr_end = str_addr + iovec.len as usize;

                let str_slice = &memory[str_addr..str_addr_end];
                let buffer_str = core::str::from_utf8(str_slice).unwrap();

                match fd {
                    1 => {
                        tracing::info!("Found Buffer {:?}", buffer_str);
                    }
                    2 => {
                        tracing::error!("Found Buffer {:?}", buffer_str);
                    }
                    _ => todo!(),
                };

                memory.writeu32(retptr0 as u32, iovec.len).expect("");

                Ok(async move {
                    let mut result = Vec::with_capacity(1);
                    result.push(wasm_interpret::vm::StackValue::I32(0));
                    result
                })
            },
        )),
        include_bytes!("../wasm-interpret/tests/hello-world.wasm"),
        "test",
    ));

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
        k_handle.add_task(tetris());
        k_handle.add_task(ping([192, 168, 178, 20]));

        /*
        if let Some(udp_listen) = udp_listen {
            k_handle.add_task(udp_listener(udp_listen));
        }
        */

        kernel.run(x86_64::instructions::hlt);
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
