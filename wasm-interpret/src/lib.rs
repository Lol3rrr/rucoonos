#![cfg_attr(not(test), no_std)]
extern crate alloc;

use alloc::vec::Vec;

// https://webassembly.github.io/spec/core/binary/modules.html#binary-typesec

mod leb128;
use leb128::{parse_ileb128, parse_uleb128};

#[derive(Debug)]
pub struct Module {
    sections: Vec<Section>,
}

pub trait Parseable: Sized {
    type Error;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>;
}

#[derive(Debug)]
pub struct Vector<C> {
    items: Vec<C>,
}

#[derive(Debug)]
pub enum VectorError<E> {
    InvalidSize,
    ElementError(E),
}

impl<C> Parseable for Vector<C>
where
    C: Parseable,
{
    type Error = VectorError<C::Error>;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let size = parse_uleb128(iter.by_ref()).ok_or(VectorError::InvalidSize)?;

        let mut result = Vec::new();
        for _ in 0..size {
            let item = C::parse(iter.by_ref()).map_err(|e| VectorError::ElementError(e))?;

            result.push(item);
        }

        Ok(Self { items: result })
    }
}

#[derive(Debug)]
pub struct FunctionType {
    input: ResultType,
    output: ResultType,
}

#[derive(Debug)]
pub enum FunctionTypeError {
    MissingMagicByte,
    InvalidMagicByte(u8),
    InvalidInputResultType(ResultTypeError),
    InvalidOutputResultType(ResultTypeError),
}

impl Parseable for FunctionType {
    type Error = FunctionTypeError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let magic_vec = iter.next().ok_or(FunctionTypeError::MissingMagicByte)?;
        if magic_vec != 0x60 {
            return Err(FunctionTypeError::InvalidMagicByte(magic_vec));
        }

        let first =
            ResultType::parse(iter.by_ref()).map_err(FunctionTypeError::InvalidInputResultType)?;
        let second =
            ResultType::parse(iter.by_ref()).map_err(FunctionTypeError::InvalidOutputResultType)?;

        Ok(Self {
            input: first,
            output: second,
        })
    }
}

#[derive(Debug)]
pub struct ResultType {
    elements: Vector<ValueType>,
}

#[derive(Debug)]
pub enum ResultTypeError {
    VectorError(VectorError<ValueTypeError>),
}

impl Parseable for ResultType {
    type Error = ResultTypeError;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let elements = Vector::parse(iter).map_err(ResultTypeError::VectorError)?;

        Ok(Self { elements })
    }
}

#[derive(Debug)]
pub enum ValueType {
    Number(NumberType),
}

#[derive(Debug)]
pub enum ValueTypeError {
    MissingType,
    Unknown(u8),
}

impl Parseable for ValueType {
    type Error = ValueTypeError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let byte = iter.next().ok_or(ValueTypeError::MissingType)?;

        match byte {
            0x7f => Ok(Self::Number(NumberType::I32)),
            other => Err(ValueTypeError::Unknown(other)),
        }
    }
}

#[derive(Debug)]
pub enum NumberType {
    I32,
    I64,
}

#[derive(Debug)]
pub struct TypeIndex(u32);

#[derive(Debug)]
pub enum TypeIndexError {
    Missing,
}

impl Parseable for TypeIndex {
    type Error = TypeIndexError;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let mut peeked = iter.peekable();

        let index = parse_uleb128(peeked.by_ref()).ok_or(TypeIndexError::Missing)?;

        Ok(Self(index))
    }
}

#[derive(Debug)]
pub struct MemoryType {
    limits: Limits,
}

#[derive(Debug)]
pub enum MemoryTypeError {
    LimitsError(LimitsError),
}

impl Parseable for MemoryType {
    type Error = MemoryTypeError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let limits = Limits::parse(iter.by_ref()).map_err(MemoryTypeError::LimitsError)?;

        Ok(Self { limits })
    }
}

#[derive(Debug)]
pub struct Limits {
    min: u32,
    max: Option<u32>,
}

#[derive(Debug)]
pub enum LimitsError {
    MissingLimitType,
    UnknownLimitType(u8),
    InvalidMin,
    InvalidMax,
}

impl Parseable for Limits {
    type Error = LimitsError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let indicator = iter.next().ok_or(LimitsError::MissingLimitType)?;

        let min = parse_uleb128(iter.by_ref()).ok_or(LimitsError::InvalidMin)?;

        match indicator {
            0x0 => Ok(Self { min, max: None }),
            0x1 => {
                let max = parse_uleb128(iter.by_ref()).ok_or(LimitsError::InvalidMax)?;

                Ok(Self {
                    min,
                    max: Some(max),
                })
            }
            other => Err(LimitsError::UnknownLimitType(other)),
        }
    }
}

#[derive(Debug)]
pub struct Memory {
    mem_type: MemoryType,
}

#[derive(Debug)]
pub enum MemoryError {
    MemoryTypeError(MemoryTypeError),
}

impl Parseable for Memory {
    type Error = MemoryError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let mem_type = MemoryType::parse(iter.by_ref()).map_err(MemoryError::MemoryTypeError)?;

        Ok(Self { mem_type })
    }
}

#[derive(Debug)]
pub struct Byte(u8);

#[derive(Debug)]
pub enum ByteError {
    Missing,
}

impl Parseable for Byte {
    type Error = ByteError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let value = iter.next().ok_or(ByteError::Missing)?;

        Ok(Self(value))
    }
}

#[derive(Debug)]
pub struct Name(Vector<Byte>);

#[derive(Debug)]
pub enum NameError {
    VectorError(VectorError<ByteError>),
}

impl Parseable for Name {
    type Error = NameError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let inner = Vector::parse(iter.by_ref()).map_err(NameError::VectorError)?;

        Ok(Self(inner))
    }
}

#[derive(Debug)]
pub struct Export {
    name: Name,
    desc: ExportDescription,
}

#[derive(Debug)]
pub enum ExportError {
    NameError(NameError),
    DescriptionError(ExportDescriptionError),
}

impl Parseable for Export {
    type Error = ExportError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let name = Name::parse(iter.by_ref()).map_err(ExportError::NameError)?;
        let desc =
            ExportDescription::parse(iter.by_ref()).map_err(ExportError::DescriptionError)?;

        Ok(Self { name, desc })
    }
}

#[derive(Debug)]
pub enum ExportDescription {
    Function(u32),
    Table(u32),
    Memory(u32),
    Global(u32),
}

#[derive(Debug)]
pub enum ExportDescriptionError {
    MissingIndicator,
    MissingId,
    UnknownIndicator(u8),
}

impl Parseable for ExportDescription {
    type Error = ExportDescriptionError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let ind = iter
            .next()
            .ok_or(ExportDescriptionError::MissingIndicator)?;

        let id = parse_uleb128(iter.by_ref()).ok_or(ExportDescriptionError::MissingId)?;

        match ind {
            0 => Ok(Self::Function(id)),
            1 => Ok(Self::Table(id)),
            2 => Ok(Self::Memory(id)),
            3 => Ok(Self::Global(id)),
            other => Err(ExportDescriptionError::UnknownIndicator(other)),
        }
    }
}

#[derive(Debug)]
pub enum RefType {
    FuncReference,
    ExternReference,
}

#[derive(Debug)]
pub enum RefTypeError {
    MissingType,
    UnknownType(u8),
}

impl Parseable for RefType {
    type Error = RefTypeError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let rtype = iter.next().ok_or(RefTypeError::MissingType)?;

        match rtype {
            0x70 => Ok(Self::FuncReference),
            0x6f => Ok(Self::ExternReference),
            other => Err(RefTypeError::UnknownType(other)),
        }
    }
}

#[derive(Debug)]
pub struct TableType {
    elem: RefType,
    limits: Limits,
}

#[derive(Debug)]
pub enum TableTypeError {
    InvalidElem(RefTypeError),
    InvalidLimits(LimitsError),
}

impl Parseable for TableType {
    type Error = TableTypeError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let elem = RefType::parse(iter.by_ref()).map_err(TableTypeError::InvalidElem)?;
        let limits = Limits::parse(iter.by_ref()).map_err(TableTypeError::InvalidLimits)?;

        Ok(Self { elem, limits })
    }
}

#[derive(Debug)]
pub struct Table(TableType);

#[derive(Debug)]
pub enum TableError {
    InvalidTableType(TableTypeError),
}

impl Parseable for Table {
    type Error = TableError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let inner = TableType::parse(iter.by_ref()).map_err(TableError::InvalidTableType)?;

        Ok(Self(inner))
    }
}

#[derive(Debug)]
pub struct Global {}

#[derive(Debug)]
pub enum GlobalError {}

impl Parseable for Global {
    type Error = GlobalError;

    fn parse<I>(_: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        todo!("Parse Global")
    }
}

#[derive(Debug)]
pub struct GlobalType {}

#[derive(Debug)]
pub enum Instruction {
    ConstantI32(i32),
    ConstantI64(i64),
}

#[derive(Debug)]
pub enum InstructionError {
    MissingInstruction,
    UnknownInstruction(u8),
    InvalidOperand,
}

impl Parseable for Instruction {
    type Error = InstructionError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let instr_ty = iter.next().ok_or(InstructionError::MissingInstruction)?;

        match instr_ty {
            0x41 => {
                let con = parse_ileb128(iter.by_ref()).ok_or(InstructionError::InvalidOperand)?;
                Ok(Self::ConstantI32(con))
            }
            0x42 => {
                let con = parse_ileb128(iter.by_ref()).ok_or(InstructionError::InvalidOperand)?;
                Ok(Self::ConstantI64(con))
            }
            other => Err(InstructionError::UnknownInstruction(other)),
        }
    }
}

#[derive(Debug)]
pub struct Expression {
    instructions: Vec<Instruction>,
}

#[derive(Debug)]
pub enum ExpressionError {
    InvalidInstruction(InstructionError),
}

impl Parseable for Expression {
    type Error = ExpressionError;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let mut instructions = Vec::new();

        let mut peekable = iter.peekable();
        while let Some(byte) = peekable.peek() {
            if *byte == 0x0b {
                break;
            }

            let instr = Instruction::parse(peekable.by_ref())
                .map_err(ExpressionError::InvalidInstruction)?;
            instructions.push(instr);
        }

        Ok(Self { instructions })
    }
}

#[derive(Debug)]
pub struct Code {
    size: u32,
    code: Func,
}

#[derive(Debug)]
pub enum CodeError {
    InvalidSize,
    InvalidFunc(FuncError),
}

impl Parseable for Code {
    type Error = CodeError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let size = parse_uleb128(iter.by_ref()).ok_or(CodeError::InvalidSize)?;

        let func_iter = iter.by_ref().take(size as usize);
        let func = Func::parse(func_iter).map_err(CodeError::InvalidFunc)?;

        Ok(Self { size, code: func })
    }
}

#[derive(Debug)]
pub struct Func {
    locals: Vector<Local>,
    exp: Expression,
}

#[derive(Debug)]
pub enum FuncError {
    InvalidLocals(VectorError<LocalError>),
    InvalidExpression(ExpressionError),
}

impl Parseable for Func {
    type Error = FuncError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let locals: Vector<Local> =
            Vector::parse(iter.by_ref()).map_err(FuncError::InvalidLocals)?;

        let exp = Expression::parse(iter.by_ref()).map_err(FuncError::InvalidExpression)?;

        Ok(Self { locals, exp })
    }
}

#[derive(Debug)]
pub struct Local {
    n: u32,
    ty: ValueType,
}

#[derive(Debug)]
pub enum LocalError {}

impl Parseable for Local {
    type Error = LocalError;

    fn parse<I>(_: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        todo!()
    }
}

#[derive(Debug)]
pub enum Section {
    TypeSection(Vector<FunctionType>),
    FunctionSection(Vector<TypeIndex>),
    TableSection(Vector<Table>),
    MemorySection(Vector<Memory>),
    GlobalSection(Vector<Global>),
    ExportSection(Vector<Export>),
    CodeSection(Vector<Code>),
}

#[derive(Debug)]
pub enum SectionError {
    TypeSection(VectorError<FunctionTypeError>),
    FunctionSection(VectorError<TypeIndexError>),
    TableSection(VectorError<TableError>),
    MemorySection(VectorError<MemoryError>),
    GlobalSection(VectorError<GlobalError>),
    ExportSection(VectorError<ExportError>),
    CodeSection(VectorError<CodeError>),
    Unknown(u8),
}

impl Section {
    pub fn parse<I>(byte: u8, mut content_iter: I) -> Result<Self, SectionError>
    where
        I: Iterator<Item = u8>,
    {
        match byte {
            0x0 => {
                // println!("Custom Section");

                todo!()
            }
            0x1 => {
                let vec: Vector<FunctionType> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::TypeSection)?;

                Ok(Section::TypeSection(vec))
            }
            0x3 => {
                let vec: Vector<TypeIndex> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::FunctionSection)?;

                Ok(Section::FunctionSection(vec))
            }
            0x4 => {
                let tables: Vector<Table> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::TableSection)?;

                Ok(Section::TableSection(tables))
            }
            0x5 => {
                let memories: Vector<Memory> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::MemorySection)?;

                Ok(Section::MemorySection(memories))
            }
            0x6 => {
                let globals: Vector<Global> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::GlobalSection)?;

                Ok(Section::GlobalSection(globals))
            }
            0x7 => {
                let exports: Vector<Export> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::ExportSection)?;

                Ok(Section::ExportSection(exports))
            }
            0xa => {
                let code_entries: Vector<Code> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::CodeSection)?;

                Ok(Section::CodeSection(code_entries))
            }
            other => Err(SectionError::Unknown(other)),
        }
    }
}

#[derive(Debug)]
pub enum ModuleError {
    InvalidSectionSize,
    InvalidSection(SectionError),
}

impl Module {
    pub fn parse(bytes: &[u8]) -> Result<Self, ModuleError> {
        let mut byte_iter = bytes.iter().copied();

        let magic: Vec<u8> = byte_iter.by_ref().take(4).collect();
        assert_eq!(&[0b00, b'a', b's', b'm'] as &[u8], &magic as &[u8]);

        let version = {
            let mut tmp = [0, 0, 0, 0];

            for (index, val) in byte_iter.by_ref().take(4).enumerate() {
                tmp[index] = val;
            }

            u32::from_le_bytes(tmp)
        };
        assert_eq!(1, version);

        let mut sections = Vec::new();
        while let Some(byte) = byte_iter.next() {
            let size: u32 =
                parse_uleb128(byte_iter.by_ref()).ok_or(ModuleError::InvalidSectionSize)?;

            let section = Section::parse(byte, byte_iter.by_ref().take(size as usize))
                .map_err(ModuleError::InvalidSection)?;
            sections.push(section);
        }

        Ok(Self { sections })
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sample() {
        let module = [
            0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x85, 0x80, 0x80, 0x80, 0x00,
            0x01, 0x60, 0x00, 0x01, 0x7f, 0x03, 0x82, 0x80, 0x80, 0x80, 0x00, 0x01, 0x00, 0x04,
            0x84, 0x80, 0x80, 0x80, 0x00, 0x01, 0x70, 0x00, 0x00, 0x05, 0x83, 0x80, 0x80, 0x80,
            0x00, 0x01, 0x00, 0x01, 0x06, 0x81, 0x80, 0x80, 0x80, 0x00, 0x00, 0x07, 0x91, 0x80,
            0x80, 0x80, 0x00, 0x02, 0x06, 0x6d, 0x65, 0x6d, 0x6f, 0x72, 0x79, 0x02, 0x00, 0x04,
            0x6d, 0x61, 0x69, 0x6e, 0x00, 0x00, 0x0a, 0x8a, 0x80, 0x80, 0x80, 0x00, 0x01, 0x84,
            0x80, 0x80, 0x80, 0x00, 0x00, 0x41, 0x2a, 0x0b,
        ];

        let module = Module::parse(&module);

        dbg!(&module);

        unreachable!()
    }
}
