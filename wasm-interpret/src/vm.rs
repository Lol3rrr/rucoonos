use alloc::{collections::BTreeMap, string::String, vec::Vec};

use crate::{
    ExportDescription, Func, FuncId, FunctionType, ImportDescription, Instruction, IntegerVariant,
    LocalId, MemArg, Module, NumberType, Section, ValueType,
};

use self::handler::ExternalHandler;

pub mod handler;

pub struct HandleOpStack<'s> {
    stack: &'s mut Vec<StackValue>,
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

struct State {
    func: u32,
    pc: usize,
    op_stack: Vec<StackValue>,
    current_frame: StackFrame,
    call_stack: Vec<StackFrame>,
}

#[derive(Debug)]
struct StackFrame {
    locals: Vec<StackValue>,
    func: u32,
    pc: usize,
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

            exec_state: State {
                func: 0,
                pc: 0,
                op_stack: Vec::new(),
                call_stack: Vec::new(),
                current_frame: StackFrame {
                    locals: Vec::new(),
                    func: 0,
                    pc: 0,
                },
            },
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

    pub async fn run_completion(&mut self, name: &str) -> Result<StackValue, RunError> {
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

        self.exec_state.func = func_id;
        self.exec_state.pc = 0;
        self.exec_state.current_frame = StackFrame {
            func: self.exec_state.func,
            pc: self.exec_state.pc,
            locals: self.locals(func),
        };

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

                match instr {
                    Instruction::ConstantI32(con) => {
                        self.exec_state.op_stack.push(StackValue::I32(*con));
                    }
                    Instruction::LoadI32(MemArg { align, offset }) => {
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
                    Instruction::StoreI32(MemArg { align, offset }) => {
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
                        let local_var = match self
                            .exec_state
                            .current_frame
                            .locals
                            .get(id.0 as usize)
                            .cloned()
                        {
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

                        let local_var =
                            match self.exec_state.current_frame.locals.get_mut(id.0 as usize) {
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

                        let local_var =
                            match self.exec_state.current_frame.locals.get_mut(id.0 as usize) {
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

                                let n_frame = StackFrame {
                                    func: cid.0,
                                    pc: 0,
                                    locals: self.locals(func),
                                };

                                let mut current_frame =
                                    core::mem::replace(&mut self.exec_state.current_frame, n_frame);
                                current_frame.func = self.exec_state.func;
                                current_frame.pc = self.exec_state.pc;

                                self.exec_state.call_stack.push(current_frame);

                                self.exec_state.func = cid.0;
                                self.exec_state.pc = 0;
                            }
                            Some(Function::External) => {
                                let name = match self.imported_funcs.get(&cid.0) {
                                    Some(n) => n,
                                    None => todo!("Unknown External Function {:?}", cid),
                                };

                                if !self.env.external_handler.handles(name) {
                                    todo!("Handler does not handle called External Function")
                                }

                                let op_stack = HandleOpStack {
                                    stack: &mut self.exec_state.op_stack,
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

            if let Some(prev_frame) = self.exec_state.call_stack.pop() {
                self.exec_state.func = prev_frame.func;
                self.exec_state.pc = prev_frame.pc;
                self.exec_state.current_frame = prev_frame;

                continue 'outer;
            }

            break;
        }

        self.exec_state.op_stack.pop().ok_or(RunError {
            err: RunErrorType::Other,
            ctx: RunErrorContext {},
        })
    }
}

#[derive(Debug, PartialEq, Clone)]
pub enum StackValue {
    I32(i32),
    I64(i64),
}
