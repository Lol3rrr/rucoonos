use alloc::boxed::Box;

use kernel::Extension;
use wasm_interpret::{vm, Module};

pub struct WasmProgram<H> {
    data: &'static [u8],
    handlers: H,
    name: &'static str,
}

impl<H> WasmProgram<H>
where
    H: wasm_interpret::vm::handler::ExternalHandler,
{
    pub fn new(handler: H, data: &'static [u8], func: &'static str) -> Self {
        Self {
            data,
            handlers: handler,
            name: func,
        }
    }
}

impl<HA, H> Extension<H> for WasmProgram<HA>
where
    HA: wasm_interpret::vm::handler::ExternalHandler + 'static,
{
    fn setup(
        self,
        kernel: &kernel::Kernel<H>,
        hardware: &H,
    ) -> core::pin::Pin<alloc::boxed::Box<dyn core::future::Future<Output = ()>>> {
        let env = vm::Environment::new(self.handlers);
        let module = match Module::parse(self.data) {
            Ok(m) => m,
            Err(e) => {
                tracing::error!("Parsing WASM-Module {:?}", e);
                return Box::pin(async move {});
            }
        };

        Box::pin(run_module(self.name, module, env))
    }
}

#[tracing::instrument(name = "WASM-Module", skip(name, module, env))]
async fn run_module<EH>(name: &'static str, module: Module, env: vm::Environment<EH>)
where
    EH: vm::handler::ExternalHandler,
{
    let mut interpreter = vm::Interpreter::new(env, &module);

    let mut count = 0;
    match interpreter
        .run_with_wait(name, || {
            count += 1;
            if count > 100 {
                count = 0;
                Some(Box::pin(rucoon::futures::yield_now()))
            } else {
                None
            }
        })
        .await
    {
        Ok(r) => {
            tracing::debug!("Result: {:?}", r);
        }
        Err(e) => {
            tracing::error!("Running WASM {:?}", e);
        }
    }
}
