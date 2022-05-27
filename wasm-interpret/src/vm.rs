use core::{future::Future, pin::Pin};

use alloc::{
    boxed::Box,
    collections::{BTreeMap, BTreeSet},
    string::String,
    vec::Vec,
};

use crate::{
    ExportDescription, Func, FuncId, FunctionType, ImportDescription, Instruction, IntegerVariant,
    LocalIndex, MemArg, Module, NumberType, Section, ValueType,
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
    module: &'m Module,
    env: Environment<EH>,
    func_names: BTreeMap<String, u32>,
    imported_funcs: BTreeMap<u32, String>,
    functions: BTreeMap<u32, Function<'m>>,

    exec_state: State<'m>,
}

#[derive(Debug, PartialEq)]
pub enum RunErrorType {
    UnknownInitialFunction(String, FuncId),
    UnknownInstruction(Instruction),
    UnknownFuncName(String),
    UnknownFunc(FuncId),
    UnknownExternalFunc(FuncId),
    UnhandledExternal(String),
    UnknownLocal(LocalIndex),
    MismatchedTypes,
    Other,
}

#[derive(Debug, PartialEq)]
pub struct RunErrorContext {
    instruction: Option<Instruction>,
}

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
        let functions = {
            let import_func_iter = module.imports().filter_map(|imp| match &imp.d {
                ImportDescription::Function(index) => Some((imp, index)),
                _ => None,
            });
            let imported_func_map: BTreeMap<u32, Function<'m>> = import_func_iter
                .map(|(imp, d)| (d.0, Function::External))
                .collect();

            let func_iter = module
                .sections()
                .filter_map(|sect| match sect {
                    Section::FunctionSection(fs) => Some(fs),
                    _ => None,
                })
                .flat_map(|s| s.items.iter());

            let func_types: Vec<_> = module.function_types().collect();

            let mut index = 0;
            let defined_func_iter = module.functions().zip(func_iter).map(|(func, f_type)| {
                while imported_func_map.contains_key(&index) {
                    index += 1;
                }
                let c_index = index;
                index += 1;

                let f_type = match func_types.get(f_type.0 as usize) {
                    Some(ft) => ft,
                    None => todo!(),
                };

                (c_index, Function::Internal(&func.code, f_type))
            });
            let defined_func_map: BTreeMap<u32, Function<'m>> = defined_func_iter.collect();

            let mut tmp = BTreeMap::new();
            tmp.extend(imported_func_map);
            tmp.extend(defined_func_map);

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
            module,
            env,
            functions,
            func_names: exported_func,
            imported_funcs,

            exec_state: State::new(0, Vec::new(), core::iter::empty()),
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
                    _ => todo!("Unexpected Local Type"),
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
            ctx: RunErrorContext { instruction: None },
        })?;

        let func = match self.functions.get(&func_id) {
            Some(func) => func,
            None => {
                return Err(RunError {
                    err: RunErrorType::UnknownInitialFunction(String::from(name), FuncId(func_id)),
                    ctx: RunErrorContext { instruction: None },
                })
            }
        };

        let func = match func {
            Function::Internal(f, t) => (*f, *t),
            Function::External => {
                return Err(RunError {
                    err: RunErrorType::Other,
                    ctx: RunErrorContext { instruction: None },
                })
            }
        };

        let globals_iter = {
            let raw_globals = self.module.globals();

            let last_global_import = self
                .module
                .imports()
                .filter(|exp| matches!(exp.d, ImportDescription::Global(_)))
                .count() as u32;

            ((last_global_import.saturating_sub(1))..).zip(raw_globals)
        };

        self.exec_state = State::new(func_id, self.locals(func), globals_iter);

        'outer: loop {
            let func = match self.functions.get(&self.exec_state.func) {
                Some(func) => func,
                None => {
                    return Err(RunError {
                        err: RunErrorType::Other,
                        ctx: RunErrorContext { instruction: None },
                    })
                }
            };

            let func = match func {
                Function::Internal(f, t) => (f, t),
                Function::External => {
                    return Err(RunError {
                        err: RunErrorType::Other,
                        ctx: RunErrorContext { instruction: None },
                    })
                }
            };

            let mut instructions = func.0.exp.instructions.iter().skip(self.exec_state.pc);

            while let Some(instr) = instructions.next() {
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
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
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
                    Instruction::StoreI32(MemArg { offset, .. }, ws) => {
                        let value = match self.exec_state.op_stack.pop() {
                            Some(StackValue::I32(v)) => v,
                            _ => {
                                return Err(RunError {
                                    err: RunErrorType::MismatchedTypes,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        let dyn_address = match self.exec_state.op_stack.pop() {
                            Some(StackValue::I32(v)) => v,
                            _ => {
                                return Err(RunError {
                                    err: RunErrorType::MismatchedTypes,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        let address = dyn_address as u32 + *offset;
                        let address_end = address + (*ws as u32);

                        if self.env.memory.len() < address_end as usize {
                            self.env.memory.resize(address_end as usize, 0);
                        }

                        let target = &mut self.env.memory[address as usize..address_end as usize];

                        let value = i32::to_le_bytes(value);

                        target.copy_from_slice(&value[..*ws]);
                    }
                    Instruction::SubI(variant) => {
                        match variant {
                            IntegerVariant::I32 => {
                                let first = match self.exec_state.op_stack.pop() {
                                    Some(StackValue::I32(v)) => v,
                                    _ => {
                                        return Err(RunError {
                                            err: RunErrorType::MismatchedTypes,
                                            ctx: RunErrorContext {
                                                instruction: Some(instr.clone()),
                                            },
                                        })
                                    }
                                };
                                let second = match self.exec_state.op_stack.pop() {
                                    Some(StackValue::I32(v)) => v,
                                    _ => {
                                        return Err(RunError {
                                            err: RunErrorType::MismatchedTypes,
                                            ctx: RunErrorContext {
                                                instruction: Some(instr.clone()),
                                            },
                                        })
                                    }
                                };

                                self.exec_state
                                    .op_stack
                                    .push(StackValue::I32(first - second));
                            }
                            IntegerVariant::I64 => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
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
                                            ctx: RunErrorContext {
                                                instruction: Some(instr.clone()),
                                            },
                                        })
                                    }
                                };
                                let second = match self.exec_state.op_stack.pop() {
                                    Some(StackValue::I32(v)) => v,
                                    _ => {
                                        return Err(RunError {
                                            err: RunErrorType::MismatchedTypes,
                                            ctx: RunErrorContext {
                                                instruction: Some(instr.clone()),
                                            },
                                        })
                                    }
                                };

                                self.exec_state
                                    .op_stack
                                    .push(StackValue::I32(first + second));
                            }
                            IntegerVariant::I64 => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };
                    }
                    Instruction::LocalGet(id) => {
                        let local_var = match self.exec_state.get_local(id.0).cloned() {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::UnknownLocal(id.clone()),
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
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
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        let local_var = match self.exec_state.get_local_mut(id.0) {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::UnknownLocal(id.clone()),
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
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
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
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
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        let local_var = match self.exec_state.get_local_mut(id.0) {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::UnknownLocal(id.clone()),
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
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
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };
                    }
                    Instruction::GlobalGet(gid) => {
                        let value = match self.exec_state.get_global(gid.0) {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        self.exec_state.op_stack.push(value.clone());
                    }
                    Instruction::GlobalSet(gid) => {
                        let value = match self.exec_state.op_stack.pop() {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        let target_var = match self.exec_state.get_global_mut(gid.0) {
                            Some(t) => t,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        match (target_var, value) {
                            (StackValue::I32(g_var), StackValue::I32(val)) => {
                                *g_var = val;
                            }
                            other => {
                                return Err(RunError {
                                    err: RunErrorType::MismatchedTypes,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
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
                                    None => {
                                        return Err(RunError {
                                            err: RunErrorType::UnknownExternalFunc(cid.clone()),
                                            ctx: RunErrorContext {
                                                instruction: Some(instr.clone()),
                                            },
                                        })
                                    }
                                };

                                if !self.env.external_handler.handles(name) {
                                    return Err(RunError {
                                        err: RunErrorType::UnhandledExternal(name.clone()),
                                        ctx: RunErrorContext {
                                            instruction: Some(instr.clone()),
                                        },
                                    });
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
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::UnknownFunc(cid.clone()),
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        continue 'outer;
                    }
                    Instruction::Block(type_index, b_instr) => {
                        todo!("Type Index {:?}", type_index)
                    }
                    other => {
                        return Err(RunError {
                            err: RunErrorType::UnknownInstruction(other.clone()),
                            ctx: RunErrorContext {
                                instruction: Some(instr.clone()),
                            },
                        })
                    }
                };
            }

            if self.exec_state.has_predecessor() {
                self.exec_state.return_from_func().unwrap();
            }

            break;
        }

        self.exec_state.op_stack.pop().ok_or(RunError {
            err: RunErrorType::Other,
            ctx: RunErrorContext { instruction: None },
        })
    }
}
