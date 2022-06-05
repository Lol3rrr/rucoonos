pub struct AsyncMutex<T> {
    mutex: spin::Mutex<T>,
}

// #[must_not_suspend]
pub struct AsyncMutexGuard<'m, T> {
    guard: spin::MutexGuard<'m, T>,
}

impl<T> AsyncMutex<T> {
    pub async fn lock(&self) -> AsyncMutexGuard<'_, T> {
        loop {
            if let Some(guard) = self.mutex.try_lock() {
                return AsyncMutexGuard { guard };
            }

            rucoon::futures::yield_now().await;
        }
    }

    pub fn try_lock(&self) -> Option<AsyncMutexGuard<'_, T>> {
        self.mutex.try_lock().map(|guard| AsyncMutexGuard { guard })
    }
}
