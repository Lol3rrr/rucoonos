use core::{future::Future, pin::Pin};

use alloc::{boxed::Box, collections::BTreeMap, string::String, vec::Vec};

use crate::{
    BlockType, Data, Element, ExportDescription, Func, FuncIndex, FunctionType, GlobalIndex,
    ImportDescription, Instruction, IntegerVariant, LocalIndex, MemArg, Module, NumberType,
    RefType, Section, TypeIndex, ValueType,
};

use self::{
    handler::ExternalHandler,
    state::{Blocks, OpStack},
};

pub mod handler;

mod state;
pub use state::StackValue;
use state::State;

pub struct HandleOpStack<'s> {
    stack: &'s mut OpStack,
    arguments: usize,
    remaining: usize,
}

impl<'s> HandleOpStack<'s> {
    pub fn len(&self) -> usize {
        self.arguments
    }

    pub fn pop(&mut self) -> Option<StackValue> {
        if self.remaining == 0 {
            return None;
        }

        let res = self.stack.pop();

        if res.is_some() {
            self.remaining -= 1;
        }

        res
    }
}

pub struct HandleMemory<'s> {
    memory: &'s mut Vec<u8>,
}

impl<'s> HandleMemory<'s> {
    pub fn writei32(&mut self, addr: u32, data: i32) -> Result<(), ()> {
        let raw = data.to_le_bytes();

        if self.memory.len() < addr as usize + 4 {
            return Err(());
        }

        self.memory[addr as usize..addr as usize + 4].copy_from_slice(&raw);
        Ok(())
    }
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

    pub fn init<'d>(&mut self, data_iter: impl Iterator<Item = &'d Data>) {
        for data in data_iter {
            match data {
                Data::Variant0(offset_exp, data) => {
                    let offset = offset_exp.const_eval().unwrap() as usize;
                    let size = data.items.len();

                    if self.memory.len() < offset + size {
                        self.memory.resize(offset + size, 0);
                    }

                    for index in 0..size {
                        self.memory[index + offset] = data.items[index].0;
                    }
                }
                Data::Variant1 => todo!(),
                Data::Variant2 => todo!(),
            }
        }
    }
}

pub struct Interpreter<'m, EH> {
    module: &'m Module,
    env: Environment<EH>,
    func_names: BTreeMap<String, FuncIndex>,
    imported_funcs: BTreeMap<FuncIndex, String>,
    functions: BTreeMap<FuncIndex, Function<'m>>,
    tables: Vec<Table<'m>>,

    exec_state: State<'m>,
}

#[derive(Debug, PartialEq)]
pub enum RunErrorType {
    UnknownInitialFunction(String, FuncIndex),
    UnknownInstruction(Instruction),
    UnknownFuncName(String),
    UnknownFunc(FuncIndex),
    UnknownExternalFunc(FuncIndex),
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
    External(&'m FunctionType),
}

#[derive(Debug)]
struct Table<'m> {
    ty: &'m RefType,
    entries: Vec<TableEntry>,
    max: Option<u32>,
}

#[derive(Debug)]
enum TableEntry {
    Empty,
    FuncID(FuncIndex),
}

impl<'m, EH> Interpreter<'m, EH>
where
    EH: ExternalHandler,
{
    pub fn new(mut env: Environment<EH>, module: &'m Module) -> Self {
        env.memory.reserve(
            module
                .memory()
                .map(|mem| {
                    mem.mem_type
                        .limits
                        .min
                        .saturating_sub(env.memory.capacity() as u32)
                })
                .unwrap_or(0) as usize,
        );

        env.init(
            module
                .sections()
                .filter_map(|sect| match sect {
                    Section::DataSection(d) => Some(d),
                    _ => None,
                })
                .flat_map(|d| d.items.iter()),
        );

        let functions = {
            let import_func_iter = module.imports().filter_map(|imp| match &imp.d {
                ImportDescription::Function(index) => Some((imp, index)),
                _ => None,
            });

            let func_iter = module
                .sections()
                .filter_map(|sect| match sect {
                    Section::FunctionSection(fs) => Some(fs),
                    _ => None,
                })
                .flat_map(|s| s.items.iter());

            let func_types: BTreeMap<TypeIndex, _> = module
                .function_types()
                .enumerate()
                .map(|(i, v)| (TypeIndex::from(i as u32), v))
                .collect();

            let imported_func_map: BTreeMap<FuncIndex, Function<'m>> = import_func_iter
                .enumerate()
                .map(|(i, (_, ty_index))| {
                    (
                        FuncIndex::from(i as u32),
                        Function::External(func_types.get(ty_index).unwrap()),
                    )
                })
                .collect();

            let mut index = 0;
            let defined_func_iter = module.functions().zip(func_iter).map(|(func, f_type)| {
                while imported_func_map.contains_key(&FuncIndex::from(index)) {
                    index += 1;
                }
                let c_index = index;
                index += 1;

                let f_type = match func_types.get(f_type) {
                    Some(ft) => ft,
                    None => todo!(),
                };

                (
                    FuncIndex::from(c_index),
                    Function::Internal(&func.code, f_type),
                )
            });
            let defined_func_map: BTreeMap<FuncIndex, Function<'m>> = defined_func_iter.collect();

            let mut tmp = BTreeMap::new();
            tmp.extend(imported_func_map);
            tmp.extend(defined_func_map);

            tmp
        };

        let exported_func: BTreeMap<_, _> = module
            .exports()
            .filter_map(|exp| match exp.desc {
                ExportDescription::Function(id) => Some((exp.name.0.clone(), FuncIndex::from(id))),
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
            .enumerate()
            .map(|(index, (imp, t))| (FuncIndex::from(index as u32), imp.nm.0.clone()))
            .collect::<BTreeMap<_, _>>();

        let tables = {
            let mut raw_tables: Vec<_> = module
                .tables()
                .map(|t| Table {
                    ty: &t.0.elem,
                    entries: Vec::with_capacity(t.0.limits.min as usize),
                    max: t.0.limits.max,
                })
                .collect();

            for element in module.elements() {
                match element {
                    Element::Type1 { func_ids, offset } => {
                        let table_id = 0;

                        let offset_value = offset.const_eval().expect("IDK why yet");
                        let offset: usize = offset_value.try_into().expect("");

                        let max_size: usize = offset + func_ids.items.len();

                        let table = raw_tables.get_mut(table_id).expect("");

                        if table.entries.len() < max_size {
                            table.entries.resize_with(max_size, || TableEntry::Empty);
                        }

                        for (f_offset, id) in func_ids.items.iter().enumerate() {
                            let index = offset + f_offset;

                            table.entries[index] = TableEntry::FuncID(id.clone());
                        }
                    }
                };
            }

            raw_tables
        };

        Self {
            module,
            env,
            functions,
            func_names: exported_func,
            imported_funcs,
            tables,

            exec_state: State::new(FuncIndex::from(0), BTreeMap::new(), core::iter::empty()),
        }
    }

    fn locals(&mut self, func: (&Func, &FunctionType)) -> BTreeMap<LocalIndex, StackValue> {
        let arguments = (0..func.1.input.elements.items.len()).map(|i| {
            (
                LocalIndex::from(i as u32),
                self.exec_state.op_stack.pop().expect(""),
            )
        });

        let mut index = func.1.input.elements.items.len() as u32;
        arguments
            .into_iter()
            .chain(
                func.0
                    .locals
                    .items
                    .iter()
                    .map(|loc| (loc.n as usize, loc.ty.clone()))
                    .flat_map(|(n, ty)| {
                        core::iter::repeat_with(move || {
                            let i = &mut index;
                            *i += 1;
                            match ty {
                                ValueType::Number(NumberType::I32) => {
                                    (LocalIndex::from(*i - 1), StackValue::I32(0))
                                }
                                ValueType::Number(NumberType::I64) => {
                                    (LocalIndex::from(*i - 1), StackValue::I64(0))
                                }
                                _ => todo!("Unexpected Local Type"),
                            }
                        })
                        .take(n)
                    }),
            )
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
        let func_id = self.func_names.get(name).cloned().ok_or_else(|| RunError {
            err: RunErrorType::UnknownFuncName(String::from(name)),
            ctx: RunErrorContext { instruction: None },
        })?;

        let func = match self.functions.get(&func_id) {
            Some(func) => func,
            None => {
                return Err(RunError {
                    err: RunErrorType::UnknownInitialFunction(String::from(name), func_id),
                    ctx: RunErrorContext { instruction: None },
                })
            }
        };

        let func = match func {
            Function::Internal(f, t) => (*f, *t),
            Function::External(_) => {
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

            ((last_global_import.saturating_sub(1))..)
                .zip(raw_globals)
                .map(|(i, g)| (GlobalIndex::from(i), g))
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
                Function::External(_) => {
                    return Err(RunError {
                        err: RunErrorType::Other,
                        ctx: RunErrorContext { instruction: None },
                    })
                }
            };

            let mut blocks = {
                let mut tmp = Blocks::new();
                tmp.enter(
                    func.0.exp.instructions.iter().skip(self.exec_state.pc),
                    func.1.output.elements.items.len(),
                );

                tmp
            };

            while let Some(instr) = blocks.advance(&mut self.exec_state.op_stack) {
                self.exec_state.pc += 1;

                // If we want to wait for something
                if let Some(w) = wait() {
                    w.await;
                }

                match instr {
                    Instruction::ConstantI32(con) => {
                        tracing::trace!("Pushing Constant I32({:?})", con);

                        self.exec_state.op_stack.push(StackValue::I32(*con));
                    }
                    Instruction::LoadI32(MemArg { offset, .. }) => {
                        tracing::trace!("Loading I32 from {:?}", offset);

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

                        tracing::trace!("Loaded I32({:?}) from {:?}", value, address);

                        self.exec_state.op_stack.push(StackValue::I32(value));
                    }
                    Instruction::StoreI32(MemArg { offset, align }, ws) => {
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

                        tracing::trace!(
                            "Dyn-Address {:?} with offset {:?}, alignment {:?} and word-size {:?} to store {:?}",
                            dyn_address,
                            offset,
                            align,
                            ws,
                            value
                        );

                        let address = dyn_address as u32 + *offset;
                        let address_end = address + 4;

                        if self.env.memory.len() < address_end as usize {
                            self.env.memory.resize(address_end as usize, 0);
                        }

                        let target = &mut self.env.memory[address as usize..address_end as usize];

                        let value = i32::to_le_bytes(value);

                        assert_eq!(4, *ws);

                        target.copy_from_slice(&value);
                    }
                    Instruction::SubI(variant) => {
                        tracing::trace!("Subtract");

                        match variant {
                            IntegerVariant::I32 => {
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
                        tracing::trace!("Adding Integers {:?}", variant);

                        match variant {
                            IntegerVariant::I32 => {
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
                    Instruction::AndI(variant) => {
                        tracing::trace!("AndI Variant {:?}", variant);

                        let second = match self.exec_state.op_stack.pop() {
                            Some(s) => s,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };
                        let first = match self.exec_state.op_stack.pop() {
                            Some(f) => f,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        let res = match (variant, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                StackValue::I32(fv & sv)
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

                        self.exec_state.op_stack.push(res);
                    }
                    Instruction::LocalGet(id) => {
                        let local_var = match self.exec_state.get_local(id).cloned() {
                            Some(v) => v,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::UnknownLocal(id.clone()),
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                });
                            }
                        };

                        tracing::trace!("Getting Local {:?} = {:?}", id, local_var);

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

                        let local_var = match self.exec_state.get_local_mut(id) {
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

                        tracing::trace!("Local Tee {:?} = {:?}", id, value);

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

                        let local_var = match self.exec_state.get_local_mut(id) {
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

                        tracing::trace!("Setting Local {:?} = {:?}", id, value);

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
                        let value = match self.exec_state.get_global(gid) {
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

                        tracing::trace!("Global Get {:?} = {:?}", gid, value);

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

                        let target_var = match self.exec_state.get_global_mut(gid) {
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

                        tracing::trace!("Global Set {:?} = {:?}", gid, value);

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
                    Instruction::LtUI(var) => {
                        tracing::trace!("Less Than Unsigned Integer Comparison");

                        let second = match self.exec_state.op_stack.pop() {
                            Some(s) => s,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };
                        let first = match self.exec_state.op_stack.pop() {
                            Some(f) => f,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        let res = match (var, first, second) {
                            (
                                IntegerVariant::I32,
                                StackValue::I32(first),
                                StackValue::I32(second),
                            ) => {
                                if (first as u32) < (second as u32) {
                                    StackValue::I32(1)
                                } else {
                                    StackValue::I32(0)
                                }
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

                        self.exec_state.op_stack.push(res);
                    }
                    Instruction::LeSI(var) => {
                        tracing::trace!("Less than or Equal Signed Integer Comparison");

                        let second = match self.exec_state.op_stack.pop() {
                            Some(s) => s,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };
                        let first = match self.exec_state.op_stack.pop() {
                            Some(f) => f,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        let res = match (var, first, second) {
                            (
                                IntegerVariant::I32,
                                StackValue::I32(first),
                                StackValue::I32(second),
                            ) => {
                                if first <= second {
                                    StackValue::I32(1)
                                } else {
                                    StackValue::I32(0)
                                }
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

                        self.exec_state.op_stack.push(res);
                    }
                    Instruction::LeUI(var) => {
                        tracing::trace!("Less than or Equal Signed Integer Comparison");

                        let second = match self.exec_state.op_stack.pop() {
                            Some(s) => s,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };
                        let first = match self.exec_state.op_stack.pop() {
                            Some(f) => f,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        let res = match (var, first, second) {
                            (
                                IntegerVariant::I32,
                                StackValue::I32(first),
                                StackValue::I32(second),
                            ) => {
                                if (first as u32) <= (second as u32) {
                                    StackValue::I32(1)
                                } else {
                                    StackValue::I32(0)
                                }
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

                        self.exec_state.op_stack.push(res);
                    }

                    Instruction::GtUI(var) => {
                        tracing::trace!("Greater Than Unsigned Integer Comparison");

                        let second = match self.exec_state.op_stack.pop() {
                            Some(s) => s,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };
                        let first = match self.exec_state.op_stack.pop() {
                            Some(f) => f,
                            None => {
                                return Err(RunError {
                                    err: RunErrorType::Other,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        let res = match (var, first, second) {
                            (
                                IntegerVariant::I32,
                                StackValue::I32(first),
                                StackValue::I32(second),
                            ) => {
                                if (first as u32) > (second as u32) {
                                    StackValue::I32(1)
                                } else {
                                    StackValue::I32(0)
                                }
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

                        self.exec_state.op_stack.push(res);
                    }

                    Instruction::Call(cid) => {
                        match self.functions.get(cid) {
                            Some(Function::Internal(f, t)) => {
                                tracing::trace!("Calling Internal Function");

                                let func = (*f, *t);

                                let old_blocks = core::mem::replace(&mut blocks, Blocks::new());

                                let loc = self.locals(func);

                                self.exec_state.go_into_func(cid.clone(), loc, old_blocks);
                            }
                            Some(Function::External(t)) => {
                                tracing::trace!("Calling External Function {:?}", cid);

                                let name = match self.imported_funcs.get(cid) {
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
                                    arguments: t.input.elements.items.len(),
                                    remaining: t.input.elements.items.len(),
                                };
                                let h_memory = HandleMemory {
                                    memory: &mut self.env.memory,
                                };
                                let result = self
                                    .env
                                    .external_handler
                                    .handle(name, op_stack, h_memory)
                                    .await;

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
                    Instruction::Block(ty, b_instr) => {
                        tracing::trace!("Block");

                        let input_arity = match ty {
                            BlockType::Empty => 0,
                            BlockType::Value(_) => todo!(),
                            BlockType::TypeIndex(_) => todo!(),
                        };

                        let output_arity = match ty {
                            BlockType::Empty => 0,
                            BlockType::Value(_) => todo!(),
                            BlockType::TypeIndex(_) => todo!(),
                        };

                        let values = {
                            let mut tmp = Vec::new();

                            for _ in 0..input_arity {
                                let value = self.exec_state.op_stack.pop().expect("");
                                tmp.push(value);
                            }

                            tmp
                        };

                        self.exec_state.op_stack.push(StackValue::Block);
                        self.exec_state.op_stack.extend(values.into_iter().rev());

                        blocks.enter(b_instr.iter().skip(0), output_arity);
                    }
                    Instruction::Branch(index) => {
                        tracing::trace!("Branch {:?}", index);

                        /*
                        // 1.
                        assert!(blocks.blocks.len() > index.0 as usize);

                        // 2.
                        let L = blocks.blocks.get(index.0 as usize).expect("There should be at least this many blocks because we previously asserted this");

                        // 3.
                        let n = L.ty.input.elements.items.len();

                        // 4.
                        assert!(self.exec_state.op_stack.len() >= n);

                        // 5.
                        let values = {
                            let mut tmp = Vec::with_capacity(n);

                            for _ in 0..n {
                                let val = self.exec_state.op_stack.pop().expect("");
                                tmp.push(val);
                            }

                            tmp
                        };

                        // 6.
                        for _ in 0..(index.0 + 1) {
                            while !matches!(
                                self.exec_state.op_stack.last(),
                                Some(StackValue::Block)
                            ) {
                                self.exec_state.op_stack.pop();
                            }

                            self.exec_state.op_stack.pop();
                            blocks.blocks.pop();
                        }

                        // 7.
                        for val in values {
                            self.exec_state.op_stack.push(val);
                        }
                        */

                        todo!("Perform an unconditional Branch")
                    }
                    Instruction::BranchConditional(c) => {
                        tracing::trace!("Branching Conditional {:?}", c);

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

                        let cond_value = match value {
                            StackValue::I32(v) => v,
                            _ => {
                                return Err(RunError {
                                    err: RunErrorType::MismatchedTypes,
                                    ctx: RunErrorContext {
                                        instruction: Some(instr.clone()),
                                    },
                                })
                            }
                        };

                        if cond_value != 0 {
                            todo!("Perform a conditional Branch")
                        } else {
                            // Do nothing
                        }
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
                continue;
            }

            break;
        }

        self.exec_state.op_stack.pop().ok_or(RunError {
            err: RunErrorType::Other,
            ctx: RunErrorContext { instruction: None },
        })
    }
}
