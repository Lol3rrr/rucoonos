use core::{future::Future, pin::Pin};

use alloc::{boxed::Box, collections::BTreeMap, string::String, vec::Vec};

use crate::{
    ExportDescription, Func, FuncId, FunctionType, ImportDescription, Instruction, IntegerVariant,
    LocalId, MemArg, Module, NumberType, Section, ValueType,
};

use self::handler::ExternalHandler;

pub mod handler;

mod state;
pub use state::StackValue;
use state::State;

pub struct HandleOpStack<'s> {
    stack: &'s mut Vec<StackValue>,
    arguments: usize,
}

pub struct Environment<EH> {
    external_handler: EH,
    memory: Vec<u8>,
}

impl<EH> Environment<EH> {
    pub fn new(handler: EH) -> Self {
        Self {
            external_handler: handler,
            memory: Vec::new(),
        }
    }
}

pub struct Interpreter<'m, EH> {
    env: Environment<EH>,
    func_names: BTreeMap<String, u32>,
    imported_funcs: BTreeMap<u32, String>,
    functions: BTreeMap<u32, Function<'m>>,

    exec_state: State,
}

#[derive(Debug, PartialEq)]
pub enum RunErrorType {
    UnknownFuncName(String),
    UnknownFunc(FuncId),
    UnknownLocal(LocalId),
    MismatchedTypes,
    Other,
}

#[derive(Debug, PartialEq)]
pub struct RunErrorContext {}

#[derive(Debug, PartialEq)]
pub struct RunError {
    err: RunErrorType,
    ctx: RunErrorContext,
}

enum Function<'m> {
    Internal(&'m Func, &'m FunctionType),
    External,
}

impl<'m, EH> Interpreter<'m, EH>
where
    EH: ExternalHandler,
{
    pub fn new(env: Environment<EH>, module: &'m Module) -> Self {
        let func_types = module
            .sections()
            .filter_map(|sect| match sect {
                Section::TypeSection(t) => Some(t),
                _ => None,
            })
            .flat_map(|t| t.items.iter());

        let imported_funcs = module
            .sections()
            .filter_map(|sect| match sect {
                Section::ImportSection(s) => Some(s),
                _ => None,
            })
            .flat_map(|s| s.items.iter())
            .filter_map(|imp| match &imp.d {
                ImportDescription::Function(f) => Some(f),
                _ => None,
            })
            .map(|imp| (imp.0, Function::External))
            .collect::<BTreeMap<_, _>>();

        let mut index: u32 = 0;
        let code_sections: BTreeMap<u32, Function> = module
            .sections()
            .filter_map(|sec| match sec {
                Section::CodeSection(c) => Some(c),
                _ => None,
            })
            .flat_map(|e| e.items.iter())
            .zip(func_types)
            .zip(core::iter::from_fn(|| {
                while imported_funcs.contains_key(&index) {
                    index += 1;
                }
                index += 1;
                Some(index - 1)
            }))
            .map(|((c, ft), index)| (index, Function::Internal(&c.code, ft)))
            .collect();

        let functions = {
            let mut tmp = BTreeMap::new();

            tmp.extend(imported_funcs);
            tmp.extend(code_sections);

            tmp
        };

        let exported_func: BTreeMap<_, _> = module
            .exports()
            .filter_map(|exp| match exp.desc {
                ExportDescription::Function(id) => Some((exp.name.0.clone(), id)),
                _ => None,
            })
            .collect();

        let imported_funcs = module
            .sections()
            .filter_map(|sect| match sect {
                Section::ImportSection(s) => Some(s),
                _ => None,
            })
            .flat_map(|s| s.items.iter())
            .filter_map(|imp| match &imp.d {
                ImportDescription::Function(f) => Some((imp, f)),
                _ => None,
            })
            .map(|(imp, t)| (t.0, imp.nm.0.clone()))
            .collect::<BTreeMap<_, _>>();

        Self {
            env,
            functions,
            func_names: exported_func,
            imported_funcs,

            exec_state: State::new(0, Vec::new()),
        }
    }

    fn locals(&self, func: (&Func, &FunctionType)) -> Vec<StackValue> {
        func.1
            .input
            .elements
            .items
            .iter()
            .map(|t| (1, t.clone()))
            .chain(
                func.0
                    .locals
                    .items
                    .iter()
                    .map(|loc| (loc.n as usize, loc.ty.clone())),
            )
            .flat_map(|(n, ty)| {
                core::iter::repeat_with(move || match ty {
                    ValueType::Number(NumberType::I32) => StackValue::I32(0),
                    ValueType::Number(NumberType::I64) => StackValue::I64(0),
                    _ => todo!(),
                })
                .take(n)
            })
            .collect()
    }

    pub async fn run_with_wait<F>(
        &mut self,
        name: &str,
        mut wait: F,
    ) -> Result<StackValue, RunError>
    where
        F: FnMut() -> Option<Pin<Box<dyn Future<Output = ()>>>>,
    {
        let func_id = self.func_names.get(name).copied().ok_or_else(|| RunError {
            err: RunErrorType::UnknownFuncName(String::from(name)),
            ctx: RunErrorContext {},
        })?;

        let func = match self.functions.get(&func_id) {
            Some(func) => func,
            None => {
                return Err(RunError {
                    err: RunErrorType::UnknownFunc(FuncId(func_id)),
                    ctx: RunErrorContext {},
                })
            }
        };

        let func = match func {
            Function::Internal(f, t) => (*f, *t),
            Function::External => {
                return Err(RunError {
                    err: RunErrorType::Other,
                    ctx: RunErrorContext {},
                })
            }
        };

        self.exec_state = State::new(func_id, self.locals(func));

        'outer: loop {
            let func = match self.functions.get(&self.exec_state.func) {
                Some(func) => func,
                None => todo!("Unknown Function"),
            };

            let func = match func {
                Function::Internal(f, t) => (f, t),
                Function::External => {
                    return Err(RunError {
                        err: RunErrorType::Other,
                        ctx: RunErrorContext {},
                    })
                }
            };

            let instructions = func.0.exp.instructions.iter().skip(self.exec_state.pc);

            for instr in instructions {
                self.exec_state.pc += 1;

                // If we want to wait for something
                if let Some(w) = wait() {
                    w.await;
                }

                match instr {
                    Instruction::ConstantI32(con) => {
                        self.exec_state.op_stack.push(StackValue::I32(*con));
                    }
                    Instruction::LoadI32(MemArg { offset, .. }) => {
                        let dyn_address = match self.exec_state.op_stack.pop() {
                            Some(StackValue::I32(v)) => v,
                            _ => {
                                return Err(RunError {
                                    err: RunErrorType::MismatchedTypes,
                                    ctx: RunErrorContext {},
                                })
                            }
                        };

                        let address = dyn_address as u32 + offset;
                        let address_end = address + 4;

                        if self.env.memory.len() < address_end as usize {
                            self.env.memory.resize(address_end as usize, 0);
                        }

                        let raw_value = &self.env.memory[address as usize..address_end as usize];
                        let raw_value: [u8; 4] = raw_value.try_into().unwrap();

                        let value = i32::from_le_bytes(raw_value);
                        self.exec_state.op_stack.push(StackValue::I32(value));
                    }
                    Instruction::StoreI32(MemArg { offset, .. }) => {
                        let value = match self.exec_state.op_stack.pop() {
                            Some(StackValue::I32(v)) => v,
                            _ => {
                                return Err(RunError {
                                    err: RunErrorType::MismatchedTypes,
                                    ctx: RunErrorContext {},
                                })
                            }
                        };

                        let dyn_address = match self.exec_state.op_stack.pop() {
                            Some(StackValue::I32(v)) => v,
                            _ => {
                                return Err(RunError {
                                    err: RunErrorType::MismatchedTypes,
                                    ctx: RunErrorContext {},
                                })
                            }
                        };

                        let address = dyn_address as u32 + *offset;
                        let address_end = address + 4;

                        if self.env.memory.len() < address_end as usize {
                            self.env.memory.resize(address_end as usize, 0);
                        }

                        let target = &mut self.env.memory[address as usize..address_end as usize];

                        let value = i32::to_le_bytes(value);

                        target.copy_from_slice(&value);
                    }
                    Instruction::SubI(variant) => {
                        match variant {
                            IntegerVariant::I32 => {
                                let first = match self.exec_state.op_stack.pop() {
                                    Some(StackValue::I32(v)) => v,
                                    _ => {
                                        return Err(RunError {
                                            err: RunErrorType::MismatchedTypes,
                                            ctx: RunErrorContext {},
                                        })
                                    }
                                };
                                let second = match self.exec_state.op_stack.pop() {
                                    Some(StackValue::I32(v)) => v,
                                    _ => {
                                        return Err(RunError {
                                            err: RunErrorType::MismatchedTypes,
                                            ctx: RunErrorContext {},
                                        })
                                    }
                                };

                                self.exec_state
                                    .op_stack
                                    .push(StackValue::I32(first - second));
                            }
                            IntegerVariant::I64 => {
                                todo!("Sub I64")
                            }
                        };
                    }
                    Instruction::AddI(variant) => {
                        match variant {
                            IntegerVariant::I32 => {
                                let first = match self.exec_state.op_stack.pop() {
                                    Some(StackValue::I32(v)) => v,
                                    _ => {
                                        return Err(RunError {
                                            err: RunErrorType::MismatchedTypes,
                                            ctx: RunErrorContext {},
                                        })
                                    }
                                };
                                let second = match self.exec_state.op_stack.pop() {
                                    Some(StackValue::I32(v)) => v,
                                    _ => {
                                        return Err(RunError {
                                            err: RunErrorType::MismatchedTypes,
                                            ctx: RunErrorContext {},
                                        })
                                    }
                                };

                                self.exec_state
                                    .op_stack
                                    .push(StackValue::I32(first + second));
                            }
                            IntegerVariant::I64 => {
                                todo!("Sub I64")
                            }
                        };
                    }
                    Instruction::LocalGet(id) => {
                        let local_var = match self.exec_state.get_local(id.0).cloned() {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::UnknownLocal(id.clone()),
                                    ctx: RunErrorContext {},
                                })
                            }
                        };

                        self.exec_state.op_stack.push(local_var);
                    }
                    Instruction::LocalTee(id) => {
                        let value = match self.exec_state.op_stack.last().cloned() {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {},
                                })
                            }
                        };

                        let local_var = match self.exec_state.get_local_mut(id.0) {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::UnknownLocal(id.clone()),
                                    ctx: RunErrorContext {},
                                })
                            }
                        };

                        match (local_var, value) {
                            (StackValue::I32(lvar), StackValue::I32(nvar)) => {
                                *lvar = nvar;
                            }
                            _ => {
                                return Err(RunError {
                                    err: RunErrorType::MismatchedTypes,
                                    ctx: RunErrorContext {},
                                })
                            }
                        };
                    }
                    Instruction::LocalSet(id) => {
                        let value = match self.exec_state.op_stack.pop() {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {},
                                })
                            }
                        };

                        let local_var = match self.exec_state.get_local_mut(id.0) {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::UnknownLocal(id.clone()),
                                    ctx: RunErrorContext {},
                                })
                            }
                        };

                        match (local_var, value) {
                            (StackValue::I32(lvar), StackValue::I32(nvar)) => {
                                *lvar = nvar;
                            }
                            _ => {
                                return Err(RunError {
                                    err: RunErrorType::MismatchedTypes,
                                    ctx: RunErrorContext {},
                                })
                            }
                        };
                    }
                    Instruction::Call(cid) => {
                        match self.functions.get(&cid.0) {
                            Some(Function::Internal(f, t)) => {
                                let func = (*f, *t);

                                self.exec_state.go_into_func(cid.0, self.locals(func));
                            }
                            Some(Function::External) => {
                                let name = match self.imported_funcs.get(&cid.0) {
                                    Some(n) => n,
                                    None => todo!("Unknown External Function {:?}", cid),
                                };

                                if !self.env.external_handler.handles(name) {
                                    todo!("Handler does not handle called External Function")
                                }

                                // TODO
                                // Figure out how many arguments the external Function receives
                                let op_stack = HandleOpStack {
                                    stack: &mut self.exec_state.op_stack,
                                    arguments: 0,
                                };
                                let result = self.env.external_handler.handle(name, op_stack).await;

                                for val in result {
                                    self.exec_state.op_stack.push(val);
                                }
                            }
                            None => todo!("Unknown Function"),
                        };

                        continue 'outer;
                    }
                    other => todo!("Execute Instruction: {:?}", other),
                };
            }

            if self.exec_state.has_predecessor() {
                self.exec_state.return_from_func().unwrap();
            }

            break;
        }

        self.exec_state.op_stack.pop().ok_or(RunError {
            err: RunErrorType::Other,
            ctx: RunErrorContext {},
        })
    }
}
