use wasm_interpret::{vm, Module};

#[tokio::test]
async fn hello_world() {
    let raw_module = include_bytes!("./hello-world.wasm");

    let module = Module::parse(raw_module);
    assert!(module.is_ok());

    let module = module.unwrap();
    dbg!(module.imports().count());
    dbg!(module.exports().collect::<Vec<_>>());

    dbg!(module.tables().collect::<Vec<_>>());
    dbg!(module.elements().collect::<Vec<_>>());
    dbg!(module.functions().count());

    let env = vm::Environment::new(vm::handler::empty_handler());
    let mut interpreter = vm::Interpreter::new(env, &module);

    let compute_res = interpreter.run_with_wait("_start", || None).await;
    dbg!(&compute_res);

    assert_eq!(Ok(vm::StackValue::I32(2)), compute_res);
}
