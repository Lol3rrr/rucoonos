use core::{future::Future, marker::PhantomData, pin::Pin};

use alloc::{boxed::Box, vec::Vec};

use super::{state::OpStack, StackValue};

#[derive(Debug)]
pub enum HandleError {}

/// A Handler represents a way to provide external Functions to a WASM environment
pub trait ExternalHandler: Sized {
    /// Whether or not the current Handler handles the external function with the given name
    fn handles(&self, name: &str) -> bool;

    /// The current Handler should handle the external function with the given name and gets given
    /// the current OpStack to get its arguments from for further processing
    fn handle(
        &mut self,
        name: &str,
        args: HandleArguments<'_>,
        mem: HandleMemory<'_>,
    ) -> Result<Pin<Box<dyn Future<Output = Vec<StackValue>>>>, HandleError>;

    /// Chain `self` and `other` together.
    ///
    /// # Behaviour
    /// If self  handles a given External Function, we use self to handle it.
    /// If other handles a given External Function, we use other to handle it.
    ///
    /// If both handle a function we prefer self over other as it is the first entry
    fn chain<O>(self, other: O) -> ExternalHandlerChain<Self, O>
    where
        O: ExternalHandler,
    {
        ExternalHandlerChain {
            first: self,
            second: other,
        }
    }
}

pub struct ExternalHandlerEmpty {}
pub fn empty_handler() -> ExternalHandlerEmpty {
    ExternalHandlerEmpty {}
}

impl ExternalHandler for ExternalHandlerEmpty {
    fn handles(&self, _: &str) -> bool {
        false
    }

    fn handle(
        &mut self,
        _: &str,
        _: HandleArguments<'_>,
        _: HandleMemory<'_>,
    ) -> Result<Pin<Box<dyn Future<Output = Vec<StackValue>>>>, HandleError> {
        Ok(Box::pin(async move { Vec::new() }))
    }
}

pub struct ExternalHandlerChain<F, S> {
    first: F,
    second: S,
}

impl<F, S> ExternalHandler for ExternalHandlerChain<F, S>
where
    F: ExternalHandler,
    S: ExternalHandler,
{
    fn handles(&self, name: &str) -> bool {
        self.first.handles(name) || self.second.handles(name)
    }

    fn handle(
        &mut self,
        name: &str,
        args: HandleArguments<'_>,
        mem: HandleMemory<'_>,
    ) -> Result<Pin<Box<dyn Future<Output = Vec<StackValue>>>>, HandleError> {
        if self.first.handles(name) {
            return self.first.handle(name, args, mem);
        }

        if self.second.handles(name) {
            return self.second.handle(name, args, mem);
        }

        Ok(Box::pin(async move { Vec::new() }))
    }
}

pub struct ExternalHandlerConstant<F> {
    name: &'static str,
    func: F,
}
impl<F, FF> ExternalHandlerConstant<F>
where
    F: FnMut(HandleArguments<'_>, HandleMemory<'_>) -> FF,
    FF: Future<Output = Vec<StackValue>> + 'static,
{
    pub fn new(name: &'static str, func: F) -> Self {
        Self { name, func }
    }
}
impl<F, FF> ExternalHandler for ExternalHandlerConstant<F>
where
    F: FnMut(HandleArguments<'_>, HandleMemory<'_>) -> FF,
    FF: Future<Output = Vec<StackValue>> + 'static,
{
    fn handles(&self, name: &str) -> bool {
        self.name == name
    }

    fn handle(
        &mut self,
        _: &str,
        args: HandleArguments<'_>,
        mem: HandleMemory<'_>,
    ) -> Result<Pin<Box<dyn Future<Output = Vec<StackValue>>>>, HandleError> {
        let result = (self.func)(args, mem);
        Ok(Box::pin(result))
    }
}

pub struct FallibleExternalHandler<F, FF> {
    name: &'static str,
    func: F,
    _marker: PhantomData<FF>,
}
impl<F, FF> FallibleExternalHandler<F, FF>
where
    F: FnMut(HandleArguments<'_>, HandleMemory<'_>) -> Result<FF, ()>,
    FF: Future<Output = Vec<StackValue>> + 'static,
{
    pub fn new(name: &'static str, func: F) -> Self {
        Self {
            name,
            func,
            _marker: PhantomData {},
        }
    }
}
impl<F, FF> ExternalHandler for FallibleExternalHandler<F, FF>
where
    F: FnMut(HandleArguments<'_>, HandleMemory<'_>) -> Result<FF, HandleError>,
    FF: Future<Output = Vec<StackValue>> + 'static,
{
    fn handles(&self, name: &str) -> bool {
        self.name == name
    }

    fn handle(
        &mut self,
        _: &str,
        args: HandleArguments<'_>,
        mem: HandleMemory<'_>,
    ) -> Result<Pin<Box<dyn Future<Output = Vec<StackValue>>>>, HandleError> {
        (self.func)(args, mem)
            .map(|f| Box::pin(f) as Pin<Box<dyn Future<Output = Vec<StackValue>>>>)
    }
}

pub struct HandleArguments<'s> {
    pub(crate) stack: &'s mut OpStack,
    pub(crate) arguments: usize,
}

impl<'s> HandleArguments<'s> {
    /// The Number of Arguments passed to the Funtion
    pub fn len(&self) -> usize {
        self.arguments
    }
    pub fn is_empty(&self) -> bool {
        self.arguments == 0
    }

    /// Gets the n-th Argument for the Function in the correct Order, according to the Function
    /// Definition
    pub fn get<'o>(&'o self, index: usize) -> Option<&'s StackValue>
    where
        'o: 's,
    {
        let target_index = self.stack.len() - self.arguments + index;
        self.stack.get(target_index)
    }
}

pub struct HandleMemory<'s> {
    pub(crate) memory: &'s mut Vec<u8>,
}

impl<'s> HandleMemory<'s> {
    pub fn grow(&mut self, n_size: usize) {
        if self.memory.len() >= n_size {
            return;
        }

        self.memory.resize(n_size, 0);
    }

    pub fn as_bytes(&self) -> &[u8] {
        &self.memory
    }

    pub fn writestr(&mut self, addr: u32, data: &str) -> Result<(), ()> {
        let raw = data.as_bytes();

        if self.memory.len() < addr as usize + raw.len() {
            return Err(());
        }

        self.memory[addr as usize..addr as usize + raw.len()].copy_from_slice(raw);
        Ok(())
    }
    pub fn writei32(&mut self, addr: u32, data: i32) -> Result<(), ()> {
        let raw = data.to_le_bytes();

        if self.memory.len() < addr as usize + 4 {
            return Err(());
        }

        self.memory[addr as usize..addr as usize + 4].copy_from_slice(&raw);
        Ok(())
    }

    pub fn writeu32(&mut self, addr: u32, data: u32) -> Result<(), ()> {
        let raw = data.to_le_bytes();

        if self.memory.len() < addr as usize + 4 {
            return Err(());
        }

        self.memory[addr as usize..addr as usize + 4].copy_from_slice(&raw);
        Ok(())
    }

    /// Attempts to read a Type from the Data at the given Address
    ///
    /// # Safety
    /// TODO
    pub unsafe fn read_raw<'o, 't, T>(&'o self, addr: usize) -> Option<&'t T>
    where
        'o: 't,
    {
        let t_size = core::mem::size_of::<T>();
        if self.memory.len() < addr + t_size {
            return None;
        }

        let raw_memory = self.as_bytes();

        let target_slice = &raw_memory[addr..addr + t_size];
        let target_ptr = target_slice.as_ptr();

        Some(unsafe { &*(target_ptr as *const T) })
    }
}
