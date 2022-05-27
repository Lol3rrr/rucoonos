use crate::{leb128::parse_uleb128, Parseable};

#[derive(Debug, Clone, PartialEq)]
pub struct Index(pub u32);

#[derive(Debug)]
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

pub type LabelIndex = Index;
pub type LabelIndexError = IndexError;

pub type GlobalIndex = Index;
pub type GlobalIndexError = IndexError;

pub type TypeIndex = Index;
pub type TypeIndexError = IndexError;

pub type LocalIndex = Index;
pub type LocalIndexError = IndexError;

pub type TableIndex = Index;
pub type TableIndexError = IndexError;
