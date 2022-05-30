use crate::{leb128::parse_uleb128, Parseable};

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct Index(pub u32);

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub enum IndexError {
    Missing,
}

impl Parseable for Index {
    type Error = IndexError;

    fn parse<I>(mut iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let index = parse_uleb128(iter.by_ref()).ok_or(IndexError::Missing)?;
        Ok(Self(index))
    }
}

pub type LabelIndexError = IndexError;
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct LabelIndex(Index);

impl Parseable for LabelIndex {
    type Error = IndexError;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let index = Index::parse(iter)?;
        Ok(Self(index))
    }
}
impl From<u32> for LabelIndex {
    fn from(v: u32) -> Self {
        Self(Index(v))
    }
}

pub type GlobalIndexError = IndexError;
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct GlobalIndex(Index);

impl Parseable for GlobalIndex {
    type Error = IndexError;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let index = Index::parse(iter)?;
        Ok(Self(index))
    }
}
impl From<u32> for GlobalIndex {
    fn from(v: u32) -> Self {
        Self(Index(v))
    }
}

pub type TypeIndexError = IndexError;
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct TypeIndex(Index);

impl Parseable for TypeIndex {
    type Error = IndexError;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let index = Index::parse(iter)?;
        Ok(Self(index))
    }
}
impl From<u32> for TypeIndex {
    fn from(v: u32) -> Self {
        Self(Index(v))
    }
}

pub type LocalIndexError = IndexError;
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct LocalIndex(Index);

impl Parseable for LocalIndex {
    type Error = IndexError;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let index = Index::parse(iter)?;
        Ok(Self(index))
    }
}
impl From<u32> for LocalIndex {
    fn from(v: u32) -> Self {
        Self(Index(v))
    }
}

pub type TableIndexError = IndexError;
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct TableIndex(Index);

impl Parseable for TableIndex {
    type Error = IndexError;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let index = Index::parse(iter)?;
        Ok(Self(index))
    }
}
impl From<u32> for TableIndex {
    fn from(v: u32) -> Self {
        Self(Index(v))
    }
}

pub type FuncIndexError = IndexError;
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct FuncIndex(Index);

impl Parseable for FuncIndex {
    type Error = IndexError;

    fn parse<I>(iter: I) -> Result<Self, Self::Error>
    where
        I: Iterator<Item = u8>,
    {
        let index = Index::parse(iter)?;
        Ok(Self(index))
    }
}
impl From<u32> for FuncIndex {
    fn from(v: u32) -> Self {
        Self(Index(v))
    }
}
