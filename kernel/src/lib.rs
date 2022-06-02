#![no_std]
#![deny(unsafe_op_in_unsafe_fn)]

use core::{future::Future, pin::Pin, task::Poll};

use alloc::{boxed::Box, sync::Arc, vec::Vec};

extern crate alloc;

mod task;
use task::Task;

mod handle;
pub use handle::Handle;

/// Extensions allow you to add custom parts to the Kernel to enable new Things, like networking
pub trait Extension<H> {
    /// Setups the Extension and the returned Future
    fn setup(self, kernel: &Kernel<H>, hardware: &H)
        -> Pin<Box<dyn Future<Output = ()> + 'static>>;
}

#[derive(Debug, Clone, PartialEq)]
pub(crate) struct TaskID {
    id: usize,
}

#[derive(Clone)]
struct RunQueueSender {
    sender: Arc<nolock::queues::mpsc::jiffy::Sender<TaskID>>,
}

struct RunQueueReceiver {
    recv: nolock::queues::mpsc::jiffy::Receiver<TaskID>,
}

pub struct Kernel<H> {
    queue: RunQueueReceiver,
    queue_sender: RunQueueSender,
    tasks: Vec<Task>,
    handle: Handle,
    task_add_queue: nolock::queues::mpsc::jiffy::Receiver<Task>,

    hardware: H,
}

impl<H> Kernel<H> {
    pub fn setup(hardware: H) -> Self {
        let (raw_recv, raw_sender) = nolock::queues::mpsc::jiffy::queue();
        let queue_sender = RunQueueSender {
            sender: Arc::new(raw_sender),
        };
        let queue_receiver = RunQueueReceiver { recv: raw_recv };

        let (add_task_recv, add_task_send) = nolock::queues::mpsc::jiffy::queue();

        let handle = Handle::new(add_task_send, queue_sender.clone());

        Self {
            queue: queue_receiver,
            queue_sender,
            tasks: Vec::new(),
            handle,
            task_add_queue: add_task_recv,
            hardware,
        }
    }

    pub fn handle(&self) -> Handle {
        self.handle.clone()
    }

    pub fn add_extension<E>(&self, extension: E)
    where
        E: Extension<H>,
    {
        let ext_task = extension.setup(self, &self.hardware);
        self.handle.add_raw_task(ext_task);
    }

    pub fn hardware(&self) -> &H {
        &self.hardware
    }

    pub fn run(mut self) {
        loop {
            let run_id = match self.queue.recv.dequeue() {
                Some(e) => e,
                None => {
                    tracing::error!("Queue was closed");
                    return;
                }
            };

            while let Ok(n_task) = self.task_add_queue.try_dequeue() {
                self.tasks.push(n_task);
            }

            let entry = match self.tasks.iter_mut().find(|task| task.id == run_id) {
                Some(e) => e,
                None => {
                    tracing::error!("Task no longer available: {:?}", run_id);
                    continue;
                }
            };

            match entry.run(&self.queue_sender) {
                Poll::Ready(_) => {
                    tracing::error!("Done with Task");
                }
                Poll::Pending => {}
            };
        }
    }
}
