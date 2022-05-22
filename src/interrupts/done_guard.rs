// TODO
// The Guard should will perform the notify end of interrupt for the PICS and therefore help to
// prevent that we forget to call it at the end and would cause the

use pic8259::ChainedPics;

/// This Guard can be used to make sure that once an interrupt by the PIC has been handled
/// we also notify it that it was handlded
pub struct InterruptDoneGuard<'p> {
    pics: &'p spin::Mutex<ChainedPics>,
    id: u8,
}

impl<'p> InterruptDoneGuard<'p> {
    /// Creates a new Guard for the given ID and the given PIC
    pub fn new(id: u8, pics: &'p spin::Mutex<ChainedPics>) -> Self {
        Self { id, pics }
    }
}

impl<'p> Drop for InterruptDoneGuard<'p> {
    fn drop(&mut self) {
        let mut p = self.pics.lock();

        unsafe {
            p.notify_end_of_interrupt(self.id);
        }
    }
}
