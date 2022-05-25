use crate::{leb128::parse_uleb128, Export, Import, Section, SectionError};

use alloc::vec::Vec;

#[derive(Debug)]
pub struct Module {
    sections: Vec<Section>,
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

    pub fn sections(&self) -> impl Iterator<Item = &Section> + '_ {
        self.sections.iter()
    }

    pub fn imports(&self) -> impl Iterator<Item = &Import> + '_ {
        self.sections
            .iter()
            .filter_map(|sect| match sect {
                Section::ImportSection(s) => Some(s),
                _ => None,
            })
            .flat_map(|s| s.items.iter())
    }

    pub fn exports(&self) -> impl Iterator<Item = &Export> + '_ {
        self.sections
            .iter()
            .filter_map(|sect| match sect {
                Section::ExportSection(e) => Some(e),
                _ => None,
            })
            .flat_map(|e| e.items.iter())
    }
}
