use core::{future::Future, pin::Pin};

use alloc::{boxed::Box, vec::Vec};

use super::{HandleOpStack, StackValue};

pub trait ExternalHandler: Sized {
    /// Whether or not the current Handler handles the external function with the given name
    fn handles(&self, name: &str) -> bool;

    /// The current Handler should handle the external function with the given name and gets given
    /// the current OpStack to get its arguments from for further processing
    fn handle(
        &mut self,
        name: &str,
        op_stack: HandleOpStack<'_>,
    ) -> Pin<Box<dyn Future<Output = Vec<StackValue>>>>;

    fn switch<S>(self, sw: S) -> ExternalHandlerSwitch<S, Self>
    where
        S: Fn() -> bool,
    {
        ExternalHandlerSwitch {
            switch: sw,
            inner: self,
        }
    }

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
        _: HandleOpStack<'_>,
    ) -> Pin<Box<dyn Future<Output = Vec<StackValue>>>> {
        Box::pin(async move { Vec::new() })
    }
}

pub struct ExternalHandlerSwitch<S, I> {
    switch: S,
    inner: I,
}

pub struct ExternalHandlerChain<F, S> {
    first: F,
    second: S,
}

pub struct ExternalHandlerConstant<F> {
    name: &'static str,
    func: F,
}
impl<F, FF> ExternalHandlerConstant<F>
where
    F: FnMut(HandleOpStack<'_>) -> FF,
    FF: Future<Output = Vec<StackValue>> + 'static,
{
    pub fn new(name: &'static str, func: F) -> Self {
        Self { name, func }
    }
}
impl<F, FF> ExternalHandler for ExternalHandlerConstant<F>
where
    F: FnMut(HandleOpStack<'_>) -> FF,
    FF: Future<Output = Vec<StackValue>> + 'static,
{
    fn handles(&self, name: &str) -> bool {
        self.name == name
    }

    fn handle(
        &mut self,
        _: &str,
        op_stack: HandleOpStack<'_>,
    ) -> Pin<Box<dyn Future<Output = Vec<StackValue>>>> {
        let result = (self.func)(op_stack);
        Box::pin(result)
    }
}
