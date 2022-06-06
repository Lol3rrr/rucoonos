use alloc::vec::Vec;
use core::ops::{Shl, Shr};

use wasm::{Instruction, MemArg};

use super::{
    branch, call, handler::ExternalHandler, memory::Memory, op, state::Blocks, BlockIterator,
    BlockType, Function, InnerLoop, IntegerVariant, Interpreter, RunError, RunErrorContext,
    RunErrorType, StackValue, TableEntry,
};

pub(super) struct ExecCtx<'c, 'm, EH, M> {
    pub blocks: &'c mut Blocks<'m>,
    pub int: &'c mut Interpreter<'m, EH, M>,
}

/// This function is actually responsible for properly executing a single Instruction
#[tracing::instrument(name = "exec-instr", skip(instr, ctx))]
pub(super) async fn exec<'m, EH, M>(
    instr: &'m Instruction,
    ctx: ExecCtx<'_, 'm, EH, M>,
) -> Result<Option<InnerLoop>, RunError>
where
    EH: ExternalHandler,
    M: Memory,
{
    match instr {
        Instruction::ConstantI32(con) => {
            let span = tracing::span!(tracing::Level::TRACE, "ConstantI32");
            let _guard = span.enter();

            tracing::trace!("Pushing Constant I32({:?})", con);

            ctx.int.exec_state.op_stack.push(StackValue::I32(*con));
        }
        Instruction::ConstantI64(con) => {
            let span = tracing::span!(tracing::Level::TRACE, "ConstantI64");
            let _guard = span.enter();

            tracing::trace!("Pushing Constant I64({:?})", con);

            ctx.int.exec_state.op_stack.push(StackValue::I64(*con));
        }
        Instruction::Drop => {
            let span = tracing::span!(tracing::Level::TRACE, "Drop");
            let _guard = span.enter();

            tracing::trace!("Drop Instruction");

            match ctx.int.exec_state.op_stack.pop() {
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

            let c = match ctx.int.exec_state.op_stack.pop() {
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

            let v_2 = match ctx.int.exec_state.op_stack.pop() {
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
            let v_1 = match ctx.int.exec_state.op_stack.pop() {
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

            ctx.int.exec_state.op_stack.push(res);
        }
        Instruction::LoadI32(MemArg { offset, .. }) => {
            let span = tracing::span!(tracing::Level::TRACE, "LoadI32");
            let _guard = span.enter();

            tracing::trace!("Loading I32 from {:?}", offset);

            let dyn_address = match ctx.int.exec_state.op_stack.pop() {
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

            if ctx.int.env.memory.size() < address_end as usize {
                ctx.int.env.memory.grow(address_end as usize);
                tracing::trace!("Resize");
            }

            let raw_value = &ctx.int.env.memory[address as usize..address_end as usize];
            let raw_value: [u8; 4] = raw_value.try_into().unwrap();

            let value = i32::from_le_bytes(raw_value);

            tracing::trace!("Loaded I32({:?}) from {:?}", value, address);

            ctx.int.exec_state.op_stack.push(StackValue::I32(value));
        }
        Instruction::LoadI32_8U(MemArg { offset, .. }) => {
            let span = tracing::span!(tracing::Level::TRACE, "LoadI32_8U");
            let _guard = span.enter();

            tracing::trace!("Loading I32 from {:?}", offset);

            let dyn_address = match ctx.int.exec_state.op_stack.pop() {
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

            if ctx.int.env.memory.size() < address_end as usize {
                ctx.int.env.memory.grow(address_end as usize);
                tracing::trace!("Resize");
            }

            let raw_value = ctx.int.env.memory[address as usize];
            let value = raw_value as i32;

            tracing::trace!("Loaded I32({:?}) from {:?}", value, address);

            ctx.int.exec_state.op_stack.push(StackValue::I32(value));
        }
        Instruction::LoadI32_8S(MemArg { offset, .. }) => {
            let span = tracing::span!(tracing::Level::TRACE, "LoadI32_8U");
            let _guard = span.enter();

            tracing::trace!("Loading I32 from {:?}", offset);

            let dyn_address = match ctx.int.exec_state.op_stack.pop() {
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

            if ctx.int.env.memory.size() < address_end as usize {
                ctx.int.env.memory.grow(address_end as usize);
                tracing::trace!("Resize");
            }

            let raw_value: i8 = ctx.int.env.memory[address as usize].try_into().unwrap();
            let value = raw_value as i32;

            tracing::trace!("Loaded I32({:?}) from {:?}", value, address);

            ctx.int.exec_state.op_stack.push(StackValue::I32(value));
        }
        Instruction::LoadI32_16U(MemArg { offset, .. }) => {
            let span = tracing::span!(tracing::Level::TRACE, "LoadI32_16U");
            let _guard = span.enter();

            tracing::trace!("Loading I32 from {:?}", offset);

            let dyn_address = match ctx.int.exec_state.op_stack.pop() {
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

            if ctx.int.env.memory.size() < address_end as usize {
                ctx.int.env.memory.grow(address_end as usize);
                tracing::trace!("Resize");
            }

            let raw_value = &ctx.int.env.memory[address as usize..address_end as usize];
            let value = i32::from_le_bytes([raw_value[0], raw_value[1], 0, 0]);

            tracing::trace!("Loaded I32({:?}) from {:?}", value, address);

            ctx.int.exec_state.op_stack.push(StackValue::I32(value));
        }
        Instruction::LoadI64(MemArg { offset, .. }) => {
            let span = tracing::span!(tracing::Level::TRACE, "LoadI64");
            let _guard = span.enter();

            tracing::trace!("Loading I64 from {:?}", offset);

            let dyn_address = match ctx.int.exec_state.op_stack.pop() {
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

            if ctx.int.env.memory.size() < address_end as usize {
                ctx.int.env.memory.grow(address_end as usize);
                tracing::trace!("Resize");
            }

            let raw_value = &ctx.int.env.memory[address as usize..address_end as usize];
            let raw_value: [u8; 8] = raw_value.try_into().unwrap();

            let value = i64::from_le_bytes(raw_value);

            tracing::trace!("Loaded I64({:?}) from {:?}", value, address);

            ctx.int.exec_state.op_stack.push(StackValue::I64(value));
        }
        Instruction::LoadI64_32U(MemArg { offset, .. }) => {
            let span = tracing::span!(tracing::Level::TRACE, "LoadI64_32U");
            let _guard = span.enter();

            tracing::trace!("Loading I64_32U from {:?}", offset);

            let dyn_address = match ctx.int.exec_state.op_stack.pop() {
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

            if ctx.int.env.memory.size() < address_end as usize {
                ctx.int.env.memory.grow(address_end as usize);
                tracing::trace!("Resize");
            }

            let raw_value = &ctx.int.env.memory[address as usize..address_end as usize];
            let raw_value: [u8; 4] = raw_value.try_into().unwrap();

            let value = u32::from_le_bytes(raw_value);

            tracing::trace!("Loaded U32({:?}) from {:?}", value, address);

            ctx.int
                .exec_state
                .op_stack
                .push(StackValue::I64(value as i64));
        }
        Instruction::StoreI32(MemArg { offset, align }, ws) => {
            let span = tracing::span!(tracing::Level::TRACE, "StoreI32");
            let _guard = span.enter();

            let value = match ctx.int.exec_state.op_stack.pop() {
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

            let dyn_address = match ctx.int.exec_state.op_stack.pop() {
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

            if ctx.int.env.memory.size() < address_end as usize {
                ctx.int.env.memory.grow(address_end as usize);
            }

            match *ws {
                1 => {
                    ctx.int.env.memory[address as usize] = value as u8;
                }
                2 => {
                    let target = &mut ctx.int.env.memory[address as usize..address_end as usize];

                    let value = i32::to_le_bytes(value);

                    target.copy_from_slice(&value[..2]);
                }
                4 => {
                    let target = &mut ctx.int.env.memory[address as usize..address_end as usize];

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

            let value = match ctx.int.exec_state.op_stack.pop() {
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

            let dyn_address = match ctx.int.exec_state.op_stack.pop() {
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

            if ctx.int.env.memory.size() < address_end as usize {
                ctx.int.env.memory.grow(address_end as usize);
            }

            let target = &mut ctx.int.env.memory[address as usize..address_end as usize];

            match *ws {
                8 => {
                    let value = i64::to_le_bytes(value);

                    target.copy_from_slice(&value);
                }
                4 => {
                    let value = i32::to_le_bytes((value % (2 ^ 32)) as i32);

                    target.copy_from_slice(&value);
                }
                other => todo!(),
            }
        }
        Instruction::SubI(variant) => {
            let span = tracing::span!(tracing::Level::TRACE, "SubI");
            let _guard = span.enter();

            tracing::trace!("Subtract");

            op::binary_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            op::binary_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            op::binary_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            op::binary_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            op::binary_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            op::binary_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            op::binary_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            op::binary_op(&mut ctx.int.exec_state.op_stack, |first, second| {
                match (var, first, second) {
                    (IntegerVariant::I32, StackValue::I32(first), StackValue::I32(second)) => {
                        let first = first as u32;
                        let second = second as u32;

                        Ok(StackValue::I32((first.shr(second)) as i32))
                    }
                    (IntegerVariant::I64, StackValue::I64(first), StackValue::I64(second)) => {
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

            op::binary_op(&mut ctx.int.exec_state.op_stack, |first, second| {
                match (var, first, second) {
                    (IntegerVariant::I32, StackValue::I32(first), StackValue::I32(second)) => {
                        Ok(StackValue::I32(first.shr(second)))
                    }
                    (IntegerVariant::I64, StackValue::I64(first), StackValue::I64(second)) => {
                        Ok(StackValue::I64(first.shr(second)))
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
        Instruction::ShlI(var) => {
            let span = tracing::span!(tracing::Level::TRACE, "ShlI");
            let _guard = span.enter();

            tracing::trace!("Shift Left");

            let second = match ctx.int.exec_state.op_stack.pop() {
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
            let first = match ctx.int.exec_state.op_stack.pop() {
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

            ctx.int.exec_state.op_stack.push(res);
        }
        Instruction::RotlI(var) => {
            let span = tracing::span!(tracing::Level::TRACE, "RotlI");
            let _guard = span.enter();

            tracing::trace!("RotlI");

            op::binary_op(&mut ctx.int.exec_state.op_stack, |first, second| {
                match (var, first, second) {
                    (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => {
                        Ok(StackValue::I32(fv.rotate_left(sv as u32)))
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
        Instruction::WrapI32I64 => {
            let span = tracing::span!(tracing::Level::TRACE, "WrapI32I64");
            let _guard = span.enter();

            tracing::trace!("Wrapping I64 down to I32");

            let prev = match ctx.int.exec_state.op_stack.pop() {
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

            ctx.int.exec_state.op_stack.push(StackValue::I32(n_value));
        }
        Instruction::ExtendI64I32U => {
            let span = tracing::span!(tracing::Level::TRACE, "ExtendI64I32");
            let _guard = span.enter();

            tracing::trace!("Extending I32 to I64 unsigned");

            let prev = match ctx.int.exec_state.op_stack.pop() {
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

            ctx.int.exec_state.op_stack.push(StackValue::I64(n_value));
        }
        Instruction::LocalGet(id) => {
            let span = tracing::span!(tracing::Level::TRACE, "LocalGet");
            let _guard = span.enter();

            let local_var = match ctx.int.exec_state.get_local(id).cloned() {
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

            ctx.int.exec_state.op_stack.push(local_var);
        }
        Instruction::LocalTee(id) => {
            let span = tracing::span!(tracing::Level::TRACE, "LocalTee");
            let _guard = span.enter();

            let value = match ctx.int.exec_state.op_stack.last().cloned() {
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

            let local_var = match ctx.int.exec_state.get_local_mut(id) {
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

            let value = match ctx.int.exec_state.op_stack.pop() {
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

            let local_var = match ctx.int.exec_state.get_local_mut(id) {
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

            let value = match ctx.int.exec_state.get_global(gid) {
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

            ctx.int.exec_state.op_stack.push(value.clone());
        }
        Instruction::GlobalSet(gid) => {
            let span = tracing::span!(tracing::Level::TRACE, "GlobalSet");
            let _guard = span.enter();

            let value = match ctx.int.exec_state.op_stack.pop() {
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

            let target_var = match ctx.int.exec_state.get_global_mut(gid) {
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

            let value = match ctx.int.exec_state.op_stack.pop() {
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

            ctx.int.exec_state.op_stack.push(res);
        }
        Instruction::EqI(var) => {
            let span = tracing::span!(tracing::Level::TRACE, "EqI");
            let _guard = span.enter();

            tracing::trace!("Equal Integer Comparison");

            op::relation_op(&mut ctx.int.exec_state.op_stack, |first, second| {
                match (var, first, second) {
                    (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => Ok(fv == sv),
                    (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => Ok(fv == sv),
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

            op::relation_op(&mut ctx.int.exec_state.op_stack, |first, second| {
                match (var, first, second) {
                    (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => Ok(fv != sv),
                    (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => Ok(fv != sv),
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

            op::relation_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            op::relation_op(&mut ctx.int.exec_state.op_stack, |first, second| {
                match (var, first, second) {
                    (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => Ok(fv < sv),
                    (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => Ok(fv < sv),
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

            op::relation_op(&mut ctx.int.exec_state.op_stack, |first, second| {
                match (var, first, second) {
                    (IntegerVariant::I32, StackValue::I32(fv), StackValue::I32(sv)) => Ok(fv <= sv),
                    (IntegerVariant::I64, StackValue::I64(fv), StackValue::I64(sv)) => Ok(fv <= sv),
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

            op::relation_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            op::relation_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            op::relation_op(&mut ctx.int.exec_state.op_stack, |first, second| {
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

            call::call(ctx.int, cid.clone(), ctx.blocks, instr).await?;
        }
        Instruction::CallIndirect(ty, index) => {
            let span = tracing::span!(tracing::Level::TRACE, "CallIndirect");
            let _guard = span.enter();

            tracing::trace!("Calling Indirect {:?} {:?}", ty, index);

            let table = ctx.int.tables.get(u32::from(index) as usize).expect("");

            let i = match ctx.int.exec_state.op_stack.pop() {
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

            call::call(ctx.int, entry.clone(), ctx.blocks, instr).await?;
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
                    let value = ctx.int.exec_state.op_stack.pop().expect("");
                    tmp.push(value);
                }

                tmp
            };

            let prev_stack = ctx.int.exec_state.op_stack.len();
            ctx.int.exec_state.op_stack.extend(values.into_iter().rev());

            ctx.blocks.enter(
                BlockIterator::block(b_instr.iter()),
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
                    let value = ctx.int.exec_state.op_stack.pop().expect("");
                    tmp.push(value);
                }

                tmp
            };

            let prev_stack = ctx.int.exec_state.op_stack.len();
            ctx.int.exec_state.op_stack.extend(values.into_iter().rev());

            ctx.blocks.enter(
                BlockIterator::looped(&l_instr),
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

            branch::branch(ctx.int, ctx.blocks, b_index as usize);
        }
        Instruction::BranchTable(vlabels, index) => {
            let span = tracing::span!(tracing::Level::TRACE, "BranchTable");
            let _guard = span.enter();

            tracing::trace!(
                "Branching Table {:?} {:?}, current {:?}",
                vlabels,
                index,
                ctx.blocks.blocks.len(),
            );

            let value = match ctx.int.exec_state.op_stack.pop() {
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

            branch::branch(ctx.int, ctx.blocks, u32::from(target_index) as usize);
        }
        Instruction::BranchConditional(index) => {
            let span = tracing::span!(tracing::Level::TRACE, "BranchConditional");
            let _guard = span.enter();

            tracing::trace!(
                "Branching Conditional {:?}, current {:?}",
                index,
                ctx.blocks.blocks.len(),
            );

            let value = match ctx.int.exec_state.op_stack.pop() {
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

                branch::branch(ctx.int, ctx.blocks, u32::from(index) as usize);
            } else {
                tracing::trace!("Not taking Conditional Branch");
            }
        }
        Instruction::Return => {
            let span = tracing::span!(tracing::Level::TRACE, "Return");
            let _guard = span.enter();

            tracing::trace!("Return from {:?}", ctx.int.exec_state.func);
            tracing::trace!(
                "Return Op-Stack {:?} entered with {:?}",
                ctx.int.exec_state.op_stack.len(),
                ctx.int.exec_state.current_opstack_starting_height()
            );

            // 2.
            let func = ctx.int.functions.get(&ctx.int.exec_state.func).expect("");

            // 3.
            let n = match func {
                Function::Internal(_, ty) => ty.output.elements.items.len(),
                Function::External(ty) => ty.output.elements.items.len(),
            };

            // 4.
            assert!(ctx.int.exec_state.op_stack.len() >= n);

            // 5.
            let values = {
                let mut tmp = Vec::with_capacity(n);

                for _ in 0..n {
                    let val = ctx.int.exec_state.op_stack.pop().expect("");
                    tmp.push(val);
                }

                tmp
            };

            // 6.
            // Does not need to be done here

            assert!(
                ctx.int.exec_state.op_stack.len()
                    >= ctx.int.exec_state.current_opstack_starting_height()
            );

            for _ in 0..(ctx
                .int
                .exec_state
                .op_stack
                .len()
                .saturating_sub(ctx.int.exec_state.current_opstack_starting_height()))
            {
                ctx.int.exec_state.op_stack.pop();
            }

            tracing::trace!("Returning Values {:?}", values);

            // 7.
            for val in values {
                ctx.int.exec_state.op_stack.push(val);
            }

            match ctx.int.exec_state.return_from_func() {
                Ok(b) => {
                    *ctx.blocks = b;
                    return Ok(Some(InnerLoop::Continue));
                }
                Err(_) => {
                    return Ok(Some(InnerLoop::Break));
                }
            };
        }
        Instruction::MemorySize => {
            let span = tracing::span!(tracing::Level::TRACE, "Memory Size");
            let _guard = span.enter();

            tracing::trace!("Memory Size");

            let raw_size = ctx.int.env.memory.size();

            let pages = raw_size / 65536;

            tracing::trace!("Memory Size {:?}/{:?}", raw_size, pages);

            ctx.int
                .exec_state
                .op_stack
                .push(StackValue::I32(pages as i32));
        }
        Instruction::MemoryGrow => {
            let span = tracing::span!(tracing::Level::TRACE, "MemoryGrow");
            let _guard = span.enter();

            tracing::trace!("Memory Grow");

            let n_pages = match ctx.int.exec_state.op_stack.pop() {
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
            let current_size = ctx.int.env.memory.size();
            let target_size = current_size + grow_size;

            ctx.int.env.memory.grow(target_size);

            let previous_page_count = (current_size / 65536) as i32;

            ctx.int
                .exec_state
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

    Ok(None)
}
