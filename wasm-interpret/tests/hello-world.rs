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
async fn hello_world() {
    let raw_module = include_bytes!("./hello-world.wasm");

    let module = Module::parse(raw_module);
    assert!(module.is_ok());

    let module = module.unwrap();
    dbg!(module.exports().collect::<Vec<_>>());
    dbg!(module.elements().collect::<Vec<_>>());

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

            memory[env_size as usize] = 0;
            memory[env_count as usize] = 0;

            async move { vec![vm::StackValue::I32(0)] }
        });
    let fd_write_handler =
        vm::handler::ExternalHandlerConstant::new("fd_write", |args, mut memory| {
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

            logged.store(buffer_str == "Hello, world!\n", Ordering::SeqCst);

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

            async move { vec![vm::StackValue::I32(0)] }
        });
    let env = vm::Environment::new(
        env_arg_sizes
            .chain(proc_exit_handler)
            .chain(fd_write_handler),
        Vec::new(),
    );
    let mut interpreter = vm::Interpreter::new(env, &module);

    let compute_res = interpreter.run_with_wait("test", || None).await;
    dbg!(&compute_res);

    assert_eq!(Ok(vec![]), compute_res);
    assert!(logged.load(Ordering::SeqCst));
}
