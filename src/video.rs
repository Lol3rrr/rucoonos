use bootloader::boot_info::{FrameBuffer, FrameBufferInfo};

/// Holds the information about the Framebuffer
static INFO: spin::Once<FrameBufferInfo> = spin::Once::new();
/// The actual raw underlying Framebuffer
static BUFFER: spin::Once<spin::Mutex<&'static mut [u8]>> = spin::Once::new();

pub fn init(buffer: &'static mut FrameBuffer) {
    INFO.call_once(|| buffer.info());
    BUFFER.call_once(|| spin::Mutex::new(buffer.buffer_mut()));
}

/// Draws the given Color on screen at the given coordinates
pub fn draw(x: usize, y: usize, color: Color) {
    let raw_buffer = match BUFFER.poll() {
        Some(b) => b,
        None => return,
    };
    let info = INFO.poll().unwrap();

    let start = y * info.horizontal_resolution * info.bytes_per_pixel + x * info.bytes_per_pixel;

    if info.byte_len <= start + info.bytes_per_pixel {
        return;
    }

    x86_64::instructions::interrupts::without_interrupts(|| {
        let mut locked = raw_buffer.lock();

        *(locked.get_mut(start).unwrap()) = color.red;
        *(locked.get_mut(start + 1).unwrap()) = color.green;
        *(locked.get_mut(start + 2).unwrap()) = color.blue;
    });
}

/// Holds color information for a single Pixel
pub struct Color {
    /// The Red Color channel
    pub red: u8,
    /// The Green Color channel
    pub green: u8,
    /// The Blue Color channel
    pub blue: u8,
}
