use test_log::test;
use wasm_interpret::{vm, Module};

#[test(tokio::test)]
async fn func_call() {
    let raw_module = include_bytes!("./func_call.wasm");

    let module = Module::parse(raw_module);
    assert!(module.is_ok());

    let module = module.unwrap();

    let env = vm::Environment::new(vm::handler::empty_handler());
    let mut interpreter = vm::Interpreter::new(env, &module);

    let compute_res = interpreter.run_with_wait("test", || None).await;
    dbg!(&compute_res);

    assert_eq!(Ok(vec![vm::StackValue::I32(2)]), compute_res);
}
