use test_log::test;
use wasm::Module;
use wasm_interpret::vm;

#[test(tokio::test)]
async fn extern_func() {
    let raw_module = include_bytes!("./extern_func.wasm");

    let module = Module::parse(raw_module);
    assert!(module.is_ok());

    let module = module.unwrap();

    let handler = vm::handler::ExternalHandlerConstant::new("other", |_, _| async move {
        vec![vm::StackValue::I32(0)]
    });
    let env = vm::Environment::new(handler);
    let mut interpreter = vm::Interpreter::new(env, &module);

    let compute_res = interpreter.run_with_wait("test", || None).await;
    dbg!(&compute_res);

    assert_eq!(Ok(vec![vm::StackValue::I32(-5)]), compute_res);
}
