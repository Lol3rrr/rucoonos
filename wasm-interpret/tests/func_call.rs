use wasm_interpret::{vm, Module};

#[tokio::test]
async fn func_call() {
    let raw_module = include_bytes!("./func_call.wasm");

    let module = Module::parse(raw_module);
    dbg!(&module);
    assert!(module.is_ok());

    let module = module.unwrap();

    dbg!(&module);

    let env = vm::Environment::new(vm::handler::empty_handler());
    let mut interpreter = vm::Interpreter::new(env, &module);

    let compute_res = interpreter.run_with_wait("main", || None).await;
    dbg!(&compute_res);

    assert_eq!(Ok(vm::StackValue::I32(2)), compute_res);
}
