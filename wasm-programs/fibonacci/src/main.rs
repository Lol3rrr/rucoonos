#[no_mangle]
pub extern "C" fn fib_recursive(n: i32) -> u64 {
    if n < 0 {
        panic!("What");
    }
    match n {
        0 => panic!("What"),
        1 | 2 => 1,
        _ => fib_recursive(n - 1) + fib_recursive(n - 2),
    }
}

#[no_mangle]
pub extern "C" fn fib_iterative(n: i32) -> u64 {
    if n < 0 {
        panic!("{} is negative!", n);
    } else if n == 0 {
        panic!("zero is not a right argument to fibonacci()!");
    } else if n == 1 {
        return 1;
    }

    let mut sum = 0;
    let mut last = 0;
    let mut curr = 1;
    for _i in 1..n {
        sum = last + curr;
        last = curr;
        curr = sum;
    }
    sum
}

fn main() {
    println!("Hello, world!");
}
