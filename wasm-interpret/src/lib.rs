#![cfg_attr(not(test), no_std)]
extern crate alloc;

use alloc::{string::String, vec::Vec};

// https://webassembly.github.io/spec/core/binary/modules.html#binary-typesec

mod leb128;
use leb128::parse_uleb128;

mod indices;
pub use indices::*;

mod instruction;
pub use instruction::*;

mod module;
pub use module::Module;

mod types;
pub use types::*;

pub mod vm;

pub trait Parseable: Sized {
    type Error;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>;
}

#[derive(Debug, Clone, PartialEq)]
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
            let item = C::parse(iter.by_ref()).map_err(VectorError::ElementError)?;

            result.push(item);
        }

        Ok(Self { items: result })
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
pub struct Name(String);

#[derive(Debug)]
pub enum NameError {
    VectorError(VectorError<ByteError>),
    UtfError(alloc::string::FromUtf8Error),
}

impl Parseable for Name {
    type Error = NameError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let inner = Vector::parse(iter.by_ref()).map_err(NameError::VectorError)?;

        let raw: Vec<_> = inner.items.iter().map(|b: &Byte| b.0).collect();
        let string = String::from_utf8(raw).map_err(NameError::UtfError)?;

        Ok(Self(string))
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
pub struct Global {
    ty: GlobalType,
    exp: Expression,
}

#[derive(Debug)]
pub enum GlobalError {
    InvalidType(GlobalTypeError),
    InvalidExpression(ExpressionError),
}

impl Parseable for Global {
    type Error = GlobalError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let ty = GlobalType::parse(iter.by_ref()).map_err(GlobalError::InvalidType)?;
        let exp = Expression::parse(iter.by_ref()).map_err(GlobalError::InvalidExpression)?;

        Ok(Self { ty, exp })
    }
}

#[derive(Debug)]
pub struct GlobalType {
    ty: ValueType,
    mutable: bool,
}

#[derive(Debug)]
pub enum GlobalTypeError {
    InvalidValueType(ValueTypeError),
    MissingMutability,
    InvalidMutability(u8),
}

impl Parseable for GlobalType {
    type Error = GlobalTypeError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let val_type =
            ValueType::parse(iter.by_ref()).map_err(GlobalTypeError::InvalidValueType)?;
        let raw_mut = iter.next().ok_or(GlobalTypeError::MissingMutability)?;
        let mutable = match raw_mut {
            0x00 => false,
            0x01 => true,
            other => return Err(GlobalTypeError::InvalidMutability(other)),
        };

        Ok(Self {
            ty: val_type,
            mutable,
        })
    }
}

#[derive(Debug, Clone)]
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
                let _ = peekable.next();
                break;
            }

            let instr = Instruction::parse(peekable.by_ref())
                .map_err(ExpressionError::InvalidInstruction)?;
            instructions.push(instr);
        }

        Ok(Self { instructions })
    }
}

impl Expression {
    pub fn const_eval(&self) -> Result<i32, ()> {
        if self.instructions.len() != 1 {
            return Err(());
        }

        let instr = self.instructions.get(0).expect(
            "There should be exactly one instruction in the Expression as we previously checked",
        );

        match instr {
            Instruction::ConstantI32(con) => Ok(*con),
            _ => Err(()),
        }
    }
}

#[derive(Debug, Clone)]
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

#[derive(Debug, Clone)]
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

#[derive(Debug, Clone)]
pub struct Local {
    n: u32,
    ty: ValueType,
}

#[derive(Debug)]
pub enum LocalError {
    InvalidNumber,
    InvalidValueType(ValueTypeError),
}

impl Parseable for Local {
    type Error = LocalError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let n: u32 = parse_uleb128(iter.by_ref()).ok_or(LocalError::InvalidNumber)?;
        let val_type = ValueType::parse(iter.by_ref()).map_err(LocalError::InvalidValueType)?;

        Ok(Self { n, ty: val_type })
    }
}

#[derive(Debug)]
pub struct Import {
    mod_: Name,
    nm: Name,
    d: ImportDescription,
}

#[derive(Debug)]
pub enum ImportError {
    InvalidMod(NameError),
    InvalidNm(NameError),
    InvalidDescription(ImportDescriptionError),
}

impl Parseable for Import {
    type Error = ImportError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let mod_ = Name::parse(iter.by_ref()).map_err(ImportError::InvalidMod)?;
        let nm = Name::parse(iter.by_ref()).map_err(ImportError::InvalidNm)?;
        let desc =
            ImportDescription::parse(iter.by_ref()).map_err(ImportError::InvalidDescription)?;

        Ok(Self { mod_, nm, d: desc })
    }
}

#[derive(Debug)]
pub enum ImportDescription {
    Function(TypeIndex),
    Table(TableType),
    Memory(MemoryType),
    Global(GlobalType),
}

#[derive(Debug)]
pub enum ImportDescriptionError {
    MissingDescriptor,
    UnknownDescription(u8),
    InvalidFuncType(TypeIndexError),
    InvalidTableType(TableTypeError),
    InvalidMemory(MemoryTypeError),
    InvalidGlobal(GlobalTypeError),
}

impl Parseable for ImportDescription {
    type Error = ImportDescriptionError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let id = iter
            .next()
            .ok_or(ImportDescriptionError::MissingDescriptor)?;

        match id {
            0x00 => {
                let tid = TypeIndex::parse(iter.by_ref())
                    .map_err(ImportDescriptionError::InvalidFuncType)?;
                Ok(Self::Function(tid))
            }
            0x01 => {
                let tid = TableType::parse(iter.by_ref())
                    .map_err(ImportDescriptionError::InvalidTableType)?;
                Ok(Self::Table(tid))
            }
            0x02 => {
                let mtype = MemoryType::parse(iter.by_ref())
                    .map_err(ImportDescriptionError::InvalidMemory)?;
                Ok(Self::Memory(mtype))
            }
            0x03 => todo!(""),
            other => Err(ImportDescriptionError::UnknownDescription(other)),
        }
    }
}

#[derive(Debug, Clone)]
pub enum Element {
    Type1 {
        func_ids: Vector<FuncIndex>,
        offset: Expression,
    },
}

#[derive(Debug)]
pub enum ElementError {
    MissingId,
    InvalidId(u32),
    InvalidExpression(ExpressionError),
    InvalidFuncIds(VectorError<FuncIndexError>),
}

impl Parseable for Element {
    type Error = ElementError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let raw_id = parse_uleb128(iter.by_ref()).ok_or(ElementError::MissingId)?;

        match raw_id {
            0 => {
                let exp =
                    Expression::parse(iter.by_ref()).map_err(ElementError::InvalidExpression)?;

                let func_ids: Vector<FuncIndex> =
                    Vector::parse(iter.by_ref()).map_err(ElementError::InvalidFuncIds)?;

                Ok(Self::Type1 {
                    func_ids,
                    offset: exp,
                })
            }
            1 => todo!(),
            2 => todo!(),
            3 => todo!(),
            4 => todo!(),
            5 => todo!(),
            6 => todo!(),
            7 => todo!(),
            other => Err(ElementError::InvalidId(other)),
        }
    }
}

#[derive(Debug)]
pub enum Data {
    Variant0(Expression, Vector<Byte>),
    Variant1,
    Variant2,
}

#[derive(Debug)]
pub enum DataError {
    InvalidVariant,
    UnknownVariant(u32),
    InvalidExpression(ExpressionError),
    InvalidBytes(VectorError<ByteError>),
}

impl Parseable for Data {
    type Error = DataError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let variant_ident: u32 = parse_uleb128(iter.by_ref()).ok_or(DataError::InvalidVariant)?;

        match variant_ident {
            0 => {
                let exp = Expression::parse(iter.by_ref()).map_err(DataError::InvalidExpression)?;
                let bytes: Vector<Byte> =
                    Vector::parse(iter.by_ref()).map_err(DataError::InvalidBytes)?;

                Ok(Self::Variant0(exp, bytes))
            }
            1 => todo!("Variant 1"),
            2 => todo!("Variant 2"),
            other => Err(DataError::UnknownVariant(other)),
        }
    }
}

#[derive(Debug)]
pub enum Section {
    Custom(Name, Vec<u8>),
    TypeSection(Vector<FunctionType>),
    ImportSection(Vector<Import>),
    FunctionSection(Vector<TypeIndex>),
    TableSection(Vector<Table>),
    MemorySection(Vector<Memory>),
    GlobalSection(Vector<Global>),
    ExportSection(Vector<Export>),
    ElementSection(Vector<Element>),
    CodeSection(Vector<Code>),
    DataSection(Vector<Data>),
}

#[derive(Debug)]
pub enum SectionError {
    CustomSection(NameError),
    TypeSection(VectorError<FunctionTypeError>),
    ImportSection(VectorError<ImportError>),
    FunctionSection(VectorError<TypeIndexError>),
    TableSection(VectorError<TableError>),
    MemorySection(VectorError<MemoryError>),
    GlobalSection(VectorError<GlobalError>),
    ExportSection(VectorError<ExportError>),
    ElementSection(VectorError<ElementError>),
    CodeSection(VectorError<CodeError>),
    DataSection(VectorError<DataError>),
    Unknown(u8),
}

impl Section {
    pub fn parse<I>(byte: u8, mut content_iter: I) -> Result<Self, SectionError>
    where
        I: Iterator<Item = u8>,
    {
        match byte {
            0x0 => {
                let name =
                    Name::parse(content_iter.by_ref()).map_err(SectionError::CustomSection)?;
                let raw = content_iter.collect::<Vec<_>>();

                Ok(Self::Custom(name, raw))
            }
            0x1 => {
                let vec: Vector<FunctionType> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::TypeSection)?;

                Ok(Self::TypeSection(vec))
            }
            0x2 => {
                let imports: Vector<Import> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::ImportSection)?;

                Ok(Self::ImportSection(imports))
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
            0x9 => {
                let elem_entries: Vector<Element> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::ElementSection)?;

                Ok(Self::ElementSection(elem_entries))
            }
            0xa => {
                let code_entries: Vector<Code> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::CodeSection)?;

                Ok(Section::CodeSection(code_entries))
            }
            0xb => {
                let data_entries: Vector<Data> =
                    Vector::parse(content_iter.by_ref()).map_err(SectionError::DataSection)?;

                Ok(Section::DataSection(data_entries))
            }
            other => Err(SectionError::Unknown(other)),
        }
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
    }
}
