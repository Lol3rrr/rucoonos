use test_log::test;
use wasm_interpret::{vm, Module};

#[test(tokio::test)]
async fn hello_world() {
    let raw_module = include_bytes!("./hello-world.wasm");

    let module = Module::parse(raw_module);
    assert!(module.is_ok());

    let module = module.unwrap();
    dbg!(module.exports().collect::<Vec<_>>());

    let env_arg_sizes =
        vm::handler::ExternalHandlerConstant::new("environ_sizes_get", |mut stack, mut memory| {
            tracing::trace!(
                "Called 'environ_sizes_get' with {:?} Arguments",
                stack.len()
            );

            let env_size = match stack.pop().expect("") {
                vm::StackValue::I32(ptr) => ptr,
                _ => todo!(),
            };
            let env_count = match stack.pop().expect("") {
                vm::StackValue::I32(ptr) => ptr,
                _ => todo!(),
            };

            tracing::trace!("Arguments ({:?}, {:?})", env_count, env_size);

            memory.writei32(env_size as u32, 0).expect("");
            memory.writei32(env_count as u32, 0).expect("");

            async move { vec![vm::StackValue::I32(0)] }
        });
    let env = vm::Environment::new(env_arg_sizes);
    let mut interpreter = vm::Interpreter::new(env, &module);

    let compute_res = interpreter.run_with_wait("_start", || None).await;
    dbg!(&compute_res);

    assert_eq!(Ok(vm::StackValue::I32(2)), compute_res);
}
