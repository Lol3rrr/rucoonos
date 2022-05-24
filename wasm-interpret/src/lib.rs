// https://webassembly.github.io/spec/core/binary/modules.html#binary-typesec

#[derive(Debug)]
pub struct Module {
    sections: Vec<Section>,
}

fn parse_uleb128<I>(mut bytes: I) -> Option<u32>
where
    I: Iterator<Item = u8>,
{
    let mut result = 0;
    let mut shift = 0;

    loop {
        let byte = bytes.next()?;
        result |= (byte as u32 & 0x7f) << shift;

        if (byte & 0x80) == 0 {
            break;
        }

        shift += 7;
    }

    Some(result)
}

fn parse_ileb128<I>(mut bytes: I) -> Option<i32>
where
    I: Iterator<Item = u8>,
{
    let mut result = 0;
    let mut shift = 0;

    let size = 32;

    let mut byte = 0;
    loop {
        byte = bytes.next()?;
        result |= (byte as i32 & 0x7f) << shift;
        shift += 7;

        if byte & 0x80 == 0 {
            break;
        }
    }

    if shift < size && byte & 0x80 != 0 {
        result |= !0 << shift;
    }

    Some(result)
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

impl<C> Vector<C>
where
    C: Parseable,
{
    pub fn parse<I>(mut iter: I) -> Option<Self>
    where
        I: Iterator<Item = u8>,
    {
        let size = parse_uleb128(iter.by_ref())?;

        let mut result = Vec::new();
        for _ in 0..size {
            let item = C::parse(iter.by_ref());
            if let Ok(i) = item {
                result.push(i);
            }
        }

        Some(Self { items: result })
    }
}

#[derive(Debug)]
pub struct FunctionType {
    input: ResultType,
    output: ResultType,
}
impl Parseable for FunctionType {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let magic_vec = iter.next().ok_or(())?;
        if magic_vec != 0x60 {
            return Err(());
        }

        let first = ResultType::parse(iter.by_ref())?;
        let second = ResultType::parse(iter.by_ref())?;

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

impl Parseable for ResultType {
    type Error = ();

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let elements = Vector::parse(iter).ok_or(())?;

        Ok(Self { elements })
    }
}

#[derive(Debug)]
pub enum ValueType {
    Number(NumberType),
}

impl Parseable for ValueType {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let byte = iter.next().ok_or(())?;

        match byte {
            0x7f => Ok(Self::Number(NumberType::I32)),
            _ => todo!("Byte: {:x}", byte),
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

impl Parseable for TypeIndex {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let mut peeked = iter.peekable();

        let index = parse_uleb128(peeked.by_ref()).ok_or(())?;

        Ok(Self(index))
    }
}

#[derive(Debug)]
pub struct MemoryType {
    limits: Limits,
}
impl Parseable for MemoryType {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let limits = Limits::parse(iter.by_ref())?;

        Ok(Self { limits })
    }
}

#[derive(Debug)]
pub struct Limits {
    min: u32,
    max: Option<u32>,
}

impl Parseable for Limits {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let indicator = iter.next().ok_or(())?;

        let min = parse_uleb128(iter.by_ref()).ok_or(())?;

        match indicator {
            0x0 => Ok(Self { min, max: None }),
            0x1 => {
                let max = parse_uleb128(iter.by_ref()).ok_or(())?;

                Ok(Self {
                    min,
                    max: Some(max),
                })
            }
            other => todo!("Unknown id for Limits: {}", other),
        }
    }
}

#[derive(Debug)]
pub struct Memory {
    mem_type: MemoryType,
}

impl Parseable for Memory {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let mem_type = MemoryType::parse(iter.by_ref())?;

        Ok(Self { mem_type })
    }
}

#[derive(Debug)]
pub struct Byte(u8);

impl Parseable for Byte {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let value = iter.next().ok_or(())?;

        Ok(Self(value))
    }
}

#[derive(Debug)]
pub struct Name(Vector<Byte>);

impl Parseable for Name {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let inner = Vector::parse(iter.by_ref()).ok_or(())?;

        Ok(Self(inner))
    }
}

#[derive(Debug)]
pub struct Export {
    name: Name,
    desc: ExportDescription,
}

impl Parseable for Export {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let name = Name::parse(iter.by_ref())?;
        let desc = ExportDescription::parse(iter.by_ref())?;

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

impl Parseable for ExportDescription {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let ind = iter.next().ok_or(())?;

        let id = parse_uleb128(iter.by_ref()).ok_or(())?;

        match ind {
            0 => Ok(Self::Function(id)),
            1 => Ok(Self::Table(id)),
            2 => Ok(Self::Memory(id)),
            3 => Ok(Self::Global(id)),
            other => todo!("Unknown Export {:?}", other),
        }
    }
}

#[derive(Debug)]
pub enum RefType {
    FuncReference,
    ExternReference,
}

impl Parseable for RefType {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let rtype = iter.next().ok_or(())?;

        match rtype {
            0x70 => Ok(Self::FuncReference),
            0x6f => Ok(Self::ExternReference),
            other => todo!("Unknown Reference Type {:?}", other),
        }
    }
}

#[derive(Debug)]
pub struct TableType {
    elem: RefType,
    limits: Limits,
}

impl Parseable for TableType {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let elem = RefType::parse(iter.by_ref())?;
        let limits = Limits::parse(iter.by_ref())?;

        Ok(Self { elem, limits })
    }
}

#[derive(Debug)]
pub struct Table(TableType);

impl Parseable for Table {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let inner = TableType::parse(iter.by_ref())?;

        Ok(Self(inner))
    }
}

#[derive(Debug)]
pub struct Global {}

impl Parseable for Global {
    type Error = ();

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
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
}

impl Parseable for Instruction {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let instr_ty = iter.next().ok_or(())?;

        match instr_ty {
            0x41 => {
                let con = parse_ileb128(iter.by_ref()).ok_or(())?;
                Ok(Self::ConstantI32(con))
            }
            other => todo!("Unknown Instruction 0x{:x}", other),
        }
    }
}

#[derive(Debug)]
pub struct Expression {
    instructions: Vec<Instruction>,
}

impl Parseable for Expression {
    type Error = ();

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

            let instr = Instruction::parse(peekable.by_ref())?;
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

impl Parseable for Code {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let size = parse_uleb128(iter.by_ref()).unwrap();
        println!("Size: {:?}", size);

        let func_iter = iter.by_ref().take(size as usize);
        let func = Func::parse(func_iter)?;

        Ok(Self { size, code: func })
    }
}

#[derive(Debug)]
pub struct Func {
    locals: Vector<Local>,
    exp: Expression,
}

impl Parseable for Func {
    type Error = ();

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let locals: Vector<Local> = Vector::parse(iter.by_ref()).ok_or(())?;

        let exp = Expression::parse(iter.by_ref())?;

        Ok(Self { locals, exp })
    }
}

#[derive(Debug)]
pub struct Local {
    n: u32,
    ty: ValueType,
}

impl Parseable for Local {
    type Error = ();

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
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

impl Section {
    pub fn parse<I>(byte: u8, mut content_iter: I) -> Result<Self, ()>
    where
        I: Iterator<Item = u8>,
    {
        match byte {
            0x0 => {
                println!("Custom Section");

                todo!()
            }
            0x1 => {
                let vec: Vector<FunctionType> = Vector::parse(content_iter.by_ref()).unwrap();

                Ok(Section::TypeSection(vec))
            }
            0x3 => {
                let vec: Vector<TypeIndex> = Vector::parse(content_iter.by_ref()).unwrap();

                Ok(Section::FunctionSection(vec))
            }
            0x4 => {
                let tables: Vector<Table> = Vector::parse(content_iter.by_ref()).unwrap();

                Ok(Section::TableSection(tables))
            }
            0x5 => {
                let memories: Vector<Memory> = Vector::parse(content_iter.by_ref()).unwrap();

                Ok(Section::MemorySection(memories))
            }
            0x6 => {
                let globals: Vector<Global> = Vector::parse(content_iter.by_ref()).unwrap();

                Ok(Section::GlobalSection(globals))
            }
            0x7 => {
                let exports: Vector<Export> = Vector::parse(content_iter.by_ref()).unwrap();

                Ok(Section::ExportSection(exports))
            }
            0xa => {
                let code_entries: Vector<Code> = Vector::parse(content_iter.by_ref()).unwrap();

                Ok(Section::CodeSection(code_entries))
            }
            other => {
                todo!("Unknown Section ID {:?}", other);
            }
        }
    }
}

impl Module {
    pub fn parse(bytes: &[u8]) -> Result<Self, ()> {
        let mut byte_iter = bytes.iter().copied();

        let magic: Vec<u8> = byte_iter.by_ref().take(4).collect();
        println!("Magic: {:?}", magic);

        let version: Vec<u8> = byte_iter.by_ref().take(4).collect();
        println!("Version: {:?}", version);

        let mut sections = Vec::new();
        while let Some(byte) = byte_iter.next() {
            let size = parse_uleb128(byte_iter.by_ref()).unwrap();

            let section = Section::parse(byte, byte_iter.by_ref().take(size as usize)).unwrap();
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

        dbg!(module);

        unreachable!()
    }
}
