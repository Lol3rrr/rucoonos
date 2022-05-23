use super::{ActionRequest, HandlerMessage, HANDLE_QUEUE};

/// Find the MAC-Address of the given IP-Address
pub async fn get_mac(ip: [u8; 4]) -> Option<[u8; 6]> {
    let queue = HANDLE_QUEUE.get().expect("");

    let (mut recv, send) = nolock::queues::spsc::bounded::async_queue(1);

    queue
        .enqueue(HandlerMessage::Action(ActionRequest::SendArpRequest {
            ip,
            ret_queue: send,
        }))
        .ok()?;

    recv.dequeue().await.ok()
}
