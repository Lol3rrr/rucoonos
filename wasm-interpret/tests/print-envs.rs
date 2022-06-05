use std::{
    future::Future,
    pin::Pin,
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc,
    },
};

use test_log::test;
use wasm::Module;
use wasm_interpret::vm::{self, handler::ExternalHandler};

#[test(tokio::test)]
async fn print_env() {
    let raw_module = include_bytes!("./print-envs.wasm");

    let module = Module::parse(raw_module);
    assert!(module.is_ok());

    let module = module.unwrap();
    dbg!(module.exports().collect::<Vec<_>>());

    let logged = Arc::new(AtomicBool::new(false));

    let proc_exit_handler = vm::handler::FallibleExternalHandler::<
        _,
        Pin<Box<dyn Future<Output = Vec<vm::StackValue>>>>,
    >::new("proc_exit", |_, _| Err(vm::handler::HandleError::Other));
    let env_arg_sizes =
        vm::handler::ExternalHandlerConstant::new("environ_sizes_get", |args, mut memory| {
            tracing::trace!("Called 'environ_sizes_get' with {:?} Arguments", args.len());

            let env_size = match args.get(1).expect("") {
                vm::StackValue::I32(ptr) => *ptr,
                _ => todo!(),
            };
            let env_count = match args.get(0).expect("") {
                vm::StackValue::I32(ptr) => *ptr,
                _ => todo!(),
            };

            tracing::trace!("Arguments ({:?}, {:?})", env_count, env_size);

            memory.writeu32(env_size as u32, 5).expect("");
            memory.writeu32(env_count as u32, 1).expect("");

            async move { vec![vm::StackValue::I32(0)] }
        });
    let env_get = vm::handler::ExternalHandlerConstant::new("environ_get", |args, mut memory| {
        let environ = match args.get(0) {
            Some(vm::StackValue::I32(v)) => *v,
            _ => todo!(),
        };
        let environ_buf = match args.get(1) {
            Some(vm::StackValue::I32(v)) => *v,
            _ => todo!(),
        };

        println!("Environ: x{:x}  Environ-Buf: 0x{:x}", environ, environ_buf);

        let base_addr = environ_buf as usize;
        memory[base_addr] = b't';
        memory[base_addr + 1] = b'e';
        memory[base_addr + 2] = b'=';
        memory[base_addr + 3] = b'l';
        memory[base_addr + 4] = b's';
        memory[base_addr + 5] = 0;

        memory.writei32(environ as u32, environ_buf);

        // todo!();

        async move { vec![vm::StackValue::I32(0)] }
    });
    let fd_write_handler =
        vm::handler::ExternalHandlerConstant::new("fd_write", |args, mut memory| {
            logged.store(true, Ordering::SeqCst);

            let retptr0 = match args.get(3) {
                Some(vm::StackValue::I32(v)) => *v,
                _ => todo!(),
            };
            let iovs_len = args.get(2);
            let iovs = match args.get(1) {
                Some(vm::StackValue::I32(v)) => *v,
                _ => todo!(),
            };
            let fd = match args.get(0) {
                Some(vm::StackValue::I32(v)) => *v,
                _ => todo!(),
            };

            tracing::trace!(
                "Called FD_write with fd={:?} iovs={:?} iovs_len={:?} retptr={:?}",
                fd,
                iovs,
                iovs_len,
                retptr0
            );

            let iovec: &wasm_interpret::wasi::IoVec =
                unsafe { memory.read_raw(iovs as usize) }.expect("");

            tracing::trace!("IOVec Buffer {:?} with len {:?}", iovec.buf, iovec.len);

            let str_addr = iovec.buf as usize;
            let str_addr_end = str_addr + iovec.len as usize;

            let str_slice = &memory[str_addr..str_addr_end];
            let buffer_str = core::str::from_utf8(str_slice).unwrap();

            println!("FD-Write");

            match fd {
                1 => {
                    tracing::info!("Found Buffer {:?}", buffer_str);
                }
                2 => {
                    tracing::error!("Found Buffer {:?}", buffer_str);
                }
                _ => todo!(),
            };

            memory
                .writeu32(retptr0 as u32, buffer_str.len() as u32)
                .expect("");

            async move { vec![vm::StackValue::I32(0)] }
        });
    let env = vm::Environment::new(
        env_arg_sizes
            .chain(proc_exit_handler)
            .chain(fd_write_handler)
            .chain(env_get),
        Vec::new(),
    );
    let mut interpreter = vm::Interpreter::new(env, &module);

    let compute_res = interpreter.run_with_wait("_start", || None).await;
    dbg!(&compute_res);

    assert_eq!(Ok(vec![]), compute_res);
    assert!(logged.load(Ordering::SeqCst));
}
