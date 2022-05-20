use core::{
    future::Future,
    pin::Pin,
    task::{Context, RawWaker, RawWakerVTable},
};

use alloc::boxed::Box;

use crate::{RunQueueSender, TaskID};

struct InternalWaker {
    queue: RunQueueSender,
    id: TaskID,
}

/// A Task is like a Process
pub struct Task {
    /// The ID of the Task
    pub(crate) id: TaskID,
    /// The Future to run
    future: Pin<Box<dyn Future<Output = ()>>>,
}

impl Task {
    pub(crate) fn new<F>(id: TaskID, fut: F) -> Self
    where
        F: Future<Output = ()> + 'static,
    {
        Self {
            id,
            future: Box::pin(fut),
        }
    }

    pub(crate) fn new_raw(id: TaskID, fut: Pin<Box<dyn Future<Output = ()>>>) -> Self {
        Self { id, future: fut }
    }

    pub(crate) fn run(&mut self, run_queue: &RunQueueSender) -> core::task::Poll<()> {
        let waker = create_waker(run_queue.clone(), self.id.clone());
        let mut context = Context::from_waker(&waker);

        self.future.as_mut().poll(&mut context)
    }
}

impl InternalWaker {
    unsafe fn ptr_ref(raw: *const ()) -> &'static Self {
        let ptr: *const Self = raw as *const Self;
        unsafe { &*ptr }
    }
}

unsafe fn clone(ptr: *const ()) -> RawWaker {
    let waker = unsafe { InternalWaker::ptr_ref(ptr) };

    let n_waker = Box::new(InternalWaker {
        queue: waker.queue.clone(),
        id: waker.id.clone(),
    });
    let n_waker_ptr = Box::into_raw(n_waker);

    RawWaker::new(n_waker_ptr as *const (), &VTABLE)
}
unsafe fn wake(ptr: *const ()) {
    let waker = unsafe { InternalWaker::ptr_ref(ptr) };
    waker.queue.sender.enqueue(waker.id.clone()).unwrap();
}
unsafe fn wake_by_ref(ptr: *const ()) {
    let waker = unsafe { InternalWaker::ptr_ref(ptr) };
    waker.queue.sender.enqueue(waker.id.clone()).unwrap();
}
unsafe fn drop(ptr: *const ()) {
    let w_ptr = ptr as *mut InternalWaker;
    unsafe {
        let _ = Box::from_raw(w_ptr);
    }
}

const VTABLE: RawWakerVTable = RawWakerVTable::new(clone, wake, wake_by_ref, drop);

fn create_waker(queue: RunQueueSender, id: TaskID) -> core::task::Waker {
    let waker = Box::new(InternalWaker { queue, id });
    let waker_ptr = Box::into_raw(waker);
    let raw = core::task::RawWaker::new(waker_ptr as *const (), &VTABLE);
    unsafe { core::task::Waker::from_raw(raw) }
}
