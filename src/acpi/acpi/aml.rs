use crate::println;

// https://uefi.org/specs/ACPI/6.4/20_AML_Specification/AML_Specification.html#aml-byte-stream-byte-values

fn parse_pkg_length<I>(iter: &mut I) -> Option<usize>
where
    I: Iterator<Item = u8>,
{
    let initial = iter.next()?;
    println!("Initial Length: {:08b}", initial);

    let used_other_bytes = initial >> 6;
    match used_other_bytes {
        0 => Some((initial & 0b00011111) as usize - 1),
        1 => {
            let next_bytes = iter.next()? as u64;
            println!("Next-Bytes: {:?}", next_bytes);

            let result = next_bytes << 4 | (initial as u64 & 0x0f);
            Some(result as usize - 2)
        }
        2 => {
            todo!()
        }
        3 => {
            todo!()
        }
        _ => unreachable!(),
    }
}

fn parse_namepath<I>(iter: &mut I)
where
    I: Iterator<Item = u8>,
{
    let initial = iter.next().unwrap();

    match initial {
        0x2e => {
            todo!("Dual Name Path");
        }
        0x2f => {
            todo!("Multi Name Path");
        }
        0x00 => {
            todo!("Null Name Path");
        }
        other => {
            todo!("NameSeg")
        }
    };
}

pub fn parse(content: &[u8]) {
    let mut bytes = content.iter().map(|b| *b);

    while let Some(leading) = bytes.next() {
        match leading {
            0x10 => {
                println!("Handle ScopeOp");
                let length = parse_pkg_length(&mut bytes).unwrap();
                println!("Length: {}", length);

                let mut inner_iter = bytes.by_ref().take(length).peekable();

                let leading_name_byte = inner_iter.peek().unwrap();
                match leading_name_byte {
                    0x5c => {
                        println!("Root-Char");
                        let _ = inner_iter.next();

                        parse_namepath(&mut inner_iter);
                    }
                    other => {
                        println!("Leading Name-Byte: {:x}", other);
                    }
                };

                for inner in inner_iter {
                    println!("0x{:x}", inner);
                }
            }
            other => {
                println!("Unknown Leading OP: 0x{:x}", other);
            }
        };
    }
}
