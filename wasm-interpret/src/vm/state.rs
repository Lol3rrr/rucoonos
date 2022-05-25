use alloc::vec::Vec;

pub struct State {
    pub func: u32,
    pub pc: usize,
    pub op_stack: Vec<StackValue>,
    current_frame: CurrentFrame,
    call_stack: Vec<StackFrame>,
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

impl State {
    pub fn new(func_id: u32, func_locals: Vec<StackValue>) -> Self {
        Self {
            pc: 0,
            func: func_id,
            op_stack: Vec::new(),
            current_frame: CurrentFrame {
                locals: func_locals,
            },
            call_stack: Vec::new(),
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
}
