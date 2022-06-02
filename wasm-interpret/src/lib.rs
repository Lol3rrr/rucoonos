//! [WASM Spec](https://webassembly.github.io/spec/core/intro/index.html)
//! [WASI C Header](https://github.com/WebAssembly/wasi-libc/blob/main/libc-bottom-half/headers/public/wasi/api.h)

#![cfg_attr(not(test), no_std)]
#![deny(unsafe_op_in_unsafe_fn)]
extern crate alloc;

// https://webassembly.github.io/spec/core/binary/modules.html#binary-typesec

pub mod vm;

pub mod wasi;
