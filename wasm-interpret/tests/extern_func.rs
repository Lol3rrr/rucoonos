use wasm_interpret::{vm, Module};

#[tokio::test]
async fn extern_func() {
    let raw_module = include_bytes!("./extern_func.wasm");

    let module = Module::parse(raw_module);
    dbg!(&module);
    assert!(module.is_ok());

    let module = module.unwrap();

    let imports: Vec<_> = module.imports().collect();
    assert_eq!(1, imports.len());

    let exports: Vec<_> = module.exports().collect();
    assert_eq!(2, exports.len());

    let handler = vm::handler::ExternalHandlerConstant::new("external", |_| async move {
        vec![vm::StackValue::I32(0)]
    });
    let env = vm::Environment::new(handler);
    let mut interpreter = vm::Interpreter::new(env, &module);

    let compute_res = interpreter.run_completion("main").await;
    dbg!(&compute_res);

    assert_eq!(Ok(vm::StackValue::I32(3)), compute_res);
}
