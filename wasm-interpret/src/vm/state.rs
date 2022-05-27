use core::marker::PhantomData;

use alloc::{collections::BTreeMap, vec::Vec};

use crate::{Global, Instruction};

pub struct State<'m> {
    pub func: u32,
    pub pc: usize,
    pub op_stack: Vec<StackValue>,
    globals: BTreeMap<u32, StackValue>,
    current_frame: CurrentFrame,
    call_stack: Vec<StackFrame>,

    _marker: PhantomData<&'m ()>,
}

#[derive(Debug)]
struct CurrentFrame {
    locals: Vec<StackValue>,
}

#[derive(Debug)]
struct StackFrame {
    locals: Vec<StackValue>,
    pc: usize,
    func: u32,
}

#[derive(Debug, PartialEq, Clone)]
pub enum StackValue {
    I32(i32),
    I64(i64),
}

impl<'m> State<'m> {
    pub fn new<'g>(
        func_id: u32,
        func_locals: Vec<StackValue>,
        globals: impl Iterator<Item = (u32, &'g Global)>,
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
            op_stack: Vec::new(),
            globals,
            current_frame: CurrentFrame {
                locals: func_locals,
            },
            call_stack: Vec::new(),

            _marker: PhantomData {},
        }
    }

    pub fn go_into_func(&mut self, func_id: u32, func_locals: Vec<StackValue>) {
        let prev_locals = core::mem::replace(&mut self.current_frame.locals, func_locals);

        let stack_frame = StackFrame {
            func: self.func,
            pc: self.pc,
            locals: prev_locals,
        };

        self.pc = 0;
        self.func = func_id;

        self.call_stack.push(stack_frame);
    }

    pub fn return_from_func(&mut self) -> Result<(), ()> {
        let prev = self.call_stack.pop().ok_or(())?;

        self.func = prev.func;
        self.pc = prev.pc;
        self.current_frame.locals = prev.locals;

        Ok(())
    }

    pub fn has_predecessor(&self) -> bool {
        !self.call_stack.is_empty()
    }

    pub fn get_local(&self, id: u32) -> Option<&StackValue> {
        self.current_frame.locals.get(id as usize)
    }
    pub fn get_local_mut(&mut self, id: u32) -> Option<&mut StackValue> {
        self.current_frame.locals.get_mut(id as usize)
    }

    pub fn get_global(&self, id: u32) -> Option<&StackValue> {
        self.globals.get(&id)
    }
    pub fn get_global_mut(&mut self, id: u32) -> Option<&mut StackValue> {
        self.globals.get_mut(&id)
    }
}
