use wasm_interpret::{vm, Module};

#[tokio::test]
async fn return_const() {
    let raw_module = include_bytes!("./return_const.wasm");

    let module = Module::parse(raw_module);
    dbg!(&module);
    assert!(module.is_ok());

    let module = module.unwrap();

    dbg!(&module);

    let env = vm::Environment::new(vm::handler::empty_handler());
    let mut interpreter = vm::Interpreter::new(env, &module);

    let compute_res = interpreter.run_with_wait("main", || None).await;
    assert_eq!(Ok(vm::StackValue::I32(42)), compute_res);
}
