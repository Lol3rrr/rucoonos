use crate::{leb128::parse_ileb128, Parseable, Vector, VectorError};

#[derive(Debug, Clone)]
pub struct FunctionType {
    pub input: ResultType,
    pub output: ResultType,
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

#[derive(Debug, Clone)]
pub struct ResultType {
    pub elements: Vector<ValueType>,
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

#[derive(Debug, Clone, PartialEq)]
pub enum ValueType {
    Number(NumberType),
    Vector128,
    FuncRef,
    ExternRef,
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
        let data = iter.next().ok_or(ValueTypeError::MissingType)?;

        match data {
            0x7f => Ok(Self::Number(NumberType::I32)),
            0x7e => Ok(Self::Number(NumberType::I64)),
            0x7d => Ok(Self::Number(NumberType::F32)),
            0x7c => Ok(Self::Number(NumberType::F64)),
            0x7b => Ok(Self::Vector128),
            0x70 => Ok(Self::FuncRef),
            0x6f => Ok(Self::ExternRef),
            other => Err(ValueTypeError::Unknown(other)),
        }
    }
}
impl ValueType {
    fn fits(data: u8) -> bool {
        matches!(data, 0x7f | 0x7e | 0x7d | 0x7c | 0x7b | 0x70 | 0x6f)
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum NumberType {
    I32,
    I64,
    F32,
    F64,
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

#[derive(Debug, Clone, PartialEq)]
pub enum BlockType {
    Empty,
    Value(ValueType),
    TypeIndex(i32),
}

#[derive(Debug)]
pub enum BlockTypeError {
    MissingData,
    InvalidValueType(ValueTypeError),
    InvalidIndex,
}

impl Parseable for BlockType {
    type Error = BlockTypeError;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let mut iter = iter.peekable();

        let peeked = iter.peek().ok_or(BlockTypeError::MissingData)?;

        if *peeked == 0x40 {
            let _ = iter.next();

            return Ok(Self::Empty);
        }

        // TODO

        if ValueType::fits(*peeked) {
            let val = ValueType::parse(iter).map_err(BlockTypeError::InvalidValueType)?;

            return Ok(Self::Value(val));
        }

        let index = parse_ileb128(iter).ok_or(BlockTypeError::InvalidIndex)?;
        Ok(Self::TypeIndex(index))
    }
}
