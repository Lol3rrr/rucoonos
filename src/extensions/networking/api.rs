use core::{future::Future, sync::atomic::AtomicBool};

use alloc::sync::Arc;

use super::{ActionRequest, HandlerMessage, HANDLE_QUEUE};

/// Find the MAC-Address of the given IP-Address
pub async fn get_mac(ip: [u8; 4]) -> Option<[u8; 6]> {
    let queue = HANDLE_QUEUE.get().expect("");

    let (mut recv, send) = nolock::queues::spsc::bounded::async_queue(2);

    queue
        .enqueue(HandlerMessage::Action(ActionRequest::SendArpRequest {
            ip,
            ret_queue: send,
        }))
        .ok()?;

    recv.dequeue().await.ok()
}

pub fn raw_ping(ip: [u8; 4], mac: [u8; 6]) -> impl Future<Output = ()> {
    PingFuture {
        ip: Some(ip),
        mac: Some(mac),
        send: false,
        returned: Arc::new(AtomicBool::new(false)),
    }
}

pub struct PingFuture {
    ip: Option<[u8; 4]>,
    mac: Option<[u8; 6]>,
    send: bool,
    returned: Arc<AtomicBool>,
}

impl Future for PingFuture {
    type Output = ();

    fn poll(
        mut self: core::pin::Pin<&mut Self>,
        cx: &mut core::task::Context<'_>,
    ) -> core::task::Poll<Self::Output> {
        if self.returned.load(core::sync::atomic::Ordering::SeqCst) {
            return core::task::Poll::Ready(());
        }

        if !self.send {
            let queue = HANDLE_QUEUE.get().expect("");

            let mac = self.mac.take().expect("");
            let ip = self.ip.take().expect("");

            let _ = queue.enqueue(HandlerMessage::Action(ActionRequest::PingRequest {
                waker: cx.waker().clone(),
                ip,
                mac,
                result: self.returned.clone(),
            }));

            self.send = true;
        }

        core::task::Poll::Pending
    }
}
