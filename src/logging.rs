use core::{
    fmt::{Display, Write},
    future::Future,
    sync::atomic::{AtomicU64, Ordering},
};

use alloc::{
    collections::BTreeMap,
    string::{String, ToString},
    vec::Vec,
};
use nolock::queues::mpsc::jiffy::AsyncReceiver;

use crate::println;

mod level;
pub use level::LogLevel;

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
            write!(self.content, "{:?}", value);
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
        self.writer.enqueue(SubscriberMessage::NewSpan {
            id: id.clone(),
            name,
        });
        id
    }

    fn record(&self, span: &tracing::span::Id, values: &tracing::span::Record<'_>) {}

    fn record_follows_from(&self, span: &tracing::span::Id, follows: &tracing::span::Id) {}

    fn event(&self, event: &tracing::Event<'_>) {
        let mut content = String::new();
        let mut visitor = Visitor {
            content: &mut content,
        };

        event.record(&mut visitor);

        self.writer.enqueue(SubscriberMessage::Event {
            content,
            level: event.metadata().level().into(),
        });
    }

    fn enter(&self, span: &tracing::span::Id) {
        self.writer.enqueue(SubscriberMessage::Enter(span.clone()));
    }

    fn exit(&self, span: &tracing::span::Id) {
        self.writer.enqueue(SubscriberMessage::Exit(span.clone()));
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
                current_name.pop();
            }
            SubscriberMessage::Event { content, level } => {
                let name = current_name.last().copied().unwrap_or("");

                println!("[{}][{}] {}", level, name, content);
            }
        };
    }
}
