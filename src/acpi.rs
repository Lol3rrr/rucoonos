pub mod acpi;

mod ptr;
pub use ptr::*;

mod raw {
    #[repr(packed)]
    pub struct RSDP {
        pub signature: [u8; 8],
        pub checksum: u8,
        pub oemid: [u8; 6],
        pub revision: u8,
        pub rsdt_addr: u32,
    }
}

/// This Trait is used to Map a Physical Address to a Virtual one allowing the User to specify the
/// Translation Process/Method independently depending on their Setup
pub trait Mapper: Clone {
    /// This maps a Physical Address to a Virtual one
    fn map(&self, physical: u64) -> u64;
}

#[derive(Debug, Clone)]
pub struct OffsetMapper {
    offset: u64,
}

impl OffsetMapper {
    pub fn new(offset: u64) -> Self {
        Self { offset }
    }
}

impl Mapper for OffsetMapper {
    fn map(&self, physical: u64) -> u64 {
        physical + self.offset
    }
}

#[derive(Debug)]
pub struct RSDP {
    signature: [u8; 8],
    checksum: u8,
    oemid: [u8; 6],
    revision: u8,
    rsdt_addr: PhysicalPtr,
}

impl RSDP {
    pub unsafe fn load<M>(physical_ptr: PhysicalPtr, mapping: &M) -> Self
    where
        M: Mapper,
    {
        let target_ptr = physical_ptr.translate(mapping);
        let raw = unsafe { target_ptr.read::<raw::RSDP>() };

        Self {
            signature: raw.signature,
            checksum: raw.checksum,
            oemid: raw.oemid,
            revision: raw.revision,
            rsdt_addr: PhysicalPtr::new(raw.rsdt_addr as u64),
        }
    }

    pub unsafe fn load_rsdt<M>(&self, mapping: M) -> RSDT<M>
    where
        M: Mapper,
    {
        unsafe { RSDT::load(self.rsdt_addr.clone(), mapping) }
    }
}

#[repr(packed)]
pub struct SDTHeader {
    signature: [u8; 4],
    length: u32,
    revision: u8,
    checksum: u8,
    oemid: [u8; 6],
    oemtableid: [u8; 8],
    oemrevision: u32,
    creatorid: u32,
    creatorrevision: u32,
}

impl SDTHeader {
    unsafe fn load<M>(ptr: PhysicalPtr, mapping: &M) -> Self
    where
        M: Mapper,
    {
        let target_ptr = ptr.translate(mapping);
        unsafe { target_ptr.read::<Self>() }
    }

    pub fn signature(&self) -> &str {
        core::str::from_utf8(&self.signature).unwrap()
    }
}

pub struct RSDT<M> {
    header: SDTHeader,
    others: RSDTPointers<M>,
}

#[derive(Debug)]
pub struct RSDTPointers<M> {
    start: PhysicalPtr,
    size: usize,
    count: usize,
    mapping: M,
}

impl<M> RSDT<M>
where
    M: Mapper,
{
    unsafe fn load(ptr: PhysicalPtr, mapping: M) -> Self {
        let header = unsafe { SDTHeader::load(ptr, &mapping) };

        let signature_str = core::str::from_utf8(&header.signature).unwrap();

        let ptr_size = if signature_str == "XSDT" { 8 } else { 4 };

        let entries = (header.length as usize - core::mem::size_of::<SDTHeader>()) / ptr_size;

        let ptrs = RSDTPointers {
            start: ptr.add_raw(core::mem::size_of::<SDTHeader>() as u64),
            size: ptr_size,
            count: entries,
            mapping,
        };

        Self {
            header,
            others: ptrs,
        }
    }

    pub fn iter(&self) -> RSDTIter<'_, M> {
        RSDTIter {
            ptr: self.others.start,
            size: self.others.size as u64,
            left: self.others.count,
            mapping: &self.others.mapping,
        }
    }
}

pub struct RSDTIter<'m, M> {
    ptr: PhysicalPtr,
    size: u64,
    left: usize,
    mapping: &'m M,
}

impl<'m, M> Iterator for RSDTIter<'m, M>
where
    M: Mapper,
{
    type Item = (SDTHeader, PhysicalPtr);

    fn next(&mut self) -> Option<Self::Item> {
        if self.left == 0 {
            return None;
        }

        let virtual_current_ptr = self.ptr.translate(self.mapping);
        let raw_header_ptr = if self.size == 4 {
            PhysicalPtr::new(unsafe { virtual_current_ptr.read::<u32>() as u64 })
        } else {
            PhysicalPtr::new(unsafe { virtual_current_ptr.read::<u64>() })
        };

        let header = unsafe { SDTHeader::load(raw_header_ptr, self.mapping) };
        let rest_ptr = raw_header_ptr.add_raw(core::mem::size_of::<SDTHeader>() as u64);

        self.ptr = self.ptr.add_raw(self.size);
        self.left -= 1;

        Some((header, rest_ptr))
    }
}
