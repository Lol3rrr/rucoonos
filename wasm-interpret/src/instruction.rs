use crate::{
    leb128::{parse_ileb128, parse_uleb128},
    FuncId, FuncIdError, LocalId, LocalIdError, Parseable,
};

#[derive(Debug, Clone)]
pub enum IntegerVariant {
    I32,
    I64,
}

#[derive(Debug, Clone)]
pub enum FloatVariant {
    F32,
    F64,
}

#[derive(Debug, Clone)]
pub struct MemArg {
    pub align: u32,
    pub offset: u32,
}

#[derive(Debug)]
pub enum MemArgError {
    InvalidAlign,
    InvalidOffset,
}

impl Parseable for MemArg {
    type Error = MemArgError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let align: u32 = parse_uleb128(iter.by_ref()).ok_or(MemArgError::InvalidAlign)?;
        let offset: u32 = parse_uleb128(iter.by_ref()).ok_or(MemArgError::InvalidOffset)?;

        Ok(Self { align, offset })
    }
}

#[derive(Debug, Clone)]
pub enum Instruction {
    Call(FuncId),
    //
    LocalGet(LocalId),
    LocalSet(LocalId),
    LocalTee(LocalId),
    //
    LoadI32(MemArg),
    LoadI64(MemArg),
    LoadF32(MemArg),
    LoadF64(MemArg),
    //
    StoreI32(MemArg),
    StoreI64(MemArg),
    StoreF32(MemArg),
    StoreF64(MemArg),

    //
    ConstantI32(i32),
    ConstantI64(i64),
    // Comparisons for integers
    EqzI(IntegerVariant),
    EqI(IntegerVariant),
    NeI(IntegerVariant),
    LtSI(IntegerVariant),
    LtUI(IntegerVariant),
    GtSI(IntegerVariant),
    GtUI(IntegerVariant),
    LeSI(IntegerVariant),
    LeUI(IntegerVariant),
    GeSI(IntegerVariant),
    GeUI(IntegerVariant),
    // Comparisons for float
    EqF(FloatVariant),
    NeF(FloatVariant),
    LtF(FloatVariant),
    GtF(FloatVariant),
    LeF(FloatVariant),
    GeF(FloatVariant),
    // Operands for Integers
    ClzI(IntegerVariant),
    CtzI(IntegerVariant),
    PopcntI(IntegerVariant),
    AddI(IntegerVariant),
    SubI(IntegerVariant),
    MulI(IntegerVariant),
    DivSI(IntegerVariant),
    DivUI(IntegerVariant),
    RemSI(IntegerVariant),
    RemUI(IntegerVariant),
    AndI(IntegerVariant),
    OrI(IntegerVariant),
    XorI(IntegerVariant),
    ShlI(IntegerVariant),
    ShrSI(IntegerVariant),
    ShrUI(IntegerVariant),
    RotlI(IntegerVariant),
    RotrI(IntegerVariant),
}

#[derive(Debug)]
pub enum InstructionError {
    MissingInstruction,
    UnknownInstruction(u8),
    InvalidOperand,
    InvalidMemArg(MemArgError),
    InvalidFuncId(FuncIdError),
    InvalidLocalId(LocalIdError),
}

impl Parseable for Instruction {
    type Error = InstructionError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let instr_ty = iter.next().ok_or(InstructionError::MissingInstruction)?;

        match instr_ty {
            0x10 => {
                let id = FuncId::parse(iter.by_ref()).map_err(InstructionError::InvalidFuncId)?;
                Ok(Self::Call(id))
            }
            0x20 => {
                let id = LocalId::parse(iter.by_ref()).map_err(InstructionError::InvalidLocalId)?;
                Ok(Self::LocalGet(id))
            }
            0x21 => {
                let id = LocalId::parse(iter.by_ref()).map_err(InstructionError::InvalidLocalId)?;
                Ok(Self::LocalSet(id))
            }
            0x22 => {
                let id = LocalId::parse(iter.by_ref()).map_err(InstructionError::InvalidLocalId)?;
                Ok(Self::LocalTee(id))
            }
            0x23 => {
                todo!("Global Get")
            }
            0x24 => {
                todo!("Global Set")
            }
            mem_instr if (0x28..=0x3e).contains(&mem_instr) => {
                let arg = MemArg::parse(iter.by_ref()).map_err(InstructionError::InvalidMemArg)?;

                let instr = match mem_instr {
                    0x28 => Self::LoadI32(arg),
                    0x29 => Self::LoadI64(arg),
                    0x2a => Self::LoadF32(arg),
                    0x2b => Self::LoadF64(arg),
                    //
                    0x36 => Self::StoreI32(arg),
                    0x37 => Self::StoreI64(arg),
                    0x38 => Self::StoreF32(arg),
                    0x39 => Self::StoreF64(arg),
                    _ => unreachable!(),
                };
                Ok(instr)
            }
            0x41 => {
                let con = parse_ileb128(iter.by_ref()).ok_or(InstructionError::InvalidOperand)?;
                Ok(Self::ConstantI32(con))
            }
            0x42 => {
                let con = parse_ileb128(iter.by_ref()).ok_or(InstructionError::InvalidOperand)?;
                Ok(Self::ConstantI64(con))
            }
            0x43 => {
                todo!("f32 const")
            }
            0x44 => {
                todo!("f64 const")
            }
            //
            0x45 => Ok(Self::EqzI(IntegerVariant::I32)),
            0x46 => Ok(Self::EqI(IntegerVariant::I32)),
            0x47 => Ok(Self::NeI(IntegerVariant::I32)),
            0x48 => Ok(Self::LtSI(IntegerVariant::I32)),
            0x49 => Ok(Self::LtUI(IntegerVariant::I32)),
            0x4a => Ok(Self::GtSI(IntegerVariant::I32)),
            0x4b => Ok(Self::GtUI(IntegerVariant::I32)),
            0x4c => Ok(Self::LeSI(IntegerVariant::I32)),
            0x4d => Ok(Self::LeUI(IntegerVariant::I32)),
            0x4e => Ok(Self::GeSI(IntegerVariant::I32)),
            0x4f => Ok(Self::GeUI(IntegerVariant::I32)),
            //
            0x50 => Ok(Self::EqzI(IntegerVariant::I64)),
            0x51 => Ok(Self::EqI(IntegerVariant::I64)),
            0x52 => Ok(Self::NeI(IntegerVariant::I64)),
            0x53 => Ok(Self::LtSI(IntegerVariant::I64)),
            0x54 => Ok(Self::LtUI(IntegerVariant::I64)),
            0x55 => Ok(Self::GtSI(IntegerVariant::I64)),
            0x56 => Ok(Self::GtUI(IntegerVariant::I64)),
            0x57 => Ok(Self::LeSI(IntegerVariant::I64)),
            0x58 => Ok(Self::LeUI(IntegerVariant::I64)),
            0x59 => Ok(Self::GeSI(IntegerVariant::I64)),
            0x5a => Ok(Self::GeUI(IntegerVariant::I64)),
            //
            0x5b => Ok(Self::EqF(FloatVariant::F32)),
            0x5c => Ok(Self::NeF(FloatVariant::F32)),
            0x5d => Ok(Self::LtF(FloatVariant::F32)),
            0x5e => Ok(Self::GtF(FloatVariant::F32)),
            0x5f => Ok(Self::LeF(FloatVariant::F32)),
            0x60 => Ok(Self::GeF(FloatVariant::F32)),
            //
            0x61 => Ok(Self::EqF(FloatVariant::F64)),
            0x62 => Ok(Self::NeF(FloatVariant::F64)),
            0x63 => Ok(Self::LtF(FloatVariant::F64)),
            0x64 => Ok(Self::GtF(FloatVariant::F64)),
            0x65 => Ok(Self::LeF(FloatVariant::F64)),
            0x66 => Ok(Self::GeF(FloatVariant::F64)),
            //
            0x67 => Ok(Self::ClzI(IntegerVariant::I32)),
            0x68 => Ok(Self::CtzI(IntegerVariant::I32)),
            0x69 => Ok(Self::PopcntI(IntegerVariant::I32)),
            0x6a => Ok(Self::AddI(IntegerVariant::I32)),
            0x6b => Ok(Self::SubI(IntegerVariant::I32)),
            0x6c => Ok(Self::MulI(IntegerVariant::I32)),
            0x6d => Ok(Self::DivSI(IntegerVariant::I32)),
            0x6e => Ok(Self::DivUI(IntegerVariant::I32)),
            0x6f => Ok(Self::RemSI(IntegerVariant::I32)),
            0x70 => Ok(Self::RemUI(IntegerVariant::I32)),
            0x71 => Ok(Self::AndI(IntegerVariant::I32)),
            0x72 => Ok(Self::OrI(IntegerVariant::I32)),
            0x73 => Ok(Self::XorI(IntegerVariant::I32)),
            0x74 => Ok(Self::ShlI(IntegerVariant::I32)),
            0x75 => Ok(Self::ShrSI(IntegerVariant::I32)),
            0x76 => Ok(Self::ShrUI(IntegerVariant::I32)),
            0x77 => Ok(Self::RotlI(IntegerVariant::I32)),
            0x78 => Ok(Self::RotrI(IntegerVariant::I32)),
            //
            0x79 => Ok(Self::ClzI(IntegerVariant::I64)),
            0x7a => Ok(Self::CtzI(IntegerVariant::I64)),
            0x7b => Ok(Self::PopcntI(IntegerVariant::I64)),
            0x7c => Ok(Self::AddI(IntegerVariant::I64)),
            0x7d => Ok(Self::SubI(IntegerVariant::I64)),
            0x7e => Ok(Self::MulI(IntegerVariant::I64)),
            0x7f => Ok(Self::DivSI(IntegerVariant::I64)),
            0x80 => Ok(Self::DivUI(IntegerVariant::I64)),
            0x81 => Ok(Self::RemSI(IntegerVariant::I64)),
            0x82 => Ok(Self::RemUI(IntegerVariant::I64)),
            0x83 => Ok(Self::AndI(IntegerVariant::I64)),
            0x84 => Ok(Self::OrI(IntegerVariant::I64)),
            0x85 => Ok(Self::XorI(IntegerVariant::I64)),
            0x86 => Ok(Self::ShlI(IntegerVariant::I64)),
            0x87 => Ok(Self::ShrSI(IntegerVariant::I64)),
            0x88 => Ok(Self::ShrUI(IntegerVariant::I64)),
            0x89 => Ok(Self::RotlI(IntegerVariant::I64)),
            0x8a => Ok(Self::RotrI(IntegerVariant::I64)),
            other => Err(InstructionError::UnknownInstruction(other)),
        }
    }
}
