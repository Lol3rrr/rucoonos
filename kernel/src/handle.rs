use core::{
    future::Future,
    pin::Pin,
    sync::atomic::{AtomicUsize, Ordering},
};

use alloc::{boxed::Box, sync::Arc};

use crate::{task::Task, RunQueueSender, TaskID};

#[derive(Clone)]
pub struct Handle {
    add_queue: Arc<nolock::queues::mpsc::jiffy::Sender<Task>>,
    run_queue: RunQueueSender,
    id_count: Arc<AtomicUsize>,
}

impl Handle {
    pub(crate) fn new(
        queue: nolock::queues::mpsc::jiffy::Sender<Task>,
        r_queue: RunQueueSender,
    ) -> Self {
        Self {
            add_queue: Arc::new(queue),
            run_queue: r_queue,
            id_count: Arc::new(AtomicUsize::new(0)),
        }
    }

    pub fn add_task<F>(&self, fut: F)
    where
        F: Future<Output = ()> + 'static,
    {
        let task_id = self.id_count.fetch_add(1, Ordering::SeqCst);

        let task = Task::new(TaskID { id: task_id }, fut);

        let _ = self.add_queue.enqueue(task);
        let _ = self.run_queue.sender.enqueue(TaskID { id: task_id });
    }

    pub(crate) fn add_raw_task(&self, fut: Pin<Box<dyn Future<Output = ()>>>) {
        let task_id = self.id_count.fetch_add(1, Ordering::SeqCst);

        let task = Task::new_raw(TaskID { id: task_id }, fut);

        let _ = self.add_queue.enqueue(task);
        let _ = self.run_queue.sender.enqueue(TaskID { id: task_id });
    }
}
