pub fn parse_uleb128<R, I>(mut bytes: I) -> Option<R>
where
    R: Default
        + From<u8>
        + core::ops::BitOrAssign
        + core::ops::BitAnd<Output = R>
        + core::ops::Shl<i32, Output = R>,
    I: Iterator<Item = u8>,
{
    let mut result: R = Default::default();
    let mut shift = 0;

    loop {
        let byte = bytes.next()?;
        let byte_r: R = byte.into();
        result |= (byte_r & 0x7fu8.into()) << shift;

        if (byte & 0x80) == 0 {
            break;
        }

        shift += 7;
    }

    Some(result)
}

pub trait SignedLeb128:
    Default
    + From<u8>
    + core::ops::Not<Output = Self>
    + core::ops::BitOrAssign
    + core::ops::BitAnd<Output = Self>
    + core::ops::Shl<i32, Output = Self>
{
    fn bits() -> i32;
}

pub fn parse_ileb128<R, I>(mut bytes: I) -> Option<R>
where
    R: SignedLeb128,
    I: Iterator<Item = u8>,
{
    let mut result: R = Default::default();
    let mut shift = 0;

    let size = R::bits();

    let mut byte;
    loop {
        byte = bytes.next()?;
        let low_order_bit: R = (byte & 0x7f).into();
        result |= low_order_bit << shift;
        shift += 7;

        if byte & 0x80 == 0 {
            break;
        }
    }

    if shift < size && byte & 0x40 != 0 {
        result |= !R::default() << shift;
    }

    Some(result)
}

impl SignedLeb128 for i32 {
    fn bits() -> i32 {
        32
    }
}
impl SignedLeb128 for i64 {
    fn bits() -> i32 {
        64
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn simple() {
        let bytes = [0xC0, 0xBB, 0x78];

        let result: i32 = parse_ileb128(bytes.into_iter()).unwrap();

        assert_eq!(-123456, result);
    }
}
