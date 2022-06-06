use crate::vm;
use alloc::{boxed::Box, vec::Vec};

pub trait EnvironmentVariables {
    fn count(&self) -> i32;
    fn total_size(&self) -> i32;

    fn write_env(&self, index: usize, buffer: &mut [u8]) -> usize;
}

impl<'s, const N: usize> EnvironmentVariables for [&'s str; N] {
    fn count(&self) -> i32 {
        N as i32
    }
    fn total_size(&self) -> i32 {
        self.iter().map(|entry| entry.len()).sum::<usize>() as i32
    }

    fn write_env(&self, index: usize, buffer: &mut [u8]) -> usize {
        let env_var = self[index];

        let bytes = env_var.as_bytes();

        buffer[0..bytes.len()].copy_from_slice(bytes);

        bytes.len()
    }
}

pub struct EnvHandler<EV> {
    vars: EV,
}

impl<EV> EnvHandler<EV>
where
    EV: EnvironmentVariables,
{
    pub fn new(vars: EV) -> Self {
        Self { vars }
    }
}

impl<EV> vm::handler::ExternalHandler for EnvHandler<EV>
where
    EV: EnvironmentVariables,
{
    fn handles(&self, name: &str) -> bool {
        name == "environ_sizes_get" || name == "environ_get"
    }

    fn handle(
        &mut self,
        name: &str,
        args: vm::handler::HandleArguments<'_>,
        mut mem: vm::handler::HandleMemory<'_>,
    ) -> Result<
        core::pin::Pin<Box<dyn core::future::Future<Output = Vec<vm::StackValue>>>>,
        vm::handler::HandleError,
    > {
        match name {
            "environ_sizes_get" => {
                let target_count = args
                    .get(0)
                    .ok_or(vm::handler::HandleError::Other)?
                    .as_i32()
                    .ok_or(vm::handler::HandleError::Other)?;
                let target_size = args
                    .get(1)
                    .ok_or(vm::handler::HandleError::Other)?
                    .as_i32()
                    .ok_or(vm::handler::HandleError::Other)?;

                mem.writei32(target_count as u32, self.vars.count())
                    .map_err(|_| vm::handler::HandleError::Other)?;
                mem.writei32(
                    target_size as u32,
                    self.vars.total_size() + self.vars.count(),
                )
                .map_err(|_| vm::handler::HandleError::Other)?;

                let mut res = Vec::with_capacity(1);
                res.push(vm::StackValue::I32(0));
                Ok(Box::pin(async move { res }))
            }
            "environ_get" => {
                let environ = match args.get(0) {
                    Some(vm::StackValue::I32(v)) => *v,
                    _ => todo!(),
                };
                let environ_buf = match args.get(1) {
                    Some(vm::StackValue::I32(v)) => *v,
                    _ => todo!(),
                };

                let mut offset: usize = environ_buf as usize;
                let mem_size = mem.memory.size();
                for index in 0..self.vars.count() {
                    let written = self
                        .vars
                        .write_env(index as usize, &mut mem.memory[offset..mem_size]);

                    mem.memory[offset + written] = 0;

                    mem.writei32((environ + index * 4) as u32, offset as i32)
                        .map_err(|_| vm::handler::HandleError::Other)?;

                    offset += written + 1;
                }

                let mut res = Vec::with_capacity(1);
                res.push(vm::StackValue::I32(0));
                Ok(Box::pin(async move { res }))
            }
            _ => Err(vm::handler::HandleError::Other),
        }
    }
}
