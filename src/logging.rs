/// The logging works by having two mostly seperated components, the Writer and the Subscriber.
///
/// # Writer
/// The Writer is a simple "Process" that waits for things to output. It receives Data from the
/// Queue and then writes that, with the correct Formatting, out.
///
/// # Subscriber
/// The Subscriber simply takes all the tracing information and converts the Information into
/// their corresponding Events to send over the Queue to the Writer
///
/// # Benefits
/// Decoupling these Parts allows for easy seperation of concerns and means that logging should be
/// very fast as we only need to add the correct Data to the Queue, which requires little extra
/// synchronization.
/// In general this avoids any form of locking and can therefore not cause any deadlocks or other
/// weird synchronization problems
///
/// # Problems
/// The asynchronous nature of this design also poses the Problem that in the Event of a crash
/// or other Problem, the already written Logs might not contain all the logs and there may be
/// some pending Logs in the Queue.
/// This might be solveable by allowing the Panic-Handler to hook into the Queue and force output
/// all the pending logs.
use core::{
    fmt::Write,
    future::Future,
    sync::atomic::{AtomicU64, Ordering},
};

use alloc::{collections::BTreeMap, string::String, vec::Vec};

use crate::println;

mod level;
pub use level::LogLevel;

#[derive(Debug)]
enum SubscriberMessage {
    NewSpan {
        id: tracing::span::Id,
        name: &'static str,
    },
    Enter(tracing::span::Id),
    Exit(tracing::span::Id),
    Event {
        content: String,
        level: LogLevel,
    },
}

pub struct SerialSubscriber {
    writer: nolock::queues::mpsc::jiffy::AsyncSender<SubscriberMessage>,
    id_counter: AtomicU64,
    level: LogLevel,
}

struct Visitor<'s> {
    content: &'s mut String,
}

impl<'s> tracing::field::Visit for Visitor<'s> {
    fn record_debug(&mut self, field: &tracing::field::Field, value: &dyn alloc::fmt::Debug) {
        if field.name() == "message" {
            let _ = write!(self.content, "{:?}", value);
        }
    }
}

impl tracing::Subscriber for SerialSubscriber {
    fn enabled(&self, metadata: &tracing::Metadata<'_>) -> bool {
        let m_level: LogLevel = metadata.level().into();
        m_level >= self.level
    }

    fn new_span(&self, span: &tracing::span::Attributes<'_>) -> tracing::span::Id {
        let id = tracing::span::Id::from_u64(self.id_counter.fetch_add(1, Ordering::SeqCst));
        let name = span.metadata().name();
        self.writer
            .enqueue(SubscriberMessage::NewSpan {
                id: id.clone(),
                name,
            })
            .expect("The Queue should always work");
        id
    }

    fn record(&self, _span: &tracing::span::Id, _values: &tracing::span::Record<'_>) {}

    fn record_follows_from(&self, _span: &tracing::span::Id, _follows: &tracing::span::Id) {}

    fn event(&self, event: &tracing::Event<'_>) {
        let mut content = String::new();
        let mut visitor = Visitor {
            content: &mut content,
        };

        event.record(&mut visitor);

        self.writer
            .enqueue(SubscriberMessage::Event {
                content,
                level: event.metadata().level().into(),
            })
            .expect("The Queue should always work");
    }

    fn enter(&self, span: &tracing::span::Id) {
        self.writer
            .enqueue(SubscriberMessage::Enter(span.clone()))
            .expect("The Queue should always work");
    }

    fn exit(&self, span: &tracing::span::Id) {
        self.writer
            .enqueue(SubscriberMessage::Exit(span.clone()))
            .expect("The Queue should always work");
    }
}

pub fn serial(level: LogLevel) -> (SerialSubscriber, impl Future<Output = ()>) {
    let (recv, send) = nolock::queues::mpsc::jiffy::async_queue();

    (
        SerialSubscriber {
            writer: send,
            id_counter: AtomicU64::new(1),
            level,
        },
        logger(recv),
    )
}

async fn logger(mut queue: nolock::queues::mpsc::jiffy::AsyncReceiver<SubscriberMessage>) {
    let mut span_names: BTreeMap<u64, &'static str> = BTreeMap::new();

    let mut current_name: Vec<&'static str> = Vec::new();
    loop {
        let entry = match queue.dequeue().await {
            Ok(e) => e,
            Err(_) => continue,
        };

        match entry {
            SubscriberMessage::NewSpan { id, name } => {
                span_names.insert(id.into_u64(), name);
            }
            SubscriberMessage::Enter(id) => {
                if let Some(name) = span_names.get(&id.into_u64()) {
                    current_name.push(name);
                }
            }
            SubscriberMessage::Exit(id) => {
                let exit_name = match span_names.get(&id.into_u64()) {
                    Some(n) => n,
                    None => continue,
                };
                if let Some(last) = current_name.last() {
                    if last == exit_name {
                        current_name.pop();
                    }
                }
            }
            SubscriberMessage::Event { content, level } => {
                let name = current_name.last().copied().unwrap_or("");

                println!("[{}][{}] {}", level, name, content);
            }
        };
    }
}
