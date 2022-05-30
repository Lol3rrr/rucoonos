use alloc::{boxed::Box, vec::Vec};

use crate::{
    leb128::{parse_ileb128, parse_uleb128},
    BlockType, BlockTypeError, FuncIndex, FuncIndexError, GlobalIndex, GlobalIndexError,
    LabelIndex, LabelIndexError, LocalIndex, LocalIndexError, Parseable, TableIndex,
    TableIndexError, TypeIndex, TypeIndexError, Vector, VectorError,
};

#[derive(Debug, Clone, PartialEq)]
pub enum IntegerVariant {
    I32,
    I64,
}

#[derive(Debug, Clone, PartialEq)]
pub enum FloatVariant {
    F32,
    F64,
}

#[derive(Debug, Clone, PartialEq)]
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

#[derive(Debug, Clone, PartialEq)]
pub enum Instruction {
    Unreachable,
    Nop,
    Block(BlockType, Vec<Self>),
    Loop(BlockType, Vec<Self>),
    If(BlockType, Vec<Self>),
    IfElse(BlockType, Vec<Self>, Vec<Self>),
    Branch(LabelIndex),
    BranchConditional(LabelIndex),
    BranchTable(Vector<LabelIndex>, LabelIndex),
    Return,
    Call(FuncIndex),
    CallIndirect(TypeIndex, TableIndex),

    //
    Drop,
    Select,

    //
    LocalGet(LocalIndex),
    LocalSet(LocalIndex),
    LocalTee(LocalIndex),
    GlobalGet(GlobalIndex),
    GlobalSet(GlobalIndex),
    //
    LoadI32(MemArg),
    LoadI32_8S(MemArg),
    LoadI32_8U(MemArg),
    LoadI32_16S(MemArg),
    LoadI32_16U(MemArg),
    LoadI64(MemArg),
    LoadI64_8S(MemArg),
    LoadI64_8U(MemArg),
    LoadI64_16S(MemArg),
    LoadI64_16U(MemArg),
    LoadI64_32S(MemArg),
    LoadI64_32U(MemArg),
    LoadF32(MemArg),
    LoadF64(MemArg),
    //
    StoreI32(MemArg, usize),
    StoreI64(MemArg, usize),
    StoreF32(MemArg),
    StoreF64(MemArg),

    //
    MemorySize,
    MemoryGrow,

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

    //
    WrapI32I64,
    ExtendI64I32U,
    ExtendI64I32S,
}

#[derive(Debug)]
pub enum InstructionError {
    MissingInstruction,
    UnknownInstruction(u8),
    InvalidOperand,
    InvalidMemArg(MemArgError),
    InvalidFuncId(FuncIndexError),
    InvalidLocalIndex(LocalIndexError),
    InvalodGlobalIndex(GlobalIndexError),
    InvalidBlockType(BlockTypeError),
    InvalidInstruction(Box<InstructionError>),
    InvalidLabelIndex(LabelIndexError),
    InvalidLabelIndices(VectorError<LabelIndexError>),
    InvalidTableIndex(TableIndexError),
    InvalidTypeIndex(TypeIndexError),
}

impl Parseable for Instruction {
    type Error = InstructionError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let instr_ty = iter.next().ok_or(InstructionError::MissingInstruction)?;

        match instr_ty {
            0x00 => Ok(Self::Unreachable),
            0x01 => Ok(Self::Nop),
            0x02 => {
                let block_type =
                    BlockType::parse(iter.by_ref()).map_err(InstructionError::InvalidBlockType)?;

                let mut instructions = Vec::new();
                let mut peekable = iter.peekable();
                while let Some(byte) = peekable.peek() {
                    if *byte == 0x0b {
                        let _ = peekable.next();
                        break;
                    }

                    let instr =
                        Self::parse(Box::new(peekable.by_ref()) as Box<dyn Iterator<Item = u8>>)
                            .map_err(|e| InstructionError::InvalidInstruction(Box::new(e)))?;
                    instructions.push(instr);
                }

                Ok(Self::Block(block_type, instructions))
            }
            0x03 => {
                let block_type =
                    BlockType::parse(iter.by_ref()).map_err(InstructionError::InvalidBlockType)?;

                let mut instructions = Vec::new();
                let mut peekable = iter.peekable();
                while let Some(byte) = peekable.peek() {
                    if *byte == 0x0b {
                        let _ = peekable.next();
                        break;
                    }

                    let instr =
                        Self::parse(Box::new(peekable.by_ref()) as Box<dyn Iterator<Item = u8>>)
                            .map_err(|e| InstructionError::InvalidInstruction(Box::new(e)))?;
                    instructions.push(instr);
                }

                Ok(Self::Loop(block_type, instructions))
            }
            0x4 => {
                let block_type =
                    BlockType::parse(iter.by_ref()).map_err(InstructionError::InvalidBlockType)?;

                let mut true_instr = Vec::new();
                let mut peekable = iter.peekable();
                while let Some(byte) = peekable.peek() {
                    if *byte == 0x0b || *byte == 0x05 {
                        break;
                    }

                    let instr =
                        Self::parse(Box::new(peekable.by_ref()) as Box<dyn Iterator<Item = u8>>)
                            .map_err(|e| InstructionError::InvalidInstruction(Box::new(e)))?;
                    true_instr.push(instr);
                }

                match peekable.next() {
                    Some(b) if b == 0x0b => Ok(Self::If(block_type, true_instr)),
                    Some(b) if b == 0x05 => {
                        let mut false_instr = Vec::new();
                        while let Some(byte) = peekable.peek() {
                            if *byte == 0x0b {
                                break;
                            }

                            let instr = Self::parse(
                                Box::new(peekable.by_ref()) as Box<dyn Iterator<Item = u8>>
                            )
                            .map_err(|e| InstructionError::InvalidInstruction(Box::new(e)))?;
                            false_instr.push(instr);
                        }

                        Ok(Self::IfElse(block_type, true_instr, false_instr))
                    }
                    Some(_) => unreachable!(),
                    None => unreachable!(),
                }
            }
            0x0c => {
                let lindex = LabelIndex::parse(iter.by_ref())
                    .map_err(InstructionError::InvalidLabelIndex)?;

                Ok(Self::Branch(lindex))
            }
            0x0d => {
                let lindex = LabelIndex::parse(iter.by_ref())
                    .map_err(InstructionError::InvalidLabelIndex)?;

                Ok(Self::BranchConditional(lindex))
            }
            0x0e => {
                let lindicies: Vector<LabelIndex> =
                    Vector::parse(iter.by_ref()).map_err(InstructionError::InvalidLabelIndices)?;
                let lindex = LabelIndex::parse(iter.by_ref())
                    .map_err(InstructionError::InvalidLabelIndex)?;

                Ok(Self::BranchTable(lindicies, lindex))
            }
            0x0f => Ok(Self::Return),
            0x10 => {
                let id =
                    FuncIndex::parse(iter.by_ref()).map_err(InstructionError::InvalidFuncId)?;
                Ok(Self::Call(id))
            }
            0x11 => {
                let taid =
                    TypeIndex::parse(iter.by_ref()).map_err(InstructionError::InvalidTypeIndex)?;
                let tyid = TableIndex::parse(iter.by_ref())
                    .map_err(InstructionError::InvalidTableIndex)?;
                Ok(Self::CallIndirect(taid, tyid))
            }
            //
            0x1a => Ok(Self::Drop),
            0x1b => Ok(Self::Select),
            //
            0x20 => {
                let id = LocalIndex::parse(iter.by_ref())
                    .map_err(InstructionError::InvalidLocalIndex)?;
                Ok(Self::LocalGet(id))
            }
            0x21 => {
                let id = LocalIndex::parse(iter.by_ref())
                    .map_err(InstructionError::InvalidLocalIndex)?;
                Ok(Self::LocalSet(id))
            }
            0x22 => {
                let id = LocalIndex::parse(iter.by_ref())
                    .map_err(InstructionError::InvalidLocalIndex)?;
                Ok(Self::LocalTee(id))
            }
            0x23 => {
                let id = GlobalIndex::parse(iter.by_ref())
                    .map_err(InstructionError::InvalodGlobalIndex)?;
                Ok(Self::GlobalGet(id))
            }
            0x24 => {
                let id = GlobalIndex::parse(iter.by_ref())
                    .map_err(InstructionError::InvalodGlobalIndex)?;
                Ok(Self::GlobalSet(id))
            }
            mem_instr if (0x28..=0x3e).contains(&mem_instr) => {
                let arg = MemArg::parse(iter.by_ref()).map_err(InstructionError::InvalidMemArg)?;

                let instr = match mem_instr {
                    0x28 => Self::LoadI32(arg),
                    0x29 => Self::LoadI64(arg),
                    0x2a => Self::LoadF32(arg),
                    0x2b => Self::LoadF64(arg),
                    0x2c => Self::LoadI32_8S(arg),
                    0x2d => Self::LoadI32_8U(arg),
                    0x2e => Self::LoadI32_16S(arg),
                    0x2f => Self::LoadI32_16U(arg),
                    0x30 => Self::LoadI64_8S(arg),
                    0x31 => Self::LoadI64_8U(arg),
                    0x32 => Self::LoadI64_16S(arg),
                    0x33 => Self::LoadI64_16U(arg),
                    0x34 => Self::LoadI64_32S(arg),
                    0x35 => Self::LoadI64_32U(arg),
                    //
                    0x36 => Self::StoreI32(arg, 4),
                    0x37 => Self::StoreI64(arg, 8),
                    0x38 => Self::StoreF32(arg),
                    0x39 => Self::StoreF64(arg),
                    0x3a => Self::StoreI32(arg, 1),
                    0x3b => Self::StoreI32(arg, 2),
                    0x3c => Self::StoreI64(arg, 1),
                    0x3d => Self::StoreI64(arg, 2),
                    0x3e => Self::StoreI64(arg, 4),
                    other => todo!("Unknown 0x{:x}", other),
                };
                Ok(instr)
            }

            //
            0x3f => Ok(Self::MemorySize),
            0x40 => Ok(Self::MemoryGrow),

            //
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
            //
            0xa7 => Ok(Self::WrapI32I64),
            0xac => Ok(Self::ExtendI64I32S),
            0xad => Ok(Self::ExtendI64I32U),
            //
            other => Err(InstructionError::UnknownInstruction(other)),
        }
    }
}
