use core::{
    future::Future,
    ops::{Shl, Shr},
    pin::Pin,
};

use alloc::{boxed::Box, collections::BTreeMap, string::String, vec::Vec};

use wasm::{
    BlockType, Data, Element, ExportDescription, Func, FuncIndex, FunctionType, GlobalIndex,
    ImportDescription, Instruction, IntegerVariant, LocalIndex, MemArg, Module, NumberType,
    RefType, Section, TypeIndex, ValueType,
};

use self::{handler::ExternalHandler, state::Blocks};

pub mod handler;
pub mod memory;

mod state;
pub use state::StackValue;
use state::State;

mod branch;
mod call;
mod op;

pub struct Environment<EH, M> {
    external_handler: EH,
    memory: M,
}

impl<EH, M> Environment<EH, M>
where
    M: memory::Memory,
{
    pub fn new(handler: EH, memory: M) -> Self {
        Self {
            external_handler: handler,
            memory,
        }
    }

    #[tracing::instrument(skip(self, data_iter))]
    pub fn init<'d>(&mut self, data_iter: impl Iterator<Item = &'d Data>) {
        for data in data_iter {
            match data {
                Data::Variant0(offset_exp, data) => {
                    let offset = offset_exp.const_eval().unwrap() as usize;
                    let size = data.items.len();

                    tracing::trace!("Writing {:?} bytes starting at {:?}", size, offset);

                    if self.memory.size() < offset + size {
                        self.memory.grow(offset + size);
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

pub struct Interpreter<'m, EH, M> {
    module: &'m Module,
    env: Box<Environment<EH, M>>,
    func_names: BTreeMap<String, FuncIndex>,
    imported_funcs: BTreeMap<FuncIndex, String>,
    functions: BTreeMap<FuncIndex, Function<'m>>,
    tables: Vec<Table<'m>>,

    exec_state: Box<State<'m>>,
}

#[derive(Debug, PartialEq)]
pub enum RunErrorType {
    MissingOperand,
    UnknownInitialFunction(String, FuncIndex),
    UnknownInstruction(Instruction),
    UnknownFuncName(String),
    UnknownFunc(FuncIndex),
    UnknownExternalFunc(FuncIndex),
    UnhandledExternal(String),
    UnknownLocal(LocalIndex),
    MismatchedTypes,
    ReachedUnreachable,
    FailedExternalFunc(String),
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

#[derive(Debug)]
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

impl<'m, EH, M> Interpreter<'m, EH, M>
where
    EH: ExternalHandler,
    M: memory::Memory,
{
    pub fn new(mut env: Environment<EH, M>, module: &'m Module) -> Self {
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
            .map(|(index, (imp, _))| (FuncIndex::from(index as u32), imp.nm.0.clone()))
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
                    Element::Type1 {
                        func_ids,
                        offset: offset_exp,
                    } => {
                        let table_id = 0;

                        let offset_value = offset_exp.const_eval().expect("IDK why yet");
                        let offset: usize = offset_value.try_into().expect("");

                        let max_size: usize = offset + func_ids.items.len();

                        let table = raw_tables.get_mut(table_id).expect("");

                        if table.entries.len() < max_size {
                            table.entries.resize_with(max_size, || TableEntry::Empty);
                        }

                        tracing::trace!("Offset {:?} from {:?}", offset, offset_exp);

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
            env: Box::new(env),
            functions,
            func_names: exported_func,
            imported_funcs,
            tables,

            exec_state: Box::new(State::new(
                FuncIndex::from(0),
                BTreeMap::new(),
                core::iter::empty(),
            )),
        }
    }

    #[tracing::instrument(name = "locals", skip(self, func))]
    fn locals(&mut self, func: (&Func, &FunctionType)) -> BTreeMap<LocalIndex, StackValue> {
        let arguments: BTreeMap<LocalIndex, StackValue> = (0..func.1.input.elements.items.len())
            .map(|i| {
                (
                    LocalIndex::from(i as u32),
                    self.exec_state.op_stack.pop().expect(""),
                )
            })
            .rev()
            .collect();

        tracing::trace!("Arguments {:?}", arguments);

        let index = func.1.input.elements.items.len() as u32;
        arguments
            .into_iter()
            .chain(
                func.0
                    .locals
                    .items
                    .iter()
                    .map(|loc| (loc.n as usize, &loc.ty))
                    .flat_map(|(n, ty)| {
                        core::iter::repeat_with(move || match ty {
                            ValueType::Number(NumberType::I32) => StackValue::I32(0),
                            ValueType::Number(NumberType::I64) => StackValue::I64(0),
                            _ => todo!("Unexpected Local Type"),
                        })
                        .take(n)
                    })
                    .enumerate()
                    .map(|(off, val)| (LocalIndex::from(off as u32 + index), val)),
            )
            .collect()
    }

    pub async fn run_with_wait<F>(
        &mut self,
        name: &str,
        mut wait: F,
    ) -> Result<Vec<StackValue>, RunError>
    where
        F: FnMut() -> Option<Pin<Box<dyn Future<Output = ()>>>>,
    {
        let func = {
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

            self.exec_state = Box::new(State::new(func_id, self.locals(func), globals_iter));

            func
        };

        let mut blocks = {
            let mut tmp = Blocks::new();
            tmp.enter(
                func.0.exp.instructions.iter().skip(0),
                func.1.input.elements.items.len(),
                func.1.output.elements.items.len(),
                self.exec_state.op_stack.len(),
            );

            tmp
        };

        loop {
            match Box::pin(self.inner_loop(&mut blocks, &mut wait)).await? {
                InnerLoop::Continue => continue,
                InnerLoop::Break => break,
                InnerLoop::Nop => {}
            };

            if self.exec_state.has_predecessor() {
                tracing::trace!("Reached End of Function {:?}", self.exec_state.func);

                tracing::trace!(
                    "Return Op-Stack {:?} entered with {:?}",
                    self.exec_state.op_stack.len(),
                    self.exec_state.current_opstack_starting_height()
                );

                if self.exec_state.op_stack.len()
                    < self.exec_state.current_opstack_starting_height()
                {
                    tracing::trace!("Op-Stack {:#?}", self.exec_state.op_stack);
                    panic!();
                }

                blocks = self.exec_state.return_from_func().unwrap();

                tracing::trace!(
                    "Return to caller with values {:?}",
                    self.exec_state.op_stack.last()
                );

                continue;
            }

            assert!(blocks.blocks.is_empty());

            tracing::trace!("Broke from the Loop");

            break;
        }

        let functy = self
            .functions
            .get(&self.exec_state.func)
            .map(|f| match f {
                Function::Internal(_, t) => t,
                _ => unreachable!(),
            })
            .expect("");

        tracing::trace!("Function Types {:?}", functy);

        if self.exec_state.op_stack.len() != functy.output.elements.items.len() {
            return Err(RunError {
                err: RunErrorType::Other,
                ctx: RunErrorContext { instruction: None },
            });
        }

        Ok(self.exec_state.take_stack().into())
    }

    async fn inner_loop(
        &mut self,
        blocks: &mut Blocks<'m>,
        wait: &mut dyn FnMut() -> Option<Pin<Box<dyn Future<Output = ()>>>>,
    ) -> Result<InnerLoop, RunError> {
        while let Some(instr) = blocks.advance(&mut self.exec_state.op_stack) {
            // If we want to wait for something
            if let Some(w) = wait() {
                w.await;
            }

            let instr_span = tracing::span!(
                tracing::Level::TRACE,
                "exec_instr",
                func = u32::from(self.exec_state.func.clone()),
                block = blocks.blocks.len(),
            );
            let _guard = instr_span.enter();

            match instr {
                Instruction::ConstantI32(con) => {
                    let span = tracing::span!(tracing::Level::TRACE, "ConstantI32");
                    let _guard = span.enter();

                    tracing::trace!("Pushing Constant I32({:?})", con);

                    self.exec_state.op_stack.push(StackValue::I32(*con));
                }
                Instruction::ConstantI64(con) => {
                    let span = tracing::span!(tracing::Level::TRACE, "ConstantI64");
                    let _guard = span.enter();

                    tracing::trace!("Pushing Constant I64({:?})", con);

                    self.exec_state.op_stack.push(StackValue::I64(*con));
                }
                Instruction::Drop => {
                    let span = tracing::span!(tracing::Level::TRACE, "Drop");
                    let _guard = span.enter();

                    tracing::trace!("Drop Instruction");

                    match self.exec_state.op_stack.pop() {
                        Some(_) => {}
                        None => {
                            return Err(RunError {
                                err: RunErrorType::Other,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                    };
                }
                Instruction::Select => {
                    let span = tracing::span!(tracing::Level::TRACE, "Select");
                    let _guard = span.enter();

                    tracing::trace!("Select Instruction");

                    let c = match self.exec_state.op_stack.pop() {
                        Some(StackValue::I32(c)) => c,
                        Some(other) => {
                            return Err(RunError {
                                err: RunErrorType::MismatchedTypes,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                        None => {
                            return Err(RunError {
                                err: RunErrorType::Other,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                    };

                    let v_2 = match self.exec_state.op_stack.pop() {
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
                    let v_1 = match self.exec_state.op_stack.pop() {
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

                    match (&v_1, &v_2) {
                        (StackValue::I32(_), StackValue::I32(_)) => {}
                        _ => {
                            return Err(RunError {
                                err: RunErrorType::MismatchedTypes,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                    };

                    let res = if c != 0 { v_1 } else { v_2 };

                    self.exec_state.op_stack.push(res);
                }
                Instruction::LoadI32(MemArg { offset, .. }) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LoadI32");
                    let _guard = span.enter();

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

                    if self.env.memory.size() < address_end as usize {
                        self.env.memory.grow(address_end as usize);
                        tracing::trace!("Resize");
                    }

                    let raw_value = &self.env.memory[address as usize..address_end as usize];
                    let raw_value: [u8; 4] = raw_value.try_into().unwrap();

                    let value = i32::from_le_bytes(raw_value);

                    tracing::trace!("Loaded I32({:?}) from {:?}", value, address);

                    self.exec_state.op_stack.push(StackValue::I32(value));
                }
                Instruction::LoadI32_8U(MemArg { offset, .. }) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LoadI32_8U");
                    let _guard = span.enter();

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
                    let address_end = address + 1;

                    if self.env.memory.size() < address_end as usize {
                        self.env.memory.grow(address_end as usize);
                        tracing::trace!("Resize");
                    }

                    let raw_value = self.env.memory[address as usize];
                    let value = raw_value as i32;

                    tracing::trace!("Loaded I32({:?}) from {:?}", value, address);

                    self.exec_state.op_stack.push(StackValue::I32(value));
                }
                Instruction::LoadI32_8S(MemArg { offset, .. }) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LoadI32_8U");
                    let _guard = span.enter();

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
                    let address_end = address + 1;

                    if self.env.memory.size() < address_end as usize {
                        self.env.memory.grow(address_end as usize);
                        tracing::trace!("Resize");
                    }

                    let raw_value: i8 = self.env.memory[address as usize].try_into().unwrap();
                    let value = raw_value as i32;

                    tracing::trace!("Loaded I32({:?}) from {:?}", value, address);

                    self.exec_state.op_stack.push(StackValue::I32(value));
                }
                Instruction::LoadI32_16U(MemArg { offset, .. }) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LoadI32_16U");
                    let _guard = span.enter();

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
                    let address_end = address + 2;

                    if self.env.memory.size() < address_end as usize {
                        self.env.memory.grow(address_end as usize);
                        tracing::trace!("Resize");
                    }

                    let raw_value = &self.env.memory[address as usize..address_end as usize];
                    let value = i32::from_le_bytes([raw_value[0], raw_value[1], 0, 0]);

                    tracing::trace!("Loaded I32({:?}) from {:?}", value, address);

                    self.exec_state.op_stack.push(StackValue::I32(value));
                }
                Instruction::LoadI64(MemArg { offset, .. }) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LoadI64");
                    let _guard = span.enter();

                    tracing::trace!("Loading I64 from {:?}", offset);

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
                    let address_end = address + 8;

                    if self.env.memory.size() < address_end as usize {
                        self.env.memory.grow(address_end as usize);
                        tracing::trace!("Resize");
                    }

                    let raw_value = &self.env.memory[address as usize..address_end as usize];
                    let raw_value: [u8; 8] = raw_value.try_into().unwrap();

                    let value = i64::from_le_bytes(raw_value);

                    tracing::trace!("Loaded I64({:?}) from {:?}", value, address);

                    self.exec_state.op_stack.push(StackValue::I64(value));
                }
                Instruction::LoadI64_32U(MemArg { offset, .. }) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LoadI64_32U");
                    let _guard = span.enter();

                    tracing::trace!("Loading I64_32U from {:?}", offset);

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

                    if self.env.memory.size() < address_end as usize {
                        self.env.memory.grow(address_end as usize);
                        tracing::trace!("Resize");
                    }

                    let raw_value = &self.env.memory[address as usize..address_end as usize];
                    let raw_value: [u8; 4] = raw_value.try_into().unwrap();

                    let value = u32::from_le_bytes(raw_value);

                    tracing::trace!("Loaded U32({:?}) from {:?}", value, address);

                    self.exec_state.op_stack.push(StackValue::I64(value as i64));
                }
                Instruction::StoreI32(MemArg { offset, align }, ws) => {
                    let span = tracing::span!(tracing::Level::TRACE, "StoreI32");
                    let _guard = span.enter();

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
                    let address_end = address + *ws as u32;

                    if self.env.memory.size() < address_end as usize {
                        self.env.memory.grow(address_end as usize);
                    }

                    match *ws {
                        1 => {
                            self.env.memory[address as usize] = value as u8;
                        }
                        2 => {
                            let target =
                                &mut self.env.memory[address as usize..address_end as usize];

                            let value = i32::to_le_bytes(value);

                            target.copy_from_slice(&value[..2]);
                        }
                        4 => {
                            let target =
                                &mut self.env.memory[address as usize..address_end as usize];

                            let value = i32::to_le_bytes(value);

                            target.copy_from_slice(&value);
                        }
                        other => {
                            tracing::trace!("Store I32 as word-size {:?}", other);
                            todo!()
                        }
                    }
                }
                Instruction::StoreI64(MemArg { align, offset }, ws) => {
                    let span = tracing::span!(tracing::Level::TRACE, "StoreI64");
                    let _guard = span.enter();

                    tracing::trace!("StoreI64");

                    let value = match self.exec_state.op_stack.pop() {
                        Some(StackValue::I64(v)) => v,
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
                    let address_end = address + 8;

                    if self.env.memory.size() < address_end as usize {
                        self.env.memory.grow(address_end as usize);
                    }

                    let target = &mut self.env.memory[address as usize..address_end as usize];

                    let value = i64::to_le_bytes(value);

                    assert_eq!(8, *ws);

                    target.copy_from_slice(&value);
                }
                Instruction::SubI(variant) => {
                    let span = tracing::span!(tracing::Level::TRACE, "SubI");
                    let _guard = span.enter();

                    tracing::trace!("Subtract");

                    op::binary_op(&mut self.exec_state.op_stack, |first, second| {
                        match (variant, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(StackValue::I32(fv - sv))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::AddI(variant) => {
                    let span = tracing::span!(tracing::Level::TRACE, "AddI");
                    let _guard = span.enter();

                    tracing::trace!("Adding Integers {:?}", variant);

                    op::binary_op(&mut self.exec_state.op_stack, |first, second| {
                        match (variant, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(StackValue::I32(fv + sv))
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok(StackValue::I64(fv + sv))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::MulI(variant) => {
                    let span = tracing::span!(tracing::Level::TRACE, "MulI");
                    let _guard = span.enter();

                    tracing::trace!("MulI Variant {:?}", variant);

                    op::binary_op(&mut self.exec_state.op_stack, |first, second| {
                        match (variant, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(StackValue::I32(fv * sv))
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok(StackValue::I64(fv * sv))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::DivUI(variant) => {
                    let span = tracing::span!(tracing::Level::TRACE, "DivUI");
                    let _guard = span.enter();

                    tracing::trace!("DivUI Variant {:?}", variant);

                    op::binary_op(&mut self.exec_state.op_stack, |first, second| {
                        match (variant, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(StackValue::I32(((fv as u32) / (sv as u32)) as i32))
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok(StackValue::I64(((fv as u64) / (sv as u64)) as i64))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::AndI(variant) => {
                    let span = tracing::span!(tracing::Level::TRACE, "AndI");
                    let _guard = span.enter();

                    tracing::trace!("AndI Variant {:?}", variant);

                    op::binary_op(&mut self.exec_state.op_stack, |first, second| {
                        match (variant, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(StackValue::I32(fv & sv))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::OrI(variant) => {
                    let span = tracing::span!(tracing::Level::TRACE, "OrI");
                    let _guard = span.enter();

                    tracing::trace!("OrI Variant {:?}", variant);

                    op::binary_op(&mut self.exec_state.op_stack, |first, second| {
                        match (variant, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(StackValue::I32(fv | sv))
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok(StackValue::I64(fv | sv))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::XorI(variant) => {
                    let span = tracing::span!(tracing::Level::TRACE, "XorI");
                    let _guard = span.enter();

                    tracing::trace!("XorI Variant {:?}", variant);

                    op::binary_op(&mut self.exec_state.op_stack, |first, second| {
                        match (variant, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(StackValue::I32(fv ^ sv))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::ShrUI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "ShrUI");
                    let _guard = span.enter();

                    tracing::trace!("Shift Right Unsigned");

                    op::binary_op(&mut self.exec_state.op_stack, |first, second| {
                        match (var, first, second) {
                            (
                                IntegerVariant::I32,
                                StackValue::I32(first),
                                StackValue::I32(second),
                            ) => {
                                let first = first as u32;
                                let second = second as u32;

                                Ok(StackValue::I32((first.shr(second)) as i32))
                            }
                            (
                                IntegerVariant::I64,
                                StackValue::I64(first),
                                StackValue::I64(second),
                            ) => {
                                let first = first as u64;
                                let second = second as u64;

                                Ok(StackValue::I64((first.shr(second)) as i64))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ty| RunError {
                        err: ty,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::ShrSI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "ShrSI");
                    let _guard = span.enter();

                    tracing::trace!("Shift Right Signed");

                    op::binary_op(&mut self.exec_state.op_stack, |first, second| {
                        match (var, first, second) {
                            (
                                IntegerVariant::I32,
                                StackValue::I32(first),
                                StackValue::I32(second),
                            ) => Ok(StackValue::I32(first.shr(second))),
                            (
                                IntegerVariant::I64,
                                StackValue::I64(first),
                                StackValue::I64(second),
                            ) => Ok(StackValue::I64(first.shr(second))),
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ty| RunError {
                        err: ty,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::ShlI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "ShlI");
                    let _guard = span.enter();

                    tracing::trace!("Shift Left");

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
                        (IntegerVariant::I32, StackValue::I32(first), StackValue::I32(second)) => {
                            StackValue::I32(first.shl(second))
                        }
                        (IntegerVariant::I64, StackValue::I64(first), StackValue::I64(second)) => {
                            StackValue::I64(first.shl(second))
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
                Instruction::WrapI32I64 => {
                    let span = tracing::span!(tracing::Level::TRACE, "WrapI32I64");
                    let _guard = span.enter();

                    tracing::trace!("Wrapping I64 down to I32");

                    let prev = match self.exec_state.op_stack.pop() {
                        Some(StackValue::I64(v)) => v,
                        Some(other) => {
                            return Err(RunError {
                                err: RunErrorType::MismatchedTypes,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                        None => {
                            return Err(RunError {
                                err: RunErrorType::Other,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                    };

                    let n_value = (prev % (i32::MAX as i64)) as i32;

                    self.exec_state.op_stack.push(StackValue::I32(n_value));
                }
                Instruction::ExtendI64I32U => {
                    let span = tracing::span!(tracing::Level::TRACE, "ExtendI64I32");
                    let _guard = span.enter();

                    tracing::trace!("Extending I32 to I64 unsigned");

                    let prev = match self.exec_state.op_stack.pop() {
                        Some(StackValue::I32(v)) => v,
                        Some(other) => {
                            return Err(RunError {
                                err: RunErrorType::MismatchedTypes,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                        None => {
                            return Err(RunError {
                                err: RunErrorType::Other,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                    };

                    let n_value = ((prev as u32) as u64) as i64;

                    self.exec_state.op_stack.push(StackValue::I64(n_value));
                }
                Instruction::LocalGet(id) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LocalGet");
                    let _guard = span.enter();

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
                    let span = tracing::span!(tracing::Level::TRACE, "LocalTee");
                    let _guard = span.enter();

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

                    // TODO
                    // Same as in the Set, is this actually correct?
                    *local_var = value;

                    /*
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
                    */
                }
                Instruction::LocalSet(id) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LocalSet");
                    let _guard = span.enter();

                    tracing::trace!("LocalSet");

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

                    tracing::trace!("Setting Local {:?}({:?}) = {:?}", id, local_var, value);

                    // TODO
                    // Is this actually correct
                    *local_var = value;

                    /*
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
                    */
                }
                Instruction::GlobalGet(gid) => {
                    let span = tracing::span!(tracing::Level::TRACE, "GlobalGet");
                    let _guard = span.enter();

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
                    let span = tracing::span!(tracing::Level::TRACE, "GlobalSet");
                    let _guard = span.enter();

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
                Instruction::EqzI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "EqzI");
                    let _guard = span.enter();

                    tracing::trace!("Equal to Zero");

                    let value = match self.exec_state.op_stack.pop() {
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

                    let res = match (var, value) {
                        (IntegerVariant::I32, StackValue::I32(val)) => {
                            if val == 0 {
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
                Instruction::EqI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "EqI");
                    let _guard = span.enter();

                    tracing::trace!("Equal Integer Comparison");

                    op::relation_op(&mut self.exec_state.op_stack, |first, second| {
                        match (var, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(fv == sv)
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok(fv == sv)
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::NeI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "NeI");
                    let _guard = span.enter();

                    tracing::trace!("Not-Equal Integer Comparison");

                    op::relation_op(&mut self.exec_state.op_stack, |first, second| {
                        match (var, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(fv != sv)
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok(fv != sv)
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::LtUI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LtUI");
                    let _guard = span.enter();

                    tracing::trace!("Less Than Unsigned Integer Comparison");

                    op::relation_op(&mut self.exec_state.op_stack, |first, second| {
                        match (var, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok((fv as u32) < (sv as u32))
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok((fv as u64) < (sv as u64))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::LtSI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LtSI");
                    let _guard = span.enter();

                    tracing::trace!("Less Than Signed Integer Comparison");

                    op::relation_op(&mut self.exec_state.op_stack, |first, second| {
                        match (var, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(fv < sv)
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok(fv < sv)
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::LeSI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LeSI");
                    let _guard = span.enter();

                    tracing::trace!("Less than or Equal Signed Integer Comparison");

                    op::relation_op(&mut self.exec_state.op_stack, |first, second| {
                        match (var, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok(fv <= sv)
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok(fv <= sv)
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::LeUI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "LeUI");
                    let _guard = span.enter();

                    tracing::trace!("Less than or Equal Unsigned Integer Comparison");

                    op::relation_op(&mut self.exec_state.op_stack, |first, second| {
                        match (var, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok((fv as u32) <= (sv as u32))
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok((fv as u64) <= (sv as u64))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::GtUI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "GtUI");
                    let _guard = span.enter();

                    tracing::trace!("Greater Than Unsigned Integer Comparison");

                    op::relation_op(&mut self.exec_state.op_stack, |first, second| {
                        match (var, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok((fv as u32) > (sv as u32))
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok((fv as u64) > (sv as u64))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::GeUI(var) => {
                    let span = tracing::span!(tracing::Level::TRACE, "GeUI");
                    let _guard = span.enter();

                    tracing::trace!("Greater Than or Equal Unsigned Integer Comparison");

                    op::relation_op(&mut self.exec_state.op_stack, |first, second| {
                        match (var, first, second) {
                            (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                                Ok((fv as u32) >= (sv as u32))
                            }
                            (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => {
                                Ok((fv as u64) >= (sv as u64))
                            }
                            _ => Err(RunErrorType::MismatchedTypes),
                        }
                    })
                    .map_err(|ety| RunError {
                        err: ety,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    })?;
                }
                Instruction::Call(cid) => {
                    let span = tracing::span!(tracing::Level::TRACE, "Call");
                    let _guard = span.enter();

                    call::call(self, cid.clone(), blocks, instr).await?;
                }
                Instruction::CallIndirect(ty, index) => {
                    let span = tracing::span!(tracing::Level::TRACE, "CallIndirect");
                    let _guard = span.enter();

                    tracing::trace!("Calling Indirect {:?} {:?}", ty, index);

                    let table = self.tables.get(u32::from(index) as usize).expect("");

                    let i = match self.exec_state.op_stack.pop() {
                        Some(StackValue::I32(i)) => i,
                        Some(other) => {
                            return Err(RunError {
                                err: RunErrorType::MismatchedTypes,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                        None => {
                            return Err(RunError {
                                err: RunErrorType::MismatchedTypes,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                    };

                    tracing::trace!("Index({:?}) in Table ({:?})", i, table);

                    let entry = match table.entries.get(i as usize).expect("") {
                        TableEntry::FuncID(fid) => fid,
                        TableEntry::Empty => todo!(),
                    };

                    tracing::trace!("Entry {:?}", entry);

                    call::call(self, entry.clone(), blocks, instr).await?;
                }
                Instruction::Block(ty, b_instr) => {
                    let span = tracing::span!(tracing::Level::TRACE, "Block");
                    let _guard = span.enter();

                    tracing::trace!("Block {:?}", ty);

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

                    let prev_stack = self.exec_state.op_stack.len();
                    self.exec_state.op_stack.extend(values.into_iter().rev());

                    blocks.enter(
                        b_instr.iter().skip(0),
                        input_arity,
                        output_arity,
                        prev_stack,
                    );
                }
                Instruction::Loop(ty, l_instr) => {
                    let span = tracing::span!(tracing::Level::TRACE, "Loop");
                    let _guard = span.enter();

                    tracing::trace!("Loop {:?}", ty);

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

                    let prev_stack = self.exec_state.op_stack.len();
                    self.exec_state.op_stack.extend(values.into_iter().rev());

                    blocks.enter(
                        l_instr.iter().skip(0).cycle(),
                        input_arity,
                        output_arity,
                        prev_stack,
                    );
                }
                Instruction::Branch(index) => {
                    let span = tracing::span!(tracing::Level::TRACE, "Branch");
                    let _guard = span.enter();

                    tracing::trace!("Branch {:?}", index);

                    let b_index: u32 = index.into();

                    branch::branch(self, blocks, b_index as usize);
                }
                Instruction::BranchTable(vlabels, index) => {
                    let span = tracing::span!(tracing::Level::TRACE, "BranchTable");
                    let _guard = span.enter();

                    tracing::trace!(
                        "Branching Table {:?} {:?}, current {:?}",
                        vlabels,
                        index,
                        blocks.blocks.len(),
                    );

                    let value = match self.exec_state.op_stack.pop() {
                        Some(StackValue::I32(v)) => v,
                        Some(other) => {
                            return Err(RunError {
                                err: RunErrorType::MismatchedTypes,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                        None => {
                            return Err(RunError {
                                err: RunErrorType::Other,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                    };

                    let target_index = vlabels.items.get(value as usize).unwrap_or(index);

                    /*
                    let target_index = if value < vlabels.items.len() as i32 {
                        match  {
                            Some(i) => i,
                            None => {
                                todo!("Getting Index {:?} in Table {:?}", value, table)
                            }
                        }
                    } else {
                        index
                    };
                    */
                    tracing::trace!("Branch Table to {:?}", target_index);

                    branch::branch(self, blocks, u32::from(target_index) as usize);
                }
                Instruction::BranchConditional(index) => {
                    let span = tracing::span!(tracing::Level::TRACE, "BranchConditional");
                    let _guard = span.enter();

                    tracing::trace!(
                        "Branching Conditional {:?}, current {:?}",
                        index,
                        blocks.blocks.len(),
                    );

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
                        tracing::trace!("Taking Conditional Branch");

                        branch::branch(self, blocks, u32::from(index) as usize);
                    } else {
                        tracing::trace!("Not taking Conditional Branch");
                    }
                }
                Instruction::Return => {
                    let span = tracing::span!(tracing::Level::TRACE, "Return");
                    let _guard = span.enter();

                    tracing::trace!(
                        "Return Op-Stack {:?} entered with {:?}",
                        self.exec_state.op_stack.len(),
                        self.exec_state.current_opstack_starting_height()
                    );

                    // 2.
                    let func = self.functions.get(&self.exec_state.func).expect("");

                    // 3.
                    let n = match func {
                        Function::Internal(_, ty) => ty.output.elements.items.len(),
                        Function::External(ty) => ty.output.elements.items.len(),
                    };

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
                    // Does not need to be done here

                    assert!(
                        self.exec_state.op_stack.len()
                            >= self.exec_state.current_opstack_starting_height()
                    );

                    for _ in 0..(self
                        .exec_state
                        .op_stack
                        .len()
                        .saturating_sub(self.exec_state.current_opstack_starting_height()))
                    {
                        self.exec_state.op_stack.pop();
                    }

                    // 7.
                    for val in values {
                        self.exec_state.op_stack.push(val);
                    }

                    *blocks = self.exec_state.return_from_func().unwrap();

                    return Ok(InnerLoop::Continue);
                }
                Instruction::MemorySize => {
                    let span = tracing::span!(tracing::Level::TRACE, "Memory Size");
                    let _guard = span.enter();

                    tracing::trace!("Memory Size");

                    let raw_size = self.env.memory.size();

                    let pages = raw_size / 65536;

                    tracing::trace!("Memory Size {:?}/{:?}", raw_size, pages);

                    self.exec_state.op_stack.push(StackValue::I32(pages as i32));
                }
                Instruction::MemoryGrow => {
                    let span = tracing::span!(tracing::Level::TRACE, "MemoryGrow");
                    let _guard = span.enter();

                    tracing::trace!("Memory Grow");

                    let n_pages = match self.exec_state.op_stack.pop() {
                        Some(StackValue::I32(v)) => v,
                        Some(other) => {
                            return Err(RunError {
                                err: RunErrorType::MismatchedTypes,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                        None => {
                            return Err(RunError {
                                err: RunErrorType::Other,
                                ctx: RunErrorContext {
                                    instruction: Some(instr.clone()),
                                },
                            })
                        }
                    };

                    tracing::trace!("Attempting to grow by {:?} pages", n_pages);

                    let grow_size = n_pages as usize * 65536;
                    let current_size = self.env.memory.size();
                    let target_size = current_size + grow_size;

                    self.env.memory.grow(target_size);

                    let previous_page_count = (current_size / 65536) as i32;

                    self.exec_state
                        .op_stack
                        .push(StackValue::I32(previous_page_count));
                }
                Instruction::Unreachable => {
                    tracing::trace!("Reached Unreachable");

                    return Err(RunError {
                        err: RunErrorType::ReachedUnreachable,
                        ctx: RunErrorContext {
                            instruction: Some(instr.clone()),
                        },
                    });
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

        Ok(InnerLoop::Nop)
    }
}

enum InnerLoop {
    Continue,
    Break,
    Nop,
}
