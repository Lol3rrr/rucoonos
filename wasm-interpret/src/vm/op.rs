use super::{state::OpStack, RunErrorType, StackValue};

pub fn binary_op<F>(stack: &mut OpStack, func: F) -> Result<(), RunErrorType>
where
    F: FnOnce(StackValue, StackValue) -> Result<StackValue, RunErrorType>,
{
    let second = match stack.pop() {
        Some(s) => s,
        None => return Err(RunErrorType::MissingOperand),
    };
    let first = match stack.pop() {
        Some(f) => f,
        None => return Err(RunErrorType::MissingOperand),
    };

    let res = func(first, second)?;

    stack.push(res);

    Ok(())
}

pub fn relation_op<F>(stack: &mut OpStack, func: F) -> Result<(), RunErrorType>
where
    F: FnOnce(StackValue, StackValue) -> Result<bool, RunErrorType>,
{
    let second = match stack.pop() {
        Some(s) => s,
        None => return Err(RunErrorType::MissingOperand),
    };
    let first = match stack.pop() {
        Some(f) => f,
        None => return Err(RunErrorType::MissingOperand),
    };

    let res = if func(first, second)? {
        StackValue::I32(1)
    } else {
        StackValue::I32(0)
    };

    stack.push(res);

    Ok(())
}
