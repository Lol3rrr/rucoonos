use core::marker::PhantomData;

use alloc::{collections::BTreeMap, vec::Vec};

use crate::{FuncIndex, Global, GlobalIndex, Instruction, LocalIndex};

#[derive(Debug)]
pub struct Block<'m> {
    output_arity: usize,
    iterator: core::iter::Skip<core::slice::Iter<'m, Instruction>>,
}

#[derive(Debug)]
pub struct Blocks<'m> {
    pub blocks: Vec<Block<'m>>,
}

impl<'m> Blocks<'m> {
    pub fn new() -> Self {
        Self { blocks: Vec::new() }
    }

    pub fn enter(
        &mut self,
        iterator: core::iter::Skip<core::slice::Iter<'m, Instruction>>,
        output_arity: usize,
    ) {
        tracing::trace!("Entered Block");

        self.blocks.push(Block {
            output_arity,
            iterator,
        });
    }

    pub fn advance(&mut self, op_stack: &mut OpStack) -> Option<&'m Instruction> {
        loop {
            let last = self.blocks.last_mut()?;

            match last.iterator.next() {
                Some(item) => return Some(item),
                None => {
                    tracing::trace!("End of Block, remaining Blocks {:?}", self.blocks.len() - 1);

                    let latest = self.blocks.pop().expect("");

                    #[allow(clippy::needless_collect)]
                    let values: Vec<_> = (0..latest.output_arity)
                        .map(|_| op_stack.pop().expect(""))
                        .collect();

                    match op_stack.pop() {
                        Some(l) if l == StackValue::Block => {
                            // End of Block reached
                        }
                        Some(l) => {
                            assert_eq!(0, self.blocks.len());
                            op_stack.push(l);
                        }
                        None => {
                            assert!(self.blocks.len() <= 1);
                        }
                    };

                    op_stack.extend(values.into_iter().rev());

                    continue;
                }
            }
        }
    }
}

#[derive(Debug)]
pub struct State<'m> {
    pub func: FuncIndex,
    pub pc: usize,
    pub op_stack: OpStack,
    globals: BTreeMap<GlobalIndex, StackValue>,
    current_frame: CurrentFrame,
    call_stack: Vec<StackFrame<'m>>,

    _marker: PhantomData<&'m ()>,
}

#[derive(Debug)]
pub struct OpStack {
    stack: Vec<StackValue>,
}

#[derive(Debug)]
struct CurrentFrame {
    locals: BTreeMap<LocalIndex, StackValue>,
}

#[derive(Debug)]
struct StackFrame<'m> {
    locals: BTreeMap<LocalIndex, StackValue>,
    pc: usize,
    func: FuncIndex,
    blocks: Blocks<'m>,
}

#[derive(Debug, PartialEq, Clone)]
pub enum StackValue {
    I32(i32),
    I64(i64),
    Block,
}

impl<'m> State<'m> {
    pub fn new<'g>(
        func_id: FuncIndex,
        func_locals: BTreeMap<LocalIndex, StackValue>,
        globals: impl Iterator<Item = (GlobalIndex, &'g Global)>,
    ) -> Self {
        let globals = {
            let mut tmp = BTreeMap::new();

            for (index, global) in globals {
                let instr = &global.exp.instructions;
                assert_eq!(1, instr.len());

                let init_instr = instr.get(0).expect(
                    "There should be exactly one Instruction as this was previously asserted",
                );
                let value = match init_instr {
                    Instruction::ConstantI32(con) => StackValue::I32(*con),
                    Instruction::ConstantI64(con) => StackValue::I64(*con),
                    other => todo!("Unknown Init Instruction {:?}", other),
                };

                tmp.insert(index, value);
            }

            tmp
        };

        Self {
            pc: 0,
            func: func_id,
            op_stack: OpStack::new(),
            globals,
            current_frame: CurrentFrame {
                locals: func_locals,
            },
            call_stack: Vec::new(),

            _marker: PhantomData {},
        }
    }

    pub fn go_into_func(
        &mut self,
        func_id: FuncIndex,
        func_locals: BTreeMap<LocalIndex, StackValue>,
        blocks: Blocks<'m>,
    ) {
        let prev_locals = core::mem::replace(&mut self.current_frame.locals, func_locals);

        let stack_frame = StackFrame {
            func: self.func.clone(),
            pc: self.pc,
            locals: prev_locals,
            blocks,
        };

        self.pc = 0;
        self.func = func_id;

        self.call_stack.push(stack_frame);
    }

    pub fn return_from_func(&mut self) -> Result<Blocks<'m>, ()> {
        let prev = self.call_stack.pop().ok_or(())?;

        self.func = prev.func;
        self.pc = prev.pc;
        self.current_frame.locals = prev.locals;

        Ok(prev.blocks)
    }

    pub fn has_predecessor(&self) -> bool {
        !self.call_stack.is_empty()
    }

    pub fn get_local(&self, id: &LocalIndex) -> Option<&StackValue> {
        self.current_frame.locals.get(id)
    }
    pub fn get_local_mut(&mut self, id: &LocalIndex) -> Option<&mut StackValue> {
        self.current_frame.locals.get_mut(id)
    }

    pub fn get_global(&self, id: &GlobalIndex) -> Option<&StackValue> {
        self.globals.get(id)
    }
    pub fn get_global_mut(&mut self, id: &GlobalIndex) -> Option<&mut StackValue> {
        self.globals.get_mut(id)
    }
}

impl OpStack {
    pub fn new() -> Self {
        Self { stack: Vec::new() }
    }

    pub fn pop(&mut self) -> Option<StackValue> {
        self.stack.pop()
    }
    pub fn last(&self) -> Option<&StackValue> {
        self.stack.last()
    }

    pub fn push(&mut self, value: StackValue) {
        self.stack.push(value);
    }

    pub fn extend(&mut self, items: impl Iterator<Item = StackValue>) {
        for item in items {
            self.stack.push(item);
        }
    }
}
