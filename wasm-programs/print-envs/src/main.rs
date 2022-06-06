fn main() {
    println!("Started");
    for (key, value) in std::env::vars() {
        println!("{}", key);
        println!("{}", value)
    }
}
