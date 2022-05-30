fn func(val: i32) -> i32 {
    val + 3
}

#[no_mangle]
pub extern "C" fn example() -> i32 {
    let tmp = 3;
    func(tmp)
}

fn main() {
    example();
}
