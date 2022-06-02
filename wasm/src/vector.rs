use alloc::vec::Vec;

use crate::{leb128::parse_uleb128, Parseable};

#[derive(Debug, Clone, PartialEq)]
pub struct Vector<C> {
    pub items: Vec<C>,
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
