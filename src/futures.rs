pub fn sleep_ms(duration: usize) -> impl core::future::Future<Output = ()> {
    rucoon::extensions::time::sleep(
        &crate::interrupts::TIMER,
        core::time::Duration::from_millis(duration as u64),
    )
}
