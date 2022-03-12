use super::Mapper;

/// This represents a Pointer to a Physical Address not a Virtual Address, meaning that we cant
/// directly access this Address but instead need to translate it first to a Virtual Address by
/// some Mapping that the User can specify themselves depending on their setup
#[derive(Debug, Clone, Copy)]
pub struct PhysicalPtr(u64);

impl PhysicalPtr {
    /// Creates a new PhysicalPtr from the given raw Address
    pub fn new(ptr: u64) -> Self {
        Self(ptr)
    }

    /// Translates the PhysicalPtr to a Virtual Ptr using the given Mapper
    pub fn translate<M>(&self, mapper: &M) -> VirtualPtr
    where
        M: Mapper,
    {
        let addr = mapper.map(self.0);
        VirtualPtr::new(addr)
    }

    /// Adds the given Offset to the PhysicalPtr
    pub fn add_raw(&self, offset: u64) -> Self {
        Self::new(self.0 + offset)
    }
}

/// This represents a Pointer to a Virtual Address that can actually be used for Accessing the
/// Memory
#[derive(Debug, Clone, Copy)]
pub struct VirtualPtr(u64);

impl VirtualPtr {
    fn new(ptr: u64) -> Self {
        Self(ptr)
    }

    /// Adds the raw Offset to the underlying Pointer
    pub fn add_raw(&self, offset: u64) -> Self {
        Self::new(self.0 + offset)
    }

    /// Reads the Type T from the Location pointed to by this Pointer
    pub unsafe fn read<T>(&self) -> T {
        let ptr = self.0 as *const T;
        unsafe { ptr.read() }
    }

    pub fn as_ptr<T>(&self) -> *const T {
        self.0 as *const T
    }
}
