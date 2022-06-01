use super::{handler::ExternalHandler, Blocks, Interpreter, StackValue};

use alloc::vec::Vec;

pub fn branch<'m, EH>(interpret: &mut Interpreter<'m, EH>, blocks: &mut Blocks<'m>, b_index: usize)
where
    EH: ExternalHandler,
{
    // 1.
    assert!(blocks.blocks.len() > b_index);

    // 2.
    let block =
        blocks.blocks.iter().rev().nth(b_index).expect(
            "There should be at least this many blocks because we previously asserted this",
        );

    // 3.
    let n = block.input_arity;

    // 4.
    assert!(interpret.exec_state.op_stack.len() >= n);

    // 5.
    let values = {
        let mut tmp = Vec::with_capacity(n);

        for _ in 0..n {
            let val = interpret.exec_state.op_stack.pop().expect("");
            tmp.push(val);
        }

        tmp
    };

    // 6.
    for i in 0..(b_index + 1) {
        while !matches!(
            interpret.exec_state.op_stack.last(),
            Some(StackValue::Block) | None
        ) {
            interpret.exec_state.op_stack.pop();
        }

        let popped = interpret.exec_state.op_stack.pop();
        if i < b_index {
            // assert_eq!(Some(StackValue::Block), popped);
        }

        blocks.blocks.pop();
    }

    // 7.
    for val in values {
        interpret.exec_state.op_stack.push(val);
    }
}
