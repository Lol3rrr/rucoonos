use core::marker::PhantomData;

use alloc::{collections::BTreeMap, vec::Vec};

use wasm::{FuncIndex, Global, GlobalIndex, Instruction, LocalIndex};

#[derive(Debug)]
pub struct Block<'m> {
    pub input_arity: usize,
    pub output_arity: usize,
    iterator: BlockIterator<'m>,
    pub stack_height: usize,
}

#[derive(Debug)]
pub enum BlockIterator<'m> {
    Sliced(core::iter::Skip<core::slice::Iter<'m, Instruction>>),
    Cycled(core::iter::Cycle<core::iter::Skip<core::slice::Iter<'m, Instruction>>>),
}

impl<'m> Iterator for BlockIterator<'m> {
    type Item = &'m Instruction;

    fn next(&mut self) -> Option<Self::Item> {
        match self {
            Self::Sliced(iter) => iter.next(),
            Self::Cycled(iter) => iter.next(),
        }
    }
}
impl<'m> From<core::iter::Skip<core::slice::Iter<'m, Instruction>>> for BlockIterator<'m> {
    fn from(iter: core::iter::Skip<core::slice::Iter<'m, Instruction>>) -> Self {
        Self::Sliced(iter)
    }
}
impl<'m> From<core::iter::Cycle<core::iter::Skip<core::slice::Iter<'m, Instruction>>>>
    for BlockIterator<'m>
{
    fn from(iter: core::iter::Cycle<core::iter::Skip<core::slice::Iter<'m, Instruction>>>) -> Self {
        Self::Cycled(iter)
    }
}

#[derive(Debug)]
pub struct Blocks<'m> {
    pub blocks: Vec<Block<'m>>,
}

impl<'m> Blocks<'m> {
    pub fn new() -> Self {
        Self { blocks: Vec::new() }
    }

    pub fn enter<I>(
        &mut self,
        iterator: I,
        input_arity: usize,
        output_arity: usize,
        current_stack_height: usize,
    ) where
        I: Into<BlockIterator<'m>>,
    {
        tracing::trace!("Entered Block with {} -> {}", input_arity, output_arity);

        self.blocks.push(Block {
            input_arity,
            output_arity,
            iterator: iterator.into(),
            stack_height: current_stack_height,
        });
    }

    pub fn advance(&mut self, op_stack: &mut OpStack) -> Option<&'m Instruction> {
        loop {
            let last = self.blocks.last_mut()?;

            match last.iterator.next() {
                Some(item) => return Some(item),
                None => {
                    tracing::trace!("Left Block");

                    let latest = self.blocks.pop().expect("");

                    #[allow(clippy::needless_collect)]
                    let values: Vec<_> = (0..latest.output_arity)
                        .map(|_| op_stack.pop().expect(""))
                        .collect();

                    tracing::trace!(
                        "Op-Stack {:?} Entered with {:?}",
                        op_stack.len(),
                        latest.stack_height
                    );
                    assert!(op_stack.len() == latest.stack_height);

                    for _ in 0..(op_stack.len() - latest.stack_height) {
                        op_stack.pop();
                    }

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
    pc: usize,
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
    op_stack_starting_height: usize,
}

#[derive(Debug)]
struct StackFrame<'m> {
    locals: BTreeMap<LocalIndex, StackValue>,
    pc: usize,
    func: FuncIndex,
    blocks: Blocks<'m>,
    op_stack_starting_height: usize,
}

#[derive(Debug, PartialEq, Clone)]
pub enum StackValue {
    I32(i32),
    I64(i64),
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
                op_stack_starting_height: 0,
            },
            call_stack: Vec::new(),

            _marker: PhantomData {},
        }
    }

    pub fn current_opstack_starting_height(&self) -> usize {
        self.current_frame.op_stack_starting_height
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
            op_stack_starting_height: self.current_frame.op_stack_starting_height,
        };

        self.pc = 0;
        self.func = func_id;
        self.current_frame.op_stack_starting_height = self.op_stack.len();

        self.call_stack.push(stack_frame);
    }

    pub fn return_from_func(&mut self) -> Result<Blocks<'m>, ()> {
        let prev = self.call_stack.pop().ok_or(())?;

        self.func = prev.func;
        self.pc = prev.pc;
        self.current_frame.locals = prev.locals;
        self.current_frame.op_stack_starting_height = prev.op_stack_starting_height;

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

    pub fn take_stack(&mut self) -> OpStack {
        core::mem::replace(&mut self.op_stack, OpStack::new())
    }
}

impl OpStack {
    pub fn new() -> Self {
        Self { stack: Vec::new() }
    }

    pub fn len(&self) -> usize {
        self.stack.len()
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

    pub(super) fn get(&self, index: usize) -> Option<&StackValue> {
        self.stack.get(index)
    }
}
impl From<OpStack> for Vec<StackValue> {
    fn from(ops: OpStack) -> Self {
        ops.stack
    }
}
