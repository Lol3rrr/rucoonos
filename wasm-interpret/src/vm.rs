use core::{future::Future, pin::Pin};

use alloc::{boxed::Box, collections::BTreeMap, string::String, vec::Vec};

use wasm::{
    BlockType, Data, Element, ExportDescription, Func, FuncIndex, FunctionType, GlobalIndex,
    ImportDescription, Instruction, IntegerVariant, LocalIndex, MemArg, Module, NumberType,
    RefType, Section, TypeIndex, ValueType,
};

use crate::vm::state::BlockIterator;

use self::{handler::ExternalHandler, state::Blocks};

pub mod handler;
pub mod memory;

mod state;
pub use state::StackValue;
use state::State;

mod branch;
mod call;
mod exec;
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
        wait: F,
    ) -> Result<Vec<StackValue>, RunError>
    where
        F: FnMut() -> Option<Pin<Box<dyn Future<Output = ()>>>>,
    {
        self.run_with_wait_args(name, wait, Vec::new()).await
    }

    pub async fn run_with_wait_args<F>(
        &mut self,
        name: &str,
        mut wait: F,
        args: Vec<StackValue>,
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

            self.exec_state.op_stack.extend(args.into_iter());
            self.exec_state = Box::new(State::new(func_id, self.locals(func), globals_iter));

            func
        };

        let mut blocks = {
            let mut tmp = Blocks::new();
            tmp.enter(
                BlockIterator::block(func.0.exp.instructions.iter()),
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

            if let Some(ret_v) = exec::exec(instr, exec::ExecCtx { blocks, int: self }).await? {
                return Ok(ret_v);
            }
        }

        Ok(InnerLoop::Nop)
    }
}

enum InnerLoop {
    Continue,
    Break,
    Nop,
}
