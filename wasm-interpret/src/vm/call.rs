use crate::vm::{
    handler::{HandleArguments, HandleMemory},
    state::{BlockIterator, Blocks},
};

use super::{
    handler::ExternalHandler, memory, Function, Interpreter, RunError, RunErrorContext,
    RunErrorType,
};

use wasm::{FuncIndex, Instruction};

use alloc::string::String;

pub(super) async fn call<'m, EH, M>(
    interpret: &mut Interpreter<'m, EH, M>,
    func_id: FuncIndex,
    blocks: &mut Blocks<'m>,
    instr: &Instruction,
) -> Result<(), RunError>
where
    EH: ExternalHandler,
    M: memory::Memory,
{
    match interpret.functions.get(&func_id) {
        Some(Function::Internal(f, t)) => {
            tracing::trace!(
                "Calling Internal Function({:?}) {:?} -> {:?} with {:?} Locals",
                func_id,
                t.input.elements.items,
                t.output.elements.items,
                f.locals.items,
            );

            let func = (*f, *t);

            let old_blocks = core::mem::replace(blocks, Blocks::new());

            let current_stack = interpret.exec_state.op_stack.len() - t.input.elements.items.len();

            blocks.enter(
                BlockIterator::block(f.exp.instructions.iter()),
                t.input.elements.items.len(),
                t.output.elements.items.len(),
                current_stack,
            );

            let loc = interpret.locals(func);
            tracing::trace!("New-Locals {:?}", loc);

            interpret.exec_state.go_into_func(func_id, loc, old_blocks);
        }
        Some(Function::External(t)) => {
            tracing::trace!("Calling External Function {:?}", func_id);

            let name = match interpret.imported_funcs.get(&func_id) {
                Some(n) => n,
                None => {
                    return Err(RunError {
                        err: RunErrorType::UnknownExternalFunc(func_id.clone()),
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })
                }
            };

            if !interpret.env.external_handler.handles(name) {
                return Err(RunError {
                    err: RunErrorType::UnhandledExternal(name.clone()),
                    ctx: RunErrorContext {
                        instruction: Some(instr.clone()),
                    },
                });
            }

            let expected_post_call_ops =
                interpret.exec_state.op_stack.len() - t.input.elements.items.len();

            // TODO
            // Figure out how many arguments the external Function receives
            let args = HandleArguments {
                stack: &mut interpret.exec_state.op_stack,
                arguments: t.input.elements.items.len(),
            };
            let h_memory = HandleMemory {
                memory: &mut interpret.env.memory,
            };
            let result = match interpret.env.external_handler.handle(name, args, h_memory) {
                Ok(hf) => hf.await,
                Err(_) => {
                    return Err(RunError {
                        err: RunErrorType::FailedExternalFunc(String::from(name)),
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })
                }
            };

            for _ in 0..(interpret.exec_state.op_stack.len() - expected_post_call_ops) {
                interpret.exec_state.op_stack.pop();
            }

            assert_eq!(t.output.elements.items.len(), result.len());

            for val in result {
                interpret.exec_state.op_stack.push(val);
            }
        }
        None => {
            return Err(RunError {
                err: RunErrorType::UnknownFunc(func_id.clone()),
                ctx: RunErrorContext {
                    instruction: Some(instr.clone()),
                },
            })
        }
    };

    Ok(())
}
