(module
  (type $t0 (func))
  (type $t1 (func (param i32)))
  (type $t2 (func (param i32) (result i64)))
  (type $t3 (func (param i32 i32)))
  (type $t4 (func (param i32) (result i32)))
  (type $t5 (func (param i32 i32) (result i32)))
  (type $t6 (func (param i32 i32 i32)))
  (type $t7 (func (param i32 i32 i32) (result i32)))
  (type $t8 (func (param i32 i32 i32 i32) (result i32)))
  (type $t9 (func (result i32)))
  (type $t10 (func (param i32 i32 i32 i32)))
  (type $t11 (func (param i32 i32 i32 i32 i32)))
  (type $t12 (func (param i32 i32 i32 i32 i32 i32 i32) (result i32)))
  (type $t13 (func (param i32 i32 i32 i32 i32) (result i32)))
  (type $t14 (func (param i32 i32 i32 i32 i32 i32 i32)))
  (type $t15 (func (param i32 i32 i32 i32 i32 i32) (result i32)))
  (type $t16 (func (param i64 i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "fd_write" (func $_ZN4wasi13lib_generated22wasi_snapshot_preview18fd_write17hc06613fb873ea50eE (type $t8)))
  (import "wasi_snapshot_preview1" "environ_get" (func $__imported_wasi_snapshot_preview1_environ_get (type $t5)))
  (import "wasi_snapshot_preview1" "environ_sizes_get" (func $__imported_wasi_snapshot_preview1_environ_sizes_get (type $t5)))
  (import "wasi_snapshot_preview1" "proc_exit" (func $__imported_wasi_snapshot_preview1_proc_exit (type $t1)))
  (func $__wasm_call_ctors (type $t0)
    call $__wasilibc_initialize_environ_eagerly)
  (func $_start (type $t0)
    (local $l0 i32)
    block $B0
      call $__original_main
      local.tee $l0
      i32.eqz
      br_if $B0
      local.get $l0
      call $exit
      unreachable
    end)
  (func $fib_recursive (type $t2) (param $p0 i32) (result i64)
    (local $l1 i32) (local $l2 i64)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    block $B0
      local.get $p0
      i32.const 0
      i32.lt_s
      br_if $B0
      i64.const 0
      local.set $l2
      block $B1
        block $B2
          loop $L3
            block $B4
              local.get $p0
              br_table $B2 $B1 $B1 $B4
            end
            local.get $p0
            i32.const -1
            i32.add
            call $fib_recursive
            local.get $l2
            i64.add
            local.set $l2
            local.get $p0
            i32.const -2
            i32.add
            local.set $p0
            br $L3
          end
        end
        local.get $l1
        i32.const 28
        i32.add
        i32.const 0
        i32.store
        local.get $l1
        i32.const 1048576
        i32.store offset=24
        local.get $l1
        i64.const 1
        i64.store offset=12 align=4
        local.get $l1
        i32.const 1048580
        i32.store offset=8
        local.get $l1
        i32.const 8
        i32.add
        i32.const 1048640
        call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
        unreachable
      end
      local.get $l1
      i32.const 32
      i32.add
      global.set $__stack_pointer
      local.get $l2
      i64.const 1
      i64.add
      return
    end
    local.get $l1
    i32.const 28
    i32.add
    i32.const 0
    i32.store
    local.get $l1
    i32.const 1048576
    i32.store offset=24
    local.get $l1
    i64.const 1
    i64.store offset=12 align=4
    local.get $l1
    i32.const 1048580
    i32.store offset=8
    local.get $l1
    i32.const 8
    i32.add
    i32.const 1048624
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $fib_iterative (type $t2) (param $p0 i32) (result i64)
    (local $l1 i32) (local $l2 i64) (local $l3 i32) (local $l4 i32) (local $l5 i64) (local $l6 i64)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    local.get $l1
    local.get $p0
    i32.store offset=12
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              local.get $p0
              i32.const 0
              i32.lt_s
              br_if $B4
              i64.const 1
              local.set $l2
              block $B5
                local.get $p0
                br_table $B3 $B0 $B5
              end
              local.get $p0
              i32.const -1
              i32.add
              local.tee $l3
              i32.const 7
              i32.and
              local.set $l4
              local.get $p0
              i32.const -2
              i32.add
              i32.const 7
              i32.ge_u
              br_if $B2
              i64.const 1
              local.set $l2
              i64.const 0
              local.set $l5
              br $B1
            end
            local.get $l1
            i32.const 44
            i32.add
            i32.const 1
            i32.store
            local.get $l1
            i64.const 2
            i64.store offset=28 align=4
            local.get $l1
            i32.const 1048672
            i32.store offset=24
            local.get $l1
            i32.const 1
            i32.store offset=20
            local.get $l1
            local.get $l1
            i32.const 16
            i32.add
            i32.store offset=40
            local.get $l1
            local.get $l1
            i32.const 12
            i32.add
            i32.store offset=16
            local.get $l1
            i32.const 24
            i32.add
            i32.const 1048688
            call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
            unreachable
          end
          local.get $l1
          i32.const 44
          i32.add
          i32.const 0
          i32.store
          local.get $l1
          i32.const 1048576
          i32.store offset=40
          local.get $l1
          i64.const 1
          i64.store offset=28 align=4
          local.get $l1
          i32.const 1048748
          i32.store offset=24
          local.get $l1
          i32.const 24
          i32.add
          i32.const 1048756
          call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
          unreachable
        end
        local.get $l3
        i32.const -8
        i32.and
        local.set $p0
        i64.const 1
        local.set $l2
        i64.const 0
        local.set $l5
        loop $L6
          local.get $l2
          local.get $l5
          i64.add
          local.tee $l5
          local.get $l2
          i64.add
          local.tee $l2
          local.get $l5
          i64.add
          local.tee $l5
          local.get $l2
          i64.add
          local.tee $l2
          local.get $l5
          i64.add
          local.tee $l5
          local.get $l2
          i64.add
          local.tee $l2
          local.get $l5
          i64.add
          local.tee $l5
          local.get $l2
          i64.add
          local.set $l2
          local.get $p0
          i32.const -8
          i32.add
          local.tee $p0
          br_if $L6
        end
      end
      local.get $l4
      i32.eqz
      br_if $B0
      local.get $l2
      local.set $l6
      loop $L7
        local.get $l6
        local.get $l5
        i64.add
        local.set $l2
        local.get $l6
        local.set $l5
        local.get $l2
        local.set $l6
        local.get $l4
        i32.const -1
        i32.add
        local.tee $l4
        br_if $L7
      end
    end
    local.get $l1
    i32.const 48
    i32.add
    global.set $__stack_pointer
    local.get $l2)
  (func $_ZN9fibonacci4main17hf7c881588373479aE (type $t0)
    (local $l0 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l0
    global.set $__stack_pointer
    local.get $l0
    i32.const 28
    i32.add
    i32.const 0
    i32.store
    local.get $l0
    i32.const 1048576
    i32.store offset=24
    local.get $l0
    i64.const 1
    i64.store offset=12 align=4
    local.get $l0
    i32.const 1048788
    i32.store offset=8
    local.get $l0
    i32.const 8
    i32.add
    call $_ZN3std2io5stdio6_print17h2d317cc9ca4d4730E
    local.get $l0
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $__original_main (type $t9) (result i32)
    (local $l0 i32) (local $l1 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l0
    global.set $__stack_pointer
    local.get $l0
    i32.const 2
    i32.store offset=12
    local.get $l0
    i32.const 12
    i32.add
    i32.const 1048796
    i32.const 0
    i32.const 0
    call $_ZN3std2rt19lang_start_internal17hf3ba92908e00e03cE
    local.set $l1
    local.get $l0
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $l1)
  (func $main (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    call $__original_main)
  (func $_ZN3std10sys_common9backtrace28__rust_begin_short_backtrace17hd8caa4a3127002bbE (type $t1) (param $p0 i32)
    local.get $p0
    call_indirect $T0 (type $t0))
  (func $_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17hda35c9318378c65fE.llvm.12393469044335151983 (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    local.get $p0
    i32.load
    call $_ZN3std10sys_common9backtrace28__rust_begin_short_backtrace17hd8caa4a3127002bbE
    local.get $l1
    i32.const 0
    i32.store8 offset=15
    local.get $l1
    i32.const 15
    i32.add
    call $_ZN3std3sys4wasi7process8ExitCode6as_i3217hc46b5c71da3e582cE
    local.set $p0
    local.get $l1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17hdd5f6e23e7aa570cE.llvm.12393469044335151983 (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    local.get $p0
    i32.load
    call $_ZN3std10sys_common9backtrace28__rust_begin_short_backtrace17hd8caa4a3127002bbE
    local.get $l1
    i32.const 0
    i32.store8 offset=15
    local.get $l1
    i32.const 15
    i32.add
    call $_ZN3std3sys4wasi7process8ExitCode6as_i3217hc46b5c71da3e582cE
    local.set $p0
    local.get $l1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core3ptr85drop_in_place$LT$std..rt..lang_start$LT$$LP$$RP$$GT$..$u7b$$u7b$closure$u7d$$u7d$$GT$17h8347ee127e12f099E.llvm.12393469044335151983 (type $t1) (param $p0 i32))
  (func $__rust_alloc (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    local.get $p0
    local.get $p1
    call $__rdl_alloc
    local.set $l2
    local.get $l2
    return)
  (func $__rust_dealloc (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    local.get $p0
    local.get $p1
    local.get $p2
    call $__rdl_dealloc
    return)
  (func $__rust_realloc (type $t8) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    (local $l4 i32)
    local.get $p0
    local.get $p1
    local.get $p2
    local.get $p3
    call $__rdl_realloc
    local.set $l4
    local.get $l4
    return)
  (func $__rust_alloc_error_handler (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $__rg_oom
    return)
  (func $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17h4bb391f6be197f05E (type $t2) (param $p0 i32) (result i64)
    i64.const -5139102199292759541)
  (func $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17h615ca163282f35faE (type $t2) (param $p0 i32) (result i64)
    i64.const 6368113575764679147)
  (func $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17h9b54eaeb5c3690b9E (type $t2) (param $p0 i32) (result i64)
    i64.const -5035033118515531264)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h03c19a5cab87a8bcE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    i32.load
    local.get $p1
    call $_ZN64_$LT$alloc..ffi..c_str..NulError$u20$as$u20$core..fmt..Debug$GT$3fmt17h93542ac89de10ef2E)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h68c2448d75804436E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p1
    call $_ZN43_$LT$bool$u20$as$u20$core..fmt..Display$GT$3fmt17h006a38274750e12bE)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h80292035a4d7d273E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.set $p0
    block $B0
      local.get $p1
      call $_ZN4core3fmt9Formatter15debug_lower_hex17h5784f1a3a7e69120E
      br_if $B0
      block $B1
        local.get $p1
        call $_ZN4core3fmt9Formatter15debug_upper_hex17h79028864c05f503cE
        br_if $B1
        local.get $p0
        local.get $p1
        call $_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$3fmt17h813a35a9627bd2a0E
        return
      end
      local.get $p0
      local.get $p1
      call $_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i32$GT$3fmt17h9146f2224828cde5E
      return
    end
    local.get $p0
    local.get $p1
    call $_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i32$GT$3fmt17hb8089c13c9c3b945E)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h9e3e1337724c321bE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p1
    i32.const 1048820
    i32.const 2
    call $_ZN4core3fmt9Formatter3pad17hc53f6fdd83e6dddeE)
  (func $_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h41599c7ebfcbddfcE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p1
    call $_ZN70_$LT$core..panic..location..Location$u20$as$u20$core..fmt..Display$GT$3fmt17ha37547eb9066368cE)
  (func $_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17hab8798528b645c70E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p0
    i32.load offset=4
    local.get $p1
    call $_ZN42_$LT$str$u20$as$u20$core..fmt..Display$GT$3fmt17hea89db8dbf1ee6c5E)
  (func $_ZN4core3fmt5Write10write_char17h12aa92d150748a24E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i64) (local $l4 i32) (local $l5 i32) (local $l6 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    i32.const 0
    i32.store offset=4
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p1
            i32.const 128
            i32.lt_u
            br_if $B3
            local.get $p1
            i32.const 2048
            i32.lt_u
            br_if $B2
            local.get $p1
            i32.const 65536
            i32.ge_u
            br_if $B1
            local.get $l2
            local.get $p1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=6
            local.get $l2
            local.get $p1
            i32.const 12
            i32.shr_u
            i32.const 224
            i32.or
            i32.store8 offset=4
            local.get $l2
            local.get $p1
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=5
            i32.const 3
            local.set $p1
            br $B0
          end
          local.get $l2
          local.get $p1
          i32.store8 offset=4
          i32.const 1
          local.set $p1
          br $B0
        end
        local.get $l2
        local.get $p1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=5
        local.get $l2
        local.get $p1
        i32.const 6
        i32.shr_u
        i32.const 192
        i32.or
        i32.store8 offset=4
        i32.const 2
        local.set $p1
        br $B0
      end
      local.get $l2
      local.get $p1
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=7
      local.get $l2
      local.get $p1
      i32.const 18
      i32.shr_u
      i32.const 240
      i32.or
      i32.store8 offset=4
      local.get $l2
      local.get $p1
      i32.const 6
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=6
      local.get $l2
      local.get $p1
      i32.const 12
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=5
      i32.const 4
      local.set $p1
    end
    local.get $l2
    i32.const 8
    i32.add
    local.get $p0
    i32.load
    local.get $l2
    i32.const 4
    i32.add
    local.get $p1
    call $_ZN61_$LT$std..io..stdio..StdoutLock$u20$as$u20$std..io..Write$GT$9write_all17h829d7f57f80999dfE
    block $B4
      local.get $l2
      i32.load8_u offset=8
      local.tee $p1
      i32.const 4
      i32.eq
      br_if $B4
      local.get $l2
      i64.load offset=8
      local.set $l3
      block $B5
        local.get $p0
        i32.load8_u offset=4
        i32.const 3
        i32.ne
        br_if $B5
        local.get $p0
        i32.const 8
        i32.add
        i32.load
        local.tee $l4
        i32.load
        local.get $l4
        i32.load offset=4
        i32.load
        call_indirect $T0 (type $t1)
        block $B6
          local.get $l4
          i32.load offset=4
          local.tee $l5
          i32.load offset=4
          local.tee $l6
          i32.eqz
          br_if $B6
          local.get $l4
          i32.load
          local.get $l6
          local.get $l5
          i32.load offset=8
          call $__rust_dealloc
        end
        local.get $l4
        i32.const 12
        i32.const 4
        call $__rust_dealloc
      end
      local.get $p0
      local.get $l3
      i64.store offset=4 align=4
    end
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p1
    i32.const 4
    i32.ne)
  (func $_ZN61_$LT$std..io..stdio..StdoutLock$u20$as$u20$std..io..Write$GT$9write_all17h829d7f57f80999dfE (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i64) (local $l9 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              local.get $p1
              i32.load
              local.tee $p1
              i32.load offset=8
              br_if $B4
              local.get $p1
              i32.const -1
              i32.store offset=8
              local.get $l4
              i32.const 10
              local.get $p2
              local.get $p3
              call $_ZN4core5slice6memchr7memrchr17h9ee09338dacac280E
              local.get $p1
              i32.const 12
              i32.add
              local.set $l5
              block $B5
                block $B6
                  local.get $l4
                  i32.load
                  br_if $B6
                  local.get $p1
                  i32.const 20
                  i32.add
                  i32.load
                  local.tee $l6
                  i32.eqz
                  br_if $B5
                  local.get $p1
                  i32.load offset=12
                  local.tee $l7
                  i32.eqz
                  br_if $B5
                  local.get $l6
                  local.get $l7
                  i32.add
                  i32.const -1
                  i32.add
                  i32.load8_u
                  i32.const 10
                  i32.ne
                  br_if $B5
                  local.get $l4
                  i32.const 8
                  i32.add
                  local.get $l5
                  call $_ZN3std2io8buffered9bufwriter18BufWriter$LT$W$GT$9flush_buf17h4bd8e6ff888ae7fcE
                  local.get $l4
                  i32.load8_u offset=8
                  i32.const 4
                  i32.eq
                  br_if $B5
                  local.get $l4
                  i64.load offset=8
                  local.tee $l8
                  i32.wrap_i64
                  i32.const 255
                  i32.and
                  i32.const 4
                  i32.eq
                  br_if $B5
                  local.get $p0
                  local.get $l8
                  i64.store align=4
                  br $B0
                end
                local.get $l4
                i32.load offset=4
                i32.const 1
                i32.add
                local.tee $l6
                local.get $p3
                i32.gt_u
                br_if $B3
                block $B7
                  local.get $p1
                  i32.const 20
                  i32.add
                  i32.load
                  local.tee $l7
                  i32.eqz
                  br_if $B7
                  block $B8
                    local.get $p1
                    i32.const 16
                    i32.add
                    i32.load
                    local.get $l7
                    i32.sub
                    local.get $l6
                    i32.le_u
                    br_if $B8
                    local.get $p1
                    i32.load offset=12
                    local.get $l7
                    i32.add
                    local.get $p2
                    local.get $l6
                    call $memcpy
                    drop
                    local.get $p1
                    i32.const 20
                    i32.add
                    local.get $l7
                    local.get $l6
                    i32.add
                    i32.store
                    br $B2
                  end
                  local.get $l4
                  i32.const 8
                  i32.add
                  local.get $l5
                  local.get $p2
                  local.get $l6
                  call $_ZN3std2io8buffered9bufwriter18BufWriter$LT$W$GT$14write_all_cold17hce0c9b230c9f3861E
                  local.get $l4
                  i32.load8_u offset=8
                  i32.const 4
                  i32.eq
                  br_if $B2
                  local.get $l4
                  i64.load offset=8
                  local.tee $l8
                  i32.wrap_i64
                  i32.const 255
                  i32.and
                  i32.const 4
                  i32.eq
                  br_if $B2
                  local.get $p0
                  local.get $l8
                  i64.store align=4
                  br $B0
                end
                local.get $l4
                i32.const 8
                i32.add
                local.get $l5
                local.get $p2
                local.get $l6
                call $_ZN60_$LT$std..io..stdio..StdoutRaw$u20$as$u20$std..io..Write$GT$9write_all17hfd0f93dafdc7467eE
                local.get $l4
                i32.load8_u offset=8
                i32.const 4
                i32.eq
                br_if $B1
                local.get $l4
                i64.load offset=8
                local.tee $l8
                i32.wrap_i64
                i32.const 255
                i32.and
                i32.const 4
                i32.eq
                br_if $B1
                local.get $p0
                local.get $l8
                i64.store align=4
                br $B0
              end
              block $B9
                local.get $p1
                i32.const 16
                i32.add
                i32.load
                local.get $p1
                i32.const 20
                i32.add
                local.tee $l7
                i32.load
                local.tee $l6
                i32.sub
                local.get $p3
                i32.gt_u
                br_if $B9
                local.get $p0
                local.get $l5
                local.get $p2
                local.get $p3
                call $_ZN3std2io8buffered9bufwriter18BufWriter$LT$W$GT$14write_all_cold17hce0c9b230c9f3861E
                br $B0
              end
              local.get $p1
              i32.load offset=12
              local.get $l6
              i32.add
              local.get $p2
              local.get $p3
              call $memcpy
              drop
              local.get $p0
              i32.const 4
              i32.store8
              local.get $l7
              local.get $l6
              local.get $p3
              i32.add
              i32.store
              br $B0
            end
            i32.const 1048920
            i32.const 16
            local.get $l4
            i32.const 8
            i32.add
            i32.const 1049032
            i32.const 1050760
            call $_ZN4core6result13unwrap_failed17hd4950ca6f53bad26E
            unreachable
          end
          i32.const 1048952
          i32.const 35
          i32.const 1049872
          call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
          unreachable
        end
        local.get $l4
        i32.const 8
        i32.add
        local.get $l5
        call $_ZN3std2io8buffered9bufwriter18BufWriter$LT$W$GT$9flush_buf17h4bd8e6ff888ae7fcE
        local.get $l4
        i32.load8_u offset=8
        i32.const 4
        i32.eq
        br_if $B1
        local.get $l4
        i64.load offset=8
        local.tee $l8
        i32.wrap_i64
        i32.const 255
        i32.and
        i32.const 4
        i32.eq
        br_if $B1
        local.get $p0
        local.get $l8
        i64.store align=4
        br $B0
      end
      local.get $p2
      local.get $l6
      i32.add
      local.set $l7
      block $B10
        local.get $p1
        i32.const 16
        i32.add
        i32.load
        local.get $p1
        i32.const 20
        i32.add
        local.tee $l9
        i32.load
        local.tee $p2
        i32.sub
        local.get $p3
        local.get $l6
        i32.sub
        local.tee $p3
        i32.gt_u
        br_if $B10
        local.get $p0
        local.get $l5
        local.get $l7
        local.get $p3
        call $_ZN3std2io8buffered9bufwriter18BufWriter$LT$W$GT$14write_all_cold17hce0c9b230c9f3861E
        br $B0
      end
      local.get $p1
      i32.load offset=12
      local.get $p2
      i32.add
      local.get $l7
      local.get $p3
      call $memcpy
      drop
      local.get $p0
      i32.const 4
      i32.store8
      local.get $l9
      local.get $p2
      local.get $p3
      i32.add
      i32.store
    end
    local.get $p1
    local.get $p1
    i32.load offset=8
    i32.const 1
    i32.add
    i32.store offset=8
    local.get $l4
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN4core3fmt5Write10write_char17h495658827dcb6b00E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    i32.const 0
    i32.store offset=12
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p1
            i32.const 128
            i32.lt_u
            br_if $B3
            local.get $p1
            i32.const 2048
            i32.lt_u
            br_if $B2
            local.get $p1
            i32.const 65536
            i32.ge_u
            br_if $B1
            local.get $l2
            local.get $p1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=14
            local.get $l2
            local.get $p1
            i32.const 12
            i32.shr_u
            i32.const 224
            i32.or
            i32.store8 offset=12
            local.get $l2
            local.get $p1
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=13
            i32.const 3
            local.set $p1
            br $B0
          end
          local.get $l2
          local.get $p1
          i32.store8 offset=12
          i32.const 1
          local.set $p1
          br $B0
        end
        local.get $l2
        local.get $p1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=13
        local.get $l2
        local.get $p1
        i32.const 6
        i32.shr_u
        i32.const 192
        i32.or
        i32.store8 offset=12
        i32.const 2
        local.set $p1
        br $B0
      end
      local.get $l2
      local.get $p1
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=15
      local.get $l2
      local.get $p1
      i32.const 18
      i32.shr_u
      i32.const 240
      i32.or
      i32.store8 offset=12
      local.get $l2
      local.get $p1
      i32.const 6
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=14
      local.get $l2
      local.get $p1
      i32.const 12
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=13
      i32.const 4
      local.set $p1
    end
    local.get $p0
    local.get $l2
    i32.const 12
    i32.add
    local.get $p1
    call $_ZN80_$LT$std..io..Write..write_fmt..Adapter$LT$T$GT$$u20$as$u20$core..fmt..Write$GT$9write_str17h65bd1b8bee6953cbE
    local.set $p1
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN80_$LT$std..io..Write..write_fmt..Adapter$LT$T$GT$$u20$as$u20$core..fmt..Write$GT$9write_str17h65bd1b8bee6953cbE (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i64)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    i32.const 0
    local.set $l4
    block $B0
      local.get $p2
      i32.eqz
      br_if $B0
      block $B1
        block $B2
          loop $L3
            local.get $l3
            local.get $p2
            i32.store offset=12
            local.get $l3
            local.get $p1
            i32.store offset=8
            local.get $l3
            i32.const 16
            i32.add
            i32.const 2
            local.get $l3
            i32.const 8
            i32.add
            i32.const 1
            call $_ZN4wasi13lib_generated8fd_write17h3060209719e3ef69E
            block $B4
              block $B5
                block $B6
                  local.get $l3
                  i32.load16_u offset=16
                  br_if $B6
                  local.get $l3
                  i32.load offset=20
                  local.tee $l5
                  br_if $B5
                  i32.const 1050704
                  local.set $l5
                  i64.const 2
                  local.set $l6
                  br $B1
                end
                local.get $l3
                local.get $l3
                i32.load16_u offset=18
                i32.store16 offset=30
                local.get $l3
                i32.const 30
                i32.add
                call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
                i32.const 65535
                i32.and
                local.tee $l5
                call $_ZN3std3sys4wasi17decode_error_kind17h653960bfba1bf58fE
                i32.const 255
                i32.and
                i32.const 35
                i32.eq
                br_if $B4
                i64.const 0
                local.set $l6
                br $B1
              end
              local.get $p2
              local.get $l5
              i32.lt_u
              br_if $B2
              local.get $p1
              local.get $l5
              i32.add
              local.set $p1
              local.get $p2
              local.get $l5
              i32.sub
              local.set $p2
            end
            local.get $p2
            br_if $L3
            br $B0
          end
        end
        local.get $l5
        local.get $p2
        i32.const 1050876
        call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
        unreachable
      end
      local.get $l5
      i64.extend_i32_u
      i64.const 32
      i64.shl
      local.get $l6
      i64.or
      local.set $l6
      block $B7
        local.get $p0
        i32.load8_u offset=4
        i32.const 3
        i32.ne
        br_if $B7
        local.get $p0
        i32.const 8
        i32.add
        i32.load
        local.tee $p2
        i32.load
        local.get $p2
        i32.load offset=4
        i32.load
        call_indirect $T0 (type $t1)
        block $B8
          local.get $p2
          i32.load offset=4
          local.tee $p1
          i32.load offset=4
          local.tee $l5
          i32.eqz
          br_if $B8
          local.get $p2
          i32.load
          local.get $l5
          local.get $p1
          i32.load offset=8
          call $__rust_dealloc
        end
        local.get $p2
        i32.const 12
        i32.const 4
        call $__rust_dealloc
      end
      local.get $p0
      local.get $l6
      i64.store offset=4 align=4
      i32.const 1
      local.set $l4
    end
    local.get $l3
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $l4)
  (func $_ZN4core3fmt5Write10write_char17hbf9e79e156fc6a02E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    i32.const 0
    i32.store offset=12
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p1
            i32.const 128
            i32.lt_u
            br_if $B3
            local.get $p1
            i32.const 2048
            i32.lt_u
            br_if $B2
            local.get $p1
            i32.const 65536
            i32.ge_u
            br_if $B1
            local.get $l2
            local.get $p1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=14
            local.get $l2
            local.get $p1
            i32.const 12
            i32.shr_u
            i32.const 224
            i32.or
            i32.store8 offset=12
            local.get $l2
            local.get $p1
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=13
            i32.const 3
            local.set $p1
            br $B0
          end
          local.get $l2
          local.get $p1
          i32.store8 offset=12
          i32.const 1
          local.set $p1
          br $B0
        end
        local.get $l2
        local.get $p1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=13
        local.get $l2
        local.get $p1
        i32.const 6
        i32.shr_u
        i32.const 192
        i32.or
        i32.store8 offset=12
        i32.const 2
        local.set $p1
        br $B0
      end
      local.get $l2
      local.get $p1
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=15
      local.get $l2
      local.get $p1
      i32.const 18
      i32.shr_u
      i32.const 240
      i32.or
      i32.store8 offset=12
      local.get $l2
      local.get $p1
      i32.const 6
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=14
      local.get $l2
      local.get $p1
      i32.const 12
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=13
      i32.const 4
      local.set $p1
    end
    block $B4
      local.get $p0
      i32.load
      local.tee $l3
      i32.const 4
      i32.add
      i32.load
      local.get $l3
      i32.const 8
      i32.add
      local.tee $l4
      i32.load
      local.tee $p0
      i32.sub
      local.get $p1
      i32.ge_u
      br_if $B4
      local.get $l3
      local.get $p0
      local.get $p1
      call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
      local.get $l4
      i32.load
      local.set $p0
    end
    local.get $l3
    i32.load
    local.get $p0
    i32.add
    local.get $l2
    i32.const 12
    i32.add
    local.get $p1
    call $memcpy
    drop
    local.get $l4
    local.get $p0
    local.get $p1
    i32.add
    i32.store
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    i32.const 0)
  (func $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    block $B0
      local.get $p1
      local.get $p2
      i32.add
      local.tee $p2
      local.get $p1
      i32.lt_u
      br_if $B0
      local.get $p0
      i32.const 4
      i32.add
      i32.load
      local.tee $l4
      i32.const 1
      i32.shl
      local.tee $p1
      local.get $p2
      local.get $p1
      local.get $p2
      i32.gt_u
      select
      local.tee $p1
      i32.const 8
      local.get $p1
      i32.const 8
      i32.gt_u
      select
      local.set $p1
      block $B1
        block $B2
          local.get $l4
          br_if $B2
          i32.const 0
          local.set $p2
          br $B1
        end
        local.get $l3
        local.get $l4
        i32.store offset=20
        local.get $l3
        local.get $p0
        i32.load
        i32.store offset=16
        i32.const 1
        local.set $p2
      end
      local.get $l3
      local.get $p2
      i32.store offset=24
      local.get $l3
      local.get $p1
      i32.const 1
      local.get $l3
      i32.const 16
      i32.add
      call $_ZN5alloc7raw_vec11finish_grow17h728ec3339749ee3fE
      block $B3
        local.get $l3
        i32.load
        i32.eqz
        br_if $B3
        local.get $l3
        i32.const 8
        i32.add
        i32.load
        local.tee $p0
        i32.eqz
        br_if $B0
        local.get $l3
        i32.load offset=4
        local.get $p0
        call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
        unreachable
      end
      local.get $l3
      i32.load offset=4
      local.set $p2
      local.get $p0
      i32.const 4
      i32.add
      local.get $p1
      i32.store
      local.get $p0
      local.get $p2
      i32.store
      local.get $l3
      i32.const 32
      i32.add
      global.set $__stack_pointer
      return
    end
    call $_ZN5alloc7raw_vec17capacity_overflow17h854a19520cb09142E
    unreachable)
  (func $_ZN4core3fmt5Write9write_fmt17h0f5a126dbc39caaeE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p0
    i32.store offset=4
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $l2
    i32.const 4
    i32.add
    i32.const 1048824
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN4core3fmt5Write9write_fmt17h8b8853e9f8c4a51bE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p0
    i32.store offset=4
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $l2
    i32.const 4
    i32.add
    i32.const 1048872
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN4core3fmt5Write9write_fmt17ha2304c6abd7cc588E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p0
    i32.store offset=4
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $l2
    i32.const 4
    i32.add
    i32.const 1048896
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN3std9panicking12default_hook17h158128544edd3d02E (type $t1) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i64) (local $l4 i32) (local $l5 i32) (local $l6 i32)
    global.get $__stack_pointer
    i32.const 96
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          i32.const 0
          i32.load8_u offset=1059576
          br_if $B2
          i32.const 0
          i32.const 1
          i32.store8 offset=1059576
          i32.const 0
          i32.const 0
          i32.store offset=1059580
          br $B1
        end
        i32.const 1
        local.set $l2
        i32.const 0
        i32.load offset=1059580
        i32.const 1
        i32.gt_u
        br_if $B0
      end
      call $_ZN3std5panic19get_backtrace_style17h0abef6ef86c55a38E
      i32.const 255
      i32.and
      local.set $l2
    end
    local.get $l1
    local.get $l2
    i32.store8 offset=27
    block $B3
      block $B4
        block $B5
          block $B6
            block $B7
              block $B8
                local.get $p0
                call $_ZN4core5panic10panic_info9PanicInfo8location17h6e78c86147694e2aE
                local.tee $l2
                i32.eqz
                br_if $B8
                local.get $l1
                local.get $l2
                i32.store offset=28
                local.get $l1
                i32.const 16
                i32.add
                local.get $p0
                call $_ZN4core5panic10panic_info9PanicInfo7payload17h930eb7a577a32bc1E
                local.get $l1
                i32.load offset=16
                local.tee $l2
                local.get $l1
                i32.load offset=20
                i32.load offset=12
                call_indirect $T0 (type $t2)
                local.set $l3
                block $B9
                  block $B10
                    block $B11
                      local.get $l2
                      i32.eqz
                      br_if $B11
                      local.get $l3
                      i64.const -5139102199292759541
                      i64.eq
                      br_if $B10
                    end
                    local.get $l1
                    i32.const 8
                    i32.add
                    local.get $p0
                    call $_ZN4core5panic10panic_info9PanicInfo7payload17h930eb7a577a32bc1E
                    i32.const 1051784
                    local.set $l4
                    i32.const 12
                    local.set $p0
                    local.get $l1
                    i32.load offset=8
                    local.tee $l2
                    local.get $l1
                    i32.load offset=12
                    i32.load offset=12
                    call_indirect $T0 (type $t2)
                    local.set $l3
                    block $B12
                      local.get $l2
                      i32.eqz
                      br_if $B12
                      local.get $l3
                      i64.const -5035033118515531264
                      i64.ne
                      br_if $B12
                      local.get $l2
                      i32.const 8
                      i32.add
                      i32.load
                      local.set $p0
                      local.get $l2
                      i32.load
                      local.set $l4
                    end
                    local.get $l1
                    local.get $l4
                    i32.store offset=32
                    br $B9
                  end
                  local.get $l1
                  local.get $l2
                  i32.load
                  i32.store offset=32
                  local.get $l2
                  i32.load offset=4
                  local.set $p0
                end
                local.get $l1
                local.get $p0
                i32.store offset=36
                i32.const 0
                i32.load offset=1059568
                br_if $B7
                i32.const 0
                i32.const -1
                i32.store offset=1059568
                block $B13
                  i32.const 0
                  i32.load offset=1059572
                  local.tee $p0
                  br_if $B13
                  i32.const 0
                  i32.const 0
                  local.get $l1
                  call $_ZN3std6thread6Thread3new17h6ec33b9642945a25E
                  local.tee $p0
                  i32.store offset=1059572
                end
                local.get $p0
                local.get $p0
                i32.load
                local.tee $l2
                i32.const 1
                i32.add
                i32.store
                local.get $l2
                i32.const -1
                i32.le_s
                br_if $B6
                i32.const 0
                i32.const 0
                i32.load offset=1059568
                i32.const 1
                i32.add
                i32.store offset=1059568
                block $B14
                  block $B15
                    local.get $p0
                    br_if $B15
                    i32.const 0
                    local.set $l2
                    br $B14
                  end
                  local.get $p0
                  i32.const 20
                  i32.add
                  i32.load
                  i32.const -1
                  i32.add
                  local.set $l4
                  local.get $p0
                  i32.load offset=16
                  local.set $l2
                end
                local.get $l1
                local.get $l4
                i32.const 9
                local.get $l2
                select
                i32.store offset=44
                local.get $l1
                local.get $l2
                i32.const 1051796
                local.get $l2
                select
                i32.store offset=40
                local.get $l1
                local.get $l1
                i32.const 27
                i32.add
                i32.store offset=60
                local.get $l1
                local.get $l1
                i32.const 28
                i32.add
                i32.store offset=56
                local.get $l1
                local.get $l1
                i32.const 32
                i32.add
                i32.store offset=52
                local.get $l1
                local.get $l1
                i32.const 40
                i32.add
                i32.store offset=48
                block $B16
                  i32.const 0
                  i32.load8_u offset=1059489
                  i32.eqz
                  br_if $B16
                  i32.const 0
                  i32.const 1
                  i32.store8 offset=1059489
                  block $B17
                    i32.const 0
                    i32.load offset=1059556
                    br_if $B17
                    i32.const 0
                    i64.const 1
                    i64.store offset=1059556 align=4
                    br $B16
                  end
                  i32.const 0
                  i32.load offset=1059560
                  local.set $l2
                  i32.const 0
                  i32.const 0
                  i32.store offset=1059560
                  local.get $l2
                  br_if $B5
                end
                local.get $l1
                i32.const 48
                i32.add
                local.get $l1
                i32.const 72
                i32.add
                i32.const 1051808
                call $_ZN3std9panicking12default_hook28_$u7b$$u7b$closure$u7d$$u7d$17h46214d4dcd8120bbE
                i32.const 0
                local.set $l4
                i32.const 0
                local.set $l2
                br $B4
              end
              i32.const 1048987
              i32.const 43
              i32.const 1051768
              call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
              unreachable
            end
            i32.const 1048920
            i32.const 16
            local.get $l1
            i32.const 72
            i32.add
            i32.const 1049032
            i32.const 1051568
            call $_ZN4core6result13unwrap_failed17hd4950ca6f53bad26E
            unreachable
          end
          unreachable
          unreachable
        end
        local.get $l2
        i32.load8_u offset=8
        local.set $l4
        local.get $l2
        i32.const 1
        i32.store8 offset=8
        local.get $l1
        local.get $l4
        i32.const 1
        i32.and
        local.tee $l4
        i32.store8 offset=71
        local.get $l4
        br_if $B3
        block $B18
          block $B19
            block $B20
              i32.const 0
              i32.load offset=1059552
              i32.const 2147483647
              i32.and
              br_if $B20
              local.get $l1
              i32.const 48
              i32.add
              local.get $l2
              i32.const 12
              i32.add
              i32.const 1051848
              call $_ZN3std9panicking12default_hook28_$u7b$$u7b$closure$u7d$$u7d$17h46214d4dcd8120bbE
              br $B19
            end
            call $_ZN3std9panicking11panic_count17is_zero_slow_path17h86f2705f5a70ad00E
            local.set $l4
            local.get $l1
            i32.const 48
            i32.add
            local.get $l2
            i32.const 12
            i32.add
            i32.const 1051848
            call $_ZN3std9panicking12default_hook28_$u7b$$u7b$closure$u7d$$u7d$17h46214d4dcd8120bbE
            local.get $l4
            i32.eqz
            br_if $B18
          end
          i32.const 0
          i32.load offset=1059552
          i32.const 2147483647
          i32.and
          i32.eqz
          br_if $B18
          call $_ZN3std9panicking11panic_count17is_zero_slow_path17h86f2705f5a70ad00E
          br_if $B18
          local.get $l2
          i32.const 1
          i32.store8 offset=9
        end
        i32.const 1
        local.set $l4
        i32.const 0
        i32.const 1
        i32.store8 offset=1059489
        local.get $l2
        i32.const 0
        i32.store8 offset=8
        block $B21
          i32.const 0
          i32.load offset=1059556
          br_if $B21
          i32.const 0
          local.get $l2
          i32.store offset=1059560
          i32.const 1
          local.set $l4
          i32.const 0
          i32.const 1
          i32.store offset=1059556
          br $B4
        end
        i32.const 0
        i32.load offset=1059560
        local.set $l5
        i32.const 0
        local.get $l2
        i32.store offset=1059560
        local.get $l5
        i32.eqz
        br_if $B4
        local.get $l5
        local.get $l5
        i32.load
        local.tee $l6
        i32.const -1
        i32.add
        i32.store
        i32.const 1
        local.set $l4
        local.get $l6
        i32.const 1
        i32.ne
        br_if $B4
        local.get $l5
        call $_ZN5alloc4sync12Arc$LT$T$GT$9drop_slow17hc1a21b2375a169ecE
      end
      block $B22
        local.get $p0
        i32.eqz
        br_if $B22
        local.get $p0
        local.get $p0
        i32.load
        local.tee $l5
        i32.const -1
        i32.add
        i32.store
        local.get $l5
        i32.const 1
        i32.ne
        br_if $B22
        local.get $p0
        call $_ZN5alloc4sync12Arc$LT$T$GT$9drop_slow17h1568a3f79b7f2bb7E
      end
      block $B23
        local.get $l4
        i32.const -1
        i32.xor
        local.get $l2
        i32.const 0
        i32.ne
        i32.and
        i32.eqz
        br_if $B23
        local.get $l2
        local.get $l2
        i32.load
        local.tee $p0
        i32.const -1
        i32.add
        i32.store
        local.get $p0
        i32.const 1
        i32.ne
        br_if $B23
        local.get $l2
        call $_ZN5alloc4sync12Arc$LT$T$GT$9drop_slow17hc1a21b2375a169ecE
      end
      local.get $l1
      i32.const 96
      i32.add
      global.set $__stack_pointer
      return
    end
    local.get $l1
    i32.const 92
    i32.add
    i32.const 0
    i32.store
    local.get $l1
    i32.const 88
    i32.add
    i32.const 1048920
    i32.store
    local.get $l1
    i64.const 1
    i64.store offset=76 align=4
    local.get $l1
    i32.const 1052592
    i32.store offset=72
    local.get $l1
    i32.const 71
    i32.add
    local.get $l1
    i32.const 72
    i32.add
    call $_ZN4core9panicking13assert_failed17hdf6843c1d876d039E
    unreachable)
  (func $_ZN4core9panicking13assert_failed17hdf6843c1d876d039E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    i32.const 1049722
    i32.store offset=4
    local.get $l2
    local.get $p0
    i32.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    i32.const 0
    local.get $l2
    i32.const 1049140
    local.get $l2
    i32.const 4
    i32.add
    i32.const 1049140
    local.get $l2
    i32.const 8
    i32.add
    i32.const 1052656
    call $_ZN4core9panicking19assert_failed_inner17h109cd054b38eaec9E
    unreachable)
  (func $_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h47241f009bb1a74bE (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    local.get $p0
    i32.load
    local.tee $l2
    i32.load
    local.set $p0
    local.get $l2
    i32.const 0
    i32.store
    block $B0
      block $B1
        local.get $p0
        i32.eqz
        br_if $B1
        i32.const 1024
        i32.const 1
        call $__rust_alloc
        local.tee $l2
        i32.eqz
        br_if $B0
        local.get $p0
        i32.const 0
        i32.store8 offset=28
        local.get $p0
        i32.const 0
        i32.store8 offset=24
        local.get $p0
        i64.const 1024
        i64.store offset=16 align=4
        local.get $p0
        local.get $l2
        i32.store offset=12
        local.get $p0
        i32.const 0
        i32.store offset=8
        local.get $p0
        i64.const 0
        i64.store align=4
        return
      end
      i32.const 1048987
      i32.const 43
      i32.const 1051132
      call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
      unreachable
    end
    i32.const 1024
    i32.const 1
    call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
    unreachable)
  (func $_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17heb7056d347e601d2E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p0
    i32.load
    i32.store offset=12
    local.get $l2
    i32.const 12
    i32.add
    local.get $p1
    call $_ZN3std4sync4once4Once9call_once28_$u7b$$u7b$closure$u7d$$u7d$17hc39a8a731846cbe3E
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN3std4sync4once4Once9call_once28_$u7b$$u7b$closure$u7d$$u7d$17hc39a8a731846cbe3E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p0
    i32.load
    local.tee $p0
    i32.load8_u
    local.set $l3
    local.get $p0
    i32.const 0
    i32.store8
    block $B0
      block $B1
        block $B2
          local.get $l3
          i32.const 1
          i32.and
          i32.eqz
          br_if $B2
          block $B3
            i32.const 0
            i32.load offset=1059492
            local.tee $p0
            i32.const 3
            i32.ne
            br_if $B3
            block $B4
              block $B5
                i32.const 1059496
                i32.const 0
                local.get $p0
                i32.const 3
                i32.eq
                select
                local.tee $l3
                i32.load
                i32.const 1059564
                i32.eq
                br_if $B5
                i32.const 0
                i32.load8_u offset=1059524
                local.set $l4
                i32.const 1
                local.set $p0
                i32.const 0
                i32.const 1
                i32.store8 offset=1059524
                local.get $l4
                i32.const 1
                i32.and
                br_if $B3
                local.get $l3
                i32.const 1059564
                i32.store
                br $B4
              end
              i32.const 0
              i32.load offset=1059500
              local.tee $l4
              i32.const 1
              i32.add
              local.tee $p0
              local.get $l4
              i32.lt_u
              br_if $B1
            end
            i32.const 0
            local.get $p0
            i32.store offset=1059500
            i32.const 0
            i32.load offset=1059504
            br_if $B0
            i32.const 0
            i32.const -1
            i32.store offset=1059504
            block $B6
              i32.const 0
              i32.load8_u offset=1059520
              br_if $B6
              local.get $l2
              i32.const 1059508
              call $_ZN3std2io8buffered9bufwriter18BufWriter$LT$W$GT$9flush_buf17h4bd8e6ff888ae7fcE
              local.get $l2
              i32.load8_u
              i32.const 3
              i32.ne
              br_if $B6
              local.get $l2
              i32.load offset=4
              local.tee $p0
              i32.load
              local.get $p0
              i32.load offset=4
              i32.load
              call_indirect $T0 (type $t1)
              block $B7
                local.get $p0
                i32.load offset=4
                local.tee $l4
                i32.load offset=4
                local.tee $l5
                i32.eqz
                br_if $B7
                local.get $p0
                i32.load
                local.get $l5
                local.get $l4
                i32.load offset=8
                call $__rust_dealloc
              end
              local.get $p0
              i32.const 12
              i32.const 4
              call $__rust_dealloc
            end
            block $B8
              i32.const 0
              i32.load offset=1059512
              local.tee $p0
              i32.eqz
              br_if $B8
              i32.const 0
              i32.load offset=1059508
              local.get $p0
              i32.const 1
              call $__rust_dealloc
            end
            i32.const 0
            i64.const 0
            i64.store offset=1059512 align=4
            i32.const 0
            i32.const 1
            i32.store offset=1059508
            i32.const 0
            i32.const 0
            i32.load offset=1059504
            i32.const 1
            i32.add
            i32.store offset=1059504
            i32.const 0
            i32.const 0
            i32.load offset=1059500
            i32.const -1
            i32.add
            local.tee $p0
            i32.store offset=1059500
            i32.const 0
            i32.const 0
            i32.store8 offset=1059520
            local.get $p0
            br_if $B3
            local.get $l3
            i32.const 0
            i32.store
            i32.const 0
            i32.const 0
            i32.store8 offset=1059524
          end
          local.get $l2
          i32.const 16
          i32.add
          global.set $__stack_pointer
          return
        end
        i32.const 1048987
        i32.const 43
        i32.const 1051080
        call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
        unreachable
      end
      i32.const 1051432
      i32.const 38
      i32.const 1051508
      call $_ZN4core6option13expect_failed17h2917b44da418e74cE
      unreachable
    end
    i32.const 1048920
    i32.const 16
    local.get $l2
    i32.const 8
    i32.add
    i32.const 1049032
    i32.const 1050744
    call $_ZN4core6result13unwrap_failed17hd4950ca6f53bad26E
    unreachable)
  (func $_ZN4core3ptr100drop_in_place$LT$$RF$mut$u20$std..io..Write..write_fmt..Adapter$LT$alloc..vec..Vec$LT$u8$GT$$GT$$GT$17h023d344833e89da3E (type $t1) (param $p0 i32))
  (func $_ZN4core3ptr103drop_in_place$LT$std..sync..poison..PoisonError$LT$std..sync..mutex..MutexGuard$LT$$LP$$RP$$GT$$GT$$GT$17h9727c741a7219826E (type $t1) (param $p0 i32)
    (local $l1 i32)
    local.get $p0
    i32.load
    local.set $l1
    block $B0
      local.get $p0
      i32.load8_u offset=4
      br_if $B0
      i32.const 0
      i32.load offset=1059552
      i32.const 2147483647
      i32.and
      i32.eqz
      br_if $B0
      call $_ZN3std9panicking11panic_count17is_zero_slow_path17h86f2705f5a70ad00E
      br_if $B0
      local.get $l1
      i32.const 1
      i32.store8 offset=1
    end
    local.get $l1
    i32.const 0
    i32.store8)
  (func $_ZN3std9panicking11panic_count17is_zero_slow_path17h86f2705f5a70ad00E (type $t9) (result i32)
    block $B0
      i32.const 0
      i32.load8_u offset=1059576
      i32.eqz
      br_if $B0
      i32.const 0
      i32.load offset=1059580
      i32.eqz
      return
    end
    i32.const 0
    i32.const 1
    i32.store8 offset=1059576
    i32.const 0
    i32.const 0
    i32.store offset=1059580
    i32.const 1)
  (func $_ZN4core3ptr226drop_in_place$LT$std..error..$LT$impl$u20$core..convert..From$LT$alloc..string..String$GT$$u20$for$u20$alloc..boxed..Box$LT$dyn$u20$std..error..Error$u2b$core..marker..Send$u2b$core..marker..Sync$GT$$GT$..from..StringError$GT$17h2690405bcf1255fcE (type $t1) (param $p0 i32)
    (local $l1 i32)
    block $B0
      local.get $p0
      i32.const 4
      i32.add
      i32.load
      local.tee $l1
      i32.eqz
      br_if $B0
      local.get $p0
      i32.load
      local.get $l1
      i32.const 1
      call $__rust_dealloc
    end)
  (func $_ZN5alloc4sync12Arc$LT$T$GT$9drop_slow17h1568a3f79b7f2bb7E (type $t1) (param $p0 i32)
    (local $l1 i32)
    block $B0
      local.get $p0
      i32.load offset=16
      local.tee $l1
      i32.eqz
      br_if $B0
      local.get $l1
      i32.const 0
      i32.store8
      local.get $p0
      i32.const 20
      i32.add
      i32.load
      local.tee $l1
      i32.eqz
      br_if $B0
      local.get $p0
      i32.load offset=16
      local.get $l1
      i32.const 1
      call $__rust_dealloc
    end
    block $B1
      local.get $p0
      i32.const -1
      i32.eq
      br_if $B1
      local.get $p0
      local.get $p0
      i32.load offset=4
      local.tee $l1
      i32.const -1
      i32.add
      i32.store offset=4
      local.get $l1
      i32.const 1
      i32.ne
      br_if $B1
      local.get $p0
      i32.const 32
      i32.const 8
      call $__rust_dealloc
    end)
  (func $_ZN4core3ptr70drop_in_place$LT$std..panicking..begin_panic_handler..PanicPayload$GT$17hec9230cd384f36f4E (type $t1) (param $p0 i32)
    (local $l1 i32)
    block $B0
      local.get $p0
      i32.load offset=4
      local.tee $l1
      i32.eqz
      br_if $B0
      local.get $p0
      i32.const 8
      i32.add
      i32.load
      local.tee $p0
      i32.eqz
      br_if $B0
      local.get $l1
      local.get $p0
      i32.const 1
      call $__rust_dealloc
    end)
  (func $_ZN4core3ptr81drop_in_place$LT$core..result..Result$LT$$LP$$RP$$C$std..io..error..Error$GT$$GT$17hb995fe4c7a64958dE (type $t1) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32)
    block $B0
      local.get $p0
      i32.load8_u
      i32.const 3
      i32.ne
      br_if $B0
      local.get $p0
      i32.const 4
      i32.add
      i32.load
      local.tee $l1
      i32.load
      local.get $l1
      i32.load offset=4
      i32.load
      call_indirect $T0 (type $t1)
      block $B1
        local.get $l1
        i32.load offset=4
        local.tee $l2
        i32.load offset=4
        local.tee $l3
        i32.eqz
        br_if $B1
        local.get $l1
        i32.load
        local.get $l3
        local.get $l2
        i32.load offset=8
        call $__rust_dealloc
      end
      local.get $p0
      i32.load offset=4
      i32.const 12
      i32.const 4
      call $__rust_dealloc
    end)
  (func $_ZN4core3ptr87drop_in_place$LT$std..io..Write..write_fmt..Adapter$LT$$RF$mut$u20$$u5b$u8$u5d$$GT$$GT$17h79521407f097e01cE (type $t1) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32)
    block $B0
      local.get $p0
      i32.load8_u offset=4
      i32.const 3
      i32.ne
      br_if $B0
      local.get $p0
      i32.const 8
      i32.add
      i32.load
      local.tee $l1
      i32.load
      local.get $l1
      i32.load offset=4
      i32.load
      call_indirect $T0 (type $t1)
      block $B1
        local.get $l1
        i32.load offset=4
        local.tee $l2
        i32.load offset=4
        local.tee $l3
        i32.eqz
        br_if $B1
        local.get $l1
        i32.load
        local.get $l3
        local.get $l2
        i32.load offset=8
        call $__rust_dealloc
      end
      local.get $p0
      i32.load offset=8
      i32.const 12
      i32.const 4
      call $__rust_dealloc
    end)
  (func $_ZN4core6option15Option$LT$T$GT$6unwrap17h6fb9e42b17801906E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    block $B0
      local.get $p0
      br_if $B0
      i32.const 1048987
      i32.const 43
      local.get $p1
      call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
      unreachable
    end
    local.get $p0)
  (func $_ZN4core6option15Option$LT$T$GT$6unwrap17h888399a1e25b98e0E (type $t4) (param $p0 i32) (result i32)
    block $B0
      local.get $p0
      br_if $B0
      i32.const 1048987
      i32.const 43
      i32.const 1052052
      call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
      unreachable
    end
    local.get $p0)
  (func $_ZN4core9panicking13assert_failed17hc57b9d652c1bc7aaE (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    i32.const 1051264
    i32.store offset=4
    local.get $l3
    local.get $p0
    i32.store
    local.get $l3
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l3
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l3
    local.get $p1
    i64.load align=4
    i64.store offset=8
    i32.const 0
    local.get $l3
    i32.const 1049124
    local.get $l3
    i32.const 4
    i32.add
    i32.const 1049124
    local.get $l3
    i32.const 8
    i32.add
    local.get $p2
    call $_ZN4core9panicking19assert_failed_inner17h109cd054b38eaec9E
    unreachable)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h3dc2852957e98fb1E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p0
    i32.load
    local.set $p0
    local.get $l2
    i32.const 0
    i32.store offset=12
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p1
            i32.const 128
            i32.lt_u
            br_if $B3
            local.get $p1
            i32.const 2048
            i32.lt_u
            br_if $B2
            local.get $p1
            i32.const 65536
            i32.ge_u
            br_if $B1
            local.get $l2
            local.get $p1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=14
            local.get $l2
            local.get $p1
            i32.const 12
            i32.shr_u
            i32.const 224
            i32.or
            i32.store8 offset=12
            local.get $l2
            local.get $p1
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=13
            i32.const 3
            local.set $p1
            br $B0
          end
          local.get $l2
          local.get $p1
          i32.store8 offset=12
          i32.const 1
          local.set $p1
          br $B0
        end
        local.get $l2
        local.get $p1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=13
        local.get $l2
        local.get $p1
        i32.const 6
        i32.shr_u
        i32.const 192
        i32.or
        i32.store8 offset=12
        i32.const 2
        local.set $p1
        br $B0
      end
      local.get $l2
      local.get $p1
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=15
      local.get $l2
      local.get $p1
      i32.const 18
      i32.shr_u
      i32.const 240
      i32.or
      i32.store8 offset=12
      local.get $l2
      local.get $p1
      i32.const 6
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=14
      local.get $l2
      local.get $p1
      i32.const 12
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=13
      i32.const 4
      local.set $p1
    end
    local.get $p0
    local.get $l2
    i32.const 12
    i32.add
    local.get $p1
    call $_ZN80_$LT$std..io..Write..write_fmt..Adapter$LT$T$GT$$u20$as$u20$core..fmt..Write$GT$9write_str17h65bd1b8bee6953cbE
    local.set $p1
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h4dbabd655517b3ebE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p1
    call $_ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$10write_char17h2df85f7a8155088dE
    drop
    i32.const 0)
  (func $_ZN58_$LT$alloc..string..String$u20$as$u20$core..fmt..Write$GT$10write_char17h2df85f7a8155088dE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              local.get $p1
              i32.const 128
              i32.lt_u
              br_if $B4
              local.get $l2
              i32.const 0
              i32.store offset=12
              local.get $p1
              i32.const 2048
              i32.lt_u
              br_if $B3
              local.get $p1
              i32.const 65536
              i32.ge_u
              br_if $B2
              local.get $l2
              local.get $p1
              i32.const 63
              i32.and
              i32.const 128
              i32.or
              i32.store8 offset=14
              local.get $l2
              local.get $p1
              i32.const 12
              i32.shr_u
              i32.const 224
              i32.or
              i32.store8 offset=12
              local.get $l2
              local.get $p1
              i32.const 6
              i32.shr_u
              i32.const 63
              i32.and
              i32.const 128
              i32.or
              i32.store8 offset=13
              i32.const 3
              local.set $p1
              br $B1
            end
            block $B5
              local.get $p0
              i32.load offset=8
              local.tee $l3
              local.get $p0
              i32.const 4
              i32.add
              i32.load
              i32.ne
              br_if $B5
              local.get $p0
              local.get $l3
              call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$16reserve_for_push17h258652488021381eE
              local.get $p0
              i32.load offset=8
              local.set $l3
            end
            local.get $p0
            local.get $l3
            i32.const 1
            i32.add
            i32.store offset=8
            local.get $p0
            i32.load
            local.get $l3
            i32.add
            local.get $p1
            i32.store8
            br $B0
          end
          local.get $l2
          local.get $p1
          i32.const 63
          i32.and
          i32.const 128
          i32.or
          i32.store8 offset=13
          local.get $l2
          local.get $p1
          i32.const 6
          i32.shr_u
          i32.const 192
          i32.or
          i32.store8 offset=12
          i32.const 2
          local.set $p1
          br $B1
        end
        local.get $l2
        local.get $p1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=15
        local.get $l2
        local.get $p1
        i32.const 18
        i32.shr_u
        i32.const 240
        i32.or
        i32.store8 offset=12
        local.get $l2
        local.get $p1
        i32.const 6
        i32.shr_u
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=14
        local.get $l2
        local.get $p1
        i32.const 12
        i32.shr_u
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=13
        i32.const 4
        local.set $p1
      end
      block $B6
        local.get $p0
        i32.const 4
        i32.add
        i32.load
        local.get $p0
        i32.const 8
        i32.add
        local.tee $l4
        i32.load
        local.tee $l3
        i32.sub
        local.get $p1
        i32.ge_u
        br_if $B6
        local.get $p0
        local.get $l3
        local.get $p1
        call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
        local.get $l4
        i32.load
        local.set $l3
      end
      local.get $p0
      i32.load
      local.get $l3
      i32.add
      local.get $l2
      i32.const 12
      i32.add
      local.get $p1
      call $memcpy
      drop
      local.get $l4
      local.get $l3
      local.get $p1
      i32.add
      i32.store
    end
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    i32.const 0)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h55c92bf5255df7acE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p1
    call $_ZN4core3fmt5Write10write_char17h12aa92d150748a24E)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17hd8e75667bbe06bd4E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p1
    call $_ZN4core3fmt5Write10write_char17hbf9e79e156fc6a02E)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17h4116da28c54ce459E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p0
    i32.load
    i32.store offset=4
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $l2
    i32.const 4
    i32.add
    i32.const 1048896
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17hc1cd0b26048ce4eeE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p0
    i32.load
    i32.store offset=4
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $l2
    i32.const 4
    i32.add
    i32.const 1048872
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17hd3abdebe1b974cf4E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p0
    i32.load
    i32.store offset=4
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $l2
    i32.const 4
    i32.add
    i32.const 1048824
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17hf3b6dd4ac505270cE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p0
    i32.load
    i32.store offset=4
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $l2
    i32.const 4
    i32.add
    i32.const 1048848
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17h26c407ff69ca40f6E (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p1
    local.get $p2
    call $_ZN80_$LT$std..io..Write..write_fmt..Adapter$LT$T$GT$$u20$as$u20$core..fmt..Write$GT$9write_str17h65bd1b8bee6953cbE)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17h733b40fd9a71eda9E (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i64) (local $l5 i32) (local $l6 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    i32.const 8
    i32.add
    local.get $p0
    i32.load
    local.tee $p0
    i32.load
    local.get $p1
    local.get $p2
    call $_ZN61_$LT$std..io..stdio..StdoutLock$u20$as$u20$std..io..Write$GT$9write_all17h829d7f57f80999dfE
    block $B0
      local.get $l3
      i32.load8_u offset=8
      local.tee $p1
      i32.const 4
      i32.eq
      br_if $B0
      local.get $l3
      i64.load offset=8
      local.set $l4
      block $B1
        local.get $p0
        i32.load8_u offset=4
        i32.const 3
        i32.ne
        br_if $B1
        local.get $p0
        i32.const 8
        i32.add
        i32.load
        local.tee $p2
        i32.load
        local.get $p2
        i32.load offset=4
        i32.load
        call_indirect $T0 (type $t1)
        block $B2
          local.get $p2
          i32.load offset=4
          local.tee $l5
          i32.load offset=4
          local.tee $l6
          i32.eqz
          br_if $B2
          local.get $p2
          i32.load
          local.get $l6
          local.get $l5
          i32.load offset=8
          call $__rust_dealloc
        end
        local.get $p2
        i32.const 12
        i32.const 4
        call $__rust_dealloc
      end
      local.get $p0
      local.get $l4
      i64.store offset=4 align=4
    end
    local.get $l3
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p1
    i32.const 4
    i32.ne)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17h7901cb51779d4b4cE (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32)
    block $B0
      local.get $p0
      i32.load
      i32.load
      local.tee $l3
      i32.const 4
      i32.add
      i32.load
      local.get $l3
      i32.const 8
      i32.add
      local.tee $l4
      i32.load
      local.tee $p0
      i32.sub
      local.get $p2
      i32.ge_u
      br_if $B0
      local.get $l3
      local.get $p0
      local.get $p2
      call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
      local.get $l4
      i32.load
      local.set $p0
    end
    local.get $l3
    i32.load
    local.get $p0
    i32.add
    local.get $p1
    local.get $p2
    call $memcpy
    drop
    local.get $l4
    local.get $p0
    local.get $p2
    i32.add
    i32.store
    i32.const 0)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17hc5a7aed674d57871E (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32)
    block $B0
      local.get $p0
      i32.load
      local.tee $l3
      i32.const 4
      i32.add
      i32.load
      local.get $l3
      i32.const 8
      i32.add
      local.tee $l4
      i32.load
      local.tee $p0
      i32.sub
      local.get $p2
      i32.ge_u
      br_if $B0
      local.get $l3
      local.get $p0
      local.get $p2
      call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
      local.get $l4
      i32.load
      local.set $p0
    end
    local.get $l3
    i32.load
    local.get $p0
    i32.add
    local.get $p1
    local.get $p2
    call $memcpy
    drop
    local.get $l4
    local.get $p0
    local.get $p2
    i32.add
    i32.store
    i32.const 0)
  (func $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$16reserve_for_push17h258652488021381eE (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      local.get $p1
      i32.const 1
      i32.add
      local.tee $l3
      local.get $p1
      i32.lt_u
      br_if $B0
      local.get $p0
      i32.const 4
      i32.add
      i32.load
      local.tee $l4
      i32.const 1
      i32.shl
      local.tee $p1
      local.get $l3
      local.get $p1
      local.get $l3
      i32.gt_u
      select
      local.tee $p1
      i32.const 8
      local.get $p1
      i32.const 8
      i32.gt_u
      select
      local.set $p1
      block $B1
        block $B2
          local.get $l4
          br_if $B2
          i32.const 0
          local.set $l3
          br $B1
        end
        local.get $l2
        local.get $l4
        i32.store offset=20
        local.get $l2
        local.get $p0
        i32.load
        i32.store offset=16
        i32.const 1
        local.set $l3
      end
      local.get $l2
      local.get $l3
      i32.store offset=24
      local.get $l2
      local.get $p1
      i32.const 1
      local.get $l2
      i32.const 16
      i32.add
      call $_ZN5alloc7raw_vec11finish_grow17h728ec3339749ee3fE
      block $B3
        local.get $l2
        i32.load
        i32.eqz
        br_if $B3
        local.get $l2
        i32.const 8
        i32.add
        i32.load
        local.tee $p0
        i32.eqz
        br_if $B0
        local.get $l2
        i32.load offset=4
        local.get $p0
        call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
        unreachable
      end
      local.get $l2
      i32.load offset=4
      local.set $l3
      local.get $p0
      i32.const 4
      i32.add
      local.get $p1
      i32.store
      local.get $p0
      local.get $l3
      i32.store
      local.get $l2
      i32.const 32
      i32.add
      global.set $__stack_pointer
      return
    end
    call $_ZN5alloc7raw_vec17capacity_overflow17h854a19520cb09142E
    unreachable)
  (func $_ZN5alloc4sync12Arc$LT$T$GT$9drop_slow17hc1a21b2375a169ecE (type $t1) (param $p0 i32)
    (local $l1 i32)
    block $B0
      local.get $p0
      i32.const 16
      i32.add
      i32.load
      local.tee $l1
      i32.eqz
      br_if $B0
      local.get $p0
      i32.load offset=12
      local.get $l1
      i32.const 1
      call $__rust_dealloc
    end
    block $B1
      local.get $p0
      i32.const -1
      i32.eq
      br_if $B1
      local.get $p0
      local.get $p0
      i32.load offset=4
      local.tee $l1
      i32.const -1
      i32.add
      i32.store offset=4
      local.get $l1
      i32.const 1
      i32.ne
      br_if $B1
      local.get $p0
      i32.const 24
      i32.const 4
      call $__rust_dealloc
    end)
  (func $_ZN5alloc7raw_vec11finish_grow17h728ec3339749ee3fE (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32)
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              block $B5
                block $B6
                  local.get $p2
                  i32.eqz
                  br_if $B6
                  i32.const 1
                  local.set $l4
                  local.get $p1
                  i32.const 0
                  i32.lt_s
                  br_if $B5
                  local.get $p3
                  i32.load offset=8
                  i32.eqz
                  br_if $B3
                  local.get $p3
                  i32.load offset=4
                  local.tee $l5
                  br_if $B4
                  local.get $p1
                  br_if $B2
                  local.get $p2
                  local.set $p3
                  br $B1
                end
                local.get $p0
                local.get $p1
                i32.store offset=4
                i32.const 1
                local.set $l4
              end
              i32.const 0
              local.set $p1
              br $B0
            end
            local.get $p3
            i32.load
            local.get $l5
            local.get $p2
            local.get $p1
            call $__rust_realloc
            local.set $p3
            br $B1
          end
          local.get $p1
          br_if $B2
          local.get $p2
          local.set $p3
          br $B1
        end
        local.get $p1
        local.get $p2
        call $__rust_alloc
        local.set $p3
      end
      block $B7
        local.get $p3
        i32.eqz
        br_if $B7
        local.get $p0
        local.get $p3
        i32.store offset=4
        i32.const 0
        local.set $l4
        br $B0
      end
      local.get $p0
      local.get $p1
      i32.store offset=4
      local.get $p2
      local.set $p1
    end
    local.get $p0
    local.get $l4
    i32.store
    local.get $p0
    i32.const 8
    i32.add
    local.get $p1
    i32.store)
  (func $_ZN60_$LT$alloc..string..String$u20$as$u20$core..fmt..Display$GT$3fmt17h6636b07faeedd941E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p0
    i32.const 8
    i32.add
    i32.load
    local.get $p1
    call $_ZN42_$LT$str$u20$as$u20$core..fmt..Display$GT$3fmt17hea89db8dbf1ee6c5E)
  (func $_ZN70_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17he855ed501478c391E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      block $B1
        local.get $p0
        i32.load
        br_if $B1
        local.get $l2
        local.get $p1
        i32.const 1049291
        i32.const 2
        call $_ZN4core3fmt9Formatter11debug_tuple17h75af657b8f60803eE
        local.get $l2
        local.get $p0
        i32.store offset=12
        local.get $l2
        local.get $l2
        i32.const 12
        i32.add
        i32.const 1049312
        call $_ZN4core3fmt8builders10DebugTuple5field17h6c59533708c678f2E
        drop
        br $B0
      end
      local.get $l2
      local.get $p1
      i32.const 1049288
      i32.const 3
      call $_ZN4core3fmt9Formatter11debug_tuple17h75af657b8f60803eE
      local.get $l2
      local.get $p0
      i32.store offset=12
      local.get $l2
      local.get $l2
      i32.const 12
      i32.add
      i32.const 1049296
      call $_ZN4core3fmt8builders10DebugTuple5field17h6c59533708c678f2E
      drop
    end
    local.get $l2
    call $_ZN4core3fmt8builders10DebugTuple6finish17h86934b71974f411eE
    local.set $p0
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN3std4sync4once4Once10call_inner17h1897bf0262aa8dc5E (type $t11) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32)
    (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l5
    global.set $__stack_pointer
    local.get $l5
    i32.const 8
    i32.add
    i32.const 2
    i32.or
    local.set $l6
    local.get $p0
    i32.load
    local.set $l7
    loop $L0
      block $B1
        block $B2
          block $B3
            block $B4
              block $B5
                block $B6
                  block $B7
                    block $B8
                      block $B9
                        block $B10
                          block $B11
                            block $B12
                              block $B13
                                block $B14
                                  local.get $l7
                                  br_table $B13 $B14 $B12 $B9 $B12
                                end
                                local.get $p1
                                i32.eqz
                                br_if $B11
                              end
                              local.get $p0
                              i32.const 2
                              local.get $p0
                              i32.load
                              local.tee $l8
                              local.get $l8
                              local.get $l7
                              i32.eq
                              local.tee $l9
                              select
                              i32.store
                              local.get $l9
                              br_if $B10
                              local.get $l8
                              local.set $l7
                              br $L0
                            end
                            block $B15
                              local.get $l7
                              i32.const 3
                              i32.and
                              i32.const 2
                              i32.ne
                              br_if $B15
                              loop $L16
                                local.get $l7
                                local.set $l9
                                i32.const 0
                                i32.load offset=1059568
                                br_if $B8
                                i32.const 0
                                i32.const -1
                                i32.store offset=1059568
                                block $B17
                                  i32.const 0
                                  i32.load offset=1059572
                                  local.tee $l8
                                  br_if $B17
                                  i32.const 0
                                  i32.const 0
                                  local.get $l7
                                  call $_ZN3std6thread6Thread3new17h6ec33b9642945a25E
                                  local.tee $l8
                                  i32.store offset=1059572
                                end
                                local.get $l8
                                local.get $l8
                                i32.load
                                local.tee $l7
                                i32.const 1
                                i32.add
                                i32.store
                                local.get $l7
                                i32.const -1
                                i32.le_s
                                br_if $B7
                                i32.const 0
                                i32.const 0
                                i32.load offset=1059568
                                i32.const 1
                                i32.add
                                i32.store offset=1059568
                                local.get $l8
                                i32.eqz
                                br_if $B6
                                local.get $p0
                                local.get $l6
                                local.get $p0
                                i32.load
                                local.tee $l7
                                local.get $l7
                                local.get $l9
                                i32.eq
                                select
                                i32.store
                                local.get $l5
                                i32.const 0
                                i32.store8 offset=16
                                local.get $l5
                                local.get $l8
                                i32.store offset=8
                                local.get $l5
                                local.get $l9
                                i32.const -4
                                i32.and
                                i32.store offset=12
                                block $B18
                                  local.get $l7
                                  local.get $l9
                                  i32.ne
                                  br_if $B18
                                  local.get $l5
                                  i32.load8_u offset=16
                                  i32.eqz
                                  br_if $B5
                                  br $B2
                                end
                                block $B19
                                  local.get $l5
                                  i32.load offset=8
                                  local.tee $l8
                                  i32.eqz
                                  br_if $B19
                                  local.get $l8
                                  local.get $l8
                                  i32.load
                                  local.tee $l9
                                  i32.const -1
                                  i32.add
                                  i32.store
                                  local.get $l9
                                  i32.const 1
                                  i32.ne
                                  br_if $B19
                                  local.get $l5
                                  i32.load offset=8
                                  call $_ZN5alloc4sync12Arc$LT$T$GT$9drop_slow17h1568a3f79b7f2bb7E
                                end
                                local.get $l7
                                i32.const 3
                                i32.and
                                i32.const 2
                                i32.eq
                                br_if $L16
                                br $B1
                              end
                            end
                            i32.const 1051148
                            i32.const 64
                            local.get $p4
                            call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
                            unreachable
                          end
                          local.get $l5
                          i32.const 28
                          i32.add
                          i32.const 0
                          i32.store
                          local.get $l5
                          i32.const 1048920
                          i32.store offset=24
                          local.get $l5
                          i64.const 1
                          i64.store offset=12 align=4
                          local.get $l5
                          i32.const 1051256
                          i32.store offset=8
                          local.get $l5
                          i32.const 8
                          i32.add
                          local.get $p4
                          call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
                          unreachable
                        end
                        local.get $l5
                        local.get $l7
                        i32.const 1
                        i32.eq
                        i32.store8 offset=12
                        local.get $l5
                        i32.const 3
                        i32.store offset=8
                        local.get $p2
                        local.get $l5
                        i32.const 8
                        i32.add
                        local.get $p3
                        i32.load offset=16
                        call_indirect $T0 (type $t3)
                        local.get $p0
                        i32.load
                        local.set $l7
                        local.get $p0
                        local.get $l5
                        i32.load offset=8
                        i32.store
                        local.get $l5
                        local.get $l7
                        i32.const 3
                        i32.and
                        local.tee $l8
                        i32.store
                        local.get $l8
                        i32.const 2
                        i32.ne
                        br_if $B4
                        local.get $l7
                        i32.const -2
                        i32.add
                        local.tee $l8
                        i32.eqz
                        br_if $B9
                        loop $L20
                          local.get $l8
                          i32.load
                          local.set $l7
                          local.get $l8
                          i32.const 0
                          i32.store
                          local.get $l7
                          i32.eqz
                          br_if $B3
                          local.get $l8
                          i32.load offset=4
                          local.set $l9
                          local.get $l8
                          i32.const 1
                          i32.store8 offset=8
                          local.get $l7
                          i32.const 24
                          i32.add
                          call $_ZN3std10sys_common13thread_parker7generic6Parker6unpark17h123fd38c1ee8a57cE
                          local.get $l7
                          local.get $l7
                          i32.load
                          local.tee $l8
                          i32.const -1
                          i32.add
                          i32.store
                          block $B21
                            local.get $l8
                            i32.const 1
                            i32.ne
                            br_if $B21
                            local.get $l7
                            call $_ZN5alloc4sync12Arc$LT$T$GT$9drop_slow17h1568a3f79b7f2bb7E
                          end
                          local.get $l9
                          local.set $l8
                          local.get $l9
                          br_if $L20
                        end
                      end
                      local.get $l5
                      i32.const 32
                      i32.add
                      global.set $__stack_pointer
                      return
                    end
                    i32.const 1048920
                    i32.const 16
                    local.get $l5
                    i32.const 1049032
                    i32.const 1051568
                    call $_ZN4core6result13unwrap_failed17hd4950ca6f53bad26E
                    unreachable
                  end
                  unreachable
                  unreachable
                end
                i32.const 1049460
                i32.const 94
                i32.const 1049584
                call $_ZN4core6option13expect_failed17h2917b44da418e74cE
                unreachable
              end
              loop $L22
                call $_ZN3std6thread4park17h7cff83b3baba85b7E
                local.get $l5
                i32.load8_u offset=16
                i32.eqz
                br_if $L22
                br $B2
              end
            end
            local.get $l5
            i32.const 0
            i32.store offset=8
            local.get $l5
            local.get $l5
            i32.const 8
            i32.add
            i32.const 1051268
            call $_ZN4core9panicking13assert_failed17hc57b9d652c1bc7aaE
            unreachable
          end
          i32.const 1048987
          i32.const 43
          i32.const 1051284
          call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
          unreachable
        end
        local.get $l5
        i32.load offset=8
        local.tee $l7
        i32.eqz
        br_if $B1
        local.get $l7
        local.get $l7
        i32.load
        local.tee $l8
        i32.const -1
        i32.add
        i32.store
        local.get $l8
        i32.const 1
        i32.ne
        br_if $B1
        local.get $l5
        i32.load offset=8
        call $_ZN5alloc4sync12Arc$LT$T$GT$9drop_slow17h1568a3f79b7f2bb7E
        local.get $p0
        i32.load
        local.set $l7
        br $L0
      end
      local.get $p0
      i32.load
      local.set $l7
      br $L0
    end)
  (func $_ZN3std2rt19lang_start_internal17hf3ba92908e00e03cE (type $t8) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    (local $l4 i32)
    global.get $__stack_pointer
    i32.const 112
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    local.get $l4
    i32.const 8
    i32.add
    i32.const 1049328
    i32.const 4
    call $_ZN72_$LT$$RF$str$u20$as$u20$alloc..ffi..c_str..CString..new..SpecNewImpl$GT$13spec_new_impl17h2c1a395078d3e4cdE
    block $B0
      local.get $l4
      i32.load offset=8
      br_if $B0
      local.get $l4
      i32.load offset=12
      local.get $l4
      i32.const 16
      i32.add
      i32.load
      call $_ZN3std6thread6Thread3new17h6ec33b9642945a25E
      call $_ZN3std10sys_common11thread_info3set17h5bf7c16b9aad8132E
      local.get $p0
      local.get $p1
      i32.load offset=20
      call_indirect $T0 (type $t4)
      local.set $p0
      block $B1
        i32.const 0
        i32.load offset=1059484
        i32.const 3
        i32.eq
        br_if $B1
        local.get $l4
        i32.const 1
        i32.store8 offset=40
        local.get $l4
        local.get $l4
        i32.const 40
        i32.add
        i32.store offset=72
        i32.const 1059484
        i32.const 0
        local.get $l4
        i32.const 72
        i32.add
        i32.const 1051032
        i32.const 1049444
        call $_ZN3std4sync4once4Once10call_inner17h1897bf0262aa8dc5E
      end
      local.get $l4
      i32.const 112
      i32.add
      global.set $__stack_pointer
      local.get $p0
      return
    end
    local.get $l4
    local.get $l4
    i32.const 8
    i32.add
    i32.const 4
    i32.or
    i32.store offset=28
    local.get $l4
    i32.const 40
    i32.add
    i32.const 20
    i32.add
    i32.const 1
    i32.store
    local.get $l4
    i32.const 72
    i32.add
    i32.const 20
    i32.add
    i32.const 1
    i32.store
    local.get $l4
    i64.const 2
    i64.store offset=44 align=4
    local.get $l4
    i32.const 1049356
    i32.store offset=40
    local.get $l4
    i32.const 6
    i32.store offset=68
    local.get $l4
    i64.const 1
    i64.store offset=76 align=4
    local.get $l4
    i32.const 1049412
    i32.store offset=72
    local.get $l4
    i32.const 7
    i32.store offset=100
    local.get $l4
    local.get $l4
    i32.const 64
    i32.add
    i32.store offset=56
    local.get $l4
    local.get $l4
    i32.const 72
    i32.add
    i32.store offset=64
    local.get $l4
    local.get $l4
    i32.const 96
    i32.add
    i32.store offset=88
    local.get $l4
    local.get $l4
    i32.const 28
    i32.add
    i32.store offset=96
    local.get $l4
    i32.const 32
    i32.add
    local.get $l4
    i32.const 104
    i32.add
    local.get $l4
    i32.const 40
    i32.add
    call $_ZN3std2io5Write9write_fmt17h623738e85fdccfedE
    local.get $l4
    i32.const 32
    i32.add
    call $_ZN4core3ptr81drop_in_place$LT$core..result..Result$LT$$LP$$RP$$C$std..io..error..Error$GT$$GT$17hb995fe4c7a64958dE
    call $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E
    unreachable)
  (func $_ZN3std6thread6Thread3new17h6ec33b9642945a25E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i64)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      block $B1
        i32.const 32
        i32.const 8
        call $__rust_alloc
        local.tee $l3
        i32.eqz
        br_if $B1
        local.get $l3
        local.get $p0
        i32.store offset=16
        local.get $l3
        i64.const 4294967297
        i64.store
        local.get $l3
        i32.const 20
        i32.add
        local.get $p1
        i32.store
        i32.const 0
        i32.load8_u offset=1059488
        local.set $p0
        i32.const 0
        i32.const 1
        i32.store8 offset=1059488
        local.get $l2
        local.get $p0
        i32.store8 offset=7
        local.get $p0
        br_if $B0
        block $B2
          block $B3
            i32.const 0
            i64.load offset=1059464
            local.tee $l4
            i64.const -1
            i64.eq
            br_if $B3
            i32.const 0
            local.get $l4
            i64.const 1
            i64.add
            i64.store offset=1059464
            local.get $l4
            i64.const 0
            i64.ne
            br_if $B2
            i32.const 1048987
            i32.const 43
            i32.const 1049680
            call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
            unreachable
          end
          i32.const 0
          i32.const 0
          i32.store8 offset=1059488
          local.get $l2
          i32.const 28
          i32.add
          i32.const 0
          i32.store
          local.get $l2
          i32.const 1048920
          i32.store offset=24
          local.get $l2
          i64.const 1
          i64.store offset=12 align=4
          local.get $l2
          i32.const 1049656
          i32.store offset=8
          local.get $l2
          i32.const 8
          i32.add
          i32.const 1049664
          call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
          unreachable
        end
        local.get $l3
        i64.const 0
        i64.store offset=24
        local.get $l3
        local.get $l4
        i64.store offset=8
        i32.const 0
        i32.const 0
        i32.store8 offset=1059488
        local.get $l2
        i32.const 32
        i32.add
        global.set $__stack_pointer
        local.get $l3
        return
      end
      i32.const 32
      i32.const 8
      call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
      unreachable
    end
    local.get $l2
    i32.const 8
    i32.add
    i32.const 20
    i32.add
    i32.const 0
    i32.store
    local.get $l2
    i32.const 24
    i32.add
    i32.const 1048920
    i32.store
    local.get $l2
    i64.const 1
    i64.store offset=12 align=4
    local.get $l2
    i32.const 1052592
    i32.store offset=8
    local.get $l2
    i32.const 7
    i32.add
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core9panicking13assert_failed17hdf6843c1d876d039E
    unreachable)
  (func $_ZN3std10sys_common11thread_info3set17h5bf7c16b9aad8132E (type $t1) (param $p0 i32)
    (local $l1 i32)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    block $B0
      block $B1
        i32.const 0
        i32.load offset=1059568
        br_if $B1
        i32.const 0
        i32.const -1
        i32.store offset=1059568
        i32.const 0
        i32.load offset=1059572
        br_if $B0
        i32.const 0
        local.get $p0
        i32.store offset=1059572
        i32.const 0
        i32.const 0
        i32.store offset=1059568
        local.get $l1
        i32.const 64
        i32.add
        global.set $__stack_pointer
        return
      end
      i32.const 1048920
      i32.const 16
      local.get $l1
      i32.const 40
      i32.add
      i32.const 1049032
      i32.const 1051584
      call $_ZN4core6result13unwrap_failed17hd4950ca6f53bad26E
      unreachable
    end
    local.get $l1
    i32.const 8
    i32.add
    i32.const 20
    i32.add
    i32.const 1
    i32.store
    local.get $l1
    i32.const 40
    i32.add
    i32.const 20
    i32.add
    i32.const 0
    i32.store
    local.get $l1
    i64.const 2
    i64.store offset=12 align=4
    local.get $l1
    i32.const 1049356
    i32.store offset=8
    local.get $l1
    i32.const 6
    i32.store offset=36
    local.get $l1
    i32.const 1048920
    i32.store offset=56
    local.get $l1
    i64.const 1
    i64.store offset=44 align=4
    local.get $l1
    i32.const 1051640
    i32.store offset=40
    local.get $l1
    local.get $l1
    i32.const 32
    i32.add
    i32.store offset=24
    local.get $l1
    local.get $l1
    i32.const 40
    i32.add
    i32.store offset=32
    local.get $l1
    local.get $l1
    i32.const 40
    i32.add
    local.get $l1
    i32.const 8
    i32.add
    call $_ZN3std2io5Write9write_fmt17h623738e85fdccfedE
    local.get $l1
    call $_ZN4core3ptr81drop_in_place$LT$core..result..Result$LT$$LP$$RP$$C$std..io..error..Error$GT$$GT$17hb995fe4c7a64958dE
    call $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E
    unreachable)
  (func $_ZN3std2io5Write9write_fmt17h623738e85fdccfedE (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    i32.const 4
    i32.store8 offset=12
    local.get $l3
    local.get $p1
    i32.store offset=8
    local.get $l3
    i32.const 24
    i32.add
    i32.const 16
    i32.add
    local.get $p2
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l3
    i32.const 24
    i32.add
    i32.const 8
    i32.add
    local.get $p2
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l3
    local.get $p2
    i64.load align=4
    i64.store offset=24
    block $B0
      block $B1
        local.get $l3
        i32.const 8
        i32.add
        i32.const 1050920
        local.get $l3
        i32.const 24
        i32.add
        call $_ZN4core3fmt5write17h64a435d9d6b334f1E
        i32.eqz
        br_if $B1
        block $B2
          local.get $l3
          i32.load8_u offset=12
          i32.const 4
          i32.ne
          br_if $B2
          local.get $p0
          i32.const 1050908
          i64.extend_i32_u
          i64.const 32
          i64.shl
          i64.const 2
          i64.or
          i64.store align=4
          br $B0
        end
        local.get $p0
        local.get $l3
        i64.load offset=12 align=4
        i64.store align=4
        br $B0
      end
      local.get $p0
      i32.const 4
      i32.store8
      local.get $l3
      i32.load8_u offset=12
      i32.const 3
      i32.ne
      br_if $B0
      local.get $l3
      i32.const 16
      i32.add
      i32.load
      local.tee $p2
      i32.load
      local.get $p2
      i32.load offset=4
      i32.load
      call_indirect $T0 (type $t1)
      block $B3
        local.get $p2
        i32.load offset=4
        local.tee $p1
        i32.load offset=4
        local.tee $p0
        i32.eqz
        br_if $B3
        local.get $p2
        i32.load
        local.get $p0
        local.get $p1
        i32.load offset=8
        call $__rust_dealloc
      end
      local.get $l3
      i32.load offset=16
      i32.const 12
      i32.const 4
      call $__rust_dealloc
    end
    local.get $l3
    i32.const 48
    i32.add
    global.set $__stack_pointer)
  (func $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E (type $t0)
    call $abort
    unreachable)
  (func $_ZN3std10sys_common13thread_parker7generic6Parker6unpark17h123fd38c1ee8a57cE (type $t1) (param $p0 i32)
    (local $l1 i32) (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    local.get $p0
    i32.load
    local.set $l2
    local.get $p0
    i32.const 2
    i32.store
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $l2
            br_table $B1 $B2 $B1 $B3
          end
          local.get $l1
          i32.const 28
          i32.add
          i32.const 0
          i32.store
          local.get $l1
          i32.const 1048920
          i32.store offset=24
          local.get $l1
          i64.const 1
          i64.store offset=12 align=4
          local.get $l1
          i32.const 1053036
          i32.store offset=8
          local.get $l1
          i32.const 8
          i32.add
          i32.const 1053044
          call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
          unreachable
        end
        local.get $p0
        i32.load8_u offset=4
        local.set $l2
        local.get $p0
        i32.const 1
        i32.store8 offset=4
        local.get $l1
        local.get $l2
        i32.const 1
        i32.and
        local.tee $l2
        i32.store8 offset=7
        local.get $l2
        br_if $B0
        local.get $p0
        i32.const 4
        i32.add
        local.set $p0
        i32.const 0
        local.set $l2
        block $B4
          block $B5
            block $B6
              block $B7
                block $B8
                  i32.const 0
                  i32.load offset=1059552
                  i32.const 2147483647
                  i32.and
                  i32.eqz
                  br_if $B8
                  call $_ZN3std9panicking11panic_count17is_zero_slow_path17h86f2705f5a70ad00E
                  local.set $l2
                  local.get $p0
                  i32.load8_u offset=1
                  i32.eqz
                  br_if $B6
                  local.get $l2
                  i32.const 1
                  i32.xor
                  local.set $l2
                  br $B7
                end
                local.get $p0
                i32.load8_u offset=1
                i32.eqz
                br_if $B5
              end
              local.get $l1
              local.get $l2
              i32.store8 offset=12
              local.get $l1
              local.get $p0
              i32.store offset=8
              i32.const 1049048
              i32.const 43
              local.get $l1
              i32.const 8
              i32.add
              i32.const 1049092
              i32.const 1053060
              call $_ZN4core6result13unwrap_failed17hd4950ca6f53bad26E
              unreachable
            end
            local.get $l2
            i32.eqz
            br_if $B4
          end
          i32.const 0
          i32.load offset=1059552
          i32.const 2147483647
          i32.and
          i32.eqz
          br_if $B4
          call $_ZN3std9panicking11panic_count17is_zero_slow_path17h86f2705f5a70ad00E
          br_if $B4
          local.get $p0
          i32.const 1
          i32.store8 offset=1
        end
        local.get $p0
        i32.const 0
        i32.store8
      end
      local.get $l1
      i32.const 32
      i32.add
      global.set $__stack_pointer
      return
    end
    local.get $l1
    i32.const 28
    i32.add
    i32.const 0
    i32.store
    local.get $l1
    i32.const 24
    i32.add
    i32.const 1048920
    i32.store
    local.get $l1
    i64.const 1
    i64.store offset=12 align=4
    local.get $l1
    i32.const 1052592
    i32.store offset=8
    local.get $l1
    i32.const 7
    i32.add
    local.get $l1
    i32.const 8
    i32.add
    call $_ZN4core9panicking13assert_failed17hdf6843c1d876d039E
    unreachable)
  (func $_ZN3std6thread4park17h7cff83b3baba85b7E (type $t0)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l0
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              block $B5
                block $B6
                  block $B7
                    i32.const 0
                    i32.load offset=1059568
                    br_if $B7
                    i32.const 0
                    i32.const -1
                    i32.store offset=1059568
                    block $B8
                      i32.const 0
                      i32.load offset=1059572
                      local.tee $l1
                      br_if $B8
                      i32.const 0
                      i32.const 0
                      local.get $l1
                      call $_ZN3std6thread6Thread3new17h6ec33b9642945a25E
                      local.tee $l1
                      i32.store offset=1059572
                    end
                    local.get $l1
                    local.get $l1
                    i32.load
                    local.tee $l2
                    i32.const 1
                    i32.add
                    i32.store
                    local.get $l2
                    i32.const -1
                    i32.le_s
                    br_if $B6
                    i32.const 0
                    i32.const 0
                    i32.load offset=1059568
                    i32.const 1
                    i32.add
                    i32.store offset=1059568
                    local.get $l1
                    i32.eqz
                    br_if $B5
                    local.get $l1
                    i32.const 0
                    local.get $l1
                    i32.load offset=24
                    local.tee $l2
                    local.get $l2
                    i32.const 2
                    i32.eq
                    local.tee $l2
                    select
                    i32.store offset=24
                    block $B9
                      local.get $l2
                      br_if $B9
                      local.get $l1
                      i32.const 24
                      i32.add
                      local.tee $l2
                      i32.load8_u offset=4
                      local.set $l3
                      local.get $l2
                      i32.const 1
                      i32.store8 offset=4
                      local.get $l0
                      local.get $l3
                      i32.const 1
                      i32.and
                      local.tee $l3
                      i32.store8 offset=4
                      local.get $l3
                      br_if $B4
                      local.get $l2
                      i32.const 4
                      i32.add
                      local.set $l4
                      i32.const 0
                      local.set $l5
                      block $B10
                        i32.const 0
                        i32.load offset=1059552
                        i32.const 2147483647
                        i32.and
                        i32.eqz
                        br_if $B10
                        call $_ZN3std9panicking11panic_count17is_zero_slow_path17h86f2705f5a70ad00E
                        i32.const 1
                        i32.xor
                        local.set $l5
                      end
                      local.get $l4
                      i32.load8_u offset=1
                      br_if $B3
                      local.get $l2
                      local.get $l2
                      i32.load
                      local.tee $l3
                      i32.const 1
                      local.get $l3
                      select
                      i32.store
                      local.get $l3
                      i32.eqz
                      br_if $B0
                      local.get $l3
                      i32.const 2
                      i32.ne
                      br_if $B2
                      local.get $l2
                      i32.load
                      local.set $l3
                      local.get $l2
                      i32.const 0
                      i32.store
                      local.get $l0
                      local.get $l3
                      i32.store offset=4
                      local.get $l3
                      i32.const 2
                      i32.ne
                      br_if $B1
                      block $B11
                        local.get $l5
                        br_if $B11
                        i32.const 0
                        i32.load offset=1059552
                        i32.const 2147483647
                        i32.and
                        i32.eqz
                        br_if $B11
                        call $_ZN3std9panicking11panic_count17is_zero_slow_path17h86f2705f5a70ad00E
                        br_if $B11
                        local.get $l4
                        i32.const 1
                        i32.store8 offset=1
                      end
                      local.get $l4
                      i32.const 0
                      i32.store8
                    end
                    local.get $l1
                    local.get $l1
                    i32.load
                    local.tee $l2
                    i32.const -1
                    i32.add
                    i32.store
                    block $B12
                      local.get $l2
                      i32.const 1
                      i32.ne
                      br_if $B12
                      local.get $l1
                      call $_ZN5alloc4sync12Arc$LT$T$GT$9drop_slow17h1568a3f79b7f2bb7E
                    end
                    local.get $l0
                    i32.const 32
                    i32.add
                    global.set $__stack_pointer
                    return
                  end
                  i32.const 1048920
                  i32.const 16
                  local.get $l0
                  i32.const 8
                  i32.add
                  i32.const 1049032
                  i32.const 1051568
                  call $_ZN4core6result13unwrap_failed17hd4950ca6f53bad26E
                  unreachable
                end
                unreachable
                unreachable
              end
              i32.const 1049460
              i32.const 94
              i32.const 1049584
              call $_ZN4core6option13expect_failed17h2917b44da418e74cE
              unreachable
            end
            local.get $l0
            i32.const 28
            i32.add
            i32.const 0
            i32.store
            local.get $l0
            i32.const 24
            i32.add
            i32.const 1048920
            i32.store
            local.get $l0
            i64.const 1
            i64.store offset=12 align=4
            local.get $l0
            i32.const 1052592
            i32.store offset=8
            local.get $l0
            i32.const 4
            i32.add
            local.get $l0
            i32.const 8
            i32.add
            call $_ZN4core9panicking13assert_failed17hdf6843c1d876d039E
            unreachable
          end
          local.get $l0
          local.get $l5
          i32.store8 offset=12
          local.get $l0
          local.get $l4
          i32.store offset=8
          i32.const 1049048
          i32.const 43
          local.get $l0
          i32.const 8
          i32.add
          i32.const 1049092
          i32.const 1052888
          call $_ZN4core6result13unwrap_failed17hd4950ca6f53bad26E
          unreachable
        end
        local.get $l0
        i32.const 28
        i32.add
        i32.const 0
        i32.store
        local.get $l0
        i32.const 1048920
        i32.store offset=24
        local.get $l0
        i64.const 1
        i64.store offset=12 align=4
        local.get $l0
        i32.const 1052928
        i32.store offset=8
        local.get $l0
        i32.const 8
        i32.add
        i32.const 1052936
        call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
        unreachable
      end
      local.get $l0
      i32.const 28
      i32.add
      i32.const 0
      i32.store
      local.get $l0
      i32.const 24
      i32.add
      i32.const 1048920
      i32.store
      local.get $l0
      i64.const 1
      i64.store offset=12 align=4
      local.get $l0
      i32.const 1052984
      i32.store offset=8
      local.get $l0
      i32.const 4
      i32.add
      local.get $l0
      i32.const 8
      i32.add
      i32.const 1052992
      call $_ZN4core9panicking13assert_failed17hc57b9d652c1bc7aaE
      unreachable
    end
    local.get $l0
    i32.const 28
    i32.add
    i32.const 0
    i32.store
    local.get $l0
    i32.const 1048920
    i32.store offset=24
    local.get $l0
    i64.const 1
    i64.store offset=12 align=4
    local.get $l0
    i32.const 1052480
    i32.store offset=8
    local.get $l0
    i32.const 8
    i32.add
    i32.const 1052544
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $_ZN3std3env11current_dir17hdaa0a89a009d984eE (type $t1) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    i32.const 512
    local.set $l2
    block $B0
      block $B1
        block $B2
          block $B3
            i32.const 512
            i32.const 1
            call $__rust_alloc
            local.tee $l3
            i32.eqz
            br_if $B3
            local.get $l1
            i32.const 512
            i32.store offset=4
            local.get $l1
            local.get $l3
            i32.store
            local.get $l3
            i32.const 512
            call $getcwd
            br_if $B2
            block $B4
              block $B5
                block $B6
                  i32.const 0
                  i32.load offset=1060080
                  local.tee $l2
                  i32.const 68
                  i32.ne
                  br_if $B6
                  i32.const 512
                  local.set $l2
                  br $B5
                end
                local.get $p0
                i64.const 1
                i64.store align=4
                local.get $p0
                i32.const 8
                i32.add
                local.get $l2
                i32.store
                i32.const 512
                local.set $l2
                br $B4
              end
              loop $L7
                local.get $l1
                local.get $l2
                i32.store offset=8
                local.get $l1
                local.get $l2
                i32.const 1
                call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
                local.get $l1
                i32.load
                local.tee $l3
                local.get $l1
                i32.load offset=4
                local.tee $l2
                call $getcwd
                br_if $B2
                i32.const 0
                i32.load offset=1060080
                local.tee $l4
                i32.const 68
                i32.eq
                br_if $L7
              end
              local.get $p0
              i64.const 1
              i64.store align=4
              local.get $p0
              i32.const 8
              i32.add
              local.get $l4
              i32.store
              local.get $l2
              i32.eqz
              br_if $B1
            end
            local.get $l3
            local.get $l2
            i32.const 1
            call $__rust_dealloc
            br $B1
          end
          i32.const 512
          i32.const 1
          call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
          unreachable
        end
        local.get $l1
        local.get $l3
        call $strlen
        local.tee $l4
        i32.store offset=8
        block $B8
          local.get $l2
          local.get $l4
          i32.le_u
          br_if $B8
          block $B9
            block $B10
              local.get $l4
              br_if $B10
              i32.const 1
              local.set $l5
              local.get $l3
              local.get $l2
              i32.const 1
              call $__rust_dealloc
              br $B9
            end
            local.get $l3
            local.get $l2
            i32.const 1
            local.get $l4
            call $__rust_realloc
            local.tee $l5
            i32.eqz
            br_if $B0
          end
          local.get $l1
          local.get $l4
          i32.store offset=4
          local.get $l1
          local.get $l5
          i32.store
        end
        local.get $p0
        local.get $l1
        i64.load
        i64.store offset=4 align=4
        local.get $p0
        i32.const 0
        i32.store
        local.get $p0
        i32.const 12
        i32.add
        local.get $l1
        i32.const 8
        i32.add
        i32.load
        i32.store
      end
      local.get $l1
      i32.const 16
      i32.add
      global.set $__stack_pointer
      return
    end
    local.get $l4
    i32.const 1
    call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
    unreachable)
  (func $_ZN3std3env7_var_os17h29a17237445b33b0E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    i32.const 8
    i32.add
    local.get $p1
    local.get $p2
    call $_ZN72_$LT$$RF$str$u20$as$u20$alloc..ffi..c_str..CString..new..SpecNewImpl$GT$13spec_new_impl17h2c1a395078d3e4cdE
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $l3
            i32.load offset=8
            i32.eqz
            br_if $B3
            block $B4
              local.get $l3
              i32.const 20
              i32.add
              i32.load
              local.tee $p1
              i32.eqz
              br_if $B4
              local.get $l3
              i32.const 16
              i32.add
              i32.load
              local.get $p1
              i32.const 1
              call $__rust_dealloc
            end
            local.get $p0
            i32.const 0
            i32.store
            br $B2
          end
          local.get $l3
          i32.const 16
          i32.add
          i32.load
          local.set $l4
          block $B5
            block $B6
              local.get $l3
              i32.load offset=12
              local.tee $p2
              call $getenv
              local.tee $l5
              i32.eqz
              br_if $B6
              block $B7
                block $B8
                  local.get $l5
                  call $strlen
                  local.tee $p1
                  br_if $B8
                  i32.const 1
                  local.set $l6
                  br $B7
                end
                local.get $p1
                i32.const 0
                i32.lt_s
                br_if $B1
                local.get $p1
                i32.const 1
                call $__rust_alloc
                local.tee $l6
                i32.eqz
                br_if $B0
              end
              local.get $l6
              local.get $l5
              local.get $p1
              call $memcpy
              local.set $l5
              local.get $p0
              i32.const 8
              i32.add
              local.get $p1
              i32.store
              local.get $p0
              local.get $p1
              i32.store offset=4
              local.get $p0
              local.get $l5
              i32.store
              br $B5
            end
            local.get $p0
            i32.const 0
            i32.store
          end
          local.get $p2
          i32.const 0
          i32.store8
          local.get $l4
          i32.eqz
          br_if $B2
          local.get $p2
          local.get $l4
          i32.const 1
          call $__rust_dealloc
        end
        local.get $l3
        i32.const 32
        i32.add
        global.set $__stack_pointer
        return
      end
      call $_ZN5alloc7raw_vec17capacity_overflow17h854a19520cb09142E
      unreachable
    end
    local.get $p1
    i32.const 1
    call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
    unreachable)
  (func $_ZN60_$LT$std..io..error..Error$u20$as$u20$core..fmt..Display$GT$3fmt17hc82007c165b2732bE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              local.get $p0
              i32.load8_u
              br_table $B4 $B3 $B2 $B1 $B4
            end
            local.get $l2
            local.get $p0
            i32.const 4
            i32.add
            i32.load
            local.tee $p0
            i32.store offset=4
            local.get $l2
            i32.const 8
            i32.add
            local.get $p0
            call $_ZN3std3sys4wasi2os12error_string17h230c95db4dd759daE
            local.get $l2
            i32.const 60
            i32.add
            i32.const 2
            i32.store
            local.get $l2
            i32.const 36
            i32.add
            i32.const 1
            i32.store
            local.get $l2
            i64.const 3
            i64.store offset=44 align=4
            local.get $l2
            i32.const 1050652
            i32.store offset=40
            local.get $l2
            i32.const 8
            i32.store offset=28
            local.get $l2
            local.get $l2
            i32.const 24
            i32.add
            i32.store offset=56
            local.get $l2
            local.get $l2
            i32.const 4
            i32.add
            i32.store offset=32
            local.get $l2
            local.get $l2
            i32.const 8
            i32.add
            i32.store offset=24
            local.get $p1
            local.get $l2
            i32.const 40
            i32.add
            call $_ZN4core3fmt9Formatter9write_fmt17h3c92d3032e5cf8d7E
            local.set $p0
            local.get $l2
            i32.load offset=12
            local.tee $p1
            i32.eqz
            br_if $B0
            local.get $l2
            i32.load offset=8
            local.get $p1
            i32.const 1
            call $__rust_dealloc
            br $B0
          end
          local.get $p0
          i32.load8_u offset=1
          local.set $p0
          local.get $l2
          i32.const 60
          i32.add
          i32.const 1
          i32.store
          local.get $l2
          i64.const 1
          i64.store offset=44 align=4
          local.get $l2
          i32.const 1049712
          i32.store offset=40
          local.get $l2
          i32.const 9
          i32.store offset=12
          local.get $l2
          local.get $p0
          i32.const 32
          i32.xor
          i32.const 63
          i32.and
          i32.const 2
          i32.shl
          local.tee $p0
          i32.const 1053076
          i32.add
          i32.load
          i32.store offset=28
          local.get $l2
          local.get $p0
          i32.const 1053332
          i32.add
          i32.load
          i32.store offset=24
          local.get $l2
          local.get $l2
          i32.const 8
          i32.add
          i32.store offset=56
          local.get $l2
          local.get $l2
          i32.const 24
          i32.add
          i32.store offset=8
          local.get $p1
          local.get $l2
          i32.const 40
          i32.add
          call $_ZN4core3fmt9Formatter9write_fmt17h3c92d3032e5cf8d7E
          local.set $p0
          br $B0
        end
        local.get $p0
        i32.const 4
        i32.add
        i32.load
        local.tee $p0
        i32.load
        local.get $p0
        i32.load offset=4
        local.get $p1
        call $_ZN42_$LT$str$u20$as$u20$core..fmt..Display$GT$3fmt17hea89db8dbf1ee6c5E
        local.set $p0
        br $B0
      end
      local.get $p0
      i32.const 4
      i32.add
      i32.load
      local.tee $p0
      i32.load
      local.get $p1
      local.get $p0
      i32.load offset=4
      i32.load offset=16
      call_indirect $T0 (type $t5)
      local.set $p0
    end
    local.get $l2
    i32.const 64
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN3std3sys4wasi17decode_error_kind17h653960bfba1bf58fE (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32)
    i32.const 40
    local.set $l1
    block $B0
      local.get $p0
      i32.const 65535
      i32.gt_u
      br_if $B0
      i32.const 2
      local.set $l1
      i32.const 1052802
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 3
      local.set $l1
      i32.const 1052804
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 1
      local.set $l1
      i32.const 1052806
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 1052808
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 11
      local.set $l1
      i32.const 1052810
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 7
      local.set $l1
      i32.const 1052812
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 6
      local.set $l1
      i32.const 1052814
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 9
      local.set $l1
      i32.const 1052816
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 8
      local.set $l1
      i32.const 1052818
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 0
      local.set $l1
      i32.const 1052820
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 35
      local.set $l1
      i32.const 1052822
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 20
      local.set $l1
      i32.const 1052824
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 22
      local.set $l1
      i32.const 1052826
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 12
      local.set $l1
      i32.const 1052828
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 13
      local.set $l1
      i32.const 1052830
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 36
      local.set $l1
      i32.const 1052832
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      br_if $B0
      i32.const 38
      i32.const 40
      i32.const 1052834
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i32.const 65535
      i32.and
      local.get $p0
      i32.eq
      select
      local.set $l1
    end
    local.get $l1)
  (func $_ZN3std2io8buffered9bufwriter18BufWriter$LT$W$GT$9flush_buf17h4bd8e6ff888ae7fcE (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          local.get $p1
          i32.const 8
          i32.add
          i32.load
          local.tee $l3
          br_if $B2
          local.get $p0
          i32.const 4
          i32.store8
          br $B1
        end
        local.get $p1
        i32.load
        local.set $l4
        i32.const 0
        local.set $l5
        loop $L3
          block $B4
            block $B5
              block $B6
                local.get $l3
                local.get $l5
                i32.lt_u
                br_if $B6
                local.get $l2
                local.get $l3
                local.get $l5
                i32.sub
                local.tee $l6
                i32.store offset=12
                local.get $l2
                local.get $l4
                local.get $l5
                i32.add
                local.tee $l7
                i32.store offset=8
                local.get $l2
                i32.const 16
                i32.add
                i32.const 1
                local.get $l2
                i32.const 8
                i32.add
                i32.const 1
                call $_ZN4wasi13lib_generated8fd_write17h3060209719e3ef69E
                block $B7
                  block $B8
                    block $B9
                      block $B10
                        local.get $l2
                        i32.load16_u offset=16
                        br_if $B10
                        local.get $l2
                        i32.load offset=20
                        local.set $l8
                        br $B9
                      end
                      local.get $l2
                      local.get $l2
                      i32.load16_u offset=18
                      i32.store16 offset=30
                      local.get $l6
                      local.set $l8
                      local.get $l2
                      i32.const 30
                      i32.add
                      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
                      i32.const 65535
                      i32.and
                      local.tee $l9
                      i32.const 1052800
                      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
                      i32.const 65535
                      i32.and
                      i32.ne
                      br_if $B8
                    end
                    local.get $p1
                    i32.const 0
                    i32.store8 offset=12
                    local.get $l8
                    i32.eqz
                    br_if $B7
                    local.get $l8
                    local.get $l5
                    i32.add
                    local.set $l5
                    br $B4
                  end
                  local.get $p1
                  i32.const 0
                  i32.store8 offset=12
                  local.get $l9
                  call $_ZN3std3sys4wasi17decode_error_kind17h653960bfba1bf58fE
                  i32.const 255
                  i32.and
                  i32.const 35
                  i32.eq
                  br_if $B4
                  local.get $p0
                  i32.const 0
                  i32.store
                  local.get $p0
                  i32.const 4
                  i32.add
                  local.get $l9
                  i32.store
                  br $B5
                end
                local.get $p0
                i32.const 1049756
                i64.extend_i32_u
                i64.const 32
                i64.shl
                i64.const 2
                i64.or
                i64.store align=4
                br $B5
              end
              local.get $l5
              local.get $l3
              i32.const 1049808
              call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
              unreachable
            end
            local.get $l5
            i32.eqz
            br_if $B1
            local.get $p1
            i32.const 8
            i32.add
            local.tee $l5
            i32.const 0
            i32.store
            local.get $l6
            i32.eqz
            br_if $B1
            local.get $l4
            local.get $l7
            local.get $l6
            call $memmove
            drop
            local.get $l5
            local.get $l6
            i32.store
            br $B1
          end
          local.get $l3
          local.get $l5
          i32.gt_u
          br_if $L3
        end
        local.get $p0
        i32.const 4
        i32.store8
        local.get $l5
        i32.eqz
        br_if $B1
        local.get $l3
        local.get $l5
        i32.lt_u
        br_if $B0
        local.get $p1
        i32.const 8
        i32.add
        local.tee $l8
        i32.const 0
        i32.store
        local.get $l3
        local.get $l5
        i32.sub
        local.tee $l3
        i32.eqz
        br_if $B1
        local.get $p1
        i32.load
        local.tee $l6
        local.get $l6
        local.get $l5
        i32.add
        local.get $l3
        call $memmove
        drop
        local.get $l8
        local.get $l3
        i32.store
      end
      local.get $l2
      i32.const 32
      i32.add
      global.set $__stack_pointer
      return
    end
    local.get $l5
    local.get $l3
    i32.const 1049272
    call $_ZN4core5slice5index24slice_end_index_len_fail17h1cddbbbac67bee27E
    unreachable)
  (func $_ZN3std2io8buffered9bufwriter18BufWriter$LT$W$GT$14write_all_cold17hce0c9b230c9f3861E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i64)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    block $B0
      block $B1
        local.get $p1
        i32.const 4
        i32.add
        local.tee $l5
        i32.load
        local.get $p1
        i32.const 8
        i32.add
        i32.load
        i32.sub
        local.get $p3
        i32.ge_u
        br_if $B1
        local.get $l4
        i32.const 8
        i32.add
        local.get $p1
        call $_ZN3std2io8buffered9bufwriter18BufWriter$LT$W$GT$9flush_buf17h4bd8e6ff888ae7fcE
        local.get $l4
        i32.load8_u offset=8
        i32.const 4
        i32.eq
        br_if $B1
        local.get $l4
        i64.load offset=8
        local.tee $l6
        i32.wrap_i64
        i32.const 255
        i32.and
        i32.const 4
        i32.eq
        br_if $B1
        local.get $p0
        local.get $l6
        i64.store align=4
        br $B0
      end
      block $B2
        local.get $l5
        i32.load
        local.get $p3
        i32.le_u
        br_if $B2
        local.get $p1
        i32.load
        local.get $p1
        i32.const 8
        i32.add
        local.tee $p1
        i32.load
        local.tee $l5
        i32.add
        local.get $p2
        local.get $p3
        call $memcpy
        drop
        local.get $p0
        i32.const 4
        i32.store8
        local.get $p1
        local.get $l5
        local.get $p3
        i32.add
        i32.store
        br $B0
      end
      local.get $p1
      i32.const 1
      i32.store8 offset=12
      local.get $l4
      i32.const 8
      i32.add
      local.get $p1
      local.get $p2
      local.get $p3
      call $_ZN60_$LT$std..io..stdio..StdoutRaw$u20$as$u20$std..io..Write$GT$9write_all17hfd0f93dafdc7467eE
      local.get $p1
      i32.const 0
      i32.store8 offset=12
      local.get $p0
      local.get $l4
      i64.load offset=8
      i64.store align=4
    end
    local.get $l4
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN60_$LT$std..io..stdio..StdoutRaw$u20$as$u20$std..io..Write$GT$9write_all17hfd0f93dafdc7467eE (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i64) (local $l6 i32) (local $l7 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    i64.const 4
    local.set $l5
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              local.get $p3
              i32.eqz
              br_if $B4
              loop $L5
                local.get $l4
                local.get $p3
                i32.store offset=12
                local.get $l4
                local.get $p2
                i32.store offset=8
                local.get $l4
                i32.const 16
                i32.add
                i32.const 1
                local.get $l4
                i32.const 8
                i32.add
                i32.const 1
                call $_ZN4wasi13lib_generated8fd_write17h3060209719e3ef69E
                block $B6
                  block $B7
                    block $B8
                      local.get $l4
                      i32.load16_u offset=16
                      local.tee $l6
                      br_if $B8
                      local.get $l4
                      i32.load offset=20
                      local.tee $l7
                      br_if $B7
                      i32.const 1050704
                      local.set $l7
                      i64.const 2
                      local.set $l5
                      br $B2
                    end
                    local.get $l4
                    local.get $l4
                    i32.load16_u offset=18
                    i32.store16 offset=30
                    local.get $l4
                    i32.const 30
                    i32.add
                    call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
                    i32.const 65535
                    i32.and
                    local.tee $l7
                    call $_ZN3std3sys4wasi17decode_error_kind17h653960bfba1bf58fE
                    i32.const 255
                    i32.and
                    i32.const 35
                    i32.eq
                    br_if $B6
                    i64.const 0
                    local.set $l5
                    br $B2
                  end
                  local.get $p3
                  local.get $l7
                  i32.lt_u
                  br_if $B3
                  local.get $p2
                  local.get $l7
                  i32.add
                  local.set $p2
                  local.get $p3
                  local.get $l7
                  i32.sub
                  local.set $p3
                end
                local.get $p3
                br_if $L5
              end
            end
            br $B1
          end
          local.get $l7
          local.get $p3
          i32.const 1050876
          call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
          unreachable
        end
        i32.const 1052800
        call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
        local.set $p3
        local.get $l6
        i32.eqz
        br_if $B1
        local.get $l7
        local.get $p3
        i32.const 65535
        i32.and
        i32.ne
        br_if $B1
        local.get $p0
        i32.const 4
        i32.store8
        br $B0
      end
      local.get $p0
      local.get $l7
      i64.extend_i32_u
      i64.const 32
      i64.shl
      local.get $l5
      i64.or
      i64.store align=4
    end
    local.get $l4
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $_ZN3std3sys4wasi2os12error_string17h230c95db4dd759daE (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 1056
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p1
            local.get $l2
            i32.const 0
            i32.const 1024
            call $memset
            local.tee $l2
            i32.const 1024
            call $strerror_r
            i32.const 0
            i32.lt_s
            br_if $B3
            local.get $l2
            i32.const 1024
            i32.add
            local.get $l2
            local.get $l2
            call $strlen
            call $_ZN4core3str8converts9from_utf817h2ccf4e2b9987c885E
            local.get $l2
            i32.load offset=1024
            br_if $B2
            local.get $l2
            i32.load offset=1028
            local.set $l3
            block $B4
              block $B5
                local.get $l2
                i32.const 1032
                i32.add
                i32.load
                local.tee $p1
                br_if $B5
                i32.const 1
                local.set $l4
                br $B4
              end
              local.get $p1
              i32.const 0
              i32.lt_s
              br_if $B1
              local.get $p1
              i32.const 1
              call $__rust_alloc
              local.tee $l4
              i32.eqz
              br_if $B0
            end
            local.get $l4
            local.get $l3
            local.get $p1
            call $memcpy
            local.set $l3
            local.get $p0
            local.get $p1
            i32.store offset=8
            local.get $p0
            local.get $p1
            i32.store offset=4
            local.get $p0
            local.get $l3
            i32.store
            local.get $l2
            i32.const 1056
            i32.add
            global.set $__stack_pointer
            return
          end
          local.get $l2
          i32.const 1044
          i32.add
          i32.const 0
          i32.store
          local.get $l2
          i32.const 1048920
          i32.store offset=1040
          local.get $l2
          i64.const 1
          i64.store offset=1028 align=4
          local.get $l2
          i32.const 1052728
          i32.store offset=1024
          local.get $l2
          i32.const 1024
          i32.add
          i32.const 1052768
          call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
          unreachable
        end
        local.get $l2
        local.get $l2
        i64.load offset=1028 align=4
        i64.store offset=1048
        i32.const 1049048
        i32.const 43
        local.get $l2
        i32.const 1048
        i32.add
        i32.const 1049108
        i32.const 1052784
        call $_ZN4core6result13unwrap_failed17hd4950ca6f53bad26E
        unreachable
      end
      call $_ZN5alloc7raw_vec17capacity_overflow17h854a19520cb09142E
      unreachable
    end
    local.get $p1
    i32.const 1
    call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
    unreachable)
  (func $_ZN3std2io5impls74_$LT$impl$u20$std..io..Write$u20$for$u20$alloc..vec..Vec$LT$u8$C$A$GT$$GT$5write17hcb5efe1f65675387E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32)
    block $B0
      local.get $p1
      i32.const 4
      i32.add
      i32.load
      local.get $p1
      i32.const 8
      i32.add
      local.tee $l4
      i32.load
      local.tee $l5
      i32.sub
      local.get $p3
      i32.ge_u
      br_if $B0
      local.get $p1
      local.get $l5
      local.get $p3
      call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
      local.get $l4
      i32.load
      local.set $l5
    end
    local.get $p1
    i32.load
    local.get $l5
    i32.add
    local.get $p2
    local.get $p3
    call $memcpy
    drop
    local.get $p0
    local.get $p3
    i32.store offset=4
    local.get $l4
    local.get $l5
    local.get $p3
    i32.add
    i32.store
    local.get $p0
    i32.const 0
    i32.store)
  (func $_ZN3std2io5impls74_$LT$impl$u20$std..io..Write$u20$for$u20$alloc..vec..Vec$LT$u8$C$A$GT$$GT$14write_vectored17h3dc0fad2eb0646c6E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32)
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p3
            i32.const 3
            i32.shl
            local.tee $l4
            i32.eqz
            br_if $B3
            local.get $p3
            i32.const -1
            i32.add
            i32.const 536870911
            i32.and
            local.tee $l5
            i32.const 1
            i32.add
            local.tee $l6
            i32.const 7
            i32.and
            local.set $l7
            local.get $l5
            i32.const 7
            i32.ge_u
            br_if $B2
            i32.const 0
            local.set $l6
            local.get $p2
            local.set $l5
            br $B1
          end
          local.get $p1
          i32.const 4
          i32.add
          local.set $l8
          local.get $p1
          i32.const 8
          i32.add
          local.set $l5
          i32.const 0
          local.set $l6
          br $B0
        end
        local.get $p2
        i32.const 60
        i32.add
        local.set $l5
        local.get $l6
        i32.const 1073741816
        i32.and
        local.set $l9
        i32.const 0
        local.set $l6
        loop $L4
          local.get $l5
          i32.load
          local.get $l5
          i32.const -8
          i32.add
          i32.load
          local.get $l5
          i32.const -16
          i32.add
          i32.load
          local.get $l5
          i32.const -24
          i32.add
          i32.load
          local.get $l5
          i32.const -32
          i32.add
          i32.load
          local.get $l5
          i32.const -40
          i32.add
          i32.load
          local.get $l5
          i32.const -48
          i32.add
          i32.load
          local.get $l5
          i32.const -56
          i32.add
          i32.load
          local.get $l6
          i32.add
          i32.add
          i32.add
          i32.add
          i32.add
          i32.add
          i32.add
          i32.add
          local.set $l6
          local.get $l5
          i32.const 64
          i32.add
          local.set $l5
          local.get $l9
          i32.const -8
          i32.add
          local.tee $l9
          br_if $L4
        end
        local.get $l5
        i32.const -60
        i32.add
        local.set $l5
      end
      block $B5
        local.get $l7
        i32.eqz
        br_if $B5
        local.get $l5
        i32.const 4
        i32.add
        local.set $l5
        loop $L6
          local.get $l5
          i32.load
          local.get $l6
          i32.add
          local.set $l6
          local.get $l5
          i32.const 8
          i32.add
          local.set $l5
          local.get $l7
          i32.const -1
          i32.add
          local.tee $l7
          br_if $L6
        end
      end
      local.get $p1
      i32.const 8
      i32.add
      local.set $l5
      local.get $p1
      i32.const 4
      i32.add
      local.tee $l8
      i32.load
      local.get $p1
      i32.load offset=8
      local.tee $l7
      i32.sub
      local.get $l6
      i32.ge_u
      br_if $B0
      local.get $p1
      local.get $l7
      local.get $l6
      call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
    end
    block $B7
      local.get $p3
      i32.eqz
      br_if $B7
      local.get $p2
      local.get $l4
      i32.add
      local.set $p3
      local.get $l5
      i32.load
      local.set $l5
      loop $L8
        local.get $p2
        i32.load
        local.set $l9
        block $B9
          local.get $l8
          i32.load
          local.get $l5
          i32.sub
          local.get $p2
          i32.const 4
          i32.add
          i32.load
          local.tee $l7
          i32.ge_u
          br_if $B9
          local.get $p1
          local.get $l5
          local.get $l7
          call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
          local.get $p1
          i32.load offset=8
          local.set $l5
        end
        local.get $p1
        i32.load
        local.get $l5
        i32.add
        local.get $l9
        local.get $l7
        call $memcpy
        drop
        local.get $p1
        local.get $l5
        local.get $l7
        i32.add
        local.tee $l5
        i32.store offset=8
        local.get $p3
        local.get $p2
        i32.const 8
        i32.add
        local.tee $p2
        i32.ne
        br_if $L8
      end
    end
    local.get $p0
    i32.const 0
    i32.store
    local.get $p0
    local.get $l6
    i32.store offset=4)
  (func $_ZN3std2io5impls74_$LT$impl$u20$std..io..Write$u20$for$u20$alloc..vec..Vec$LT$u8$C$A$GT$$GT$17is_write_vectored17hda3f832df0321a28E (type $t4) (param $p0 i32) (result i32)
    i32.const 1)
  (func $_ZN3std2io5impls74_$LT$impl$u20$std..io..Write$u20$for$u20$alloc..vec..Vec$LT$u8$C$A$GT$$GT$9write_all17h6bc7ff6998e1df05E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32)
    block $B0
      local.get $p1
      i32.const 4
      i32.add
      i32.load
      local.get $p1
      i32.const 8
      i32.add
      local.tee $l4
      i32.load
      local.tee $l5
      i32.sub
      local.get $p3
      i32.ge_u
      br_if $B0
      local.get $p1
      local.get $l5
      local.get $p3
      call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
      local.get $l4
      i32.load
      local.set $l5
    end
    local.get $p1
    i32.load
    local.get $l5
    i32.add
    local.get $p2
    local.get $p3
    call $memcpy
    drop
    local.get $p0
    i32.const 4
    i32.store8
    local.get $l4
    local.get $l5
    local.get $p3
    i32.add
    i32.store)
  (func $_ZN3std2io5impls74_$LT$impl$u20$std..io..Write$u20$for$u20$alloc..vec..Vec$LT$u8$C$A$GT$$GT$5flush17h5a7fbf237751575fE (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    i32.const 4
    i32.store8)
  (func $_ZN3std2io5Write18write_all_vectored17h924f39f54efaec1aE (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              local.get $p3
              br_if $B4
              i32.const 0
              local.set $l5
              br $B3
            end
            local.get $p2
            i32.const 4
            i32.add
            local.set $l6
            local.get $p3
            i32.const -1
            i32.add
            i32.const 536870911
            i32.and
            i32.const 1
            i32.add
            local.set $l7
            i32.const 0
            local.set $l5
            block $B5
              loop $L6
                local.get $l6
                i32.load
                br_if $B5
                local.get $l6
                i32.const 8
                i32.add
                local.set $l6
                local.get $l7
                local.get $l5
                i32.const 1
                i32.add
                local.tee $l5
                i32.ne
                br_if $L6
              end
              local.get $l7
              local.set $l5
            end
            local.get $l5
            local.get $p3
            i32.gt_u
            br_if $B2
          end
          local.get $p3
          local.get $l5
          i32.sub
          local.tee $l7
          i32.eqz
          br_if $B1
          local.get $p2
          local.get $l5
          i32.const 3
          i32.shl
          i32.add
          local.set $l5
          block $B7
            loop $L8
              local.get $l4
              i32.const 8
              i32.add
              i32.const 2
              local.get $l5
              local.get $l7
              call $_ZN4wasi13lib_generated8fd_write17h3060209719e3ef69E
              block $B9
                block $B10
                  local.get $l4
                  i32.load16_u offset=8
                  br_if $B10
                  local.get $l4
                  i32.load offset=12
                  local.tee $l8
                  br_if $B9
                  local.get $p0
                  i32.const 1050704
                  i64.extend_i32_u
                  i64.const 32
                  i64.shl
                  i64.const 2
                  i64.or
                  i64.store align=4
                  br $B0
                end
                local.get $l4
                local.get $l4
                i32.load16_u offset=10
                i32.store16 offset=6
                local.get $l4
                i32.const 6
                i32.add
                call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
                i32.const 65535
                i32.and
                local.tee $l6
                call $_ZN3std3sys4wasi17decode_error_kind17h653960bfba1bf58fE
                i32.const 255
                i32.and
                i32.const 35
                i32.eq
                br_if $L8
                local.get $p0
                i32.const 0
                i32.store
                local.get $p0
                i32.const 4
                i32.add
                local.get $l6
                i32.store
                br $B0
              end
              local.get $l5
              i32.const 4
              i32.add
              local.set $l6
              local.get $l7
              i32.const -1
              i32.add
              i32.const 536870911
              i32.and
              i32.const 1
              i32.add
              local.set $l9
              i32.const 0
              local.set $p3
              i32.const 0
              local.set $p2
              block $B11
                loop $L12
                  local.get $l6
                  i32.load
                  local.get $p2
                  i32.add
                  local.tee $l10
                  local.get $l8
                  i32.gt_u
                  br_if $B11
                  local.get $l6
                  i32.const 8
                  i32.add
                  local.set $l6
                  local.get $l10
                  local.set $p2
                  local.get $l9
                  local.get $p3
                  i32.const 1
                  i32.add
                  local.tee $p3
                  i32.ne
                  br_if $L12
                end
                local.get $l10
                local.set $p2
                local.get $l9
                local.set $p3
              end
              block $B13
                local.get $l7
                local.get $p3
                i32.lt_u
                br_if $B13
                local.get $l7
                local.get $p3
                i32.sub
                local.tee $l7
                i32.eqz
                br_if $B1
                local.get $l5
                local.get $p3
                i32.const 3
                i32.shl
                i32.add
                local.tee $l5
                i32.load offset=4
                local.tee $p3
                local.get $l8
                local.get $p2
                i32.sub
                local.tee $l6
                i32.lt_u
                br_if $B7
                local.get $l5
                i32.const 4
                i32.add
                local.get $p3
                local.get $l6
                i32.sub
                i32.store
                local.get $l5
                local.get $l5
                i32.load
                local.get $l6
                i32.add
                i32.store
                br $L8
              end
            end
            local.get $p3
            local.get $l7
            i32.const 1050860
            call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
            unreachable
          end
          local.get $l4
          i32.const 28
          i32.add
          i32.const 0
          i32.store
          local.get $l4
          i32.const 1048920
          i32.store offset=24
          local.get $l4
          i64.const 1
          i64.store offset=12 align=4
          local.get $l4
          i32.const 1052396
          i32.store offset=8
          local.get $l4
          i32.const 8
          i32.add
          i32.const 1052436
          call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
          unreachable
        end
        local.get $l5
        local.get $p3
        i32.const 1050860
        call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
        unreachable
      end
      local.get $p0
      i32.const 4
      i32.store8
    end
    local.get $l4
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $_ZN61_$LT$$RF$std..io..stdio..Stdout$u20$as$u20$std..io..Write$GT$9write_fmt17h737c72f244e0e9a7E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p1
            i32.load
            i32.load
            local.tee $p1
            i32.load
            i32.const 1059564
            i32.eq
            br_if $B3
            local.get $p1
            i32.load8_u offset=28
            local.set $l4
            local.get $p1
            i32.const 1
            i32.store8 offset=28
            local.get $l3
            local.get $l4
            i32.const 1
            i32.and
            local.tee $l4
            i32.store8 offset=8
            local.get $l4
            br_if $B1
            local.get $p1
            i32.const 1
            i32.store offset=4
            local.get $p1
            i32.const 1059564
            i32.store
            br $B2
          end
          local.get $p1
          i32.load offset=4
          local.tee $l4
          i32.const 1
          i32.add
          local.tee $l5
          local.get $l4
          i32.lt_u
          br_if $B0
          local.get $p1
          local.get $l5
          i32.store offset=4
        end
        local.get $l3
        local.get $p1
        i32.store offset=4
        local.get $l3
        i32.const 4
        i32.store8 offset=12
        local.get $l3
        local.get $l3
        i32.const 4
        i32.add
        i32.store offset=8
        local.get $l3
        i32.const 24
        i32.add
        i32.const 16
        i32.add
        local.get $p2
        i32.const 16
        i32.add
        i64.load align=4
        i64.store
        local.get $l3
        i32.const 24
        i32.add
        i32.const 8
        i32.add
        local.get $p2
        i32.const 8
        i32.add
        i64.load align=4
        i64.store
        local.get $l3
        local.get $p2
        i64.load align=4
        i64.store offset=24
        block $B4
          block $B5
            local.get $l3
            i32.const 8
            i32.add
            i32.const 1050944
            local.get $l3
            i32.const 24
            i32.add
            call $_ZN4core3fmt5write17h64a435d9d6b334f1E
            i32.eqz
            br_if $B5
            block $B6
              local.get $l3
              i32.load8_u offset=12
              i32.const 4
              i32.ne
              br_if $B6
              local.get $p0
              i32.const 1050908
              i64.extend_i32_u
              i64.const 32
              i64.shl
              i64.const 2
              i64.or
              i64.store align=4
              br $B4
            end
            local.get $p0
            local.get $l3
            i64.load offset=12 align=4
            i64.store align=4
            br $B4
          end
          local.get $p0
          i32.const 4
          i32.store8
          local.get $l3
          i32.load8_u offset=12
          i32.const 3
          i32.ne
          br_if $B4
          local.get $l3
          i32.const 16
          i32.add
          i32.load
          local.tee $p1
          i32.load
          local.get $p1
          i32.load offset=4
          i32.load
          call_indirect $T0 (type $t1)
          block $B7
            local.get $p1
            i32.load offset=4
            local.tee $p2
            i32.load offset=4
            local.tee $p0
            i32.eqz
            br_if $B7
            local.get $p1
            i32.load
            local.get $p0
            local.get $p2
            i32.load offset=8
            call $__rust_dealloc
          end
          local.get $l3
          i32.load offset=16
          i32.const 12
          i32.const 4
          call $__rust_dealloc
        end
        local.get $l3
        i32.load offset=4
        local.tee $p1
        local.get $p1
        i32.load offset=4
        i32.const -1
        i32.add
        local.tee $p2
        i32.store offset=4
        block $B8
          local.get $p2
          br_if $B8
          local.get $p1
          i32.const 0
          i32.store8 offset=28
          local.get $p1
          i32.const 0
          i32.store
        end
        local.get $l3
        i32.const 48
        i32.add
        global.set $__stack_pointer
        return
      end
      local.get $l3
      i32.const 44
      i32.add
      i32.const 0
      i32.store
      local.get $l3
      i32.const 40
      i32.add
      i32.const 1048920
      i32.store
      local.get $l3
      i64.const 1
      i64.store offset=28 align=4
      local.get $l3
      i32.const 1052592
      i32.store offset=24
      local.get $l3
      i32.const 8
      i32.add
      local.get $l3
      i32.const 24
      i32.add
      call $_ZN4core9panicking13assert_failed17hdf6843c1d876d039E
      unreachable
    end
    i32.const 1051432
    i32.const 38
    i32.const 1051508
    call $_ZN4core6option13expect_failed17h2917b44da418e74cE
    unreachable)
  (func $_ZN3std2io5stdio6_print17h2d317cc9ca4d4730E (type $t1) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    global.get $__stack_pointer
    i32.const 96
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    local.get $l1
    i32.const 16
    i32.add
    local.get $p0
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l1
    i32.const 8
    i32.add
    local.get $p0
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l1
    local.get $p0
    i64.load align=4
    i64.store
    local.get $l1
    i32.const 6
    i32.store offset=28
    local.get $l1
    i32.const 1050828
    i32.store offset=24
    block $B0
      block $B1
        i32.const 0
        i32.load8_u offset=1059489
        i32.eqz
        br_if $B1
        block $B2
          i32.const 0
          i32.load offset=1059556
          br_if $B2
          i32.const 0
          i64.const 1
          i64.store offset=1059556 align=4
          br $B1
        end
        i32.const 0
        i32.load offset=1059560
        local.set $p0
        i32.const 0
        i32.const 0
        i32.store offset=1059560
        local.get $p0
        i32.eqz
        br_if $B1
        local.get $p0
        i32.load8_u offset=8
        local.set $l2
        i32.const 1
        local.set $l3
        local.get $p0
        i32.const 1
        i32.store8 offset=8
        local.get $l1
        local.get $l2
        i32.const 1
        i32.and
        local.tee $l2
        i32.store8 offset=56
        block $B3
          local.get $l2
          br_if $B3
          block $B4
            i32.const 0
            i32.load offset=1059552
            i32.const 2147483647
            i32.and
            i32.eqz
            br_if $B4
            call $_ZN3std9panicking11panic_count17is_zero_slow_path17h86f2705f5a70ad00E
            local.set $l3
          end
          local.get $l1
          i32.const 4
          i32.store8 offset=60
          local.get $l1
          local.get $p0
          i32.const 12
          i32.add
          i32.store offset=56
          local.get $l1
          i32.const 72
          i32.add
          i32.const 16
          i32.add
          local.get $l1
          i32.const 16
          i32.add
          i64.load
          i64.store
          local.get $l1
          i32.const 72
          i32.add
          i32.const 8
          i32.add
          local.get $l1
          i32.const 8
          i32.add
          i64.load
          i64.store
          local.get $l1
          local.get $l1
          i64.load
          i64.store offset=72
          block $B5
            block $B6
              local.get $l1
              i32.const 56
              i32.add
              i32.const 1050968
              local.get $l1
              i32.const 72
              i32.add
              call $_ZN4core3fmt5write17h64a435d9d6b334f1E
              i32.eqz
              br_if $B6
              local.get $l1
              i32.load8_u offset=60
              i32.const 4
              i32.eq
              br_if $B5
              local.get $l1
              i32.load8_u offset=60
              i32.const 3
              i32.ne
              br_if $B5
              local.get $l1
              i32.const 64
              i32.add
              i32.load
              local.tee $l2
              i32.load
              local.get $l2
              i32.load offset=4
              i32.load
              call_indirect $T0 (type $t1)
              block $B7
                local.get $l2
                i32.load offset=4
                local.tee $l4
                i32.load offset=4
                local.tee $l5
                i32.eqz
                br_if $B7
                local.get $l2
                i32.load
                local.get $l5
                local.get $l4
                i32.load offset=8
                call $__rust_dealloc
              end
              local.get $l2
              i32.const 12
              i32.const 4
              call $__rust_dealloc
              br $B5
            end
            local.get $l1
            i32.load8_u offset=60
            i32.const 3
            i32.ne
            br_if $B5
            local.get $l1
            i32.const 64
            i32.add
            i32.load
            local.tee $l2
            i32.load
            local.get $l2
            i32.load offset=4
            i32.load
            call_indirect $T0 (type $t1)
            block $B8
              local.get $l2
              i32.load offset=4
              local.tee $l4
              i32.load offset=4
              local.tee $l5
              i32.eqz
              br_if $B8
              local.get $l2
              i32.load
              local.get $l5
              local.get $l4
              i32.load offset=8
              call $__rust_dealloc
            end
            local.get $l1
            i32.load offset=64
            i32.const 12
            i32.const 4
            call $__rust_dealloc
          end
          block $B9
            local.get $l3
            i32.eqz
            br_if $B9
            i32.const 0
            i32.load offset=1059552
            i32.const 2147483647
            i32.and
            i32.eqz
            br_if $B9
            call $_ZN3std9panicking11panic_count17is_zero_slow_path17h86f2705f5a70ad00E
            br_if $B9
            local.get $p0
            i32.const 1
            i32.store8 offset=9
          end
          local.get $p0
          i32.const 0
          i32.store8 offset=8
          i32.const 0
          i32.load offset=1059560
          local.set $l3
          i32.const 0
          local.get $p0
          i32.store offset=1059560
          local.get $l3
          i32.eqz
          br_if $B0
          local.get $l3
          local.get $l3
          i32.load
          local.tee $p0
          i32.const -1
          i32.add
          i32.store
          local.get $p0
          i32.const 1
          i32.ne
          br_if $B0
          local.get $l3
          call $_ZN5alloc4sync12Arc$LT$T$GT$9drop_slow17hc1a21b2375a169ecE
          br $B0
        end
        local.get $l1
        i32.const 92
        i32.add
        i32.const 0
        i32.store
        local.get $l1
        i32.const 88
        i32.add
        i32.const 1048920
        i32.store
        local.get $l1
        i64.const 1
        i64.store offset=76 align=4
        local.get $l1
        i32.const 1052592
        i32.store offset=72
        local.get $l1
        i32.const 56
        i32.add
        local.get $l1
        i32.const 72
        i32.add
        call $_ZN4core9panicking13assert_failed17hdf6843c1d876d039E
        unreachable
      end
      block $B10
        i32.const 0
        i32.load offset=1059492
        i32.const 3
        i32.eq
        br_if $B10
        i32.const 0
        i32.load offset=1059492
        i32.const 3
        i32.eq
        br_if $B10
        local.get $l1
        i32.const 1059496
        i32.store offset=56
        local.get $l1
        local.get $l1
        i32.const 56
        i32.add
        i32.store offset=72
        i32.const 1059492
        i32.const 1
        local.get $l1
        i32.const 72
        i32.add
        i32.const 1051112
        i32.const 1051096
        call $_ZN3std4sync4once4Once10call_inner17h1897bf0262aa8dc5E
      end
      local.get $l1
      i32.const 1059496
      i32.store offset=44
      local.get $l1
      local.get $l1
      i32.const 44
      i32.add
      i32.store offset=56
      local.get $l1
      i32.const 72
      i32.add
      i32.const 16
      i32.add
      local.get $l1
      i32.const 16
      i32.add
      i64.load
      i64.store
      local.get $l1
      i32.const 72
      i32.add
      i32.const 8
      i32.add
      local.get $l1
      i32.const 8
      i32.add
      i64.load
      i64.store
      local.get $l1
      local.get $l1
      i64.load
      i64.store offset=72
      local.get $l1
      i32.const 32
      i32.add
      local.get $l1
      i32.const 56
      i32.add
      local.get $l1
      i32.const 72
      i32.add
      call $_ZN61_$LT$$RF$std..io..stdio..Stdout$u20$as$u20$std..io..Write$GT$9write_fmt17h737c72f244e0e9a7E
      local.get $l1
      i32.load8_u offset=32
      i32.const 4
      i32.eq
      br_if $B0
      local.get $l1
      local.get $l1
      i64.load offset=32
      i64.store offset=48
      local.get $l1
      i32.const 92
      i32.add
      i32.const 2
      i32.store
      local.get $l1
      i32.const 68
      i32.add
      i32.const 10
      i32.store
      local.get $l1
      i64.const 2
      i64.store offset=76 align=4
      local.get $l1
      i32.const 1050796
      i32.store offset=72
      local.get $l1
      i32.const 9
      i32.store offset=60
      local.get $l1
      local.get $l1
      i32.const 56
      i32.add
      i32.store offset=88
      local.get $l1
      local.get $l1
      i32.const 48
      i32.add
      i32.store offset=64
      local.get $l1
      local.get $l1
      i32.const 24
      i32.add
      i32.store offset=56
      local.get $l1
      i32.const 72
      i32.add
      i32.const 1050812
      call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
      unreachable
    end
    local.get $l1
    i32.const 96
    i32.add
    global.set $__stack_pointer)
  (func $_ZN3std2io5Write9write_all17hdb7bcfec18f35a47E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          local.get $p3
          i32.eqz
          br_if $B2
          loop $L3
            local.get $l4
            local.get $p3
            i32.store offset=12
            local.get $l4
            local.get $p2
            i32.store offset=8
            local.get $l4
            i32.const 16
            i32.add
            i32.const 2
            local.get $l4
            i32.const 8
            i32.add
            i32.const 1
            call $_ZN4wasi13lib_generated8fd_write17h3060209719e3ef69E
            block $B4
              block $B5
                block $B6
                  local.get $l4
                  i32.load16_u offset=16
                  br_if $B6
                  local.get $l4
                  i32.load offset=20
                  local.tee $l5
                  br_if $B5
                  local.get $p0
                  i32.const 1050704
                  i64.extend_i32_u
                  i64.const 32
                  i64.shl
                  i64.const 2
                  i64.or
                  i64.store align=4
                  br $B1
                end
                local.get $l4
                local.get $l4
                i32.load16_u offset=18
                i32.store16 offset=30
                local.get $l4
                i32.const 30
                i32.add
                call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
                i32.const 65535
                i32.and
                local.tee $l5
                call $_ZN3std3sys4wasi17decode_error_kind17h653960bfba1bf58fE
                i32.const 255
                i32.and
                i32.const 35
                i32.eq
                br_if $B4
                local.get $p0
                i32.const 0
                i32.store
                local.get $p0
                i32.const 4
                i32.add
                local.get $l5
                i32.store
                br $B1
              end
              local.get $p3
              local.get $l5
              i32.lt_u
              br_if $B0
              local.get $p2
              local.get $l5
              i32.add
              local.set $p2
              local.get $p3
              local.get $l5
              i32.sub
              local.set $p3
            end
            local.get $p3
            br_if $L3
          end
        end
        local.get $p0
        i32.const 4
        i32.store8
      end
      local.get $l4
      i32.const 32
      i32.add
      global.set $__stack_pointer
      return
    end
    local.get $l5
    local.get $p3
    i32.const 1050876
    call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
    unreachable)
  (func $_ZN3std2io5Write18write_all_vectored17h874fd4c946a0a9aeE (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              local.get $p3
              br_if $B4
              i32.const 0
              local.set $l5
              br $B3
            end
            local.get $p2
            i32.const 4
            i32.add
            local.set $l6
            local.get $p3
            i32.const -1
            i32.add
            i32.const 536870911
            i32.and
            i32.const 1
            i32.add
            local.set $l7
            i32.const 0
            local.set $l5
            block $B5
              loop $L6
                local.get $l6
                i32.load
                br_if $B5
                local.get $l6
                i32.const 8
                i32.add
                local.set $l6
                local.get $l7
                local.get $l5
                i32.const 1
                i32.add
                local.tee $l5
                i32.ne
                br_if $L6
              end
              local.get $l7
              local.set $l5
            end
            local.get $l5
            local.get $p3
            i32.gt_u
            br_if $B2
          end
          local.get $p3
          local.get $l5
          i32.sub
          local.tee $l8
          i32.eqz
          br_if $B1
          local.get $p2
          local.get $l5
          i32.const 3
          i32.shl
          i32.add
          local.set $l9
          local.get $p1
          i32.const 4
          i32.add
          local.set $l10
          block $B7
            loop $L8
              local.get $l8
              i32.const -1
              i32.add
              i32.const 536870911
              i32.and
              local.tee $l6
              i32.const 1
              i32.add
              local.tee $l11
              i32.const 7
              i32.and
              local.set $l5
              block $B9
                block $B10
                  local.get $l6
                  i32.const 7
                  i32.ge_u
                  br_if $B10
                  i32.const 0
                  local.set $p3
                  local.get $l9
                  local.set $l6
                  br $B9
                end
                local.get $l9
                i32.const 60
                i32.add
                local.set $l6
                local.get $l11
                i32.const 1073741816
                i32.and
                local.set $l7
                i32.const 0
                local.set $p3
                loop $L11
                  local.get $l6
                  i32.load
                  local.get $l6
                  i32.const -8
                  i32.add
                  i32.load
                  local.get $l6
                  i32.const -16
                  i32.add
                  i32.load
                  local.get $l6
                  i32.const -24
                  i32.add
                  i32.load
                  local.get $l6
                  i32.const -32
                  i32.add
                  i32.load
                  local.get $l6
                  i32.const -40
                  i32.add
                  i32.load
                  local.get $l6
                  i32.const -48
                  i32.add
                  i32.load
                  local.get $l6
                  i32.const -56
                  i32.add
                  i32.load
                  local.get $p3
                  i32.add
                  i32.add
                  i32.add
                  i32.add
                  i32.add
                  i32.add
                  i32.add
                  i32.add
                  local.set $p3
                  local.get $l6
                  i32.const 64
                  i32.add
                  local.set $l6
                  local.get $l7
                  i32.const -8
                  i32.add
                  local.tee $l7
                  br_if $L11
                end
                local.get $l6
                i32.const -60
                i32.add
                local.set $l6
              end
              block $B12
                local.get $l5
                i32.eqz
                br_if $B12
                local.get $l6
                i32.const 4
                i32.add
                local.set $l6
                loop $L13
                  local.get $l6
                  i32.load
                  local.get $p3
                  i32.add
                  local.set $p3
                  local.get $l6
                  i32.const 8
                  i32.add
                  local.set $l6
                  local.get $l5
                  i32.const -1
                  i32.add
                  local.tee $l5
                  br_if $L13
                end
              end
              local.get $l8
              i32.const 3
              i32.shl
              local.set $l5
              block $B14
                local.get $l10
                i32.load
                local.get $p1
                i32.load offset=8
                local.tee $l6
                i32.sub
                local.get $p3
                i32.ge_u
                br_if $B14
                local.get $p1
                local.get $l6
                local.get $p3
                call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
                local.get $p1
                i32.load offset=8
                local.set $l6
              end
              local.get $l9
              local.get $l5
              i32.add
              local.set $l12
              local.get $l9
              local.set $l5
              loop $L15
                local.get $l5
                i32.load
                local.set $p2
                block $B16
                  local.get $l10
                  i32.load
                  local.get $l6
                  i32.sub
                  local.get $l5
                  i32.const 4
                  i32.add
                  i32.load
                  local.tee $l7
                  i32.ge_u
                  br_if $B16
                  local.get $p1
                  local.get $l6
                  local.get $l7
                  call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
                  local.get $p1
                  i32.load offset=8
                  local.set $l6
                end
                local.get $p1
                i32.load
                local.get $l6
                i32.add
                local.get $p2
                local.get $l7
                call $memcpy
                drop
                local.get $p1
                local.get $l6
                local.get $l7
                i32.add
                local.tee $l6
                i32.store offset=8
                local.get $l12
                local.get $l5
                i32.const 8
                i32.add
                local.tee $l5
                i32.ne
                br_if $L15
              end
              block $B17
                local.get $p3
                br_if $B17
                local.get $p0
                i32.const 1050704
                i64.extend_i32_u
                i64.const 32
                i64.shl
                i64.const 2
                i64.or
                i64.store align=4
                br $B0
              end
              local.get $l9
              i32.const 4
              i32.add
              local.set $l6
              i32.const 0
              local.set $l5
              i32.const 0
              local.set $l7
              block $B18
                loop $L19
                  local.get $l6
                  i32.load
                  local.get $l7
                  i32.add
                  local.tee $p2
                  local.get $p3
                  i32.gt_u
                  br_if $B18
                  local.get $l6
                  i32.const 8
                  i32.add
                  local.set $l6
                  local.get $p2
                  local.set $l7
                  local.get $l11
                  local.get $l5
                  i32.const 1
                  i32.add
                  local.tee $l5
                  i32.ne
                  br_if $L19
                end
                local.get $p2
                local.set $l7
                local.get $l11
                local.set $l5
              end
              block $B20
                local.get $l8
                local.get $l5
                i32.lt_u
                br_if $B20
                local.get $l8
                local.get $l5
                i32.sub
                local.tee $l8
                i32.eqz
                br_if $B1
                local.get $l9
                local.get $l5
                i32.const 3
                i32.shl
                local.tee $l5
                i32.add
                local.tee $p2
                i32.load offset=4
                local.tee $l12
                local.get $p3
                local.get $l7
                i32.sub
                local.tee $l6
                i32.lt_u
                br_if $B7
                local.get $p2
                i32.const 4
                i32.add
                local.get $l12
                local.get $l6
                i32.sub
                i32.store
                local.get $l9
                local.get $l5
                i32.add
                local.tee $l9
                local.get $l9
                i32.load
                local.get $l6
                i32.add
                i32.store
                br $L8
              end
            end
            local.get $l5
            local.get $l8
            i32.const 1050860
            call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
            unreachable
          end
          local.get $l4
          i32.const 28
          i32.add
          i32.const 0
          i32.store
          local.get $l4
          i32.const 1048920
          i32.store offset=24
          local.get $l4
          i64.const 1
          i64.store offset=12 align=4
          local.get $l4
          i32.const 1052396
          i32.store offset=8
          local.get $l4
          i32.const 8
          i32.add
          i32.const 1052436
          call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
          unreachable
        end
        local.get $l5
        local.get $p3
        i32.const 1050860
        call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
        unreachable
      end
      local.get $p0
      i32.const 4
      i32.store8
    end
    local.get $l4
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $_ZN3std2io5Write9write_fmt17hf640f722c5242650E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    i32.const 4
    i32.store8 offset=12
    local.get $l3
    local.get $p1
    i32.store offset=8
    local.get $l3
    i32.const 24
    i32.add
    i32.const 16
    i32.add
    local.get $p2
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l3
    i32.const 24
    i32.add
    i32.const 8
    i32.add
    local.get $p2
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l3
    local.get $p2
    i64.load align=4
    i64.store offset=24
    block $B0
      block $B1
        local.get $l3
        i32.const 8
        i32.add
        i32.const 1050968
        local.get $l3
        i32.const 24
        i32.add
        call $_ZN4core3fmt5write17h64a435d9d6b334f1E
        i32.eqz
        br_if $B1
        block $B2
          local.get $l3
          i32.load8_u offset=12
          i32.const 4
          i32.ne
          br_if $B2
          local.get $p0
          i32.const 1050908
          i64.extend_i32_u
          i64.const 32
          i64.shl
          i64.const 2
          i64.or
          i64.store align=4
          br $B0
        end
        local.get $p0
        local.get $l3
        i64.load offset=12 align=4
        i64.store align=4
        br $B0
      end
      local.get $p0
      i32.const 4
      i32.store8
      local.get $l3
      i32.load8_u offset=12
      i32.const 3
      i32.ne
      br_if $B0
      local.get $l3
      i32.const 16
      i32.add
      i32.load
      local.tee $p2
      i32.load
      local.get $p2
      i32.load offset=4
      i32.load
      call_indirect $T0 (type $t1)
      block $B3
        local.get $p2
        i32.load offset=4
        local.tee $p1
        i32.load offset=4
        local.tee $p0
        i32.eqz
        br_if $B3
        local.get $p2
        i32.load
        local.get $p0
        local.get $p1
        i32.load offset=8
        call $__rust_dealloc
      end
      local.get $l3
      i32.load offset=16
      i32.const 12
      i32.const 4
      call $__rust_dealloc
    end
    local.get $l3
    i32.const 48
    i32.add
    global.set $__stack_pointer)
  (func $_ZN80_$LT$std..io..Write..write_fmt..Adapter$LT$T$GT$$u20$as$u20$core..fmt..Write$GT$9write_str17h742c36c2aa138293E (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i64) (local $l5 i32) (local $l6 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    i32.const 8
    i32.add
    local.get $p0
    i32.load
    local.get $p1
    local.get $p2
    call $_ZN61_$LT$std..io..stdio..StdoutLock$u20$as$u20$std..io..Write$GT$9write_all17h829d7f57f80999dfE
    block $B0
      local.get $l3
      i32.load8_u offset=8
      local.tee $p1
      i32.const 4
      i32.eq
      br_if $B0
      local.get $l3
      i64.load offset=8
      local.set $l4
      block $B1
        local.get $p0
        i32.load8_u offset=4
        i32.const 3
        i32.ne
        br_if $B1
        local.get $p0
        i32.const 8
        i32.add
        i32.load
        local.tee $p2
        i32.load
        local.get $p2
        i32.load offset=4
        i32.load
        call_indirect $T0 (type $t1)
        block $B2
          local.get $p2
          i32.load offset=4
          local.tee $l5
          i32.load offset=4
          local.tee $l6
          i32.eqz
          br_if $B2
          local.get $p2
          i32.load
          local.get $l6
          local.get $l5
          i32.load offset=8
          call $__rust_dealloc
        end
        local.get $p2
        i32.const 12
        i32.const 4
        call $__rust_dealloc
      end
      local.get $p0
      local.get $l4
      i64.store offset=4 align=4
    end
    local.get $l3
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p1
    i32.const 4
    i32.ne)
  (func $_ZN80_$LT$std..io..Write..write_fmt..Adapter$LT$T$GT$$u20$as$u20$core..fmt..Write$GT$9write_str17h824f0cbe3c4a395fE (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32)
    block $B0
      local.get $p0
      i32.load
      local.tee $l3
      i32.const 4
      i32.add
      i32.load
      local.get $l3
      i32.const 8
      i32.add
      local.tee $l4
      i32.load
      local.tee $p0
      i32.sub
      local.get $p2
      i32.ge_u
      br_if $B0
      local.get $l3
      local.get $p0
      local.get $p2
      call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$7reserve21do_reserve_and_handle17he71f88a576e01461E
      local.get $l4
      i32.load
      local.set $p0
    end
    local.get $l3
    i32.load
    local.get $p0
    i32.add
    local.get $p1
    local.get $p2
    call $memcpy
    drop
    local.get $l4
    local.get $p0
    local.get $p2
    i32.add
    i32.store
    i32.const 0)
  (func $_ZN3std5panic19get_backtrace_style17h0abef6ef86c55a38E (type $t9) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l0
    global.set $__stack_pointer
    i32.const 0
    local.set $l1
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              i32.const 0
              i32.load offset=1059528
              br_table $B1 $B0 $B3 $B2 $B4
            end
            i32.const 1049156
            i32.const 40
            i32.const 1051016
            call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
            unreachable
          end
          i32.const 1
          local.set $l1
          br $B0
        end
        i32.const 2
        local.set $l1
        br $B0
      end
      local.get $l0
      i32.const 1049696
      i32.const 14
      call $_ZN3std3env7_var_os17h29a17237445b33b0E
      block $B5
        block $B6
          local.get $l0
          i32.load
          local.tee $l1
          i32.eqz
          br_if $B6
          i32.const 0
          local.set $l2
          local.get $l0
          i32.load offset=4
          local.set $l3
          block $B7
            block $B8
              block $B9
                local.get $l0
                i32.const 8
                i32.add
                i32.load
                i32.const -1
                i32.add
                br_table $B9 $B7 $B7 $B8 $B7
              end
              i32.const -2
              i32.const 0
              local.get $l1
              i32.load8_u
              i32.const 48
              i32.eq
              select
              local.set $l2
              br $B7
            end
            local.get $l1
            i32.load align=1
            i32.const 1819047270
            i32.eq
            local.set $l2
          end
          block $B10
            local.get $l3
            i32.eqz
            br_if $B10
            local.get $l1
            local.get $l3
            i32.const 1
            call $__rust_dealloc
          end
          i32.const 1
          local.set $l3
          i32.const 0
          local.set $l1
          block $B11
            local.get $l2
            i32.const 3
            i32.and
            br_table $B5 $B11 $B6 $B5
          end
          i32.const 2
          local.set $l3
          i32.const 1
          local.set $l1
          br $B5
        end
        i32.const 3
        local.set $l3
        i32.const 2
        local.set $l1
      end
      i32.const 0
      local.get $l3
      i32.store offset=1059528
    end
    local.get $l0
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $l1)
  (func $_ZN3std7process5abort17h237c8fae85f2ce92E (type $t0)
    call $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E
    unreachable)
  (func $_ZN3std4sync4once4Once15call_once_force28_$u7b$$u7b$closure$u7d$$u7d$17h799a8c877c6843f0E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    local.get $p0
    i32.load
    local.tee $l2
    i32.load
    local.set $p0
    local.get $l2
    i32.const 0
    i32.store
    block $B0
      block $B1
        local.get $p0
        i32.eqz
        br_if $B1
        i32.const 1024
        i32.const 1
        call $__rust_alloc
        local.tee $l2
        i32.eqz
        br_if $B0
        local.get $p0
        i32.const 0
        i32.store8 offset=28
        local.get $p0
        i32.const 0
        i32.store8 offset=24
        local.get $p0
        i64.const 1024
        i64.store offset=16 align=4
        local.get $p0
        local.get $l2
        i32.store offset=12
        local.get $p0
        i32.const 0
        i32.store offset=8
        local.get $p0
        i64.const 0
        i64.store align=4
        return
      end
      i32.const 1048987
      i32.const 43
      i32.const 1051132
      call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
      unreachable
    end
    i32.const 1024
    i32.const 1
    call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
    unreachable)
  (func $_ZN76_$LT$std..sync..poison..PoisonError$LT$T$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h8c1c8865a1d136dfE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    i32.const 8
    i32.add
    local.get $p1
    i32.const 1051300
    i32.const 11
    call $_ZN4core3fmt9Formatter12debug_struct17hbab99b39a6f88cb8E
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt8builders11DebugStruct21finish_non_exhaustive17h5098ad433d2bf0deE
    local.set $p1
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN91_$LT$std..sys_common..backtrace.._print..DisplayBacktrace$u20$as$u20$core..fmt..Display$GT$3fmt17h9f1e240acab2cdb1E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p0
    i32.load8_u
    local.set $l3
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN3std3env11current_dir17hdaa0a89a009d984eE
    block $B0
      block $B1
        local.get $l2
        i32.load offset=8
        br_if $B1
        local.get $l2
        i32.const 16
        i32.add
        i32.load
        local.set $l4
        local.get $l2
        i32.load offset=12
        local.set $p0
        br $B0
      end
      i32.const 0
      local.set $p0
      block $B2
        local.get $l2
        i32.load8_u offset=12
        i32.const 3
        i32.ne
        br_if $B2
        local.get $l2
        i32.const 16
        i32.add
        i32.load
        local.tee $l4
        i32.load
        local.get $l4
        i32.load offset=4
        i32.load
        call_indirect $T0 (type $t1)
        block $B3
          local.get $l4
          i32.load offset=4
          local.tee $l5
          i32.load offset=4
          local.tee $l6
          i32.eqz
          br_if $B3
          local.get $l4
          i32.load
          local.get $l6
          local.get $l5
          i32.load offset=8
          call $__rust_dealloc
        end
        local.get $l4
        i32.const 12
        i32.const 4
        call $__rust_dealloc
      end
    end
    local.get $l2
    i32.const 28
    i32.add
    i32.const 0
    i32.store
    local.get $l2
    i32.const 1048920
    i32.store offset=24
    local.get $l2
    i64.const 1
    i64.store offset=12 align=4
    local.get $l2
    i32.const 1051328
    i32.store offset=8
    block $B4
      block $B5
        block $B6
          local.get $p1
          local.get $l2
          i32.const 8
          i32.add
          call $_ZN4core3fmt9Formatter9write_fmt17h3c92d3032e5cf8d7E
          br_if $B6
          block $B7
            local.get $l3
            i32.const 255
            i32.and
            br_if $B7
            local.get $l2
            i32.const 28
            i32.add
            i32.const 0
            i32.store
            local.get $l2
            i32.const 1048920
            i32.store offset=24
            local.get $l2
            i64.const 1
            i64.store offset=12 align=4
            local.get $l2
            i32.const 1051424
            i32.store offset=8
            local.get $p1
            local.get $l2
            i32.const 8
            i32.add
            call $_ZN4core3fmt9Formatter9write_fmt17h3c92d3032e5cf8d7E
            br_if $B6
          end
          i32.const 0
          local.set $p1
          local.get $p0
          i32.eqz
          br_if $B4
          local.get $l4
          i32.eqz
          br_if $B4
          br $B5
        end
        i32.const 1
        local.set $p1
        local.get $p0
        i32.eqz
        br_if $B4
        local.get $l4
        i32.eqz
        br_if $B4
      end
      local.get $p0
      local.get $l4
      i32.const 1
      call $__rust_dealloc
    end
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN3std10sys_common9backtrace26__rust_end_short_backtrace17h8b85a47807a6eb71E (type $t1) (param $p0 i32)
    local.get $p0
    i32.load
    local.get $p0
    i32.load offset=4
    local.get $p0
    i32.load offset=8
    call $_ZN3std9panicking19begin_panic_handler28_$u7b$$u7b$closure$u7d$$u7d$17h6a7dd6b2774c3d2bE
    unreachable)
  (func $_ZN3std9panicking19begin_panic_handler28_$u7b$$u7b$closure$u7d$$u7d$17h6a7dd6b2774c3d2bE (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $p0
    i32.const 20
    i32.add
    i32.load
    local.set $l4
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p0
            i32.const 4
            i32.add
            i32.load
            br_table $B3 $B2 $B0
          end
          local.get $l4
          br_if $B0
          i32.const 1048920
          local.set $p0
          i32.const 0
          local.set $l4
          br $B1
        end
        local.get $l4
        br_if $B0
        local.get $p0
        i32.load
        local.tee $p0
        i32.load offset=4
        local.set $l4
        local.get $p0
        i32.load
        local.set $p0
      end
      local.get $l3
      local.get $l4
      i32.store offset=4
      local.get $l3
      local.get $p0
      i32.store
      local.get $l3
      i32.const 1052120
      local.get $p1
      call $_ZN4core5panic10panic_info9PanicInfo7message17h444247787ebca30fE
      local.get $p2
      local.get $p1
      call $_ZN4core5panic10panic_info9PanicInfo10can_unwind17hfe60d6e3abc99a98E
      call $_ZN3std9panicking20rust_panic_with_hook17h9a166021f8d492afE
      unreachable
    end
    local.get $l3
    i32.const 0
    i32.store offset=4
    local.get $l3
    local.get $p0
    i32.store
    local.get $l3
    i32.const 1052100
    local.get $p1
    call $_ZN4core5panic10panic_info9PanicInfo7message17h444247787ebca30fE
    local.get $p2
    local.get $p1
    call $_ZN4core5panic10panic_info9PanicInfo10can_unwind17hfe60d6e3abc99a98E
    call $_ZN3std9panicking20rust_panic_with_hook17h9a166021f8d492afE
    unreachable)
  (func $_ZN3std5alloc24default_alloc_error_hook17h2ca49935547869e3E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      i32.const 0
      i32.load8_u offset=1059480
      br_if $B0
      local.get $l2
      i32.const 11
      i32.store offset=4
      local.get $l2
      local.get $p0
      i32.store offset=12
      local.get $l2
      local.get $l2
      i32.const 12
      i32.add
      i32.store
      local.get $l2
      i32.const 4
      i32.store8 offset=20
      local.get $l2
      local.get $l2
      i32.const 56
      i32.add
      i32.store offset=16
      local.get $l2
      i32.const 52
      i32.add
      i32.const 1
      i32.store
      local.get $l2
      i64.const 2
      i64.store offset=36 align=4
      local.get $l2
      i32.const 1051684
      i32.store offset=32
      local.get $l2
      local.get $l2
      i32.store offset=48
      block $B1
        block $B2
          local.get $l2
          i32.const 16
          i32.add
          i32.const 1050920
          local.get $l2
          i32.const 32
          i32.add
          call $_ZN4core3fmt5write17h64a435d9d6b334f1E
          i32.eqz
          br_if $B2
          local.get $l2
          i32.load8_u offset=20
          i32.const 4
          i32.eq
          br_if $B1
          local.get $l2
          i32.load8_u offset=20
          i32.const 3
          i32.ne
          br_if $B1
          local.get $l2
          i32.const 24
          i32.add
          i32.load
          local.tee $p0
          i32.load
          local.get $p0
          i32.load offset=4
          i32.load
          call_indirect $T0 (type $t1)
          block $B3
            local.get $p0
            i32.load offset=4
            local.tee $l3
            i32.load offset=4
            local.tee $l4
            i32.eqz
            br_if $B3
            local.get $p0
            i32.load
            local.get $l4
            local.get $l3
            i32.load offset=8
            call $__rust_dealloc
          end
          local.get $p0
          i32.const 12
          i32.const 4
          call $__rust_dealloc
          br $B1
        end
        local.get $l2
        i32.load8_u offset=20
        i32.const 3
        i32.ne
        br_if $B1
        local.get $l2
        i32.const 24
        i32.add
        i32.load
        local.tee $p0
        i32.load
        local.get $p0
        i32.load offset=4
        i32.load
        call_indirect $T0 (type $t1)
        block $B4
          local.get $p0
          i32.load offset=4
          local.tee $l3
          i32.load offset=4
          local.tee $l4
          i32.eqz
          br_if $B4
          local.get $p0
          i32.load
          local.get $l4
          local.get $l3
          i32.load offset=8
          call $__rust_dealloc
        end
        local.get $l2
        i32.load offset=24
        i32.const 12
        i32.const 4
        call $__rust_dealloc
      end
      local.get $l2
      i32.const 64
      i32.add
      global.set $__stack_pointer
      return
    end
    local.get $l2
    i32.const 52
    i32.add
    i32.const 1
    i32.store
    local.get $l2
    i64.const 2
    i64.store offset=36 align=4
    local.get $l2
    i32.const 1051684
    i32.store offset=32
    local.get $l2
    i32.const 11
    i32.store offset=20
    local.get $l2
    local.get $p0
    i32.store
    local.get $l2
    local.get $l2
    i32.const 16
    i32.add
    i32.store offset=48
    local.get $l2
    local.get $l2
    i32.store offset=16
    local.get $l2
    i32.const 32
    i32.add
    i32.const 1051724
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $rust_oom (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    local.get $p0
    local.get $p1
    i32.const 0
    i32.load offset=1059536
    local.tee $l2
    i32.const 12
    local.get $l2
    select
    call_indirect $T0 (type $t3)
    call $_ZN3std7process5abort17h237c8fae85f2ce92E
    unreachable)
  (func $__rdl_alloc (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    block $B0
      block $B1
        local.get $p1
        i32.const 8
        i32.gt_u
        br_if $B1
        local.get $p1
        local.get $p0
        i32.le_u
        br_if $B0
      end
      local.get $p1
      local.get $p0
      call $aligned_alloc
      return
    end
    local.get $p0
    call $malloc)
  (func $__rdl_dealloc (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    local.get $p0
    call $free)
  (func $__rdl_realloc (type $t8) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    block $B0
      block $B1
        local.get $p2
        i32.const 8
        i32.gt_u
        br_if $B1
        local.get $p2
        local.get $p3
        i32.le_u
        br_if $B0
      end
      block $B2
        local.get $p2
        local.get $p3
        call $aligned_alloc
        local.tee $p2
        br_if $B2
        i32.const 0
        return
      end
      local.get $p2
      local.get $p0
      local.get $p3
      local.get $p1
      local.get $p1
      local.get $p3
      i32.gt_u
      select
      call $memcpy
      local.set $p3
      local.get $p0
      call $free
      local.get $p3
      return
    end
    local.get $p0
    local.get $p3
    call $realloc)
  (func $_ZN3std9panicking12default_hook28_$u7b$$u7b$closure$u7d$$u7d$17h46214d4dcd8120bbE (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    i32.const 20
    i32.add
    i32.const 3
    i32.store
    local.get $l3
    i32.const 32
    i32.add
    i32.const 20
    i32.add
    i32.const 13
    i32.store
    local.get $l3
    i32.const 44
    i32.add
    i32.const 9
    i32.store
    local.get $l3
    i64.const 4
    i64.store offset=4 align=4
    local.get $l3
    i32.const 1051916
    i32.store
    local.get $l3
    i32.const 9
    i32.store offset=36
    local.get $l3
    local.get $p0
    i32.load offset=8
    i32.store offset=48
    local.get $l3
    local.get $p0
    i32.load offset=4
    i32.store offset=40
    local.get $l3
    local.get $p0
    i32.load
    i32.store offset=32
    local.get $l3
    local.get $l3
    i32.const 32
    i32.add
    i32.store offset=16
    local.get $l3
    i32.const 24
    i32.add
    local.get $p1
    local.get $l3
    local.get $p2
    i32.load offset=36
    local.tee $l4
    call_indirect $T0 (type $t6)
    block $B0
      local.get $l3
      i32.load8_u offset=24
      i32.const 3
      i32.ne
      br_if $B0
      local.get $l3
      i32.load offset=28
      local.tee $p2
      i32.load
      local.get $p2
      i32.load offset=4
      i32.load
      call_indirect $T0 (type $t1)
      block $B1
        local.get $p2
        i32.load offset=4
        local.tee $l5
        i32.load offset=4
        local.tee $l6
        i32.eqz
        br_if $B1
        local.get $p2
        i32.load
        local.get $l6
        local.get $l5
        i32.load offset=8
        call $__rust_dealloc
      end
      local.get $p2
      i32.const 12
      i32.const 4
      call $__rust_dealloc
    end
    block $B2
      block $B3
        block $B4
          local.get $p0
          i32.load offset=12
          i32.load8_u
          local.tee $p0
          i32.const 3
          i32.eq
          br_if $B4
          block $B5
            block $B6
              block $B7
                local.get $p0
                br_table $B7 $B6 $B5 $B7
              end
              i32.const 0
              i32.load8_u offset=1059532
              local.set $p0
              i32.const 0
              i32.const 1
              i32.store8 offset=1059532
              local.get $l3
              local.get $p0
              i32.store8
              local.get $p0
              br_if $B3
              local.get $l3
              i32.const 52
              i32.add
              i32.const 1
              i32.store
              local.get $l3
              i64.const 1
              i64.store offset=36 align=4
              local.get $l3
              i32.const 1049712
              i32.store offset=32
              local.get $l3
              i32.const 14
              i32.store offset=4
              local.get $l3
              i32.const 0
              i32.store8 offset=63
              local.get $l3
              local.get $l3
              i32.store offset=48
              local.get $l3
              local.get $l3
              i32.const 63
              i32.add
              i32.store
              local.get $l3
              i32.const 24
              i32.add
              local.get $p1
              local.get $l3
              i32.const 32
              i32.add
              local.get $l4
              call_indirect $T0 (type $t6)
              i32.const 0
              i32.const 0
              i32.store8 offset=1059532
              local.get $l3
              i32.load8_u offset=24
              i32.const 3
              i32.ne
              br_if $B4
              local.get $l3
              i32.load offset=28
              local.tee $p0
              i32.load
              local.get $p0
              i32.load offset=4
              i32.load
              call_indirect $T0 (type $t1)
              block $B8
                local.get $p0
                i32.load offset=4
                local.tee $p1
                i32.load offset=4
                local.tee $p2
                i32.eqz
                br_if $B8
                local.get $p0
                i32.load
                local.get $p2
                local.get $p1
                i32.load offset=8
                call $__rust_dealloc
              end
              local.get $p0
              i32.const 12
              i32.const 4
              call $__rust_dealloc
              br $B4
            end
            i32.const 0
            i32.load8_u offset=1059532
            local.set $p0
            i32.const 0
            i32.const 1
            i32.store8 offset=1059532
            local.get $l3
            local.get $p0
            i32.store8
            local.get $p0
            br_if $B2
            local.get $l3
            i32.const 52
            i32.add
            i32.const 1
            i32.store
            local.get $l3
            i64.const 1
            i64.store offset=36 align=4
            local.get $l3
            i32.const 1049712
            i32.store offset=32
            local.get $l3
            i32.const 14
            i32.store offset=4
            local.get $l3
            i32.const 1
            i32.store8 offset=63
            local.get $l3
            local.get $l3
            i32.store offset=48
            local.get $l3
            local.get $l3
            i32.const 63
            i32.add
            i32.store
            local.get $l3
            i32.const 24
            i32.add
            local.get $p1
            local.get $l3
            i32.const 32
            i32.add
            local.get $l4
            call_indirect $T0 (type $t6)
            i32.const 0
            i32.const 0
            i32.store8 offset=1059532
            local.get $l3
            i32.load8_u offset=24
            i32.const 3
            i32.ne
            br_if $B4
            local.get $l3
            i32.load offset=28
            local.tee $p0
            i32.load
            local.get $p0
            i32.load offset=4
            i32.load
            call_indirect $T0 (type $t1)
            block $B9
              local.get $p0
              i32.load offset=4
              local.tee $p1
              i32.load offset=4
              local.tee $p2
              i32.eqz
              br_if $B9
              local.get $p0
              i32.load
              local.get $p2
              local.get $p1
              i32.load offset=8
              call $__rust_dealloc
            end
            local.get $p0
            i32.const 12
            i32.const 4
            call $__rust_dealloc
            br $B4
          end
          i32.const 0
          i32.load8_u offset=1059472
          local.set $p0
          i32.const 0
          i32.const 0
          i32.store8 offset=1059472
          local.get $p0
          i32.eqz
          br_if $B4
          local.get $l3
          i32.const 52
          i32.add
          i32.const 0
          i32.store
          local.get $l3
          i32.const 1048920
          i32.store offset=48
          local.get $l3
          i64.const 1
          i64.store offset=36 align=4
          local.get $l3
          i32.const 1052028
          i32.store offset=32
          local.get $l3
          local.get $p1
          local.get $l3
          i32.const 32
          i32.add
          local.get $l4
          call_indirect $T0 (type $t6)
          local.get $l3
          i32.load8_u
          i32.const 3
          i32.ne
          br_if $B4
          local.get $l3
          i32.load offset=4
          local.tee $p0
          i32.load
          local.get $p0
          i32.load offset=4
          i32.load
          call_indirect $T0 (type $t1)
          block $B10
            local.get $p0
            i32.load offset=4
            local.tee $p1
            i32.load offset=4
            local.tee $p2
            i32.eqz
            br_if $B10
            local.get $p0
            i32.load
            local.get $p2
            local.get $p1
            i32.load offset=8
            call $__rust_dealloc
          end
          local.get $p0
          i32.const 12
          i32.const 4
          call $__rust_dealloc
        end
        local.get $l3
        i32.const 64
        i32.add
        global.set $__stack_pointer
        return
      end
      local.get $l3
      i32.const 52
      i32.add
      i32.const 0
      i32.store
      local.get $l3
      i32.const 48
      i32.add
      i32.const 1048920
      i32.store
      local.get $l3
      i64.const 1
      i64.store offset=36 align=4
      local.get $l3
      i32.const 1052592
      i32.store offset=32
      local.get $l3
      local.get $l3
      i32.const 32
      i32.add
      call $_ZN4core9panicking13assert_failed17hdf6843c1d876d039E
      unreachable
    end
    local.get $l3
    i32.const 52
    i32.add
    i32.const 0
    i32.store
    local.get $l3
    i32.const 48
    i32.add
    i32.const 1048920
    i32.store
    local.get $l3
    i64.const 1
    i64.store offset=36 align=4
    local.get $l3
    i32.const 1052592
    i32.store offset=32
    local.get $l3
    local.get $l3
    i32.const 32
    i32.add
    call $_ZN4core9panicking13assert_failed17hdf6843c1d876d039E
    unreachable)
  (func $rust_begin_unwind (type $t1) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    local.get $p0
    call $_ZN4core5panic10panic_info9PanicInfo8location17h6e78c86147694e2aE
    i32.const 1052036
    call $_ZN4core6option15Option$LT$T$GT$6unwrap17h6fb9e42b17801906E
    local.set $l2
    local.get $p0
    call $_ZN4core5panic10panic_info9PanicInfo7message17h444247787ebca30fE
    call $_ZN4core6option15Option$LT$T$GT$6unwrap17h888399a1e25b98e0E
    local.set $l3
    local.get $l1
    local.get $l2
    i32.store offset=8
    local.get $l1
    local.get $p0
    i32.store offset=4
    local.get $l1
    local.get $l3
    i32.store
    local.get $l1
    call $_ZN3std10sys_common9backtrace26__rust_end_short_backtrace17h8b85a47807a6eb71E
    unreachable)
  (func $_ZN90_$LT$std..panicking..begin_panic_handler..PanicPayload$u20$as$u20$core..panic..BoxMeUp$GT$8take_box17hf881bad967b4c231E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i64)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p1
    i32.const 4
    i32.add
    local.set $l3
    block $B0
      local.get $p1
      i32.load offset=4
      br_if $B0
      local.get $p1
      i32.load
      local.set $l4
      local.get $l2
      i32.const 8
      i32.add
      i32.const 8
      i32.add
      local.tee $l5
      i32.const 0
      i32.store
      local.get $l2
      i64.const 1
      i64.store offset=8
      local.get $l2
      local.get $l2
      i32.const 8
      i32.add
      i32.store offset=20
      local.get $l2
      i32.const 24
      i32.add
      i32.const 16
      i32.add
      local.get $l4
      i32.const 16
      i32.add
      i64.load align=4
      i64.store
      local.get $l2
      i32.const 24
      i32.add
      i32.const 8
      i32.add
      local.get $l4
      i32.const 8
      i32.add
      i64.load align=4
      i64.store
      local.get $l2
      local.get $l4
      i64.load align=4
      i64.store offset=24
      local.get $l2
      i32.const 20
      i32.add
      i32.const 1048848
      local.get $l2
      i32.const 24
      i32.add
      call $_ZN4core3fmt5write17h64a435d9d6b334f1E
      drop
      local.get $l3
      i32.const 8
      i32.add
      local.get $l5
      i32.load
      i32.store
      local.get $l3
      local.get $l2
      i64.load offset=8
      i64.store align=4
    end
    local.get $l2
    i32.const 24
    i32.add
    i32.const 8
    i32.add
    local.tee $l4
    local.get $l3
    i32.const 8
    i32.add
    i32.load
    i32.store
    local.get $p1
    i32.const 12
    i32.add
    i32.const 0
    i32.store
    local.get $l3
    i64.load align=4
    local.set $l6
    local.get $p1
    i64.const 1
    i64.store offset=4 align=4
    local.get $l2
    local.get $l6
    i64.store offset=24
    block $B1
      i32.const 12
      i32.const 4
      call $__rust_alloc
      local.tee $p1
      br_if $B1
      i32.const 12
      i32.const 4
      call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
      unreachable
    end
    local.get $p1
    local.get $l2
    i64.load offset=24
    i64.store align=4
    local.get $p1
    i32.const 8
    i32.add
    local.get $l4
    i32.load
    i32.store
    local.get $p0
    i32.const 1052068
    i32.store offset=4
    local.get $p0
    local.get $p1
    i32.store
    local.get $l2
    i32.const 48
    i32.add
    global.set $__stack_pointer)
  (func $_ZN90_$LT$std..panicking..begin_panic_handler..PanicPayload$u20$as$u20$core..panic..BoxMeUp$GT$3get17hc921f629bee27affE (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p1
    i32.const 4
    i32.add
    local.set $l3
    block $B0
      local.get $p1
      i32.load offset=4
      br_if $B0
      local.get $p1
      i32.load
      local.set $p1
      local.get $l2
      i32.const 8
      i32.add
      i32.const 8
      i32.add
      local.tee $l4
      i32.const 0
      i32.store
      local.get $l2
      i64.const 1
      i64.store offset=8
      local.get $l2
      local.get $l2
      i32.const 8
      i32.add
      i32.store offset=20
      local.get $l2
      i32.const 24
      i32.add
      i32.const 16
      i32.add
      local.get $p1
      i32.const 16
      i32.add
      i64.load align=4
      i64.store
      local.get $l2
      i32.const 24
      i32.add
      i32.const 8
      i32.add
      local.get $p1
      i32.const 8
      i32.add
      i64.load align=4
      i64.store
      local.get $l2
      local.get $p1
      i64.load align=4
      i64.store offset=24
      local.get $l2
      i32.const 20
      i32.add
      i32.const 1048848
      local.get $l2
      i32.const 24
      i32.add
      call $_ZN4core3fmt5write17h64a435d9d6b334f1E
      drop
      local.get $l3
      i32.const 8
      i32.add
      local.get $l4
      i32.load
      i32.store
      local.get $l3
      local.get $l2
      i64.load offset=8
      i64.store align=4
    end
    local.get $p0
    i32.const 1052068
    i32.store offset=4
    local.get $p0
    local.get $l3
    i32.store
    local.get $l2
    i32.const 48
    i32.add
    global.set $__stack_pointer)
  (func $_ZN93_$LT$std..panicking..begin_panic_handler..StrPanicPayload$u20$as$u20$core..panic..BoxMeUp$GT$8take_box17hf696dea4ccae274aE (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32)
    local.get $p1
    i32.load offset=4
    local.set $l2
    local.get $p1
    i32.load
    local.set $l3
    block $B0
      i32.const 8
      i32.const 4
      call $__rust_alloc
      local.tee $p1
      br_if $B0
      i32.const 8
      i32.const 4
      call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
      unreachable
    end
    local.get $p1
    local.get $l2
    i32.store offset=4
    local.get $p1
    local.get $l3
    i32.store
    local.get $p0
    i32.const 1052084
    i32.store offset=4
    local.get $p0
    local.get $p1
    i32.store)
  (func $_ZN93_$LT$std..panicking..begin_panic_handler..StrPanicPayload$u20$as$u20$core..panic..BoxMeUp$GT$3get17h30812c9a258bb7c9E (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    i32.const 1052084
    i32.store offset=4
    local.get $p0
    local.get $p1
    i32.store)
  (func $_ZN3std9panicking20rust_panic_with_hook17h9a166021f8d492afE (type $t11) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32)
    (local $l5 i32) (local $l6 i32) (local $l7 i32)
    global.get $__stack_pointer
    i32.const 112
    i32.sub
    local.tee $l5
    global.set $__stack_pointer
    i32.const 1
    local.set $l6
    i32.const 0
    i32.const 0
    i32.load offset=1059552
    local.tee $l7
    i32.const 1
    i32.add
    i32.store offset=1059552
    block $B0
      block $B1
        i32.const 0
        i32.load8_u offset=1059576
        i32.eqz
        br_if $B1
        i32.const 0
        i32.load offset=1059580
        i32.const 1
        i32.add
        local.set $l6
        br $B0
      end
      i32.const 0
      i32.const 1
      i32.store8 offset=1059576
    end
    i32.const 0
    local.get $l6
    i32.store offset=1059580
    block $B2
      block $B3
        block $B4
          block $B5
            local.get $l7
            i32.const 0
            i32.lt_s
            br_if $B5
            local.get $l6
            i32.const 2
            i32.gt_u
            br_if $B5
            local.get $l5
            local.get $p4
            i32.store8 offset=32
            local.get $l5
            local.get $p3
            i32.store offset=28
            local.get $l5
            local.get $p2
            i32.store offset=24
            i32.const 0
            i32.load offset=1059540
            local.tee $l7
            i32.const -1
            i32.le_s
            br_if $B3
            i32.const 0
            local.get $l7
            i32.const 1
            i32.add
            i32.store offset=1059540
            i32.const 0
            i32.load offset=1059548
            local.tee $l7
            i32.eqz
            br_if $B4
            i32.const 0
            i32.load offset=1059544
            local.set $p2
            local.get $l5
            i32.const 8
            i32.add
            local.get $p0
            local.get $p1
            i32.load offset=16
            call_indirect $T0 (type $t3)
            local.get $l5
            local.get $l5
            i64.load offset=8
            i64.store offset=16
            local.get $p2
            local.get $l5
            i32.const 16
            i32.add
            local.get $l7
            i32.load offset=20
            call_indirect $T0 (type $t3)
            br $B2
          end
          block $B6
            block $B7
              local.get $l6
              i32.const 2
              i32.gt_u
              br_if $B7
              local.get $l5
              local.get $p4
              i32.store8 offset=64
              local.get $l5
              local.get $p3
              i32.store offset=60
              local.get $l5
              local.get $p2
              i32.store offset=56
              local.get $l5
              i32.const 1048936
              i32.store offset=52
              local.get $l5
              i32.const 1048920
              i32.store offset=48
              local.get $l5
              i32.const 15
              i32.store offset=76
              local.get $l5
              local.get $l5
              i32.const 48
              i32.add
              i32.store offset=72
              local.get $l5
              i32.const 4
              i32.store8 offset=20
              local.get $l5
              local.get $l5
              i32.const 104
              i32.add
              i32.store offset=16
              local.get $l5
              i32.const 100
              i32.add
              i32.const 1
              i32.store
              local.get $l5
              i64.const 2
              i64.store offset=84 align=4
              local.get $l5
              i32.const 1052252
              i32.store offset=80
              local.get $l5
              local.get $l5
              i32.const 72
              i32.add
              i32.store offset=96
              block $B8
                local.get $l5
                i32.const 16
                i32.add
                i32.const 1050920
                local.get $l5
                i32.const 80
                i32.add
                call $_ZN4core3fmt5write17h64a435d9d6b334f1E
                i32.eqz
                br_if $B8
                local.get $l5
                i32.load8_u offset=20
                i32.const 4
                i32.eq
                br_if $B6
                local.get $l5
                i32.load8_u offset=20
                i32.const 3
                i32.ne
                br_if $B6
                local.get $l5
                i32.const 24
                i32.add
                i32.load
                local.tee $l5
                i32.load
                local.get $l5
                i32.load offset=4
                i32.load
                call_indirect $T0 (type $t1)
                block $B9
                  local.get $l5
                  i32.load offset=4
                  local.tee $l6
                  i32.load offset=4
                  local.tee $l7
                  i32.eqz
                  br_if $B9
                  local.get $l5
                  i32.load
                  local.get $l7
                  local.get $l6
                  i32.load offset=8
                  call $__rust_dealloc
                end
                local.get $l5
                i32.const 12
                i32.const 4
                call $__rust_dealloc
                call $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E
                unreachable
              end
              local.get $l5
              i32.load8_u offset=20
              i32.const 3
              i32.ne
              br_if $B6
              local.get $l5
              i32.const 24
              i32.add
              i32.load
              local.tee $l6
              i32.load
              local.get $l6
              i32.load offset=4
              i32.load
              call_indirect $T0 (type $t1)
              block $B10
                local.get $l6
                i32.load offset=4
                local.tee $l7
                i32.load offset=4
                local.tee $p4
                i32.eqz
                br_if $B10
                local.get $l6
                i32.load
                local.get $p4
                local.get $l7
                i32.load offset=8
                call $__rust_dealloc
              end
              local.get $l5
              i32.load offset=24
              i32.const 12
              i32.const 4
              call $__rust_dealloc
              call $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E
              unreachable
            end
            local.get $l5
            i32.const 4
            i32.store8 offset=52
            local.get $l5
            local.get $l5
            i32.const 104
            i32.add
            i32.store offset=48
            local.get $l5
            i32.const 100
            i32.add
            i32.const 0
            i32.store
            local.get $l5
            i32.const 1048920
            i32.store offset=96
            local.get $l5
            i64.const 1
            i64.store offset=84 align=4
            local.get $l5
            i32.const 1052192
            i32.store offset=80
            block $B11
              local.get $l5
              i32.const 48
              i32.add
              i32.const 1050920
              local.get $l5
              i32.const 80
              i32.add
              call $_ZN4core3fmt5write17h64a435d9d6b334f1E
              i32.eqz
              br_if $B11
              local.get $l5
              i32.load8_u offset=52
              i32.const 4
              i32.eq
              br_if $B6
              local.get $l5
              i32.load8_u offset=52
              i32.const 3
              i32.ne
              br_if $B6
              local.get $l5
              i32.const 56
              i32.add
              i32.load
              local.tee $l5
              i32.load
              local.get $l5
              i32.load offset=4
              i32.load
              call_indirect $T0 (type $t1)
              block $B12
                local.get $l5
                i32.load offset=4
                local.tee $l6
                i32.load offset=4
                local.tee $l7
                i32.eqz
                br_if $B12
                local.get $l5
                i32.load
                local.get $l7
                local.get $l6
                i32.load offset=8
                call $__rust_dealloc
              end
              local.get $l5
              i32.const 12
              i32.const 4
              call $__rust_dealloc
              call $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E
              unreachable
            end
            local.get $l5
            i32.load8_u offset=52
            i32.const 3
            i32.ne
            br_if $B6
            local.get $l5
            i32.const 56
            i32.add
            i32.load
            local.tee $l6
            i32.load
            local.get $l6
            i32.load offset=4
            i32.load
            call_indirect $T0 (type $t1)
            block $B13
              local.get $l6
              i32.load offset=4
              local.tee $l7
              i32.load offset=4
              local.tee $p4
              i32.eqz
              br_if $B13
              local.get $l6
              i32.load
              local.get $p4
              local.get $l7
              i32.load offset=8
              call $__rust_dealloc
            end
            local.get $l5
            i32.load offset=56
            i32.const 12
            i32.const 4
            call $__rust_dealloc
          end
          call $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E
          unreachable
        end
        local.get $l5
        local.get $p0
        local.get $p1
        i32.load offset=16
        call_indirect $T0 (type $t3)
        local.get $l5
        local.get $l5
        i64.load
        i64.store offset=16
        local.get $l5
        i32.const 16
        i32.add
        call $_ZN3std9panicking12default_hook17h158128544edd3d02E
        br $B2
      end
      local.get $l5
      i32.const 48
      i32.add
      i32.const 20
      i32.add
      i32.const 1
      i32.store
      local.get $l5
      i32.const 80
      i32.add
      i32.const 20
      i32.add
      i32.const 0
      i32.store
      local.get $l5
      i64.const 2
      i64.store offset=52 align=4
      local.get $l5
      i32.const 1049356
      i32.store offset=48
      local.get $l5
      i32.const 6
      i32.store offset=76
      local.get $l5
      i32.const 1048920
      i32.store offset=96
      local.get $l5
      i64.const 1
      i64.store offset=84 align=4
      local.get $l5
      i32.const 1052700
      i32.store offset=80
      local.get $l5
      local.get $l5
      i32.const 72
      i32.add
      i32.store offset=64
      local.get $l5
      local.get $l5
      i32.const 80
      i32.add
      i32.store offset=72
      local.get $l5
      i32.const 40
      i32.add
      local.get $l5
      i32.const 104
      i32.add
      local.get $l5
      i32.const 48
      i32.add
      call $_ZN3std2io5Write9write_fmt17h623738e85fdccfedE
      local.get $l5
      i32.const 40
      i32.add
      call $_ZN4core3ptr81drop_in_place$LT$core..result..Result$LT$$LP$$RP$$C$std..io..error..Error$GT$$GT$17hb995fe4c7a64958dE
      call $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E
      unreachable
    end
    i32.const 0
    i32.const 0
    i32.load offset=1059540
    i32.const -1
    i32.add
    i32.store offset=1059540
    block $B14
      local.get $l6
      i32.const 1
      i32.gt_u
      br_if $B14
      local.get $p4
      i32.eqz
      br_if $B14
      local.get $p0
      local.get $p1
      call $rust_panic
      unreachable
    end
    local.get $l5
    i32.const 100
    i32.add
    i32.const 0
    i32.store
    local.get $l5
    i32.const 1048920
    i32.store offset=96
    local.get $l5
    i64.const 1
    i64.store offset=84 align=4
    local.get $l5
    i32.const 1052312
    i32.store offset=80
    local.get $l5
    i32.const 48
    i32.add
    local.get $l5
    i32.const 104
    i32.add
    local.get $l5
    i32.const 80
    i32.add
    call $_ZN3std2io5Write9write_fmt17h623738e85fdccfedE
    local.get $l5
    i32.const 48
    i32.add
    call $_ZN4core3ptr81drop_in_place$LT$core..result..Result$LT$$LP$$RP$$C$std..io..error..Error$GT$$GT$17hb995fe4c7a64958dE
    call $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E
    unreachable)
  (func $rust_panic (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 96
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p1
    i32.store offset=4
    local.get $l2
    local.get $p0
    i32.store
    local.get $l2
    local.get $l2
    call $__rust_start_panic
    i32.store offset=12
    local.get $l2
    i32.const 24
    i32.add
    i32.const 20
    i32.add
    i32.const 1
    i32.store
    local.get $l2
    i32.const 56
    i32.add
    i32.const 20
    i32.add
    i32.const 1
    i32.store
    local.get $l2
    i64.const 2
    i64.store offset=28 align=4
    local.get $l2
    i32.const 1049356
    i32.store offset=24
    local.get $l2
    i32.const 6
    i32.store offset=52
    local.get $l2
    i64.const 1
    i64.store offset=60 align=4
    local.get $l2
    i32.const 1052352
    i32.store offset=56
    local.get $l2
    i32.const 11
    i32.store offset=84
    local.get $l2
    local.get $l2
    i32.const 48
    i32.add
    i32.store offset=40
    local.get $l2
    local.get $l2
    i32.const 56
    i32.add
    i32.store offset=48
    local.get $l2
    local.get $l2
    i32.const 80
    i32.add
    i32.store offset=72
    local.get $l2
    local.get $l2
    i32.const 12
    i32.add
    i32.store offset=80
    local.get $l2
    i32.const 16
    i32.add
    local.get $l2
    i32.const 88
    i32.add
    local.get $l2
    i32.const 24
    i32.add
    call $_ZN3std2io5Write9write_fmt17h623738e85fdccfedE
    local.get $l2
    i32.const 16
    i32.add
    call $_ZN4core3ptr81drop_in_place$LT$core..result..Result$LT$$LP$$RP$$C$std..io..error..Error$GT$$GT$17hb995fe4c7a64958dE
    call $_ZN3std3sys4wasi14abort_internal17hd0329aea04f78175E
    unreachable)
  (func $_ZN3std3sys4wasi7process8ExitCode6as_i3217hc46b5c71da3e582cE (type $t4) (param $p0 i32) (result i32)
    local.get $p0
    i32.load8_u)
  (func $_ZN64_$LT$std..sys..wasi..stdio..Stderr$u20$as$u20$std..io..Write$GT$5write17he638b47b4b5fcaa0E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    local.get $l4
    local.get $p3
    i32.store offset=12
    local.get $l4
    local.get $p2
    i32.store offset=8
    i32.const 1
    local.set $p2
    local.get $l4
    i32.const 16
    i32.add
    i32.const 2
    local.get $l4
    i32.const 8
    i32.add
    i32.const 1
    call $_ZN4wasi13lib_generated8fd_write17h3060209719e3ef69E
    block $B0
      block $B1
        local.get $l4
        i32.load16_u offset=16
        br_if $B1
        local.get $p0
        local.get $l4
        i32.load offset=20
        i32.store offset=4
        i32.const 0
        local.set $p2
        br $B0
      end
      local.get $l4
      local.get $l4
      i32.load16_u offset=18
      i32.store16 offset=30
      local.get $p0
      local.get $l4
      i32.const 30
      i32.add
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i64.extend_i32_u
      i64.const 65535
      i64.and
      i64.const 32
      i64.shl
      i64.store offset=4 align=4
    end
    local.get $p0
    local.get $p2
    i32.store
    local.get $l4
    i32.const 32
    i32.add
    global.set $__stack_pointer)
  (func $_ZN64_$LT$std..sys..wasi..stdio..Stderr$u20$as$u20$std..io..Write$GT$14write_vectored17hb1358e89f45f13c6E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    local.get $l4
    i32.const 2
    local.get $p2
    local.get $p3
    call $_ZN4wasi13lib_generated8fd_write17h3060209719e3ef69E
    block $B0
      block $B1
        local.get $l4
        i32.load16_u
        br_if $B1
        local.get $p0
        local.get $l4
        i32.load offset=4
        i32.store offset=4
        i32.const 0
        local.set $p2
        br $B0
      end
      local.get $l4
      local.get $l4
      i32.load16_u offset=2
      i32.store16 offset=14
      local.get $p0
      local.get $l4
      i32.const 14
      i32.add
      call $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE
      i64.extend_i32_u
      i64.const 65535
      i64.and
      i64.const 32
      i64.shl
      i64.store offset=4 align=4
      i32.const 1
      local.set $p2
    end
    local.get $p0
    local.get $p2
    i32.store
    local.get $l4
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_ZN64_$LT$std..sys..wasi..stdio..Stderr$u20$as$u20$std..io..Write$GT$17is_write_vectored17hd0e798cc29d02535E (type $t4) (param $p0 i32) (result i32)
    i32.const 1)
  (func $_ZN64_$LT$std..sys..wasi..stdio..Stderr$u20$as$u20$std..io..Write$GT$5flush17h44579201a8bfbb2eE (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    i32.const 4
    i32.store8)
  (func $__rust_start_panic (type $t4) (param $p0 i32) (result i32)
    unreachable
    unreachable)
  (func $_ZN4wasi13lib_generated5Errno3raw17h87c7e922fb590e9dE (type $t4) (param $p0 i32) (result i32)
    local.get $p0
    i32.load16_u)
  (func $_ZN4wasi13lib_generated8fd_write17h3060209719e3ef69E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    block $B0
      block $B1
        local.get $p1
        local.get $p2
        local.get $p3
        local.get $l4
        i32.const 12
        i32.add
        call $_ZN4wasi13lib_generated22wasi_snapshot_preview18fd_write17hc06613fb873ea50eE
        local.tee $p1
        br_if $B1
        local.get $p0
        i32.const 4
        i32.add
        local.get $l4
        i32.load offset=12
        i32.store
        i32.const 0
        local.set $p1
        br $B0
      end
      local.get $p0
      local.get $p1
      i32.store16 offset=2
      i32.const 1
      local.set $p1
    end
    local.get $p0
    local.get $p1
    i32.store16
    local.get $l4
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $malloc (type $t4) (param $p0 i32) (result i32)
    local.get $p0
    call $dlmalloc)
  (func $dlmalloc (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    block $B0
      i32.const 0
      i32.load offset=1059608
      br_if $B0
      i32.const 0
      call $sbrk
      i32.const 1060128
      i32.sub
      local.tee $l2
      i32.const 89
      i32.lt_u
      br_if $B0
      i32.const 0
      local.set $l3
      block $B1
        i32.const 0
        i32.load offset=1060056
        local.tee $l4
        br_if $B1
        i32.const 0
        i64.const -1
        i64.store offset=1060068 align=4
        i32.const 0
        i64.const 281474976776192
        i64.store offset=1060060 align=4
        i32.const 0
        local.get $l1
        i32.const 8
        i32.add
        i32.const -16
        i32.and
        i32.const 1431655768
        i32.xor
        local.tee $l4
        i32.store offset=1060056
        i32.const 0
        i32.const 0
        i32.store offset=1060076
        i32.const 0
        i32.const 0
        i32.store offset=1060028
      end
      i32.const 0
      local.get $l2
      i32.store offset=1060036
      i32.const 0
      i32.const 1060128
      i32.store offset=1060032
      i32.const 0
      i32.const 1060128
      i32.store offset=1059600
      i32.const 0
      local.get $l4
      i32.store offset=1059620
      i32.const 0
      i32.const -1
      i32.store offset=1059616
      loop $L2
        local.get $l3
        i32.const 1059644
        i32.add
        local.get $l3
        i32.const 1059632
        i32.add
        local.tee $l4
        i32.store
        local.get $l4
        local.get $l3
        i32.const 1059624
        i32.add
        local.tee $l5
        i32.store
        local.get $l3
        i32.const 1059636
        i32.add
        local.get $l5
        i32.store
        local.get $l3
        i32.const 1059652
        i32.add
        local.get $l3
        i32.const 1059640
        i32.add
        local.tee $l5
        i32.store
        local.get $l5
        local.get $l4
        i32.store
        local.get $l3
        i32.const 1059660
        i32.add
        local.get $l3
        i32.const 1059648
        i32.add
        local.tee $l4
        i32.store
        local.get $l4
        local.get $l5
        i32.store
        local.get $l3
        i32.const 1059656
        i32.add
        local.get $l4
        i32.store
        local.get $l3
        i32.const 32
        i32.add
        local.tee $l3
        i32.const 256
        i32.ne
        br_if $L2
      end
      i32.const 1060128
      i32.const -8
      i32.const 1060128
      i32.sub
      i32.const 15
      i32.and
      i32.const 0
      i32.const 1060128
      i32.const 8
      i32.add
      i32.const 15
      i32.and
      select
      local.tee $l3
      i32.add
      local.tee $l4
      i32.const 4
      i32.add
      local.get $l2
      i32.const -56
      i32.add
      local.tee $l5
      local.get $l3
      i32.sub
      local.tee $l3
      i32.const 1
      i32.or
      i32.store
      i32.const 0
      i32.const 0
      i32.load offset=1060072
      i32.store offset=1059612
      i32.const 0
      local.get $l3
      i32.store offset=1059596
      i32.const 0
      local.get $l4
      i32.store offset=1059608
      i32.const 1060128
      local.get $l5
      i32.add
      i32.const 56
      i32.store offset=4
    end
    block $B3
      block $B4
        block $B5
          block $B6
            block $B7
              block $B8
                block $B9
                  block $B10
                    block $B11
                      block $B12
                        block $B13
                          block $B14
                            local.get $p0
                            i32.const 236
                            i32.gt_u
                            br_if $B14
                            block $B15
                              i32.const 0
                              i32.load offset=1059584
                              local.tee $l6
                              i32.const 16
                              local.get $p0
                              i32.const 19
                              i32.add
                              i32.const -16
                              i32.and
                              local.get $p0
                              i32.const 11
                              i32.lt_u
                              select
                              local.tee $l2
                              i32.const 3
                              i32.shr_u
                              local.tee $l4
                              i32.shr_u
                              local.tee $l3
                              i32.const 3
                              i32.and
                              i32.eqz
                              br_if $B15
                              local.get $l3
                              i32.const 1
                              i32.and
                              local.get $l4
                              i32.or
                              i32.const 1
                              i32.xor
                              local.tee $l5
                              i32.const 3
                              i32.shl
                              local.tee $p0
                              i32.const 1059632
                              i32.add
                              i32.load
                              local.tee $l4
                              i32.const 8
                              i32.add
                              local.set $l3
                              block $B16
                                block $B17
                                  local.get $l4
                                  i32.load offset=8
                                  local.tee $l2
                                  local.get $p0
                                  i32.const 1059624
                                  i32.add
                                  local.tee $p0
                                  i32.ne
                                  br_if $B17
                                  i32.const 0
                                  local.get $l6
                                  i32.const -2
                                  local.get $l5
                                  i32.rotl
                                  i32.and
                                  i32.store offset=1059584
                                  br $B16
                                end
                                local.get $p0
                                local.get $l2
                                i32.store offset=8
                                local.get $l2
                                local.get $p0
                                i32.store offset=12
                              end
                              local.get $l4
                              local.get $l5
                              i32.const 3
                              i32.shl
                              local.tee $l5
                              i32.const 3
                              i32.or
                              i32.store offset=4
                              local.get $l4
                              local.get $l5
                              i32.add
                              local.tee $l4
                              local.get $l4
                              i32.load offset=4
                              i32.const 1
                              i32.or
                              i32.store offset=4
                              br $B3
                            end
                            local.get $l2
                            i32.const 0
                            i32.load offset=1059592
                            local.tee $l7
                            i32.le_u
                            br_if $B13
                            block $B18
                              local.get $l3
                              i32.eqz
                              br_if $B18
                              block $B19
                                block $B20
                                  local.get $l3
                                  local.get $l4
                                  i32.shl
                                  i32.const 2
                                  local.get $l4
                                  i32.shl
                                  local.tee $l3
                                  i32.const 0
                                  local.get $l3
                                  i32.sub
                                  i32.or
                                  i32.and
                                  local.tee $l3
                                  i32.const 0
                                  local.get $l3
                                  i32.sub
                                  i32.and
                                  i32.const -1
                                  i32.add
                                  local.tee $l3
                                  local.get $l3
                                  i32.const 12
                                  i32.shr_u
                                  i32.const 16
                                  i32.and
                                  local.tee $l3
                                  i32.shr_u
                                  local.tee $l4
                                  i32.const 5
                                  i32.shr_u
                                  i32.const 8
                                  i32.and
                                  local.tee $l5
                                  local.get $l3
                                  i32.or
                                  local.get $l4
                                  local.get $l5
                                  i32.shr_u
                                  local.tee $l3
                                  i32.const 2
                                  i32.shr_u
                                  i32.const 4
                                  i32.and
                                  local.tee $l4
                                  i32.or
                                  local.get $l3
                                  local.get $l4
                                  i32.shr_u
                                  local.tee $l3
                                  i32.const 1
                                  i32.shr_u
                                  i32.const 2
                                  i32.and
                                  local.tee $l4
                                  i32.or
                                  local.get $l3
                                  local.get $l4
                                  i32.shr_u
                                  local.tee $l3
                                  i32.const 1
                                  i32.shr_u
                                  i32.const 1
                                  i32.and
                                  local.tee $l4
                                  i32.or
                                  local.get $l3
                                  local.get $l4
                                  i32.shr_u
                                  i32.add
                                  local.tee $l5
                                  i32.const 3
                                  i32.shl
                                  local.tee $p0
                                  i32.const 1059632
                                  i32.add
                                  i32.load
                                  local.tee $l4
                                  i32.load offset=8
                                  local.tee $l3
                                  local.get $p0
                                  i32.const 1059624
                                  i32.add
                                  local.tee $p0
                                  i32.ne
                                  br_if $B20
                                  i32.const 0
                                  local.get $l6
                                  i32.const -2
                                  local.get $l5
                                  i32.rotl
                                  i32.and
                                  local.tee $l6
                                  i32.store offset=1059584
                                  br $B19
                                end
                                local.get $p0
                                local.get $l3
                                i32.store offset=8
                                local.get $l3
                                local.get $p0
                                i32.store offset=12
                              end
                              local.get $l4
                              i32.const 8
                              i32.add
                              local.set $l3
                              local.get $l4
                              local.get $l2
                              i32.const 3
                              i32.or
                              i32.store offset=4
                              local.get $l4
                              local.get $l5
                              i32.const 3
                              i32.shl
                              local.tee $l5
                              i32.add
                              local.get $l5
                              local.get $l2
                              i32.sub
                              local.tee $l5
                              i32.store
                              local.get $l4
                              local.get $l2
                              i32.add
                              local.tee $p0
                              local.get $l5
                              i32.const 1
                              i32.or
                              i32.store offset=4
                              block $B21
                                local.get $l7
                                i32.eqz
                                br_if $B21
                                local.get $l7
                                i32.const 3
                                i32.shr_u
                                local.tee $l8
                                i32.const 3
                                i32.shl
                                i32.const 1059624
                                i32.add
                                local.set $l2
                                i32.const 0
                                i32.load offset=1059604
                                local.set $l4
                                block $B22
                                  block $B23
                                    local.get $l6
                                    i32.const 1
                                    local.get $l8
                                    i32.shl
                                    local.tee $l8
                                    i32.and
                                    br_if $B23
                                    i32.const 0
                                    local.get $l6
                                    local.get $l8
                                    i32.or
                                    i32.store offset=1059584
                                    local.get $l2
                                    local.set $l8
                                    br $B22
                                  end
                                  local.get $l2
                                  i32.load offset=8
                                  local.set $l8
                                end
                                local.get $l8
                                local.get $l4
                                i32.store offset=12
                                local.get $l2
                                local.get $l4
                                i32.store offset=8
                                local.get $l4
                                local.get $l2
                                i32.store offset=12
                                local.get $l4
                                local.get $l8
                                i32.store offset=8
                              end
                              i32.const 0
                              local.get $p0
                              i32.store offset=1059604
                              i32.const 0
                              local.get $l5
                              i32.store offset=1059592
                              br $B3
                            end
                            i32.const 0
                            i32.load offset=1059588
                            local.tee $l9
                            i32.eqz
                            br_if $B13
                            local.get $l9
                            i32.const 0
                            local.get $l9
                            i32.sub
                            i32.and
                            i32.const -1
                            i32.add
                            local.tee $l3
                            local.get $l3
                            i32.const 12
                            i32.shr_u
                            i32.const 16
                            i32.and
                            local.tee $l3
                            i32.shr_u
                            local.tee $l4
                            i32.const 5
                            i32.shr_u
                            i32.const 8
                            i32.and
                            local.tee $l5
                            local.get $l3
                            i32.or
                            local.get $l4
                            local.get $l5
                            i32.shr_u
                            local.tee $l3
                            i32.const 2
                            i32.shr_u
                            i32.const 4
                            i32.and
                            local.tee $l4
                            i32.or
                            local.get $l3
                            local.get $l4
                            i32.shr_u
                            local.tee $l3
                            i32.const 1
                            i32.shr_u
                            i32.const 2
                            i32.and
                            local.tee $l4
                            i32.or
                            local.get $l3
                            local.get $l4
                            i32.shr_u
                            local.tee $l3
                            i32.const 1
                            i32.shr_u
                            i32.const 1
                            i32.and
                            local.tee $l4
                            i32.or
                            local.get $l3
                            local.get $l4
                            i32.shr_u
                            i32.add
                            i32.const 2
                            i32.shl
                            i32.const 1059888
                            i32.add
                            i32.load
                            local.tee $p0
                            i32.load offset=4
                            i32.const -8
                            i32.and
                            local.get $l2
                            i32.sub
                            local.set $l4
                            local.get $p0
                            local.set $l5
                            block $B24
                              loop $L25
                                block $B26
                                  local.get $l5
                                  i32.load offset=16
                                  local.tee $l3
                                  br_if $B26
                                  local.get $l5
                                  i32.const 20
                                  i32.add
                                  i32.load
                                  local.tee $l3
                                  i32.eqz
                                  br_if $B24
                                end
                                local.get $l3
                                i32.load offset=4
                                i32.const -8
                                i32.and
                                local.get $l2
                                i32.sub
                                local.tee $l5
                                local.get $l4
                                local.get $l5
                                local.get $l4
                                i32.lt_u
                                local.tee $l5
                                select
                                local.set $l4
                                local.get $l3
                                local.get $p0
                                local.get $l5
                                select
                                local.set $p0
                                local.get $l3
                                local.set $l5
                                br $L25
                              end
                            end
                            local.get $p0
                            i32.load offset=24
                            local.set $l10
                            block $B27
                              local.get $p0
                              i32.load offset=12
                              local.tee $l8
                              local.get $p0
                              i32.eq
                              br_if $B27
                              i32.const 0
                              i32.load offset=1059600
                              local.get $p0
                              i32.load offset=8
                              local.tee $l3
                              i32.gt_u
                              drop
                              local.get $l8
                              local.get $l3
                              i32.store offset=8
                              local.get $l3
                              local.get $l8
                              i32.store offset=12
                              br $B4
                            end
                            block $B28
                              local.get $p0
                              i32.const 20
                              i32.add
                              local.tee $l5
                              i32.load
                              local.tee $l3
                              br_if $B28
                              local.get $p0
                              i32.load offset=16
                              local.tee $l3
                              i32.eqz
                              br_if $B12
                              local.get $p0
                              i32.const 16
                              i32.add
                              local.set $l5
                            end
                            loop $L29
                              local.get $l5
                              local.set $l11
                              local.get $l3
                              local.tee $l8
                              i32.const 20
                              i32.add
                              local.tee $l5
                              i32.load
                              local.tee $l3
                              br_if $L29
                              local.get $l8
                              i32.const 16
                              i32.add
                              local.set $l5
                              local.get $l8
                              i32.load offset=16
                              local.tee $l3
                              br_if $L29
                            end
                            local.get $l11
                            i32.const 0
                            i32.store
                            br $B4
                          end
                          i32.const -1
                          local.set $l2
                          local.get $p0
                          i32.const -65
                          i32.gt_u
                          br_if $B13
                          local.get $p0
                          i32.const 19
                          i32.add
                          local.tee $l3
                          i32.const -16
                          i32.and
                          local.set $l2
                          i32.const 0
                          i32.load offset=1059588
                          local.tee $l7
                          i32.eqz
                          br_if $B13
                          i32.const 0
                          local.set $l11
                          block $B30
                            local.get $l2
                            i32.const 256
                            i32.lt_u
                            br_if $B30
                            i32.const 31
                            local.set $l11
                            local.get $l2
                            i32.const 16777215
                            i32.gt_u
                            br_if $B30
                            local.get $l3
                            i32.const 8
                            i32.shr_u
                            local.tee $l3
                            local.get $l3
                            i32.const 1048320
                            i32.add
                            i32.const 16
                            i32.shr_u
                            i32.const 8
                            i32.and
                            local.tee $l3
                            i32.shl
                            local.tee $l4
                            local.get $l4
                            i32.const 520192
                            i32.add
                            i32.const 16
                            i32.shr_u
                            i32.const 4
                            i32.and
                            local.tee $l4
                            i32.shl
                            local.tee $l5
                            local.get $l5
                            i32.const 245760
                            i32.add
                            i32.const 16
                            i32.shr_u
                            i32.const 2
                            i32.and
                            local.tee $l5
                            i32.shl
                            i32.const 15
                            i32.shr_u
                            local.get $l3
                            local.get $l4
                            i32.or
                            local.get $l5
                            i32.or
                            i32.sub
                            local.tee $l3
                            i32.const 1
                            i32.shl
                            local.get $l2
                            local.get $l3
                            i32.const 21
                            i32.add
                            i32.shr_u
                            i32.const 1
                            i32.and
                            i32.or
                            i32.const 28
                            i32.add
                            local.set $l11
                          end
                          i32.const 0
                          local.get $l2
                          i32.sub
                          local.set $l4
                          block $B31
                            block $B32
                              block $B33
                                block $B34
                                  local.get $l11
                                  i32.const 2
                                  i32.shl
                                  i32.const 1059888
                                  i32.add
                                  i32.load
                                  local.tee $l5
                                  br_if $B34
                                  i32.const 0
                                  local.set $l3
                                  i32.const 0
                                  local.set $l8
                                  br $B33
                                end
                                i32.const 0
                                local.set $l3
                                local.get $l2
                                i32.const 0
                                i32.const 25
                                local.get $l11
                                i32.const 1
                                i32.shr_u
                                i32.sub
                                local.get $l11
                                i32.const 31
                                i32.eq
                                select
                                i32.shl
                                local.set $p0
                                i32.const 0
                                local.set $l8
                                loop $L35
                                  block $B36
                                    local.get $l5
                                    i32.load offset=4
                                    i32.const -8
                                    i32.and
                                    local.get $l2
                                    i32.sub
                                    local.tee $l6
                                    local.get $l4
                                    i32.ge_u
                                    br_if $B36
                                    local.get $l6
                                    local.set $l4
                                    local.get $l5
                                    local.set $l8
                                    local.get $l6
                                    br_if $B36
                                    i32.const 0
                                    local.set $l4
                                    local.get $l5
                                    local.set $l8
                                    local.get $l5
                                    local.set $l3
                                    br $B32
                                  end
                                  local.get $l3
                                  local.get $l5
                                  i32.const 20
                                  i32.add
                                  i32.load
                                  local.tee $l6
                                  local.get $l6
                                  local.get $l5
                                  local.get $p0
                                  i32.const 29
                                  i32.shr_u
                                  i32.const 4
                                  i32.and
                                  i32.add
                                  i32.const 16
                                  i32.add
                                  i32.load
                                  local.tee $l5
                                  i32.eq
                                  select
                                  local.get $l3
                                  local.get $l6
                                  select
                                  local.set $l3
                                  local.get $p0
                                  i32.const 1
                                  i32.shl
                                  local.set $p0
                                  local.get $l5
                                  br_if $L35
                                end
                              end
                              block $B37
                                local.get $l3
                                local.get $l8
                                i32.or
                                br_if $B37
                                i32.const 0
                                local.set $l8
                                i32.const 2
                                local.get $l11
                                i32.shl
                                local.tee $l3
                                i32.const 0
                                local.get $l3
                                i32.sub
                                i32.or
                                local.get $l7
                                i32.and
                                local.tee $l3
                                i32.eqz
                                br_if $B13
                                local.get $l3
                                i32.const 0
                                local.get $l3
                                i32.sub
                                i32.and
                                i32.const -1
                                i32.add
                                local.tee $l3
                                local.get $l3
                                i32.const 12
                                i32.shr_u
                                i32.const 16
                                i32.and
                                local.tee $l3
                                i32.shr_u
                                local.tee $l5
                                i32.const 5
                                i32.shr_u
                                i32.const 8
                                i32.and
                                local.tee $p0
                                local.get $l3
                                i32.or
                                local.get $l5
                                local.get $p0
                                i32.shr_u
                                local.tee $l3
                                i32.const 2
                                i32.shr_u
                                i32.const 4
                                i32.and
                                local.tee $l5
                                i32.or
                                local.get $l3
                                local.get $l5
                                i32.shr_u
                                local.tee $l3
                                i32.const 1
                                i32.shr_u
                                i32.const 2
                                i32.and
                                local.tee $l5
                                i32.or
                                local.get $l3
                                local.get $l5
                                i32.shr_u
                                local.tee $l3
                                i32.const 1
                                i32.shr_u
                                i32.const 1
                                i32.and
                                local.tee $l5
                                i32.or
                                local.get $l3
                                local.get $l5
                                i32.shr_u
                                i32.add
                                i32.const 2
                                i32.shl
                                i32.const 1059888
                                i32.add
                                i32.load
                                local.set $l3
                              end
                              local.get $l3
                              i32.eqz
                              br_if $B31
                            end
                            loop $L38
                              local.get $l3
                              i32.load offset=4
                              i32.const -8
                              i32.and
                              local.get $l2
                              i32.sub
                              local.tee $l6
                              local.get $l4
                              i32.lt_u
                              local.set $p0
                              block $B39
                                local.get $l3
                                i32.load offset=16
                                local.tee $l5
                                br_if $B39
                                local.get $l3
                                i32.const 20
                                i32.add
                                i32.load
                                local.set $l5
                              end
                              local.get $l6
                              local.get $l4
                              local.get $p0
                              select
                              local.set $l4
                              local.get $l3
                              local.get $l8
                              local.get $p0
                              select
                              local.set $l8
                              local.get $l5
                              local.set $l3
                              local.get $l5
                              br_if $L38
                            end
                          end
                          local.get $l8
                          i32.eqz
                          br_if $B13
                          local.get $l4
                          i32.const 0
                          i32.load offset=1059592
                          local.get $l2
                          i32.sub
                          i32.ge_u
                          br_if $B13
                          local.get $l8
                          i32.load offset=24
                          local.set $l11
                          block $B40
                            local.get $l8
                            i32.load offset=12
                            local.tee $p0
                            local.get $l8
                            i32.eq
                            br_if $B40
                            i32.const 0
                            i32.load offset=1059600
                            local.get $l8
                            i32.load offset=8
                            local.tee $l3
                            i32.gt_u
                            drop
                            local.get $p0
                            local.get $l3
                            i32.store offset=8
                            local.get $l3
                            local.get $p0
                            i32.store offset=12
                            br $B5
                          end
                          block $B41
                            local.get $l8
                            i32.const 20
                            i32.add
                            local.tee $l5
                            i32.load
                            local.tee $l3
                            br_if $B41
                            local.get $l8
                            i32.load offset=16
                            local.tee $l3
                            i32.eqz
                            br_if $B11
                            local.get $l8
                            i32.const 16
                            i32.add
                            local.set $l5
                          end
                          loop $L42
                            local.get $l5
                            local.set $l6
                            local.get $l3
                            local.tee $p0
                            i32.const 20
                            i32.add
                            local.tee $l5
                            i32.load
                            local.tee $l3
                            br_if $L42
                            local.get $p0
                            i32.const 16
                            i32.add
                            local.set $l5
                            local.get $p0
                            i32.load offset=16
                            local.tee $l3
                            br_if $L42
                          end
                          local.get $l6
                          i32.const 0
                          i32.store
                          br $B5
                        end
                        block $B43
                          i32.const 0
                          i32.load offset=1059592
                          local.tee $l3
                          local.get $l2
                          i32.lt_u
                          br_if $B43
                          i32.const 0
                          i32.load offset=1059604
                          local.set $l4
                          block $B44
                            block $B45
                              local.get $l3
                              local.get $l2
                              i32.sub
                              local.tee $l5
                              i32.const 16
                              i32.lt_u
                              br_if $B45
                              local.get $l4
                              local.get $l2
                              i32.add
                              local.tee $p0
                              local.get $l5
                              i32.const 1
                              i32.or
                              i32.store offset=4
                              i32.const 0
                              local.get $l5
                              i32.store offset=1059592
                              i32.const 0
                              local.get $p0
                              i32.store offset=1059604
                              local.get $l4
                              local.get $l3
                              i32.add
                              local.get $l5
                              i32.store
                              local.get $l4
                              local.get $l2
                              i32.const 3
                              i32.or
                              i32.store offset=4
                              br $B44
                            end
                            local.get $l4
                            local.get $l3
                            i32.const 3
                            i32.or
                            i32.store offset=4
                            local.get $l4
                            local.get $l3
                            i32.add
                            local.tee $l3
                            local.get $l3
                            i32.load offset=4
                            i32.const 1
                            i32.or
                            i32.store offset=4
                            i32.const 0
                            i32.const 0
                            i32.store offset=1059604
                            i32.const 0
                            i32.const 0
                            i32.store offset=1059592
                          end
                          local.get $l4
                          i32.const 8
                          i32.add
                          local.set $l3
                          br $B3
                        end
                        block $B46
                          i32.const 0
                          i32.load offset=1059596
                          local.tee $p0
                          local.get $l2
                          i32.le_u
                          br_if $B46
                          i32.const 0
                          i32.load offset=1059608
                          local.tee $l3
                          local.get $l2
                          i32.add
                          local.tee $l4
                          local.get $p0
                          local.get $l2
                          i32.sub
                          local.tee $l5
                          i32.const 1
                          i32.or
                          i32.store offset=4
                          i32.const 0
                          local.get $l5
                          i32.store offset=1059596
                          i32.const 0
                          local.get $l4
                          i32.store offset=1059608
                          local.get $l3
                          local.get $l2
                          i32.const 3
                          i32.or
                          i32.store offset=4
                          local.get $l3
                          i32.const 8
                          i32.add
                          local.set $l3
                          br $B3
                        end
                        block $B47
                          block $B48
                            i32.const 0
                            i32.load offset=1060056
                            i32.eqz
                            br_if $B48
                            i32.const 0
                            i32.load offset=1060064
                            local.set $l4
                            br $B47
                          end
                          i32.const 0
                          i64.const -1
                          i64.store offset=1060068 align=4
                          i32.const 0
                          i64.const 281474976776192
                          i64.store offset=1060060 align=4
                          i32.const 0
                          local.get $l1
                          i32.const 12
                          i32.add
                          i32.const -16
                          i32.and
                          i32.const 1431655768
                          i32.xor
                          i32.store offset=1060056
                          i32.const 0
                          i32.const 0
                          i32.store offset=1060076
                          i32.const 0
                          i32.const 0
                          i32.store offset=1060028
                          i32.const 65536
                          local.set $l4
                        end
                        i32.const 0
                        local.set $l3
                        block $B49
                          local.get $l4
                          local.get $l2
                          i32.const 71
                          i32.add
                          local.tee $l7
                          i32.add
                          local.tee $l6
                          i32.const 0
                          local.get $l4
                          i32.sub
                          local.tee $l11
                          i32.and
                          local.tee $l8
                          local.get $l2
                          i32.gt_u
                          br_if $B49
                          i32.const 0
                          i32.const 48
                          i32.store offset=1060080
                          br $B3
                        end
                        block $B50
                          i32.const 0
                          i32.load offset=1060024
                          local.tee $l3
                          i32.eqz
                          br_if $B50
                          block $B51
                            i32.const 0
                            i32.load offset=1060016
                            local.tee $l4
                            local.get $l8
                            i32.add
                            local.tee $l5
                            local.get $l4
                            i32.le_u
                            br_if $B51
                            local.get $l5
                            local.get $l3
                            i32.le_u
                            br_if $B50
                          end
                          i32.const 0
                          local.set $l3
                          i32.const 0
                          i32.const 48
                          i32.store offset=1060080
                          br $B3
                        end
                        i32.const 0
                        i32.load8_u offset=1060028
                        i32.const 4
                        i32.and
                        br_if $B8
                        block $B52
                          block $B53
                            block $B54
                              i32.const 0
                              i32.load offset=1059608
                              local.tee $l4
                              i32.eqz
                              br_if $B54
                              i32.const 1060032
                              local.set $l3
                              loop $L55
                                block $B56
                                  local.get $l3
                                  i32.load
                                  local.tee $l5
                                  local.get $l4
                                  i32.gt_u
                                  br_if $B56
                                  local.get $l5
                                  local.get $l3
                                  i32.load offset=4
                                  i32.add
                                  local.get $l4
                                  i32.gt_u
                                  br_if $B53
                                end
                                local.get $l3
                                i32.load offset=8
                                local.tee $l3
                                br_if $L55
                              end
                            end
                            i32.const 0
                            call $sbrk
                            local.tee $p0
                            i32.const -1
                            i32.eq
                            br_if $B9
                            local.get $l8
                            local.set $l6
                            block $B57
                              i32.const 0
                              i32.load offset=1060060
                              local.tee $l3
                              i32.const -1
                              i32.add
                              local.tee $l4
                              local.get $p0
                              i32.and
                              i32.eqz
                              br_if $B57
                              local.get $l8
                              local.get $p0
                              i32.sub
                              local.get $l4
                              local.get $p0
                              i32.add
                              i32.const 0
                              local.get $l3
                              i32.sub
                              i32.and
                              i32.add
                              local.set $l6
                            end
                            local.get $l6
                            local.get $l2
                            i32.le_u
                            br_if $B9
                            local.get $l6
                            i32.const 2147483646
                            i32.gt_u
                            br_if $B9
                            block $B58
                              i32.const 0
                              i32.load offset=1060024
                              local.tee $l3
                              i32.eqz
                              br_if $B58
                              i32.const 0
                              i32.load offset=1060016
                              local.tee $l4
                              local.get $l6
                              i32.add
                              local.tee $l5
                              local.get $l4
                              i32.le_u
                              br_if $B9
                              local.get $l5
                              local.get $l3
                              i32.gt_u
                              br_if $B9
                            end
                            local.get $l6
                            call $sbrk
                            local.tee $l3
                            local.get $p0
                            i32.ne
                            br_if $B52
                            br $B7
                          end
                          local.get $l6
                          local.get $p0
                          i32.sub
                          local.get $l11
                          i32.and
                          local.tee $l6
                          i32.const 2147483646
                          i32.gt_u
                          br_if $B9
                          local.get $l6
                          call $sbrk
                          local.tee $p0
                          local.get $l3
                          i32.load
                          local.get $l3
                          i32.load offset=4
                          i32.add
                          i32.eq
                          br_if $B10
                          local.get $p0
                          local.set $l3
                        end
                        block $B59
                          local.get $l3
                          i32.const -1
                          i32.eq
                          br_if $B59
                          local.get $l2
                          i32.const 72
                          i32.add
                          local.get $l6
                          i32.le_u
                          br_if $B59
                          block $B60
                            local.get $l7
                            local.get $l6
                            i32.sub
                            i32.const 0
                            i32.load offset=1060064
                            local.tee $l4
                            i32.add
                            i32.const 0
                            local.get $l4
                            i32.sub
                            i32.and
                            local.tee $l4
                            i32.const 2147483646
                            i32.le_u
                            br_if $B60
                            local.get $l3
                            local.set $p0
                            br $B7
                          end
                          block $B61
                            local.get $l4
                            call $sbrk
                            i32.const -1
                            i32.eq
                            br_if $B61
                            local.get $l4
                            local.get $l6
                            i32.add
                            local.set $l6
                            local.get $l3
                            local.set $p0
                            br $B7
                          end
                          i32.const 0
                          local.get $l6
                          i32.sub
                          call $sbrk
                          drop
                          br $B9
                        end
                        local.get $l3
                        local.set $p0
                        local.get $l3
                        i32.const -1
                        i32.ne
                        br_if $B7
                        br $B9
                      end
                      i32.const 0
                      local.set $l8
                      br $B4
                    end
                    i32.const 0
                    local.set $p0
                    br $B5
                  end
                  local.get $p0
                  i32.const -1
                  i32.ne
                  br_if $B7
                end
                i32.const 0
                i32.const 0
                i32.load offset=1060028
                i32.const 4
                i32.or
                i32.store offset=1060028
              end
              local.get $l8
              i32.const 2147483646
              i32.gt_u
              br_if $B6
              local.get $l8
              call $sbrk
              local.set $p0
              i32.const 0
              call $sbrk
              local.set $l3
              local.get $p0
              i32.const -1
              i32.eq
              br_if $B6
              local.get $l3
              i32.const -1
              i32.eq
              br_if $B6
              local.get $p0
              local.get $l3
              i32.ge_u
              br_if $B6
              local.get $l3
              local.get $p0
              i32.sub
              local.tee $l6
              local.get $l2
              i32.const 56
              i32.add
              i32.le_u
              br_if $B6
            end
            i32.const 0
            i32.const 0
            i32.load offset=1060016
            local.get $l6
            i32.add
            local.tee $l3
            i32.store offset=1060016
            block $B62
              local.get $l3
              i32.const 0
              i32.load offset=1060020
              i32.le_u
              br_if $B62
              i32.const 0
              local.get $l3
              i32.store offset=1060020
            end
            block $B63
              block $B64
                block $B65
                  block $B66
                    i32.const 0
                    i32.load offset=1059608
                    local.tee $l4
                    i32.eqz
                    br_if $B66
                    i32.const 1060032
                    local.set $l3
                    loop $L67
                      local.get $p0
                      local.get $l3
                      i32.load
                      local.tee $l5
                      local.get $l3
                      i32.load offset=4
                      local.tee $l8
                      i32.add
                      i32.eq
                      br_if $B65
                      local.get $l3
                      i32.load offset=8
                      local.tee $l3
                      br_if $L67
                      br $B64
                    end
                  end
                  block $B68
                    block $B69
                      i32.const 0
                      i32.load offset=1059600
                      local.tee $l3
                      i32.eqz
                      br_if $B69
                      local.get $p0
                      local.get $l3
                      i32.ge_u
                      br_if $B68
                    end
                    i32.const 0
                    local.get $p0
                    i32.store offset=1059600
                  end
                  i32.const 0
                  local.set $l3
                  i32.const 0
                  local.get $l6
                  i32.store offset=1060036
                  i32.const 0
                  local.get $p0
                  i32.store offset=1060032
                  i32.const 0
                  i32.const -1
                  i32.store offset=1059616
                  i32.const 0
                  i32.const 0
                  i32.load offset=1060056
                  i32.store offset=1059620
                  i32.const 0
                  i32.const 0
                  i32.store offset=1060044
                  loop $L70
                    local.get $l3
                    i32.const 1059644
                    i32.add
                    local.get $l3
                    i32.const 1059632
                    i32.add
                    local.tee $l4
                    i32.store
                    local.get $l4
                    local.get $l3
                    i32.const 1059624
                    i32.add
                    local.tee $l5
                    i32.store
                    local.get $l3
                    i32.const 1059636
                    i32.add
                    local.get $l5
                    i32.store
                    local.get $l3
                    i32.const 1059652
                    i32.add
                    local.get $l3
                    i32.const 1059640
                    i32.add
                    local.tee $l5
                    i32.store
                    local.get $l5
                    local.get $l4
                    i32.store
                    local.get $l3
                    i32.const 1059660
                    i32.add
                    local.get $l3
                    i32.const 1059648
                    i32.add
                    local.tee $l4
                    i32.store
                    local.get $l4
                    local.get $l5
                    i32.store
                    local.get $l3
                    i32.const 1059656
                    i32.add
                    local.get $l4
                    i32.store
                    local.get $l3
                    i32.const 32
                    i32.add
                    local.tee $l3
                    i32.const 256
                    i32.ne
                    br_if $L70
                  end
                  local.get $p0
                  i32.const -8
                  local.get $p0
                  i32.sub
                  i32.const 15
                  i32.and
                  i32.const 0
                  local.get $p0
                  i32.const 8
                  i32.add
                  i32.const 15
                  i32.and
                  select
                  local.tee $l3
                  i32.add
                  local.tee $l4
                  local.get $l6
                  i32.const -56
                  i32.add
                  local.tee $l5
                  local.get $l3
                  i32.sub
                  local.tee $l3
                  i32.const 1
                  i32.or
                  i32.store offset=4
                  i32.const 0
                  i32.const 0
                  i32.load offset=1060072
                  i32.store offset=1059612
                  i32.const 0
                  local.get $l3
                  i32.store offset=1059596
                  i32.const 0
                  local.get $l4
                  i32.store offset=1059608
                  local.get $p0
                  local.get $l5
                  i32.add
                  i32.const 56
                  i32.store offset=4
                  br $B63
                end
                local.get $l3
                i32.load8_u offset=12
                i32.const 8
                i32.and
                br_if $B64
                local.get $l5
                local.get $l4
                i32.gt_u
                br_if $B64
                local.get $p0
                local.get $l4
                i32.le_u
                br_if $B64
                local.get $l4
                i32.const -8
                local.get $l4
                i32.sub
                i32.const 15
                i32.and
                i32.const 0
                local.get $l4
                i32.const 8
                i32.add
                i32.const 15
                i32.and
                select
                local.tee $l5
                i32.add
                local.tee $p0
                i32.const 0
                i32.load offset=1059596
                local.get $l6
                i32.add
                local.tee $l11
                local.get $l5
                i32.sub
                local.tee $l5
                i32.const 1
                i32.or
                i32.store offset=4
                local.get $l3
                local.get $l8
                local.get $l6
                i32.add
                i32.store offset=4
                i32.const 0
                i32.const 0
                i32.load offset=1060072
                i32.store offset=1059612
                i32.const 0
                local.get $l5
                i32.store offset=1059596
                i32.const 0
                local.get $p0
                i32.store offset=1059608
                local.get $l4
                local.get $l11
                i32.add
                i32.const 56
                i32.store offset=4
                br $B63
              end
              block $B71
                local.get $p0
                i32.const 0
                i32.load offset=1059600
                local.tee $l8
                i32.ge_u
                br_if $B71
                i32.const 0
                local.get $p0
                i32.store offset=1059600
                local.get $p0
                local.set $l8
              end
              local.get $p0
              local.get $l6
              i32.add
              local.set $l5
              i32.const 1060032
              local.set $l3
              block $B72
                block $B73
                  block $B74
                    block $B75
                      block $B76
                        block $B77
                          block $B78
                            loop $L79
                              local.get $l3
                              i32.load
                              local.get $l5
                              i32.eq
                              br_if $B78
                              local.get $l3
                              i32.load offset=8
                              local.tee $l3
                              br_if $L79
                              br $B77
                            end
                          end
                          local.get $l3
                          i32.load8_u offset=12
                          i32.const 8
                          i32.and
                          i32.eqz
                          br_if $B76
                        end
                        i32.const 1060032
                        local.set $l3
                        loop $L80
                          block $B81
                            local.get $l3
                            i32.load
                            local.tee $l5
                            local.get $l4
                            i32.gt_u
                            br_if $B81
                            local.get $l5
                            local.get $l3
                            i32.load offset=4
                            i32.add
                            local.tee $l5
                            local.get $l4
                            i32.gt_u
                            br_if $B75
                          end
                          local.get $l3
                          i32.load offset=8
                          local.set $l3
                          br $L80
                        end
                      end
                      local.get $l3
                      local.get $p0
                      i32.store
                      local.get $l3
                      local.get $l3
                      i32.load offset=4
                      local.get $l6
                      i32.add
                      i32.store offset=4
                      local.get $p0
                      i32.const -8
                      local.get $p0
                      i32.sub
                      i32.const 15
                      i32.and
                      i32.const 0
                      local.get $p0
                      i32.const 8
                      i32.add
                      i32.const 15
                      i32.and
                      select
                      i32.add
                      local.tee $l11
                      local.get $l2
                      i32.const 3
                      i32.or
                      i32.store offset=4
                      local.get $l5
                      i32.const -8
                      local.get $l5
                      i32.sub
                      i32.const 15
                      i32.and
                      i32.const 0
                      local.get $l5
                      i32.const 8
                      i32.add
                      i32.const 15
                      i32.and
                      select
                      i32.add
                      local.tee $l6
                      local.get $l11
                      local.get $l2
                      i32.add
                      local.tee $l2
                      i32.sub
                      local.set $l5
                      block $B82
                        local.get $l4
                        local.get $l6
                        i32.ne
                        br_if $B82
                        i32.const 0
                        local.get $l2
                        i32.store offset=1059608
                        i32.const 0
                        i32.const 0
                        i32.load offset=1059596
                        local.get $l5
                        i32.add
                        local.tee $l3
                        i32.store offset=1059596
                        local.get $l2
                        local.get $l3
                        i32.const 1
                        i32.or
                        i32.store offset=4
                        br $B73
                      end
                      block $B83
                        i32.const 0
                        i32.load offset=1059604
                        local.get $l6
                        i32.ne
                        br_if $B83
                        i32.const 0
                        local.get $l2
                        i32.store offset=1059604
                        i32.const 0
                        i32.const 0
                        i32.load offset=1059592
                        local.get $l5
                        i32.add
                        local.tee $l3
                        i32.store offset=1059592
                        local.get $l2
                        local.get $l3
                        i32.const 1
                        i32.or
                        i32.store offset=4
                        local.get $l2
                        local.get $l3
                        i32.add
                        local.get $l3
                        i32.store
                        br $B73
                      end
                      block $B84
                        local.get $l6
                        i32.load offset=4
                        local.tee $l3
                        i32.const 3
                        i32.and
                        i32.const 1
                        i32.ne
                        br_if $B84
                        local.get $l3
                        i32.const -8
                        i32.and
                        local.set $l7
                        block $B85
                          block $B86
                            local.get $l3
                            i32.const 255
                            i32.gt_u
                            br_if $B86
                            local.get $l6
                            i32.load offset=8
                            local.tee $l4
                            local.get $l3
                            i32.const 3
                            i32.shr_u
                            local.tee $l8
                            i32.const 3
                            i32.shl
                            i32.const 1059624
                            i32.add
                            local.tee $p0
                            i32.eq
                            drop
                            block $B87
                              local.get $l6
                              i32.load offset=12
                              local.tee $l3
                              local.get $l4
                              i32.ne
                              br_if $B87
                              i32.const 0
                              i32.const 0
                              i32.load offset=1059584
                              i32.const -2
                              local.get $l8
                              i32.rotl
                              i32.and
                              i32.store offset=1059584
                              br $B85
                            end
                            local.get $l3
                            local.get $p0
                            i32.eq
                            drop
                            local.get $l3
                            local.get $l4
                            i32.store offset=8
                            local.get $l4
                            local.get $l3
                            i32.store offset=12
                            br $B85
                          end
                          local.get $l6
                          i32.load offset=24
                          local.set $l9
                          block $B88
                            block $B89
                              local.get $l6
                              i32.load offset=12
                              local.tee $p0
                              local.get $l6
                              i32.eq
                              br_if $B89
                              local.get $l8
                              local.get $l6
                              i32.load offset=8
                              local.tee $l3
                              i32.gt_u
                              drop
                              local.get $p0
                              local.get $l3
                              i32.store offset=8
                              local.get $l3
                              local.get $p0
                              i32.store offset=12
                              br $B88
                            end
                            block $B90
                              local.get $l6
                              i32.const 20
                              i32.add
                              local.tee $l3
                              i32.load
                              local.tee $l4
                              br_if $B90
                              local.get $l6
                              i32.const 16
                              i32.add
                              local.tee $l3
                              i32.load
                              local.tee $l4
                              br_if $B90
                              i32.const 0
                              local.set $p0
                              br $B88
                            end
                            loop $L91
                              local.get $l3
                              local.set $l8
                              local.get $l4
                              local.tee $p0
                              i32.const 20
                              i32.add
                              local.tee $l3
                              i32.load
                              local.tee $l4
                              br_if $L91
                              local.get $p0
                              i32.const 16
                              i32.add
                              local.set $l3
                              local.get $p0
                              i32.load offset=16
                              local.tee $l4
                              br_if $L91
                            end
                            local.get $l8
                            i32.const 0
                            i32.store
                          end
                          local.get $l9
                          i32.eqz
                          br_if $B85
                          block $B92
                            block $B93
                              local.get $l6
                              i32.load offset=28
                              local.tee $l4
                              i32.const 2
                              i32.shl
                              i32.const 1059888
                              i32.add
                              local.tee $l3
                              i32.load
                              local.get $l6
                              i32.ne
                              br_if $B93
                              local.get $l3
                              local.get $p0
                              i32.store
                              local.get $p0
                              br_if $B92
                              i32.const 0
                              i32.const 0
                              i32.load offset=1059588
                              i32.const -2
                              local.get $l4
                              i32.rotl
                              i32.and
                              i32.store offset=1059588
                              br $B85
                            end
                            local.get $l9
                            i32.const 16
                            i32.const 20
                            local.get $l9
                            i32.load offset=16
                            local.get $l6
                            i32.eq
                            select
                            i32.add
                            local.get $p0
                            i32.store
                            local.get $p0
                            i32.eqz
                            br_if $B85
                          end
                          local.get $p0
                          local.get $l9
                          i32.store offset=24
                          block $B94
                            local.get $l6
                            i32.load offset=16
                            local.tee $l3
                            i32.eqz
                            br_if $B94
                            local.get $p0
                            local.get $l3
                            i32.store offset=16
                            local.get $l3
                            local.get $p0
                            i32.store offset=24
                          end
                          local.get $l6
                          i32.load offset=20
                          local.tee $l3
                          i32.eqz
                          br_if $B85
                          local.get $p0
                          i32.const 20
                          i32.add
                          local.get $l3
                          i32.store
                          local.get $l3
                          local.get $p0
                          i32.store offset=24
                        end
                        local.get $l7
                        local.get $l5
                        i32.add
                        local.set $l5
                        local.get $l6
                        local.get $l7
                        i32.add
                        local.set $l6
                      end
                      local.get $l6
                      local.get $l6
                      i32.load offset=4
                      i32.const -2
                      i32.and
                      i32.store offset=4
                      local.get $l2
                      local.get $l5
                      i32.add
                      local.get $l5
                      i32.store
                      local.get $l2
                      local.get $l5
                      i32.const 1
                      i32.or
                      i32.store offset=4
                      block $B95
                        local.get $l5
                        i32.const 255
                        i32.gt_u
                        br_if $B95
                        local.get $l5
                        i32.const 3
                        i32.shr_u
                        local.tee $l4
                        i32.const 3
                        i32.shl
                        i32.const 1059624
                        i32.add
                        local.set $l3
                        block $B96
                          block $B97
                            i32.const 0
                            i32.load offset=1059584
                            local.tee $l5
                            i32.const 1
                            local.get $l4
                            i32.shl
                            local.tee $l4
                            i32.and
                            br_if $B97
                            i32.const 0
                            local.get $l5
                            local.get $l4
                            i32.or
                            i32.store offset=1059584
                            local.get $l3
                            local.set $l4
                            br $B96
                          end
                          local.get $l3
                          i32.load offset=8
                          local.set $l4
                        end
                        local.get $l4
                        local.get $l2
                        i32.store offset=12
                        local.get $l3
                        local.get $l2
                        i32.store offset=8
                        local.get $l2
                        local.get $l3
                        i32.store offset=12
                        local.get $l2
                        local.get $l4
                        i32.store offset=8
                        br $B73
                      end
                      i32.const 31
                      local.set $l3
                      block $B98
                        local.get $l5
                        i32.const 16777215
                        i32.gt_u
                        br_if $B98
                        local.get $l5
                        i32.const 8
                        i32.shr_u
                        local.tee $l3
                        local.get $l3
                        i32.const 1048320
                        i32.add
                        i32.const 16
                        i32.shr_u
                        i32.const 8
                        i32.and
                        local.tee $l3
                        i32.shl
                        local.tee $l4
                        local.get $l4
                        i32.const 520192
                        i32.add
                        i32.const 16
                        i32.shr_u
                        i32.const 4
                        i32.and
                        local.tee $l4
                        i32.shl
                        local.tee $p0
                        local.get $p0
                        i32.const 245760
                        i32.add
                        i32.const 16
                        i32.shr_u
                        i32.const 2
                        i32.and
                        local.tee $p0
                        i32.shl
                        i32.const 15
                        i32.shr_u
                        local.get $l3
                        local.get $l4
                        i32.or
                        local.get $p0
                        i32.or
                        i32.sub
                        local.tee $l3
                        i32.const 1
                        i32.shl
                        local.get $l5
                        local.get $l3
                        i32.const 21
                        i32.add
                        i32.shr_u
                        i32.const 1
                        i32.and
                        i32.or
                        i32.const 28
                        i32.add
                        local.set $l3
                      end
                      local.get $l2
                      local.get $l3
                      i32.store offset=28
                      local.get $l2
                      i64.const 0
                      i64.store offset=16 align=4
                      local.get $l3
                      i32.const 2
                      i32.shl
                      i32.const 1059888
                      i32.add
                      local.set $l4
                      block $B99
                        i32.const 0
                        i32.load offset=1059588
                        local.tee $p0
                        i32.const 1
                        local.get $l3
                        i32.shl
                        local.tee $l8
                        i32.and
                        br_if $B99
                        local.get $l4
                        local.get $l2
                        i32.store
                        i32.const 0
                        local.get $p0
                        local.get $l8
                        i32.or
                        i32.store offset=1059588
                        local.get $l2
                        local.get $l4
                        i32.store offset=24
                        local.get $l2
                        local.get $l2
                        i32.store offset=8
                        local.get $l2
                        local.get $l2
                        i32.store offset=12
                        br $B73
                      end
                      local.get $l5
                      i32.const 0
                      i32.const 25
                      local.get $l3
                      i32.const 1
                      i32.shr_u
                      i32.sub
                      local.get $l3
                      i32.const 31
                      i32.eq
                      select
                      i32.shl
                      local.set $l3
                      local.get $l4
                      i32.load
                      local.set $p0
                      loop $L100
                        local.get $p0
                        local.tee $l4
                        i32.load offset=4
                        i32.const -8
                        i32.and
                        local.get $l5
                        i32.eq
                        br_if $B74
                        local.get $l3
                        i32.const 29
                        i32.shr_u
                        local.set $p0
                        local.get $l3
                        i32.const 1
                        i32.shl
                        local.set $l3
                        local.get $l4
                        local.get $p0
                        i32.const 4
                        i32.and
                        i32.add
                        i32.const 16
                        i32.add
                        local.tee $l8
                        i32.load
                        local.tee $p0
                        br_if $L100
                      end
                      local.get $l8
                      local.get $l2
                      i32.store
                      local.get $l2
                      local.get $l4
                      i32.store offset=24
                      local.get $l2
                      local.get $l2
                      i32.store offset=12
                      local.get $l2
                      local.get $l2
                      i32.store offset=8
                      br $B73
                    end
                    local.get $p0
                    i32.const -8
                    local.get $p0
                    i32.sub
                    i32.const 15
                    i32.and
                    i32.const 0
                    local.get $p0
                    i32.const 8
                    i32.add
                    i32.const 15
                    i32.and
                    select
                    local.tee $l3
                    i32.add
                    local.tee $l11
                    local.get $l6
                    i32.const -56
                    i32.add
                    local.tee $l8
                    local.get $l3
                    i32.sub
                    local.tee $l3
                    i32.const 1
                    i32.or
                    i32.store offset=4
                    local.get $p0
                    local.get $l8
                    i32.add
                    i32.const 56
                    i32.store offset=4
                    local.get $l4
                    local.get $l5
                    i32.const 55
                    local.get $l5
                    i32.sub
                    i32.const 15
                    i32.and
                    i32.const 0
                    local.get $l5
                    i32.const -55
                    i32.add
                    i32.const 15
                    i32.and
                    select
                    i32.add
                    i32.const -63
                    i32.add
                    local.tee $l8
                    local.get $l8
                    local.get $l4
                    i32.const 16
                    i32.add
                    i32.lt_u
                    select
                    local.tee $l8
                    i32.const 35
                    i32.store offset=4
                    i32.const 0
                    i32.const 0
                    i32.load offset=1060072
                    i32.store offset=1059612
                    i32.const 0
                    local.get $l3
                    i32.store offset=1059596
                    i32.const 0
                    local.get $l11
                    i32.store offset=1059608
                    local.get $l8
                    i32.const 16
                    i32.add
                    i32.const 0
                    i64.load offset=1060040 align=4
                    i64.store align=4
                    local.get $l8
                    i32.const 0
                    i64.load offset=1060032 align=4
                    i64.store offset=8 align=4
                    i32.const 0
                    local.get $l8
                    i32.const 8
                    i32.add
                    i32.store offset=1060040
                    i32.const 0
                    local.get $l6
                    i32.store offset=1060036
                    i32.const 0
                    local.get $p0
                    i32.store offset=1060032
                    i32.const 0
                    i32.const 0
                    i32.store offset=1060044
                    local.get $l8
                    i32.const 36
                    i32.add
                    local.set $l3
                    loop $L101
                      local.get $l3
                      i32.const 7
                      i32.store
                      local.get $l5
                      local.get $l3
                      i32.const 4
                      i32.add
                      local.tee $l3
                      i32.gt_u
                      br_if $L101
                    end
                    local.get $l8
                    local.get $l4
                    i32.eq
                    br_if $B63
                    local.get $l8
                    local.get $l8
                    i32.load offset=4
                    i32.const -2
                    i32.and
                    i32.store offset=4
                    local.get $l8
                    local.get $l8
                    local.get $l4
                    i32.sub
                    local.tee $l6
                    i32.store
                    local.get $l4
                    local.get $l6
                    i32.const 1
                    i32.or
                    i32.store offset=4
                    block $B102
                      local.get $l6
                      i32.const 255
                      i32.gt_u
                      br_if $B102
                      local.get $l6
                      i32.const 3
                      i32.shr_u
                      local.tee $l5
                      i32.const 3
                      i32.shl
                      i32.const 1059624
                      i32.add
                      local.set $l3
                      block $B103
                        block $B104
                          i32.const 0
                          i32.load offset=1059584
                          local.tee $p0
                          i32.const 1
                          local.get $l5
                          i32.shl
                          local.tee $l5
                          i32.and
                          br_if $B104
                          i32.const 0
                          local.get $p0
                          local.get $l5
                          i32.or
                          i32.store offset=1059584
                          local.get $l3
                          local.set $l5
                          br $B103
                        end
                        local.get $l3
                        i32.load offset=8
                        local.set $l5
                      end
                      local.get $l5
                      local.get $l4
                      i32.store offset=12
                      local.get $l3
                      local.get $l4
                      i32.store offset=8
                      local.get $l4
                      local.get $l3
                      i32.store offset=12
                      local.get $l4
                      local.get $l5
                      i32.store offset=8
                      br $B63
                    end
                    i32.const 31
                    local.set $l3
                    block $B105
                      local.get $l6
                      i32.const 16777215
                      i32.gt_u
                      br_if $B105
                      local.get $l6
                      i32.const 8
                      i32.shr_u
                      local.tee $l3
                      local.get $l3
                      i32.const 1048320
                      i32.add
                      i32.const 16
                      i32.shr_u
                      i32.const 8
                      i32.and
                      local.tee $l3
                      i32.shl
                      local.tee $l5
                      local.get $l5
                      i32.const 520192
                      i32.add
                      i32.const 16
                      i32.shr_u
                      i32.const 4
                      i32.and
                      local.tee $l5
                      i32.shl
                      local.tee $p0
                      local.get $p0
                      i32.const 245760
                      i32.add
                      i32.const 16
                      i32.shr_u
                      i32.const 2
                      i32.and
                      local.tee $p0
                      i32.shl
                      i32.const 15
                      i32.shr_u
                      local.get $l3
                      local.get $l5
                      i32.or
                      local.get $p0
                      i32.or
                      i32.sub
                      local.tee $l3
                      i32.const 1
                      i32.shl
                      local.get $l6
                      local.get $l3
                      i32.const 21
                      i32.add
                      i32.shr_u
                      i32.const 1
                      i32.and
                      i32.or
                      i32.const 28
                      i32.add
                      local.set $l3
                    end
                    local.get $l4
                    i64.const 0
                    i64.store offset=16 align=4
                    local.get $l4
                    i32.const 28
                    i32.add
                    local.get $l3
                    i32.store
                    local.get $l3
                    i32.const 2
                    i32.shl
                    i32.const 1059888
                    i32.add
                    local.set $l5
                    block $B106
                      i32.const 0
                      i32.load offset=1059588
                      local.tee $p0
                      i32.const 1
                      local.get $l3
                      i32.shl
                      local.tee $l8
                      i32.and
                      br_if $B106
                      local.get $l5
                      local.get $l4
                      i32.store
                      i32.const 0
                      local.get $p0
                      local.get $l8
                      i32.or
                      i32.store offset=1059588
                      local.get $l4
                      i32.const 24
                      i32.add
                      local.get $l5
                      i32.store
                      local.get $l4
                      local.get $l4
                      i32.store offset=8
                      local.get $l4
                      local.get $l4
                      i32.store offset=12
                      br $B63
                    end
                    local.get $l6
                    i32.const 0
                    i32.const 25
                    local.get $l3
                    i32.const 1
                    i32.shr_u
                    i32.sub
                    local.get $l3
                    i32.const 31
                    i32.eq
                    select
                    i32.shl
                    local.set $l3
                    local.get $l5
                    i32.load
                    local.set $p0
                    loop $L107
                      local.get $p0
                      local.tee $l5
                      i32.load offset=4
                      i32.const -8
                      i32.and
                      local.get $l6
                      i32.eq
                      br_if $B72
                      local.get $l3
                      i32.const 29
                      i32.shr_u
                      local.set $p0
                      local.get $l3
                      i32.const 1
                      i32.shl
                      local.set $l3
                      local.get $l5
                      local.get $p0
                      i32.const 4
                      i32.and
                      i32.add
                      i32.const 16
                      i32.add
                      local.tee $l8
                      i32.load
                      local.tee $p0
                      br_if $L107
                    end
                    local.get $l8
                    local.get $l4
                    i32.store
                    local.get $l4
                    i32.const 24
                    i32.add
                    local.get $l5
                    i32.store
                    local.get $l4
                    local.get $l4
                    i32.store offset=12
                    local.get $l4
                    local.get $l4
                    i32.store offset=8
                    br $B63
                  end
                  local.get $l4
                  i32.load offset=8
                  local.tee $l3
                  local.get $l2
                  i32.store offset=12
                  local.get $l4
                  local.get $l2
                  i32.store offset=8
                  local.get $l2
                  i32.const 0
                  i32.store offset=24
                  local.get $l2
                  local.get $l4
                  i32.store offset=12
                  local.get $l2
                  local.get $l3
                  i32.store offset=8
                end
                local.get $l11
                i32.const 8
                i32.add
                local.set $l3
                br $B3
              end
              local.get $l5
              i32.load offset=8
              local.tee $l3
              local.get $l4
              i32.store offset=12
              local.get $l5
              local.get $l4
              i32.store offset=8
              local.get $l4
              i32.const 24
              i32.add
              i32.const 0
              i32.store
              local.get $l4
              local.get $l5
              i32.store offset=12
              local.get $l4
              local.get $l3
              i32.store offset=8
            end
            i32.const 0
            i32.load offset=1059596
            local.tee $l3
            local.get $l2
            i32.le_u
            br_if $B6
            i32.const 0
            i32.load offset=1059608
            local.tee $l4
            local.get $l2
            i32.add
            local.tee $l5
            local.get $l3
            local.get $l2
            i32.sub
            local.tee $l3
            i32.const 1
            i32.or
            i32.store offset=4
            i32.const 0
            local.get $l3
            i32.store offset=1059596
            i32.const 0
            local.get $l5
            i32.store offset=1059608
            local.get $l4
            local.get $l2
            i32.const 3
            i32.or
            i32.store offset=4
            local.get $l4
            i32.const 8
            i32.add
            local.set $l3
            br $B3
          end
          i32.const 0
          local.set $l3
          i32.const 0
          i32.const 48
          i32.store offset=1060080
          br $B3
        end
        block $B108
          local.get $l11
          i32.eqz
          br_if $B108
          block $B109
            block $B110
              local.get $l8
              local.get $l8
              i32.load offset=28
              local.tee $l5
              i32.const 2
              i32.shl
              i32.const 1059888
              i32.add
              local.tee $l3
              i32.load
              i32.ne
              br_if $B110
              local.get $l3
              local.get $p0
              i32.store
              local.get $p0
              br_if $B109
              i32.const 0
              local.get $l7
              i32.const -2
              local.get $l5
              i32.rotl
              i32.and
              local.tee $l7
              i32.store offset=1059588
              br $B108
            end
            local.get $l11
            i32.const 16
            i32.const 20
            local.get $l11
            i32.load offset=16
            local.get $l8
            i32.eq
            select
            i32.add
            local.get $p0
            i32.store
            local.get $p0
            i32.eqz
            br_if $B108
          end
          local.get $p0
          local.get $l11
          i32.store offset=24
          block $B111
            local.get $l8
            i32.load offset=16
            local.tee $l3
            i32.eqz
            br_if $B111
            local.get $p0
            local.get $l3
            i32.store offset=16
            local.get $l3
            local.get $p0
            i32.store offset=24
          end
          local.get $l8
          i32.const 20
          i32.add
          i32.load
          local.tee $l3
          i32.eqz
          br_if $B108
          local.get $p0
          i32.const 20
          i32.add
          local.get $l3
          i32.store
          local.get $l3
          local.get $p0
          i32.store offset=24
        end
        block $B112
          block $B113
            local.get $l4
            i32.const 15
            i32.gt_u
            br_if $B113
            local.get $l8
            local.get $l4
            local.get $l2
            i32.add
            local.tee $l3
            i32.const 3
            i32.or
            i32.store offset=4
            local.get $l8
            local.get $l3
            i32.add
            local.tee $l3
            local.get $l3
            i32.load offset=4
            i32.const 1
            i32.or
            i32.store offset=4
            br $B112
          end
          local.get $l8
          local.get $l2
          i32.add
          local.tee $p0
          local.get $l4
          i32.const 1
          i32.or
          i32.store offset=4
          local.get $l8
          local.get $l2
          i32.const 3
          i32.or
          i32.store offset=4
          local.get $p0
          local.get $l4
          i32.add
          local.get $l4
          i32.store
          block $B114
            local.get $l4
            i32.const 255
            i32.gt_u
            br_if $B114
            local.get $l4
            i32.const 3
            i32.shr_u
            local.tee $l4
            i32.const 3
            i32.shl
            i32.const 1059624
            i32.add
            local.set $l3
            block $B115
              block $B116
                i32.const 0
                i32.load offset=1059584
                local.tee $l5
                i32.const 1
                local.get $l4
                i32.shl
                local.tee $l4
                i32.and
                br_if $B116
                i32.const 0
                local.get $l5
                local.get $l4
                i32.or
                i32.store offset=1059584
                local.get $l3
                local.set $l4
                br $B115
              end
              local.get $l3
              i32.load offset=8
              local.set $l4
            end
            local.get $l4
            local.get $p0
            i32.store offset=12
            local.get $l3
            local.get $p0
            i32.store offset=8
            local.get $p0
            local.get $l3
            i32.store offset=12
            local.get $p0
            local.get $l4
            i32.store offset=8
            br $B112
          end
          i32.const 31
          local.set $l3
          block $B117
            local.get $l4
            i32.const 16777215
            i32.gt_u
            br_if $B117
            local.get $l4
            i32.const 8
            i32.shr_u
            local.tee $l3
            local.get $l3
            i32.const 1048320
            i32.add
            i32.const 16
            i32.shr_u
            i32.const 8
            i32.and
            local.tee $l3
            i32.shl
            local.tee $l5
            local.get $l5
            i32.const 520192
            i32.add
            i32.const 16
            i32.shr_u
            i32.const 4
            i32.and
            local.tee $l5
            i32.shl
            local.tee $l2
            local.get $l2
            i32.const 245760
            i32.add
            i32.const 16
            i32.shr_u
            i32.const 2
            i32.and
            local.tee $l2
            i32.shl
            i32.const 15
            i32.shr_u
            local.get $l3
            local.get $l5
            i32.or
            local.get $l2
            i32.or
            i32.sub
            local.tee $l3
            i32.const 1
            i32.shl
            local.get $l4
            local.get $l3
            i32.const 21
            i32.add
            i32.shr_u
            i32.const 1
            i32.and
            i32.or
            i32.const 28
            i32.add
            local.set $l3
          end
          local.get $p0
          local.get $l3
          i32.store offset=28
          local.get $p0
          i64.const 0
          i64.store offset=16 align=4
          local.get $l3
          i32.const 2
          i32.shl
          i32.const 1059888
          i32.add
          local.set $l5
          block $B118
            local.get $l7
            i32.const 1
            local.get $l3
            i32.shl
            local.tee $l2
            i32.and
            br_if $B118
            local.get $l5
            local.get $p0
            i32.store
            i32.const 0
            local.get $l7
            local.get $l2
            i32.or
            i32.store offset=1059588
            local.get $p0
            local.get $l5
            i32.store offset=24
            local.get $p0
            local.get $p0
            i32.store offset=8
            local.get $p0
            local.get $p0
            i32.store offset=12
            br $B112
          end
          local.get $l4
          i32.const 0
          i32.const 25
          local.get $l3
          i32.const 1
          i32.shr_u
          i32.sub
          local.get $l3
          i32.const 31
          i32.eq
          select
          i32.shl
          local.set $l3
          local.get $l5
          i32.load
          local.set $l2
          block $B119
            loop $L120
              local.get $l2
              local.tee $l5
              i32.load offset=4
              i32.const -8
              i32.and
              local.get $l4
              i32.eq
              br_if $B119
              local.get $l3
              i32.const 29
              i32.shr_u
              local.set $l2
              local.get $l3
              i32.const 1
              i32.shl
              local.set $l3
              local.get $l5
              local.get $l2
              i32.const 4
              i32.and
              i32.add
              i32.const 16
              i32.add
              local.tee $l6
              i32.load
              local.tee $l2
              br_if $L120
            end
            local.get $l6
            local.get $p0
            i32.store
            local.get $p0
            local.get $l5
            i32.store offset=24
            local.get $p0
            local.get $p0
            i32.store offset=12
            local.get $p0
            local.get $p0
            i32.store offset=8
            br $B112
          end
          local.get $l5
          i32.load offset=8
          local.tee $l3
          local.get $p0
          i32.store offset=12
          local.get $l5
          local.get $p0
          i32.store offset=8
          local.get $p0
          i32.const 0
          i32.store offset=24
          local.get $p0
          local.get $l5
          i32.store offset=12
          local.get $p0
          local.get $l3
          i32.store offset=8
        end
        local.get $l8
        i32.const 8
        i32.add
        local.set $l3
        br $B3
      end
      block $B121
        local.get $l10
        i32.eqz
        br_if $B121
        block $B122
          block $B123
            local.get $p0
            local.get $p0
            i32.load offset=28
            local.tee $l5
            i32.const 2
            i32.shl
            i32.const 1059888
            i32.add
            local.tee $l3
            i32.load
            i32.ne
            br_if $B123
            local.get $l3
            local.get $l8
            i32.store
            local.get $l8
            br_if $B122
            i32.const 0
            local.get $l9
            i32.const -2
            local.get $l5
            i32.rotl
            i32.and
            i32.store offset=1059588
            br $B121
          end
          local.get $l10
          i32.const 16
          i32.const 20
          local.get $l10
          i32.load offset=16
          local.get $p0
          i32.eq
          select
          i32.add
          local.get $l8
          i32.store
          local.get $l8
          i32.eqz
          br_if $B121
        end
        local.get $l8
        local.get $l10
        i32.store offset=24
        block $B124
          local.get $p0
          i32.load offset=16
          local.tee $l3
          i32.eqz
          br_if $B124
          local.get $l8
          local.get $l3
          i32.store offset=16
          local.get $l3
          local.get $l8
          i32.store offset=24
        end
        local.get $p0
        i32.const 20
        i32.add
        i32.load
        local.tee $l3
        i32.eqz
        br_if $B121
        local.get $l8
        i32.const 20
        i32.add
        local.get $l3
        i32.store
        local.get $l3
        local.get $l8
        i32.store offset=24
      end
      block $B125
        block $B126
          local.get $l4
          i32.const 15
          i32.gt_u
          br_if $B126
          local.get $p0
          local.get $l4
          local.get $l2
          i32.add
          local.tee $l3
          i32.const 3
          i32.or
          i32.store offset=4
          local.get $p0
          local.get $l3
          i32.add
          local.tee $l3
          local.get $l3
          i32.load offset=4
          i32.const 1
          i32.or
          i32.store offset=4
          br $B125
        end
        local.get $p0
        local.get $l2
        i32.add
        local.tee $l5
        local.get $l4
        i32.const 1
        i32.or
        i32.store offset=4
        local.get $p0
        local.get $l2
        i32.const 3
        i32.or
        i32.store offset=4
        local.get $l5
        local.get $l4
        i32.add
        local.get $l4
        i32.store
        block $B127
          local.get $l7
          i32.eqz
          br_if $B127
          local.get $l7
          i32.const 3
          i32.shr_u
          local.tee $l8
          i32.const 3
          i32.shl
          i32.const 1059624
          i32.add
          local.set $l2
          i32.const 0
          i32.load offset=1059604
          local.set $l3
          block $B128
            block $B129
              i32.const 1
              local.get $l8
              i32.shl
              local.tee $l8
              local.get $l6
              i32.and
              br_if $B129
              i32.const 0
              local.get $l8
              local.get $l6
              i32.or
              i32.store offset=1059584
              local.get $l2
              local.set $l8
              br $B128
            end
            local.get $l2
            i32.load offset=8
            local.set $l8
          end
          local.get $l8
          local.get $l3
          i32.store offset=12
          local.get $l2
          local.get $l3
          i32.store offset=8
          local.get $l3
          local.get $l2
          i32.store offset=12
          local.get $l3
          local.get $l8
          i32.store offset=8
        end
        i32.const 0
        local.get $l5
        i32.store offset=1059604
        i32.const 0
        local.get $l4
        i32.store offset=1059592
      end
      local.get $p0
      i32.const 8
      i32.add
      local.set $l3
    end
    local.get $l1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $l3)
  (func $free (type $t1) (param $p0 i32)
    local.get $p0
    call $dlfree)
  (func $dlfree (type $t1) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32)
    block $B0
      local.get $p0
      i32.eqz
      br_if $B0
      local.get $p0
      i32.const -8
      i32.add
      local.tee $l1
      local.get $p0
      i32.const -4
      i32.add
      i32.load
      local.tee $l2
      i32.const -8
      i32.and
      local.tee $p0
      i32.add
      local.set $l3
      block $B1
        local.get $l2
        i32.const 1
        i32.and
        br_if $B1
        local.get $l2
        i32.const 3
        i32.and
        i32.eqz
        br_if $B0
        local.get $l1
        local.get $l1
        i32.load
        local.tee $l2
        i32.sub
        local.tee $l1
        i32.const 0
        i32.load offset=1059600
        local.tee $l4
        i32.lt_u
        br_if $B0
        local.get $l2
        local.get $p0
        i32.add
        local.set $p0
        block $B2
          i32.const 0
          i32.load offset=1059604
          local.get $l1
          i32.eq
          br_if $B2
          block $B3
            local.get $l2
            i32.const 255
            i32.gt_u
            br_if $B3
            local.get $l1
            i32.load offset=8
            local.tee $l4
            local.get $l2
            i32.const 3
            i32.shr_u
            local.tee $l5
            i32.const 3
            i32.shl
            i32.const 1059624
            i32.add
            local.tee $l6
            i32.eq
            drop
            block $B4
              local.get $l1
              i32.load offset=12
              local.tee $l2
              local.get $l4
              i32.ne
              br_if $B4
              i32.const 0
              i32.const 0
              i32.load offset=1059584
              i32.const -2
              local.get $l5
              i32.rotl
              i32.and
              i32.store offset=1059584
              br $B1
            end
            local.get $l2
            local.get $l6
            i32.eq
            drop
            local.get $l2
            local.get $l4
            i32.store offset=8
            local.get $l4
            local.get $l2
            i32.store offset=12
            br $B1
          end
          local.get $l1
          i32.load offset=24
          local.set $l7
          block $B5
            block $B6
              local.get $l1
              i32.load offset=12
              local.tee $l6
              local.get $l1
              i32.eq
              br_if $B6
              local.get $l4
              local.get $l1
              i32.load offset=8
              local.tee $l2
              i32.gt_u
              drop
              local.get $l6
              local.get $l2
              i32.store offset=8
              local.get $l2
              local.get $l6
              i32.store offset=12
              br $B5
            end
            block $B7
              local.get $l1
              i32.const 20
              i32.add
              local.tee $l2
              i32.load
              local.tee $l4
              br_if $B7
              local.get $l1
              i32.const 16
              i32.add
              local.tee $l2
              i32.load
              local.tee $l4
              br_if $B7
              i32.const 0
              local.set $l6
              br $B5
            end
            loop $L8
              local.get $l2
              local.set $l5
              local.get $l4
              local.tee $l6
              i32.const 20
              i32.add
              local.tee $l2
              i32.load
              local.tee $l4
              br_if $L8
              local.get $l6
              i32.const 16
              i32.add
              local.set $l2
              local.get $l6
              i32.load offset=16
              local.tee $l4
              br_if $L8
            end
            local.get $l5
            i32.const 0
            i32.store
          end
          local.get $l7
          i32.eqz
          br_if $B1
          block $B9
            block $B10
              local.get $l1
              i32.load offset=28
              local.tee $l4
              i32.const 2
              i32.shl
              i32.const 1059888
              i32.add
              local.tee $l2
              i32.load
              local.get $l1
              i32.ne
              br_if $B10
              local.get $l2
              local.get $l6
              i32.store
              local.get $l6
              br_if $B9
              i32.const 0
              i32.const 0
              i32.load offset=1059588
              i32.const -2
              local.get $l4
              i32.rotl
              i32.and
              i32.store offset=1059588
              br $B1
            end
            local.get $l7
            i32.const 16
            i32.const 20
            local.get $l7
            i32.load offset=16
            local.get $l1
            i32.eq
            select
            i32.add
            local.get $l6
            i32.store
            local.get $l6
            i32.eqz
            br_if $B1
          end
          local.get $l6
          local.get $l7
          i32.store offset=24
          block $B11
            local.get $l1
            i32.load offset=16
            local.tee $l2
            i32.eqz
            br_if $B11
            local.get $l6
            local.get $l2
            i32.store offset=16
            local.get $l2
            local.get $l6
            i32.store offset=24
          end
          local.get $l1
          i32.load offset=20
          local.tee $l2
          i32.eqz
          br_if $B1
          local.get $l6
          i32.const 20
          i32.add
          local.get $l2
          i32.store
          local.get $l2
          local.get $l6
          i32.store offset=24
          br $B1
        end
        local.get $l3
        i32.load offset=4
        local.tee $l2
        i32.const 3
        i32.and
        i32.const 3
        i32.ne
        br_if $B1
        local.get $l3
        local.get $l2
        i32.const -2
        i32.and
        i32.store offset=4
        i32.const 0
        local.get $p0
        i32.store offset=1059592
        local.get $l1
        local.get $p0
        i32.add
        local.get $p0
        i32.store
        local.get $l1
        local.get $p0
        i32.const 1
        i32.or
        i32.store offset=4
        return
      end
      local.get $l3
      local.get $l1
      i32.le_u
      br_if $B0
      local.get $l3
      i32.load offset=4
      local.tee $l2
      i32.const 1
      i32.and
      i32.eqz
      br_if $B0
      block $B12
        block $B13
          local.get $l2
          i32.const 2
          i32.and
          br_if $B13
          block $B14
            i32.const 0
            i32.load offset=1059608
            local.get $l3
            i32.ne
            br_if $B14
            i32.const 0
            local.get $l1
            i32.store offset=1059608
            i32.const 0
            i32.const 0
            i32.load offset=1059596
            local.get $p0
            i32.add
            local.tee $p0
            i32.store offset=1059596
            local.get $l1
            local.get $p0
            i32.const 1
            i32.or
            i32.store offset=4
            local.get $l1
            i32.const 0
            i32.load offset=1059604
            i32.ne
            br_if $B0
            i32.const 0
            i32.const 0
            i32.store offset=1059592
            i32.const 0
            i32.const 0
            i32.store offset=1059604
            return
          end
          block $B15
            i32.const 0
            i32.load offset=1059604
            local.get $l3
            i32.ne
            br_if $B15
            i32.const 0
            local.get $l1
            i32.store offset=1059604
            i32.const 0
            i32.const 0
            i32.load offset=1059592
            local.get $p0
            i32.add
            local.tee $p0
            i32.store offset=1059592
            local.get $l1
            local.get $p0
            i32.const 1
            i32.or
            i32.store offset=4
            local.get $l1
            local.get $p0
            i32.add
            local.get $p0
            i32.store
            return
          end
          local.get $l2
          i32.const -8
          i32.and
          local.get $p0
          i32.add
          local.set $p0
          block $B16
            block $B17
              local.get $l2
              i32.const 255
              i32.gt_u
              br_if $B17
              local.get $l3
              i32.load offset=8
              local.tee $l4
              local.get $l2
              i32.const 3
              i32.shr_u
              local.tee $l5
              i32.const 3
              i32.shl
              i32.const 1059624
              i32.add
              local.tee $l6
              i32.eq
              drop
              block $B18
                local.get $l3
                i32.load offset=12
                local.tee $l2
                local.get $l4
                i32.ne
                br_if $B18
                i32.const 0
                i32.const 0
                i32.load offset=1059584
                i32.const -2
                local.get $l5
                i32.rotl
                i32.and
                i32.store offset=1059584
                br $B16
              end
              local.get $l2
              local.get $l6
              i32.eq
              drop
              local.get $l2
              local.get $l4
              i32.store offset=8
              local.get $l4
              local.get $l2
              i32.store offset=12
              br $B16
            end
            local.get $l3
            i32.load offset=24
            local.set $l7
            block $B19
              block $B20
                local.get $l3
                i32.load offset=12
                local.tee $l6
                local.get $l3
                i32.eq
                br_if $B20
                i32.const 0
                i32.load offset=1059600
                local.get $l3
                i32.load offset=8
                local.tee $l2
                i32.gt_u
                drop
                local.get $l6
                local.get $l2
                i32.store offset=8
                local.get $l2
                local.get $l6
                i32.store offset=12
                br $B19
              end
              block $B21
                local.get $l3
                i32.const 20
                i32.add
                local.tee $l2
                i32.load
                local.tee $l4
                br_if $B21
                local.get $l3
                i32.const 16
                i32.add
                local.tee $l2
                i32.load
                local.tee $l4
                br_if $B21
                i32.const 0
                local.set $l6
                br $B19
              end
              loop $L22
                local.get $l2
                local.set $l5
                local.get $l4
                local.tee $l6
                i32.const 20
                i32.add
                local.tee $l2
                i32.load
                local.tee $l4
                br_if $L22
                local.get $l6
                i32.const 16
                i32.add
                local.set $l2
                local.get $l6
                i32.load offset=16
                local.tee $l4
                br_if $L22
              end
              local.get $l5
              i32.const 0
              i32.store
            end
            local.get $l7
            i32.eqz
            br_if $B16
            block $B23
              block $B24
                local.get $l3
                i32.load offset=28
                local.tee $l4
                i32.const 2
                i32.shl
                i32.const 1059888
                i32.add
                local.tee $l2
                i32.load
                local.get $l3
                i32.ne
                br_if $B24
                local.get $l2
                local.get $l6
                i32.store
                local.get $l6
                br_if $B23
                i32.const 0
                i32.const 0
                i32.load offset=1059588
                i32.const -2
                local.get $l4
                i32.rotl
                i32.and
                i32.store offset=1059588
                br $B16
              end
              local.get $l7
              i32.const 16
              i32.const 20
              local.get $l7
              i32.load offset=16
              local.get $l3
              i32.eq
              select
              i32.add
              local.get $l6
              i32.store
              local.get $l6
              i32.eqz
              br_if $B16
            end
            local.get $l6
            local.get $l7
            i32.store offset=24
            block $B25
              local.get $l3
              i32.load offset=16
              local.tee $l2
              i32.eqz
              br_if $B25
              local.get $l6
              local.get $l2
              i32.store offset=16
              local.get $l2
              local.get $l6
              i32.store offset=24
            end
            local.get $l3
            i32.load offset=20
            local.tee $l2
            i32.eqz
            br_if $B16
            local.get $l6
            i32.const 20
            i32.add
            local.get $l2
            i32.store
            local.get $l2
            local.get $l6
            i32.store offset=24
          end
          local.get $l1
          local.get $p0
          i32.add
          local.get $p0
          i32.store
          local.get $l1
          local.get $p0
          i32.const 1
          i32.or
          i32.store offset=4
          local.get $l1
          i32.const 0
          i32.load offset=1059604
          i32.ne
          br_if $B12
          i32.const 0
          local.get $p0
          i32.store offset=1059592
          return
        end
        local.get $l3
        local.get $l2
        i32.const -2
        i32.and
        i32.store offset=4
        local.get $l1
        local.get $p0
        i32.add
        local.get $p0
        i32.store
        local.get $l1
        local.get $p0
        i32.const 1
        i32.or
        i32.store offset=4
      end
      block $B26
        local.get $p0
        i32.const 255
        i32.gt_u
        br_if $B26
        local.get $p0
        i32.const 3
        i32.shr_u
        local.tee $l2
        i32.const 3
        i32.shl
        i32.const 1059624
        i32.add
        local.set $p0
        block $B27
          block $B28
            i32.const 0
            i32.load offset=1059584
            local.tee $l4
            i32.const 1
            local.get $l2
            i32.shl
            local.tee $l2
            i32.and
            br_if $B28
            i32.const 0
            local.get $l4
            local.get $l2
            i32.or
            i32.store offset=1059584
            local.get $p0
            local.set $l2
            br $B27
          end
          local.get $p0
          i32.load offset=8
          local.set $l2
        end
        local.get $l2
        local.get $l1
        i32.store offset=12
        local.get $p0
        local.get $l1
        i32.store offset=8
        local.get $l1
        local.get $p0
        i32.store offset=12
        local.get $l1
        local.get $l2
        i32.store offset=8
        return
      end
      i32.const 31
      local.set $l2
      block $B29
        local.get $p0
        i32.const 16777215
        i32.gt_u
        br_if $B29
        local.get $p0
        i32.const 8
        i32.shr_u
        local.tee $l2
        local.get $l2
        i32.const 1048320
        i32.add
        i32.const 16
        i32.shr_u
        i32.const 8
        i32.and
        local.tee $l2
        i32.shl
        local.tee $l4
        local.get $l4
        i32.const 520192
        i32.add
        i32.const 16
        i32.shr_u
        i32.const 4
        i32.and
        local.tee $l4
        i32.shl
        local.tee $l6
        local.get $l6
        i32.const 245760
        i32.add
        i32.const 16
        i32.shr_u
        i32.const 2
        i32.and
        local.tee $l6
        i32.shl
        i32.const 15
        i32.shr_u
        local.get $l2
        local.get $l4
        i32.or
        local.get $l6
        i32.or
        i32.sub
        local.tee $l2
        i32.const 1
        i32.shl
        local.get $p0
        local.get $l2
        i32.const 21
        i32.add
        i32.shr_u
        i32.const 1
        i32.and
        i32.or
        i32.const 28
        i32.add
        local.set $l2
      end
      local.get $l1
      i64.const 0
      i64.store offset=16 align=4
      local.get $l1
      i32.const 28
      i32.add
      local.get $l2
      i32.store
      local.get $l2
      i32.const 2
      i32.shl
      i32.const 1059888
      i32.add
      local.set $l4
      block $B30
        block $B31
          i32.const 0
          i32.load offset=1059588
          local.tee $l6
          i32.const 1
          local.get $l2
          i32.shl
          local.tee $l3
          i32.and
          br_if $B31
          local.get $l4
          local.get $l1
          i32.store
          i32.const 0
          local.get $l6
          local.get $l3
          i32.or
          i32.store offset=1059588
          local.get $l1
          i32.const 24
          i32.add
          local.get $l4
          i32.store
          local.get $l1
          local.get $l1
          i32.store offset=8
          local.get $l1
          local.get $l1
          i32.store offset=12
          br $B30
        end
        local.get $p0
        i32.const 0
        i32.const 25
        local.get $l2
        i32.const 1
        i32.shr_u
        i32.sub
        local.get $l2
        i32.const 31
        i32.eq
        select
        i32.shl
        local.set $l2
        local.get $l4
        i32.load
        local.set $l6
        block $B32
          loop $L33
            local.get $l6
            local.tee $l4
            i32.load offset=4
            i32.const -8
            i32.and
            local.get $p0
            i32.eq
            br_if $B32
            local.get $l2
            i32.const 29
            i32.shr_u
            local.set $l6
            local.get $l2
            i32.const 1
            i32.shl
            local.set $l2
            local.get $l4
            local.get $l6
            i32.const 4
            i32.and
            i32.add
            i32.const 16
            i32.add
            local.tee $l3
            i32.load
            local.tee $l6
            br_if $L33
          end
          local.get $l3
          local.get $l1
          i32.store
          local.get $l1
          i32.const 24
          i32.add
          local.get $l4
          i32.store
          local.get $l1
          local.get $l1
          i32.store offset=12
          local.get $l1
          local.get $l1
          i32.store offset=8
          br $B30
        end
        local.get $l4
        i32.load offset=8
        local.tee $p0
        local.get $l1
        i32.store offset=12
        local.get $l4
        local.get $l1
        i32.store offset=8
        local.get $l1
        i32.const 24
        i32.add
        i32.const 0
        i32.store
        local.get $l1
        local.get $l4
        i32.store offset=12
        local.get $l1
        local.get $p0
        i32.store offset=8
      end
      i32.const 0
      i32.const 0
      i32.load offset=1059616
      i32.const -1
      i32.add
      local.tee $l1
      i32.const -1
      local.get $l1
      select
      i32.store offset=1059616
    end)
  (func $calloc (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i64)
    block $B0
      block $B1
        local.get $p0
        br_if $B1
        i32.const 0
        local.set $l2
        br $B0
      end
      local.get $p0
      i64.extend_i32_u
      local.get $p1
      i64.extend_i32_u
      i64.mul
      local.tee $l3
      i32.wrap_i64
      local.set $l2
      local.get $p1
      local.get $p0
      i32.or
      i32.const 65536
      i32.lt_u
      br_if $B0
      i32.const -1
      local.get $l2
      local.get $l3
      i64.const 32
      i64.shr_u
      i32.wrap_i64
      i32.const 0
      i32.ne
      select
      local.set $l2
    end
    block $B2
      local.get $l2
      call $dlmalloc
      local.tee $p0
      i32.eqz
      br_if $B2
      local.get $p0
      i32.const -4
      i32.add
      i32.load8_u
      i32.const 3
      i32.and
      i32.eqz
      br_if $B2
      local.get $p0
      i32.const 0
      local.get $l2
      call $memset
      drop
    end
    local.get $p0)
  (func $realloc (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32)
    block $B0
      local.get $p0
      br_if $B0
      local.get $p1
      call $dlmalloc
      return
    end
    block $B1
      local.get $p1
      i32.const -64
      i32.lt_u
      br_if $B1
      i32.const 0
      i32.const 48
      i32.store offset=1060080
      i32.const 0
      return
    end
    i32.const 16
    local.get $p1
    i32.const 19
    i32.add
    i32.const -16
    i32.and
    local.get $p1
    i32.const 11
    i32.lt_u
    select
    local.set $l2
    local.get $p0
    i32.const -4
    i32.add
    local.tee $l3
    i32.load
    local.tee $l4
    i32.const -8
    i32.and
    local.set $l5
    block $B2
      block $B3
        block $B4
          local.get $l4
          i32.const 3
          i32.and
          br_if $B4
          local.get $l2
          i32.const 256
          i32.lt_u
          br_if $B3
          local.get $l5
          local.get $l2
          i32.const 4
          i32.or
          i32.lt_u
          br_if $B3
          local.get $l5
          local.get $l2
          i32.sub
          i32.const 0
          i32.load offset=1060064
          i32.const 1
          i32.shl
          i32.le_u
          br_if $B2
          br $B3
        end
        local.get $p0
        i32.const -8
        i32.add
        local.tee $l6
        local.get $l5
        i32.add
        local.set $l7
        block $B5
          local.get $l5
          local.get $l2
          i32.lt_u
          br_if $B5
          local.get $l5
          local.get $l2
          i32.sub
          local.tee $p1
          i32.const 16
          i32.lt_u
          br_if $B2
          local.get $l3
          local.get $l2
          local.get $l4
          i32.const 1
          i32.and
          i32.or
          i32.const 2
          i32.or
          i32.store
          local.get $l6
          local.get $l2
          i32.add
          local.tee $l2
          local.get $p1
          i32.const 3
          i32.or
          i32.store offset=4
          local.get $l7
          local.get $l7
          i32.load offset=4
          i32.const 1
          i32.or
          i32.store offset=4
          local.get $l2
          local.get $p1
          call $dispose_chunk
          local.get $p0
          return
        end
        block $B6
          i32.const 0
          i32.load offset=1059608
          local.get $l7
          i32.ne
          br_if $B6
          i32.const 0
          i32.load offset=1059596
          local.get $l5
          i32.add
          local.tee $l5
          local.get $l2
          i32.le_u
          br_if $B3
          local.get $l3
          local.get $l2
          local.get $l4
          i32.const 1
          i32.and
          i32.or
          i32.const 2
          i32.or
          i32.store
          i32.const 0
          local.get $l6
          local.get $l2
          i32.add
          local.tee $p1
          i32.store offset=1059608
          i32.const 0
          local.get $l5
          local.get $l2
          i32.sub
          local.tee $l2
          i32.store offset=1059596
          local.get $p1
          local.get $l2
          i32.const 1
          i32.or
          i32.store offset=4
          local.get $p0
          return
        end
        block $B7
          i32.const 0
          i32.load offset=1059604
          local.get $l7
          i32.ne
          br_if $B7
          i32.const 0
          i32.load offset=1059592
          local.get $l5
          i32.add
          local.tee $l5
          local.get $l2
          i32.lt_u
          br_if $B3
          block $B8
            block $B9
              local.get $l5
              local.get $l2
              i32.sub
              local.tee $p1
              i32.const 16
              i32.lt_u
              br_if $B9
              local.get $l3
              local.get $l2
              local.get $l4
              i32.const 1
              i32.and
              i32.or
              i32.const 2
              i32.or
              i32.store
              local.get $l6
              local.get $l2
              i32.add
              local.tee $l2
              local.get $p1
              i32.const 1
              i32.or
              i32.store offset=4
              local.get $l6
              local.get $l5
              i32.add
              local.tee $l5
              local.get $p1
              i32.store
              local.get $l5
              local.get $l5
              i32.load offset=4
              i32.const -2
              i32.and
              i32.store offset=4
              br $B8
            end
            local.get $l3
            local.get $l4
            i32.const 1
            i32.and
            local.get $l5
            i32.or
            i32.const 2
            i32.or
            i32.store
            local.get $l6
            local.get $l5
            i32.add
            local.tee $p1
            local.get $p1
            i32.load offset=4
            i32.const 1
            i32.or
            i32.store offset=4
            i32.const 0
            local.set $p1
            i32.const 0
            local.set $l2
          end
          i32.const 0
          local.get $l2
          i32.store offset=1059604
          i32.const 0
          local.get $p1
          i32.store offset=1059592
          local.get $p0
          return
        end
        local.get $l7
        i32.load offset=4
        local.tee $l8
        i32.const 2
        i32.and
        br_if $B3
        local.get $l8
        i32.const -8
        i32.and
        local.get $l5
        i32.add
        local.tee $l9
        local.get $l2
        i32.lt_u
        br_if $B3
        local.get $l9
        local.get $l2
        i32.sub
        local.set $l10
        block $B10
          block $B11
            local.get $l8
            i32.const 255
            i32.gt_u
            br_if $B11
            local.get $l7
            i32.load offset=8
            local.tee $p1
            local.get $l8
            i32.const 3
            i32.shr_u
            local.tee $l11
            i32.const 3
            i32.shl
            i32.const 1059624
            i32.add
            local.tee $l8
            i32.eq
            drop
            block $B12
              local.get $l7
              i32.load offset=12
              local.tee $l5
              local.get $p1
              i32.ne
              br_if $B12
              i32.const 0
              i32.const 0
              i32.load offset=1059584
              i32.const -2
              local.get $l11
              i32.rotl
              i32.and
              i32.store offset=1059584
              br $B10
            end
            local.get $l5
            local.get $l8
            i32.eq
            drop
            local.get $l5
            local.get $p1
            i32.store offset=8
            local.get $p1
            local.get $l5
            i32.store offset=12
            br $B10
          end
          local.get $l7
          i32.load offset=24
          local.set $l12
          block $B13
            block $B14
              local.get $l7
              i32.load offset=12
              local.tee $l8
              local.get $l7
              i32.eq
              br_if $B14
              i32.const 0
              i32.load offset=1059600
              local.get $l7
              i32.load offset=8
              local.tee $p1
              i32.gt_u
              drop
              local.get $l8
              local.get $p1
              i32.store offset=8
              local.get $p1
              local.get $l8
              i32.store offset=12
              br $B13
            end
            block $B15
              local.get $l7
              i32.const 20
              i32.add
              local.tee $p1
              i32.load
              local.tee $l5
              br_if $B15
              local.get $l7
              i32.const 16
              i32.add
              local.tee $p1
              i32.load
              local.tee $l5
              br_if $B15
              i32.const 0
              local.set $l8
              br $B13
            end
            loop $L16
              local.get $p1
              local.set $l11
              local.get $l5
              local.tee $l8
              i32.const 20
              i32.add
              local.tee $p1
              i32.load
              local.tee $l5
              br_if $L16
              local.get $l8
              i32.const 16
              i32.add
              local.set $p1
              local.get $l8
              i32.load offset=16
              local.tee $l5
              br_if $L16
            end
            local.get $l11
            i32.const 0
            i32.store
          end
          local.get $l12
          i32.eqz
          br_if $B10
          block $B17
            block $B18
              local.get $l7
              i32.load offset=28
              local.tee $l5
              i32.const 2
              i32.shl
              i32.const 1059888
              i32.add
              local.tee $p1
              i32.load
              local.get $l7
              i32.ne
              br_if $B18
              local.get $p1
              local.get $l8
              i32.store
              local.get $l8
              br_if $B17
              i32.const 0
              i32.const 0
              i32.load offset=1059588
              i32.const -2
              local.get $l5
              i32.rotl
              i32.and
              i32.store offset=1059588
              br $B10
            end
            local.get $l12
            i32.const 16
            i32.const 20
            local.get $l12
            i32.load offset=16
            local.get $l7
            i32.eq
            select
            i32.add
            local.get $l8
            i32.store
            local.get $l8
            i32.eqz
            br_if $B10
          end
          local.get $l8
          local.get $l12
          i32.store offset=24
          block $B19
            local.get $l7
            i32.load offset=16
            local.tee $p1
            i32.eqz
            br_if $B19
            local.get $l8
            local.get $p1
            i32.store offset=16
            local.get $p1
            local.get $l8
            i32.store offset=24
          end
          local.get $l7
          i32.load offset=20
          local.tee $p1
          i32.eqz
          br_if $B10
          local.get $l8
          i32.const 20
          i32.add
          local.get $p1
          i32.store
          local.get $p1
          local.get $l8
          i32.store offset=24
        end
        block $B20
          local.get $l10
          i32.const 15
          i32.gt_u
          br_if $B20
          local.get $l3
          local.get $l4
          i32.const 1
          i32.and
          local.get $l9
          i32.or
          i32.const 2
          i32.or
          i32.store
          local.get $l6
          local.get $l9
          i32.add
          local.tee $p1
          local.get $p1
          i32.load offset=4
          i32.const 1
          i32.or
          i32.store offset=4
          local.get $p0
          return
        end
        local.get $l3
        local.get $l2
        local.get $l4
        i32.const 1
        i32.and
        i32.or
        i32.const 2
        i32.or
        i32.store
        local.get $l6
        local.get $l2
        i32.add
        local.tee $p1
        local.get $l10
        i32.const 3
        i32.or
        i32.store offset=4
        local.get $l6
        local.get $l9
        i32.add
        local.tee $l2
        local.get $l2
        i32.load offset=4
        i32.const 1
        i32.or
        i32.store offset=4
        local.get $p1
        local.get $l10
        call $dispose_chunk
        local.get $p0
        return
      end
      block $B21
        local.get $p1
        call $dlmalloc
        local.tee $l2
        br_if $B21
        i32.const 0
        return
      end
      local.get $l2
      local.get $p0
      i32.const -4
      i32.const -8
      local.get $l3
      i32.load
      local.tee $l5
      i32.const 3
      i32.and
      select
      local.get $l5
      i32.const -8
      i32.and
      i32.add
      local.tee $l5
      local.get $p1
      local.get $l5
      local.get $p1
      i32.lt_u
      select
      call $memcpy
      local.set $p1
      local.get $p0
      call $dlfree
      local.get $p1
      local.set $p0
    end
    local.get $p0)
  (func $dispose_chunk (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32)
    local.get $p0
    local.get $p1
    i32.add
    local.set $l2
    block $B0
      block $B1
        local.get $p0
        i32.load offset=4
        local.tee $l3
        i32.const 1
        i32.and
        br_if $B1
        local.get $l3
        i32.const 3
        i32.and
        i32.eqz
        br_if $B0
        local.get $p0
        i32.load
        local.tee $l3
        local.get $p1
        i32.add
        local.set $p1
        block $B2
          block $B3
            i32.const 0
            i32.load offset=1059604
            local.get $p0
            local.get $l3
            i32.sub
            local.tee $p0
            i32.eq
            br_if $B3
            block $B4
              local.get $l3
              i32.const 255
              i32.gt_u
              br_if $B4
              local.get $p0
              i32.load offset=8
              local.tee $l4
              local.get $l3
              i32.const 3
              i32.shr_u
              local.tee $l5
              i32.const 3
              i32.shl
              i32.const 1059624
              i32.add
              local.tee $l6
              i32.eq
              drop
              local.get $p0
              i32.load offset=12
              local.tee $l3
              local.get $l4
              i32.ne
              br_if $B2
              i32.const 0
              i32.const 0
              i32.load offset=1059584
              i32.const -2
              local.get $l5
              i32.rotl
              i32.and
              i32.store offset=1059584
              br $B1
            end
            local.get $p0
            i32.load offset=24
            local.set $l7
            block $B5
              block $B6
                local.get $p0
                i32.load offset=12
                local.tee $l6
                local.get $p0
                i32.eq
                br_if $B6
                i32.const 0
                i32.load offset=1059600
                local.get $p0
                i32.load offset=8
                local.tee $l3
                i32.gt_u
                drop
                local.get $l6
                local.get $l3
                i32.store offset=8
                local.get $l3
                local.get $l6
                i32.store offset=12
                br $B5
              end
              block $B7
                local.get $p0
                i32.const 20
                i32.add
                local.tee $l3
                i32.load
                local.tee $l4
                br_if $B7
                local.get $p0
                i32.const 16
                i32.add
                local.tee $l3
                i32.load
                local.tee $l4
                br_if $B7
                i32.const 0
                local.set $l6
                br $B5
              end
              loop $L8
                local.get $l3
                local.set $l5
                local.get $l4
                local.tee $l6
                i32.const 20
                i32.add
                local.tee $l3
                i32.load
                local.tee $l4
                br_if $L8
                local.get $l6
                i32.const 16
                i32.add
                local.set $l3
                local.get $l6
                i32.load offset=16
                local.tee $l4
                br_if $L8
              end
              local.get $l5
              i32.const 0
              i32.store
            end
            local.get $l7
            i32.eqz
            br_if $B1
            block $B9
              block $B10
                local.get $p0
                i32.load offset=28
                local.tee $l4
                i32.const 2
                i32.shl
                i32.const 1059888
                i32.add
                local.tee $l3
                i32.load
                local.get $p0
                i32.ne
                br_if $B10
                local.get $l3
                local.get $l6
                i32.store
                local.get $l6
                br_if $B9
                i32.const 0
                i32.const 0
                i32.load offset=1059588
                i32.const -2
                local.get $l4
                i32.rotl
                i32.and
                i32.store offset=1059588
                br $B1
              end
              local.get $l7
              i32.const 16
              i32.const 20
              local.get $l7
              i32.load offset=16
              local.get $p0
              i32.eq
              select
              i32.add
              local.get $l6
              i32.store
              local.get $l6
              i32.eqz
              br_if $B1
            end
            local.get $l6
            local.get $l7
            i32.store offset=24
            block $B11
              local.get $p0
              i32.load offset=16
              local.tee $l3
              i32.eqz
              br_if $B11
              local.get $l6
              local.get $l3
              i32.store offset=16
              local.get $l3
              local.get $l6
              i32.store offset=24
            end
            local.get $p0
            i32.load offset=20
            local.tee $l3
            i32.eqz
            br_if $B1
            local.get $l6
            i32.const 20
            i32.add
            local.get $l3
            i32.store
            local.get $l3
            local.get $l6
            i32.store offset=24
            br $B1
          end
          local.get $l2
          i32.load offset=4
          local.tee $l3
          i32.const 3
          i32.and
          i32.const 3
          i32.ne
          br_if $B1
          local.get $l2
          local.get $l3
          i32.const -2
          i32.and
          i32.store offset=4
          i32.const 0
          local.get $p1
          i32.store offset=1059592
          local.get $l2
          local.get $p1
          i32.store
          local.get $p0
          local.get $p1
          i32.const 1
          i32.or
          i32.store offset=4
          return
        end
        local.get $l3
        local.get $l6
        i32.eq
        drop
        local.get $l3
        local.get $l4
        i32.store offset=8
        local.get $l4
        local.get $l3
        i32.store offset=12
      end
      block $B12
        block $B13
          local.get $l2
          i32.load offset=4
          local.tee $l3
          i32.const 2
          i32.and
          br_if $B13
          block $B14
            i32.const 0
            i32.load offset=1059608
            local.get $l2
            i32.ne
            br_if $B14
            i32.const 0
            local.get $p0
            i32.store offset=1059608
            i32.const 0
            i32.const 0
            i32.load offset=1059596
            local.get $p1
            i32.add
            local.tee $p1
            i32.store offset=1059596
            local.get $p0
            local.get $p1
            i32.const 1
            i32.or
            i32.store offset=4
            local.get $p0
            i32.const 0
            i32.load offset=1059604
            i32.ne
            br_if $B0
            i32.const 0
            i32.const 0
            i32.store offset=1059592
            i32.const 0
            i32.const 0
            i32.store offset=1059604
            return
          end
          block $B15
            i32.const 0
            i32.load offset=1059604
            local.get $l2
            i32.ne
            br_if $B15
            i32.const 0
            local.get $p0
            i32.store offset=1059604
            i32.const 0
            i32.const 0
            i32.load offset=1059592
            local.get $p1
            i32.add
            local.tee $p1
            i32.store offset=1059592
            local.get $p0
            local.get $p1
            i32.const 1
            i32.or
            i32.store offset=4
            local.get $p0
            local.get $p1
            i32.add
            local.get $p1
            i32.store
            return
          end
          local.get $l3
          i32.const -8
          i32.and
          local.get $p1
          i32.add
          local.set $p1
          block $B16
            block $B17
              local.get $l3
              i32.const 255
              i32.gt_u
              br_if $B17
              local.get $l2
              i32.load offset=8
              local.tee $l4
              local.get $l3
              i32.const 3
              i32.shr_u
              local.tee $l5
              i32.const 3
              i32.shl
              i32.const 1059624
              i32.add
              local.tee $l6
              i32.eq
              drop
              block $B18
                local.get $l2
                i32.load offset=12
                local.tee $l3
                local.get $l4
                i32.ne
                br_if $B18
                i32.const 0
                i32.const 0
                i32.load offset=1059584
                i32.const -2
                local.get $l5
                i32.rotl
                i32.and
                i32.store offset=1059584
                br $B16
              end
              local.get $l3
              local.get $l6
              i32.eq
              drop
              local.get $l3
              local.get $l4
              i32.store offset=8
              local.get $l4
              local.get $l3
              i32.store offset=12
              br $B16
            end
            local.get $l2
            i32.load offset=24
            local.set $l7
            block $B19
              block $B20
                local.get $l2
                i32.load offset=12
                local.tee $l6
                local.get $l2
                i32.eq
                br_if $B20
                i32.const 0
                i32.load offset=1059600
                local.get $l2
                i32.load offset=8
                local.tee $l3
                i32.gt_u
                drop
                local.get $l6
                local.get $l3
                i32.store offset=8
                local.get $l3
                local.get $l6
                i32.store offset=12
                br $B19
              end
              block $B21
                local.get $l2
                i32.const 20
                i32.add
                local.tee $l4
                i32.load
                local.tee $l3
                br_if $B21
                local.get $l2
                i32.const 16
                i32.add
                local.tee $l4
                i32.load
                local.tee $l3
                br_if $B21
                i32.const 0
                local.set $l6
                br $B19
              end
              loop $L22
                local.get $l4
                local.set $l5
                local.get $l3
                local.tee $l6
                i32.const 20
                i32.add
                local.tee $l4
                i32.load
                local.tee $l3
                br_if $L22
                local.get $l6
                i32.const 16
                i32.add
                local.set $l4
                local.get $l6
                i32.load offset=16
                local.tee $l3
                br_if $L22
              end
              local.get $l5
              i32.const 0
              i32.store
            end
            local.get $l7
            i32.eqz
            br_if $B16
            block $B23
              block $B24
                local.get $l2
                i32.load offset=28
                local.tee $l4
                i32.const 2
                i32.shl
                i32.const 1059888
                i32.add
                local.tee $l3
                i32.load
                local.get $l2
                i32.ne
                br_if $B24
                local.get $l3
                local.get $l6
                i32.store
                local.get $l6
                br_if $B23
                i32.const 0
                i32.const 0
                i32.load offset=1059588
                i32.const -2
                local.get $l4
                i32.rotl
                i32.and
                i32.store offset=1059588
                br $B16
              end
              local.get $l7
              i32.const 16
              i32.const 20
              local.get $l7
              i32.load offset=16
              local.get $l2
              i32.eq
              select
              i32.add
              local.get $l6
              i32.store
              local.get $l6
              i32.eqz
              br_if $B16
            end
            local.get $l6
            local.get $l7
            i32.store offset=24
            block $B25
              local.get $l2
              i32.load offset=16
              local.tee $l3
              i32.eqz
              br_if $B25
              local.get $l6
              local.get $l3
              i32.store offset=16
              local.get $l3
              local.get $l6
              i32.store offset=24
            end
            local.get $l2
            i32.load offset=20
            local.tee $l3
            i32.eqz
            br_if $B16
            local.get $l6
            i32.const 20
            i32.add
            local.get $l3
            i32.store
            local.get $l3
            local.get $l6
            i32.store offset=24
          end
          local.get $p0
          local.get $p1
          i32.add
          local.get $p1
          i32.store
          local.get $p0
          local.get $p1
          i32.const 1
          i32.or
          i32.store offset=4
          local.get $p0
          i32.const 0
          i32.load offset=1059604
          i32.ne
          br_if $B12
          i32.const 0
          local.get $p1
          i32.store offset=1059592
          return
        end
        local.get $l2
        local.get $l3
        i32.const -2
        i32.and
        i32.store offset=4
        local.get $p0
        local.get $p1
        i32.add
        local.get $p1
        i32.store
        local.get $p0
        local.get $p1
        i32.const 1
        i32.or
        i32.store offset=4
      end
      block $B26
        local.get $p1
        i32.const 255
        i32.gt_u
        br_if $B26
        local.get $p1
        i32.const 3
        i32.shr_u
        local.tee $l3
        i32.const 3
        i32.shl
        i32.const 1059624
        i32.add
        local.set $p1
        block $B27
          block $B28
            i32.const 0
            i32.load offset=1059584
            local.tee $l4
            i32.const 1
            local.get $l3
            i32.shl
            local.tee $l3
            i32.and
            br_if $B28
            i32.const 0
            local.get $l4
            local.get $l3
            i32.or
            i32.store offset=1059584
            local.get $p1
            local.set $l3
            br $B27
          end
          local.get $p1
          i32.load offset=8
          local.set $l3
        end
        local.get $l3
        local.get $p0
        i32.store offset=12
        local.get $p1
        local.get $p0
        i32.store offset=8
        local.get $p0
        local.get $p1
        i32.store offset=12
        local.get $p0
        local.get $l3
        i32.store offset=8
        return
      end
      i32.const 31
      local.set $l3
      block $B29
        local.get $p1
        i32.const 16777215
        i32.gt_u
        br_if $B29
        local.get $p1
        i32.const 8
        i32.shr_u
        local.tee $l3
        local.get $l3
        i32.const 1048320
        i32.add
        i32.const 16
        i32.shr_u
        i32.const 8
        i32.and
        local.tee $l3
        i32.shl
        local.tee $l4
        local.get $l4
        i32.const 520192
        i32.add
        i32.const 16
        i32.shr_u
        i32.const 4
        i32.and
        local.tee $l4
        i32.shl
        local.tee $l6
        local.get $l6
        i32.const 245760
        i32.add
        i32.const 16
        i32.shr_u
        i32.const 2
        i32.and
        local.tee $l6
        i32.shl
        i32.const 15
        i32.shr_u
        local.get $l3
        local.get $l4
        i32.or
        local.get $l6
        i32.or
        i32.sub
        local.tee $l3
        i32.const 1
        i32.shl
        local.get $p1
        local.get $l3
        i32.const 21
        i32.add
        i32.shr_u
        i32.const 1
        i32.and
        i32.or
        i32.const 28
        i32.add
        local.set $l3
      end
      local.get $p0
      i64.const 0
      i64.store offset=16 align=4
      local.get $p0
      i32.const 28
      i32.add
      local.get $l3
      i32.store
      local.get $l3
      i32.const 2
      i32.shl
      i32.const 1059888
      i32.add
      local.set $l4
      block $B30
        i32.const 0
        i32.load offset=1059588
        local.tee $l6
        i32.const 1
        local.get $l3
        i32.shl
        local.tee $l2
        i32.and
        br_if $B30
        local.get $l4
        local.get $p0
        i32.store
        i32.const 0
        local.get $l6
        local.get $l2
        i32.or
        i32.store offset=1059588
        local.get $p0
        i32.const 24
        i32.add
        local.get $l4
        i32.store
        local.get $p0
        local.get $p0
        i32.store offset=8
        local.get $p0
        local.get $p0
        i32.store offset=12
        return
      end
      local.get $p1
      i32.const 0
      i32.const 25
      local.get $l3
      i32.const 1
      i32.shr_u
      i32.sub
      local.get $l3
      i32.const 31
      i32.eq
      select
      i32.shl
      local.set $l3
      local.get $l4
      i32.load
      local.set $l6
      block $B31
        loop $L32
          local.get $l6
          local.tee $l4
          i32.load offset=4
          i32.const -8
          i32.and
          local.get $p1
          i32.eq
          br_if $B31
          local.get $l3
          i32.const 29
          i32.shr_u
          local.set $l6
          local.get $l3
          i32.const 1
          i32.shl
          local.set $l3
          local.get $l4
          local.get $l6
          i32.const 4
          i32.and
          i32.add
          i32.const 16
          i32.add
          local.tee $l2
          i32.load
          local.tee $l6
          br_if $L32
        end
        local.get $l2
        local.get $p0
        i32.store
        local.get $p0
        i32.const 24
        i32.add
        local.get $l4
        i32.store
        local.get $p0
        local.get $p0
        i32.store offset=12
        local.get $p0
        local.get $p0
        i32.store offset=8
        return
      end
      local.get $l4
      i32.load offset=8
      local.tee $p1
      local.get $p0
      i32.store offset=12
      local.get $l4
      local.get $p0
      i32.store offset=8
      local.get $p0
      i32.const 24
      i32.add
      i32.const 0
      i32.store
      local.get $p0
      local.get $l4
      i32.store offset=12
      local.get $p0
      local.get $p1
      i32.store offset=8
    end)
  (func $internal_memalign (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32)
    block $B0
      block $B1
        local.get $p0
        i32.const 16
        local.get $p0
        i32.const 16
        i32.gt_u
        select
        local.tee $l2
        local.get $l2
        i32.const -1
        i32.add
        i32.and
        br_if $B1
        local.get $l2
        local.set $p0
        br $B0
      end
      i32.const 32
      local.set $l3
      loop $L2
        local.get $l3
        local.tee $p0
        i32.const 1
        i32.shl
        local.set $l3
        local.get $p0
        local.get $l2
        i32.lt_u
        br_if $L2
      end
    end
    block $B3
      i32.const -64
      local.get $p0
      i32.sub
      local.get $p1
      i32.gt_u
      br_if $B3
      i32.const 0
      i32.const 48
      i32.store offset=1060080
      i32.const 0
      return
    end
    block $B4
      local.get $p0
      i32.const 16
      local.get $p1
      i32.const 19
      i32.add
      i32.const -16
      i32.and
      local.get $p1
      i32.const 11
      i32.lt_u
      select
      local.tee $p1
      i32.add
      i32.const 12
      i32.add
      call $dlmalloc
      local.tee $l3
      br_if $B4
      i32.const 0
      return
    end
    local.get $l3
    i32.const -8
    i32.add
    local.set $l2
    block $B5
      block $B6
        local.get $p0
        i32.const -1
        i32.add
        local.get $l3
        i32.and
        br_if $B6
        local.get $l2
        local.set $p0
        br $B5
      end
      local.get $l3
      i32.const -4
      i32.add
      local.tee $l4
      i32.load
      local.tee $l5
      i32.const -8
      i32.and
      local.get $l3
      local.get $p0
      i32.add
      i32.const -1
      i32.add
      i32.const 0
      local.get $p0
      i32.sub
      i32.and
      i32.const -8
      i32.add
      local.tee $l3
      i32.const 0
      local.get $p0
      local.get $l3
      local.get $l2
      i32.sub
      i32.const 15
      i32.gt_u
      select
      i32.add
      local.tee $p0
      local.get $l2
      i32.sub
      local.tee $l3
      i32.sub
      local.set $l6
      block $B7
        local.get $l5
        i32.const 3
        i32.and
        br_if $B7
        local.get $p0
        local.get $l6
        i32.store offset=4
        local.get $p0
        local.get $l2
        i32.load
        local.get $l3
        i32.add
        i32.store
        br $B5
      end
      local.get $p0
      local.get $l6
      local.get $p0
      i32.load offset=4
      i32.const 1
      i32.and
      i32.or
      i32.const 2
      i32.or
      i32.store offset=4
      local.get $p0
      local.get $l6
      i32.add
      local.tee $l6
      local.get $l6
      i32.load offset=4
      i32.const 1
      i32.or
      i32.store offset=4
      local.get $l4
      local.get $l3
      local.get $l4
      i32.load
      i32.const 1
      i32.and
      i32.or
      i32.const 2
      i32.or
      i32.store
      local.get $l2
      local.get $l3
      i32.add
      local.tee $l6
      local.get $l6
      i32.load offset=4
      i32.const 1
      i32.or
      i32.store offset=4
      local.get $l2
      local.get $l3
      call $dispose_chunk
    end
    block $B8
      local.get $p0
      i32.load offset=4
      local.tee $l3
      i32.const 3
      i32.and
      i32.eqz
      br_if $B8
      local.get $l3
      i32.const -8
      i32.and
      local.tee $l2
      local.get $p1
      i32.const 16
      i32.add
      i32.le_u
      br_if $B8
      local.get $p0
      local.get $p1
      local.get $l3
      i32.const 1
      i32.and
      i32.or
      i32.const 2
      i32.or
      i32.store offset=4
      local.get $p0
      local.get $p1
      i32.add
      local.tee $l3
      local.get $l2
      local.get $p1
      i32.sub
      local.tee $p1
      i32.const 3
      i32.or
      i32.store offset=4
      local.get $p0
      local.get $l2
      i32.add
      local.tee $l2
      local.get $l2
      i32.load offset=4
      i32.const 1
      i32.or
      i32.store offset=4
      local.get $l3
      local.get $p1
      call $dispose_chunk
    end
    local.get $p0
    i32.const 8
    i32.add)
  (func $aligned_alloc (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    block $B0
      local.get $p0
      i32.const 16
      i32.gt_u
      br_if $B0
      local.get $p1
      call $dlmalloc
      return
    end
    local.get $p0
    local.get $p1
    call $internal_memalign)
  (func $__wasilibc_initialize_environ_eagerly (type $t0)
    call $__wasilibc_initialize_environ)
  (func $_Exit (type $t1) (param $p0 i32)
    local.get $p0
    call $__wasi_proc_exit
    unreachable)
  (func $sbrk (type $t4) (param $p0 i32) (result i32)
    block $B0
      local.get $p0
      br_if $B0
      memory.size
      i32.const 16
      i32.shl
      return
    end
    block $B1
      local.get $p0
      i32.const 65535
      i32.and
      br_if $B1
      local.get $p0
      i32.const -1
      i32.le_s
      br_if $B1
      block $B2
        local.get $p0
        i32.const 16
        i32.shr_u
        memory.grow
        local.tee $p0
        i32.const -1
        i32.ne
        br_if $B2
        i32.const 0
        i32.const 48
        i32.store offset=1060080
        i32.const -1
        return
      end
      local.get $p0
      i32.const 16
      i32.shl
      return
    end
    call $abort
    unreachable)
  (func $abort (type $t0)
    unreachable
    unreachable)
  (func $__wasi_environ_get (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    local.get $p1
    call $__imported_wasi_snapshot_preview1_environ_get
    i32.const 65535
    i32.and)
  (func $__wasi_environ_sizes_get (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    local.get $p1
    call $__imported_wasi_snapshot_preview1_environ_sizes_get
    i32.const 65535
    i32.and)
  (func $__wasi_proc_exit (type $t1) (param $p0 i32)
    local.get $p0
    call $__imported_wasi_snapshot_preview1_proc_exit
    unreachable)
  (func $__wasilibc_ensure_environ (type $t0)
    block $B0
      i32.const 0
      i32.load offset=1060084
      i32.const -1
      i32.ne
      br_if $B0
      call $__wasilibc_initialize_environ
    end)
  (func $__wasilibc_initialize_environ (type $t0)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l0
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          local.get $l0
          i32.const 12
          i32.add
          local.get $l0
          i32.const 8
          i32.add
          call $__wasi_environ_sizes_get
          br_if $B2
          block $B3
            local.get $l0
            i32.load offset=12
            local.tee $l1
            br_if $B3
            i32.const 0
            i32.const 1060088
            i32.store offset=1060084
            br $B0
          end
          block $B4
            block $B5
              local.get $l1
              i32.const 1
              i32.add
              local.tee $l2
              local.get $l1
              i32.lt_u
              br_if $B5
              local.get $l0
              i32.load offset=8
              call $malloc
              local.tee $l3
              i32.eqz
              br_if $B5
              local.get $l2
              i32.const 4
              call $calloc
              local.tee $l1
              br_if $B4
              local.get $l3
              call $free
            end
            i32.const 70
            call $_Exit
            unreachable
          end
          local.get $l1
          local.get $l3
          call $__wasi_environ_get
          i32.eqz
          br_if $B1
          local.get $l3
          call $free
          local.get $l1
          call $free
        end
        i32.const 71
        call $_Exit
        unreachable
      end
      i32.const 0
      local.get $l1
      i32.store offset=1060084
    end
    local.get $l0
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $getcwd (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    i32.const 0
    i32.load offset=1059476
    local.set $l2
    block $B0
      block $B1
        local.get $p0
        br_if $B1
        local.get $l2
        call $strdup
        local.tee $p0
        br_if $B0
        i32.const 0
        i32.const 48
        i32.store offset=1060080
        i32.const 0
        return
      end
      block $B2
        local.get $l2
        call $strlen
        i32.const 1
        i32.add
        local.get $p1
        i32.gt_u
        br_if $B2
        local.get $p0
        local.get $l2
        call $strcpy
        return
      end
      i32.const 0
      local.set $p0
      i32.const 0
      i32.const 68
      i32.store offset=1060080
    end
    local.get $p0)
  (func $dummy (type $t0))
  (func $__wasm_call_dtors (type $t0)
    call $dummy
    call $dummy)
  (func $exit (type $t1) (param $p0 i32)
    call $dummy
    call $dummy
    local.get $p0
    call $_Exit
    unreachable)
  (func $getenv (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32)
    call $__wasilibc_ensure_environ
    block $B0
      local.get $p0
      i32.const 61
      call $__strchrnul
      local.get $p0
      i32.sub
      local.tee $l1
      br_if $B0
      i32.const 0
      return
    end
    i32.const 0
    local.set $l2
    block $B1
      local.get $p0
      local.get $l1
      i32.add
      i32.load8_u
      br_if $B1
      i32.const 0
      i32.load offset=1060084
      local.tee $l3
      i32.eqz
      br_if $B1
      local.get $l3
      i32.load
      local.tee $l4
      i32.eqz
      br_if $B1
      local.get $l3
      i32.const 4
      i32.add
      local.set $l3
      block $B2
        loop $L3
          block $B4
            local.get $p0
            local.get $l4
            local.get $l1
            call $strncmp
            br_if $B4
            local.get $l4
            local.get $l1
            i32.add
            local.tee $l4
            i32.load8_u
            i32.const 61
            i32.eq
            br_if $B2
          end
          local.get $l3
          i32.load
          local.set $l4
          local.get $l3
          i32.const 4
          i32.add
          local.set $l3
          local.get $l4
          br_if $L3
          br $B1
        end
      end
      local.get $l4
      i32.const 1
      i32.add
      local.set $l2
    end
    local.get $l2)
  (func $strdup (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32)
    block $B0
      local.get $p0
      call $strlen
      i32.const 1
      i32.add
      local.tee $l1
      call $malloc
      local.tee $l2
      i32.eqz
      br_if $B0
      local.get $l2
      local.get $p0
      local.get $l1
      call $memcpy
      drop
    end
    local.get $l2)
  (func $memmove (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32)
    block $B0
      local.get $p0
      local.get $p1
      i32.eq
      br_if $B0
      block $B1
        local.get $p1
        local.get $p0
        local.get $p2
        i32.add
        local.tee $l3
        i32.sub
        i32.const 0
        local.get $p2
        i32.const 1
        i32.shl
        i32.sub
        i32.gt_u
        br_if $B1
        local.get $p0
        local.get $p1
        local.get $p2
        call $memcpy
        drop
        br $B0
      end
      local.get $p1
      local.get $p0
      i32.xor
      i32.const 3
      i32.and
      local.set $l4
      block $B2
        block $B3
          block $B4
            local.get $p0
            local.get $p1
            i32.ge_u
            br_if $B4
            block $B5
              local.get $l4
              i32.eqz
              br_if $B5
              local.get $p2
              local.set $l4
              local.get $p0
              local.set $l3
              br $B2
            end
            block $B6
              local.get $p0
              i32.const 3
              i32.and
              br_if $B6
              local.get $p2
              local.set $l4
              local.get $p0
              local.set $l3
              br $B3
            end
            local.get $p2
            i32.eqz
            br_if $B0
            local.get $p0
            local.get $p1
            i32.load8_u
            i32.store8
            local.get $p2
            i32.const -1
            i32.add
            local.set $l4
            block $B7
              local.get $p0
              i32.const 1
              i32.add
              local.tee $l3
              i32.const 3
              i32.and
              br_if $B7
              local.get $p1
              i32.const 1
              i32.add
              local.set $p1
              br $B3
            end
            local.get $l4
            i32.eqz
            br_if $B0
            local.get $p0
            local.get $p1
            i32.load8_u offset=1
            i32.store8 offset=1
            local.get $p2
            i32.const -2
            i32.add
            local.set $l4
            block $B8
              local.get $p0
              i32.const 2
              i32.add
              local.tee $l3
              i32.const 3
              i32.and
              br_if $B8
              local.get $p1
              i32.const 2
              i32.add
              local.set $p1
              br $B3
            end
            local.get $l4
            i32.eqz
            br_if $B0
            local.get $p0
            local.get $p1
            i32.load8_u offset=2
            i32.store8 offset=2
            local.get $p2
            i32.const -3
            i32.add
            local.set $l4
            block $B9
              local.get $p0
              i32.const 3
              i32.add
              local.tee $l3
              i32.const 3
              i32.and
              br_if $B9
              local.get $p1
              i32.const 3
              i32.add
              local.set $p1
              br $B3
            end
            local.get $l4
            i32.eqz
            br_if $B0
            local.get $p0
            local.get $p1
            i32.load8_u offset=3
            i32.store8 offset=3
            local.get $p0
            i32.const 4
            i32.add
            local.set $l3
            local.get $p1
            i32.const 4
            i32.add
            local.set $p1
            local.get $p2
            i32.const -4
            i32.add
            local.set $l4
            br $B3
          end
          block $B10
            local.get $l4
            br_if $B10
            block $B11
              local.get $l3
              i32.const 3
              i32.and
              i32.eqz
              br_if $B11
              local.get $p2
              i32.eqz
              br_if $B0
              local.get $p0
              local.get $p2
              i32.const -1
              i32.add
              local.tee $l3
              i32.add
              local.tee $l4
              local.get $p1
              local.get $l3
              i32.add
              i32.load8_u
              i32.store8
              block $B12
                local.get $l4
                i32.const 3
                i32.and
                br_if $B12
                local.get $l3
                local.set $p2
                br $B11
              end
              local.get $l3
              i32.eqz
              br_if $B0
              local.get $p0
              local.get $p2
              i32.const -2
              i32.add
              local.tee $l3
              i32.add
              local.tee $l4
              local.get $p1
              local.get $l3
              i32.add
              i32.load8_u
              i32.store8
              block $B13
                local.get $l4
                i32.const 3
                i32.and
                br_if $B13
                local.get $l3
                local.set $p2
                br $B11
              end
              local.get $l3
              i32.eqz
              br_if $B0
              local.get $p0
              local.get $p2
              i32.const -3
              i32.add
              local.tee $l3
              i32.add
              local.tee $l4
              local.get $p1
              local.get $l3
              i32.add
              i32.load8_u
              i32.store8
              block $B14
                local.get $l4
                i32.const 3
                i32.and
                br_if $B14
                local.get $l3
                local.set $p2
                br $B11
              end
              local.get $l3
              i32.eqz
              br_if $B0
              local.get $p0
              local.get $p2
              i32.const -4
              i32.add
              local.tee $p2
              i32.add
              local.get $p1
              local.get $p2
              i32.add
              i32.load8_u
              i32.store8
            end
            local.get $p2
            i32.const 4
            i32.lt_u
            br_if $B10
            block $B15
              local.get $p2
              i32.const -4
              i32.add
              local.tee $l5
              i32.const 2
              i32.shr_u
              i32.const 1
              i32.add
              i32.const 3
              i32.and
              local.tee $l3
              i32.eqz
              br_if $B15
              local.get $p1
              i32.const -4
              i32.add
              local.set $l4
              local.get $p0
              i32.const -4
              i32.add
              local.set $l6
              loop $L16
                local.get $l6
                local.get $p2
                i32.add
                local.get $l4
                local.get $p2
                i32.add
                i32.load
                i32.store
                local.get $p2
                i32.const -4
                i32.add
                local.set $p2
                local.get $l3
                i32.const -1
                i32.add
                local.tee $l3
                br_if $L16
              end
            end
            local.get $l5
            i32.const 12
            i32.lt_u
            br_if $B10
            local.get $p1
            i32.const -16
            i32.add
            local.set $l6
            local.get $p0
            i32.const -16
            i32.add
            local.set $l5
            loop $L17
              local.get $l5
              local.get $p2
              i32.add
              local.tee $l3
              i32.const 12
              i32.add
              local.get $l6
              local.get $p2
              i32.add
              local.tee $l4
              i32.const 12
              i32.add
              i32.load
              i32.store
              local.get $l3
              i32.const 8
              i32.add
              local.get $l4
              i32.const 8
              i32.add
              i32.load
              i32.store
              local.get $l3
              i32.const 4
              i32.add
              local.get $l4
              i32.const 4
              i32.add
              i32.load
              i32.store
              local.get $l3
              local.get $l4
              i32.load
              i32.store
              local.get $p2
              i32.const -16
              i32.add
              local.tee $p2
              i32.const 3
              i32.gt_u
              br_if $L17
            end
          end
          local.get $p2
          i32.eqz
          br_if $B0
          local.get $p2
          i32.const -1
          i32.add
          local.set $l5
          block $B18
            local.get $p2
            i32.const 3
            i32.and
            local.tee $l3
            i32.eqz
            br_if $B18
            local.get $p1
            i32.const -1
            i32.add
            local.set $l4
            local.get $p0
            i32.const -1
            i32.add
            local.set $l6
            loop $L19
              local.get $l6
              local.get $p2
              i32.add
              local.get $l4
              local.get $p2
              i32.add
              i32.load8_u
              i32.store8
              local.get $p2
              i32.const -1
              i32.add
              local.set $p2
              local.get $l3
              i32.const -1
              i32.add
              local.tee $l3
              br_if $L19
            end
          end
          local.get $l5
          i32.const 3
          i32.lt_u
          br_if $B0
          local.get $p1
          i32.const -4
          i32.add
          local.set $l4
          local.get $p0
          i32.const -4
          i32.add
          local.set $l6
          loop $L20
            local.get $l6
            local.get $p2
            i32.add
            local.tee $p1
            i32.const 3
            i32.add
            local.get $l4
            local.get $p2
            i32.add
            local.tee $l3
            i32.const 3
            i32.add
            i32.load8_u
            i32.store8
            local.get $p1
            i32.const 2
            i32.add
            local.get $l3
            i32.const 2
            i32.add
            i32.load8_u
            i32.store8
            local.get $p1
            i32.const 1
            i32.add
            local.get $l3
            i32.const 1
            i32.add
            i32.load8_u
            i32.store8
            local.get $p1
            local.get $l3
            i32.load8_u
            i32.store8
            local.get $p2
            i32.const -4
            i32.add
            local.tee $p2
            br_if $L20
            br $B0
          end
        end
        local.get $l4
        i32.const 4
        i32.lt_u
        br_if $B2
        block $B21
          local.get $l4
          i32.const -4
          i32.add
          local.tee $l6
          i32.const 2
          i32.shr_u
          i32.const 1
          i32.add
          i32.const 7
          i32.and
          local.tee $p2
          i32.eqz
          br_if $B21
          loop $L22
            local.get $l3
            local.get $p1
            i32.load
            i32.store
            local.get $p1
            i32.const 4
            i32.add
            local.set $p1
            local.get $l3
            i32.const 4
            i32.add
            local.set $l3
            local.get $l4
            i32.const -4
            i32.add
            local.set $l4
            local.get $p2
            i32.const -1
            i32.add
            local.tee $p2
            br_if $L22
          end
        end
        local.get $l6
        i32.const 28
        i32.lt_u
        br_if $B2
        loop $L23
          local.get $l3
          local.get $p1
          i32.load
          i32.store
          local.get $l3
          i32.const 4
          i32.add
          local.get $p1
          i32.const 4
          i32.add
          i32.load
          i32.store
          local.get $l3
          i32.const 8
          i32.add
          local.get $p1
          i32.const 8
          i32.add
          i32.load
          i32.store
          local.get $l3
          i32.const 12
          i32.add
          local.get $p1
          i32.const 12
          i32.add
          i32.load
          i32.store
          local.get $l3
          i32.const 16
          i32.add
          local.get $p1
          i32.const 16
          i32.add
          i32.load
          i32.store
          local.get $l3
          i32.const 20
          i32.add
          local.get $p1
          i32.const 20
          i32.add
          i32.load
          i32.store
          local.get $l3
          i32.const 24
          i32.add
          local.get $p1
          i32.const 24
          i32.add
          i32.load
          i32.store
          local.get $l3
          i32.const 28
          i32.add
          local.get $p1
          i32.const 28
          i32.add
          i32.load
          i32.store
          local.get $l3
          i32.const 32
          i32.add
          local.set $l3
          local.get $p1
          i32.const 32
          i32.add
          local.set $p1
          local.get $l4
          i32.const -32
          i32.add
          local.tee $l4
          i32.const 3
          i32.gt_u
          br_if $L23
        end
      end
      local.get $l4
      i32.eqz
      br_if $B0
      local.get $l4
      i32.const -1
      i32.add
      local.set $l6
      block $B24
        local.get $l4
        i32.const 7
        i32.and
        local.tee $p2
        i32.eqz
        br_if $B24
        loop $L25
          local.get $l3
          local.get $p1
          i32.load8_u
          i32.store8
          local.get $l4
          i32.const -1
          i32.add
          local.set $l4
          local.get $l3
          i32.const 1
          i32.add
          local.set $l3
          local.get $p1
          i32.const 1
          i32.add
          local.set $p1
          local.get $p2
          i32.const -1
          i32.add
          local.tee $p2
          br_if $L25
        end
      end
      local.get $l6
      i32.const 7
      i32.lt_u
      br_if $B0
      loop $L26
        local.get $l3
        local.get $p1
        i32.load8_u
        i32.store8
        local.get $l3
        i32.const 1
        i32.add
        local.get $p1
        i32.const 1
        i32.add
        i32.load8_u
        i32.store8
        local.get $l3
        i32.const 2
        i32.add
        local.get $p1
        i32.const 2
        i32.add
        i32.load8_u
        i32.store8
        local.get $l3
        i32.const 3
        i32.add
        local.get $p1
        i32.const 3
        i32.add
        i32.load8_u
        i32.store8
        local.get $l3
        i32.const 4
        i32.add
        local.get $p1
        i32.const 4
        i32.add
        i32.load8_u
        i32.store8
        local.get $l3
        i32.const 5
        i32.add
        local.get $p1
        i32.const 5
        i32.add
        i32.load8_u
        i32.store8
        local.get $l3
        i32.const 6
        i32.add
        local.get $p1
        i32.const 6
        i32.add
        i32.load8_u
        i32.store8
        local.get $l3
        i32.const 7
        i32.add
        local.get $p1
        i32.const 7
        i32.add
        i32.load8_u
        i32.store8
        local.get $l3
        i32.const 8
        i32.add
        local.set $l3
        local.get $p1
        i32.const 8
        i32.add
        local.set $p1
        local.get $l4
        i32.const -8
        i32.add
        local.tee $l4
        br_if $L26
      end
    end
    local.get $p0)
  (func $memset (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i64)
    block $B0
      local.get $p2
      i32.eqz
      br_if $B0
      local.get $p0
      local.get $p1
      i32.store8
      local.get $p2
      local.get $p0
      i32.add
      local.tee $l3
      i32.const -1
      i32.add
      local.get $p1
      i32.store8
      local.get $p2
      i32.const 3
      i32.lt_u
      br_if $B0
      local.get $p0
      local.get $p1
      i32.store8 offset=2
      local.get $p0
      local.get $p1
      i32.store8 offset=1
      local.get $l3
      i32.const -3
      i32.add
      local.get $p1
      i32.store8
      local.get $l3
      i32.const -2
      i32.add
      local.get $p1
      i32.store8
      local.get $p2
      i32.const 7
      i32.lt_u
      br_if $B0
      local.get $p0
      local.get $p1
      i32.store8 offset=3
      local.get $l3
      i32.const -4
      i32.add
      local.get $p1
      i32.store8
      local.get $p2
      i32.const 9
      i32.lt_u
      br_if $B0
      local.get $p0
      i32.const 0
      local.get $p0
      i32.sub
      i32.const 3
      i32.and
      local.tee $l4
      i32.add
      local.tee $l3
      local.get $p1
      i32.const 255
      i32.and
      i32.const 16843009
      i32.mul
      local.tee $p1
      i32.store
      local.get $l3
      local.get $p2
      local.get $l4
      i32.sub
      i32.const -4
      i32.and
      local.tee $l4
      i32.add
      local.tee $p2
      i32.const -4
      i32.add
      local.get $p1
      i32.store
      local.get $l4
      i32.const 9
      i32.lt_u
      br_if $B0
      local.get $l3
      local.get $p1
      i32.store offset=8
      local.get $l3
      local.get $p1
      i32.store offset=4
      local.get $p2
      i32.const -8
      i32.add
      local.get $p1
      i32.store
      local.get $p2
      i32.const -12
      i32.add
      local.get $p1
      i32.store
      local.get $l4
      i32.const 25
      i32.lt_u
      br_if $B0
      local.get $l3
      local.get $p1
      i32.store offset=24
      local.get $l3
      local.get $p1
      i32.store offset=20
      local.get $l3
      local.get $p1
      i32.store offset=16
      local.get $l3
      local.get $p1
      i32.store offset=12
      local.get $p2
      i32.const -16
      i32.add
      local.get $p1
      i32.store
      local.get $p2
      i32.const -20
      i32.add
      local.get $p1
      i32.store
      local.get $p2
      i32.const -24
      i32.add
      local.get $p1
      i32.store
      local.get $p2
      i32.const -28
      i32.add
      local.get $p1
      i32.store
      local.get $l4
      local.get $l3
      i32.const 4
      i32.and
      i32.const 24
      i32.or
      local.tee $l5
      i32.sub
      local.tee $p2
      i32.const 32
      i32.lt_u
      br_if $B0
      local.get $p1
      i64.extend_i32_u
      i64.const 4294967297
      i64.mul
      local.set $l6
      local.get $l3
      local.get $l5
      i32.add
      local.set $p1
      loop $L1
        local.get $p1
        local.get $l6
        i64.store
        local.get $p1
        i32.const 24
        i32.add
        local.get $l6
        i64.store
        local.get $p1
        i32.const 16
        i32.add
        local.get $l6
        i64.store
        local.get $p1
        i32.const 8
        i32.add
        local.get $l6
        i64.store
        local.get $p1
        i32.const 32
        i32.add
        local.set $p1
        local.get $p2
        i32.const -32
        i32.add
        local.tee $p2
        i32.const 31
        i32.gt_u
        br_if $L1
      end
    end
    local.get $p0)
  (func $strlen (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32)
    local.get $p0
    local.set $l1
    block $B0
      block $B1
        local.get $p0
        i32.const 3
        i32.and
        i32.eqz
        br_if $B1
        local.get $p0
        local.set $l1
        local.get $p0
        i32.load8_u
        i32.eqz
        br_if $B0
        local.get $p0
        i32.const 1
        i32.add
        local.tee $l1
        i32.const 3
        i32.and
        i32.eqz
        br_if $B1
        local.get $l1
        i32.load8_u
        i32.eqz
        br_if $B0
        local.get $p0
        i32.const 2
        i32.add
        local.tee $l1
        i32.const 3
        i32.and
        i32.eqz
        br_if $B1
        local.get $l1
        i32.load8_u
        i32.eqz
        br_if $B0
        local.get $p0
        i32.const 3
        i32.add
        local.tee $l1
        i32.const 3
        i32.and
        i32.eqz
        br_if $B1
        local.get $l1
        i32.load8_u
        i32.eqz
        br_if $B0
        local.get $p0
        i32.const 4
        i32.add
        local.set $l1
      end
      local.get $l1
      i32.const -4
      i32.add
      local.set $l1
      loop $L2
        local.get $l1
        i32.const 4
        i32.add
        local.tee $l1
        i32.load
        local.tee $l2
        i32.const -1
        i32.xor
        local.get $l2
        i32.const -16843009
        i32.add
        i32.and
        i32.const -2139062144
        i32.and
        i32.eqz
        br_if $L2
      end
      local.get $l2
      i32.const 255
      i32.and
      i32.eqz
      br_if $B0
      loop $L3
        local.get $l1
        i32.const 1
        i32.add
        local.tee $l1
        i32.load8_u
        br_if $L3
      end
    end
    local.get $l1
    local.get $p0
    i32.sub)
  (func $__strchrnul (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p1
            i32.const 255
            i32.and
            local.tee $l2
            i32.eqz
            br_if $B3
            local.get $p0
            i32.const 3
            i32.and
            i32.eqz
            br_if $B1
            block $B4
              local.get $p0
              i32.load8_u
              local.tee $l3
              br_if $B4
              local.get $p0
              return
            end
            local.get $l3
            local.get $p1
            i32.const 255
            i32.and
            i32.ne
            br_if $B2
            local.get $p0
            return
          end
          local.get $p0
          local.get $p0
          call $strlen
          i32.add
          return
        end
        block $B5
          local.get $p0
          i32.const 1
          i32.add
          local.tee $l3
          i32.const 3
          i32.and
          br_if $B5
          local.get $l3
          local.set $p0
          br $B1
        end
        local.get $l3
        i32.load8_u
        local.tee $l4
        i32.eqz
        br_if $B0
        local.get $l4
        local.get $p1
        i32.const 255
        i32.and
        i32.eq
        br_if $B0
        block $B6
          local.get $p0
          i32.const 2
          i32.add
          local.tee $l3
          i32.const 3
          i32.and
          br_if $B6
          local.get $l3
          local.set $p0
          br $B1
        end
        local.get $l3
        i32.load8_u
        local.tee $l4
        i32.eqz
        br_if $B0
        local.get $l4
        local.get $p1
        i32.const 255
        i32.and
        i32.eq
        br_if $B0
        block $B7
          local.get $p0
          i32.const 3
          i32.add
          local.tee $l3
          i32.const 3
          i32.and
          br_if $B7
          local.get $l3
          local.set $p0
          br $B1
        end
        local.get $l3
        i32.load8_u
        local.tee $l4
        i32.eqz
        br_if $B0
        local.get $l4
        local.get $p1
        i32.const 255
        i32.and
        i32.eq
        br_if $B0
        local.get $p0
        i32.const 4
        i32.add
        local.set $p0
      end
      block $B8
        local.get $p0
        i32.load
        local.tee $l3
        i32.const -1
        i32.xor
        local.get $l3
        i32.const -16843009
        i32.add
        i32.and
        i32.const -2139062144
        i32.and
        br_if $B8
        local.get $l2
        i32.const 16843009
        i32.mul
        local.set $l2
        loop $L9
          local.get $l3
          local.get $l2
          i32.xor
          local.tee $l3
          i32.const -1
          i32.xor
          local.get $l3
          i32.const -16843009
          i32.add
          i32.and
          i32.const -2139062144
          i32.and
          br_if $B8
          local.get $p0
          i32.const 4
          i32.add
          local.tee $p0
          i32.load
          local.tee $l3
          i32.const -1
          i32.xor
          local.get $l3
          i32.const -16843009
          i32.add
          i32.and
          i32.const -2139062144
          i32.and
          i32.eqz
          br_if $L9
        end
      end
      local.get $p0
      i32.const -1
      i32.add
      local.set $l3
      loop $L10
        local.get $l3
        i32.const 1
        i32.add
        local.tee $l3
        i32.load8_u
        local.tee $p0
        i32.eqz
        br_if $B0
        local.get $p0
        local.get $p1
        i32.const 255
        i32.and
        i32.ne
        br_if $L10
      end
    end
    local.get $l3)
  (func $memcpy (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32)
    block $B0
      block $B1
        local.get $p1
        i32.const 3
        i32.and
        i32.eqz
        br_if $B1
        local.get $p2
        i32.eqz
        br_if $B1
        local.get $p0
        local.get $p1
        i32.load8_u
        i32.store8
        local.get $p2
        i32.const -1
        i32.add
        local.set $l3
        local.get $p0
        i32.const 1
        i32.add
        local.set $l4
        local.get $p1
        i32.const 1
        i32.add
        local.tee $l5
        i32.const 3
        i32.and
        i32.eqz
        br_if $B0
        local.get $l3
        i32.eqz
        br_if $B0
        local.get $p0
        local.get $p1
        i32.load8_u offset=1
        i32.store8 offset=1
        local.get $p2
        i32.const -2
        i32.add
        local.set $l3
        local.get $p0
        i32.const 2
        i32.add
        local.set $l4
        local.get $p1
        i32.const 2
        i32.add
        local.tee $l5
        i32.const 3
        i32.and
        i32.eqz
        br_if $B0
        local.get $l3
        i32.eqz
        br_if $B0
        local.get $p0
        local.get $p1
        i32.load8_u offset=2
        i32.store8 offset=2
        local.get $p2
        i32.const -3
        i32.add
        local.set $l3
        local.get $p0
        i32.const 3
        i32.add
        local.set $l4
        local.get $p1
        i32.const 3
        i32.add
        local.tee $l5
        i32.const 3
        i32.and
        i32.eqz
        br_if $B0
        local.get $l3
        i32.eqz
        br_if $B0
        local.get $p0
        local.get $p1
        i32.load8_u offset=3
        i32.store8 offset=3
        local.get $p2
        i32.const -4
        i32.add
        local.set $l3
        local.get $p0
        i32.const 4
        i32.add
        local.set $l4
        local.get $p1
        i32.const 4
        i32.add
        local.set $l5
        br $B0
      end
      local.get $p2
      local.set $l3
      local.get $p0
      local.set $l4
      local.get $p1
      local.set $l5
    end
    block $B2
      block $B3
        block $B4
          local.get $l4
          i32.const 3
          i32.and
          local.tee $p1
          br_if $B4
          block $B5
            block $B6
              local.get $l3
              i32.const 16
              i32.lt_u
              br_if $B6
              block $B7
                local.get $l3
                i32.const -16
                i32.add
                local.tee $p1
                i32.const 16
                i32.and
                br_if $B7
                local.get $l4
                local.get $l5
                i64.load align=4
                i64.store align=4
                local.get $l4
                local.get $l5
                i64.load offset=8 align=4
                i64.store offset=8 align=4
                local.get $l4
                i32.const 16
                i32.add
                local.set $l4
                local.get $l5
                i32.const 16
                i32.add
                local.set $l5
                local.get $p1
                local.set $l3
              end
              local.get $p1
              i32.const 16
              i32.lt_u
              br_if $B5
              loop $L8
                local.get $l4
                local.get $l5
                i64.load align=4
                i64.store align=4
                local.get $l4
                i32.const 8
                i32.add
                local.get $l5
                i32.const 8
                i32.add
                i64.load align=4
                i64.store align=4
                local.get $l4
                i32.const 16
                i32.add
                local.get $l5
                i32.const 16
                i32.add
                i64.load align=4
                i64.store align=4
                local.get $l4
                i32.const 24
                i32.add
                local.get $l5
                i32.const 24
                i32.add
                i64.load align=4
                i64.store align=4
                local.get $l4
                i32.const 32
                i32.add
                local.set $l4
                local.get $l5
                i32.const 32
                i32.add
                local.set $l5
                local.get $l3
                i32.const -32
                i32.add
                local.tee $l3
                i32.const 15
                i32.gt_u
                br_if $L8
              end
            end
            local.get $l3
            local.set $p1
          end
          block $B9
            local.get $p1
            i32.const 8
            i32.and
            i32.eqz
            br_if $B9
            local.get $l4
            local.get $l5
            i64.load align=4
            i64.store align=4
            local.get $l5
            i32.const 8
            i32.add
            local.set $l5
            local.get $l4
            i32.const 8
            i32.add
            local.set $l4
          end
          block $B10
            local.get $p1
            i32.const 4
            i32.and
            i32.eqz
            br_if $B10
            local.get $l4
            local.get $l5
            i32.load
            i32.store
            local.get $l5
            i32.const 4
            i32.add
            local.set $l5
            local.get $l4
            i32.const 4
            i32.add
            local.set $l4
          end
          block $B11
            local.get $p1
            i32.const 2
            i32.and
            i32.eqz
            br_if $B11
            local.get $l4
            local.get $l5
            i32.load16_u align=1
            i32.store16 align=1
            local.get $l4
            i32.const 2
            i32.add
            local.set $l4
            local.get $l5
            i32.const 2
            i32.add
            local.set $l5
          end
          local.get $p1
          i32.const 1
          i32.and
          br_if $B3
          br $B2
        end
        block $B12
          local.get $l3
          i32.const 32
          i32.lt_u
          br_if $B12
          block $B13
            block $B14
              block $B15
                local.get $p1
                i32.const -1
                i32.add
                br_table $B15 $B14 $B13 $B12
              end
              local.get $l4
              local.get $l5
              i32.load
              local.tee $l6
              i32.store8
              local.get $l4
              local.get $l6
              i32.const 16
              i32.shr_u
              i32.store8 offset=2
              local.get $l4
              local.get $l6
              i32.const 8
              i32.shr_u
              i32.store8 offset=1
              local.get $l3
              i32.const -3
              i32.add
              local.set $l3
              local.get $l4
              i32.const 3
              i32.add
              local.set $l7
              i32.const 0
              local.set $p1
              loop $L16
                local.get $l7
                local.get $p1
                i32.add
                local.tee $l4
                local.get $l5
                local.get $p1
                i32.add
                local.tee $p2
                i32.const 4
                i32.add
                i32.load
                local.tee $l8
                i32.const 8
                i32.shl
                local.get $l6
                i32.const 24
                i32.shr_u
                i32.or
                i32.store
                local.get $l4
                i32.const 4
                i32.add
                local.get $p2
                i32.const 8
                i32.add
                i32.load
                local.tee $l6
                i32.const 8
                i32.shl
                local.get $l8
                i32.const 24
                i32.shr_u
                i32.or
                i32.store
                local.get $l4
                i32.const 8
                i32.add
                local.get $p2
                i32.const 12
                i32.add
                i32.load
                local.tee $l8
                i32.const 8
                i32.shl
                local.get $l6
                i32.const 24
                i32.shr_u
                i32.or
                i32.store
                local.get $l4
                i32.const 12
                i32.add
                local.get $p2
                i32.const 16
                i32.add
                i32.load
                local.tee $l6
                i32.const 8
                i32.shl
                local.get $l8
                i32.const 24
                i32.shr_u
                i32.or
                i32.store
                local.get $p1
                i32.const 16
                i32.add
                local.set $p1
                local.get $l3
                i32.const -16
                i32.add
                local.tee $l3
                i32.const 16
                i32.gt_u
                br_if $L16
              end
              local.get $l7
              local.get $p1
              i32.add
              local.set $l4
              local.get $l5
              local.get $p1
              i32.add
              i32.const 3
              i32.add
              local.set $l5
              br $B12
            end
            local.get $l4
            local.get $l5
            i32.load
            local.tee $l6
            i32.store16 align=1
            local.get $l3
            i32.const -2
            i32.add
            local.set $l3
            local.get $l4
            i32.const 2
            i32.add
            local.set $l7
            i32.const 0
            local.set $p1
            loop $L17
              local.get $l7
              local.get $p1
              i32.add
              local.tee $l4
              local.get $l5
              local.get $p1
              i32.add
              local.tee $p2
              i32.const 4
              i32.add
              i32.load
              local.tee $l8
              i32.const 16
              i32.shl
              local.get $l6
              i32.const 16
              i32.shr_u
              i32.or
              i32.store
              local.get $l4
              i32.const 4
              i32.add
              local.get $p2
              i32.const 8
              i32.add
              i32.load
              local.tee $l6
              i32.const 16
              i32.shl
              local.get $l8
              i32.const 16
              i32.shr_u
              i32.or
              i32.store
              local.get $l4
              i32.const 8
              i32.add
              local.get $p2
              i32.const 12
              i32.add
              i32.load
              local.tee $l8
              i32.const 16
              i32.shl
              local.get $l6
              i32.const 16
              i32.shr_u
              i32.or
              i32.store
              local.get $l4
              i32.const 12
              i32.add
              local.get $p2
              i32.const 16
              i32.add
              i32.load
              local.tee $l6
              i32.const 16
              i32.shl
              local.get $l8
              i32.const 16
              i32.shr_u
              i32.or
              i32.store
              local.get $p1
              i32.const 16
              i32.add
              local.set $p1
              local.get $l3
              i32.const -16
              i32.add
              local.tee $l3
              i32.const 17
              i32.gt_u
              br_if $L17
            end
            local.get $l7
            local.get $p1
            i32.add
            local.set $l4
            local.get $l5
            local.get $p1
            i32.add
            i32.const 2
            i32.add
            local.set $l5
            br $B12
          end
          local.get $l4
          local.get $l5
          i32.load
          local.tee $l6
          i32.store8
          local.get $l3
          i32.const -1
          i32.add
          local.set $l3
          local.get $l4
          i32.const 1
          i32.add
          local.set $l7
          i32.const 0
          local.set $p1
          loop $L18
            local.get $l7
            local.get $p1
            i32.add
            local.tee $l4
            local.get $l5
            local.get $p1
            i32.add
            local.tee $p2
            i32.const 4
            i32.add
            i32.load
            local.tee $l8
            i32.const 24
            i32.shl
            local.get $l6
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            local.get $l4
            i32.const 4
            i32.add
            local.get $p2
            i32.const 8
            i32.add
            i32.load
            local.tee $l6
            i32.const 24
            i32.shl
            local.get $l8
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            local.get $l4
            i32.const 8
            i32.add
            local.get $p2
            i32.const 12
            i32.add
            i32.load
            local.tee $l8
            i32.const 24
            i32.shl
            local.get $l6
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            local.get $l4
            i32.const 12
            i32.add
            local.get $p2
            i32.const 16
            i32.add
            i32.load
            local.tee $l6
            i32.const 24
            i32.shl
            local.get $l8
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            local.get $p1
            i32.const 16
            i32.add
            local.set $p1
            local.get $l3
            i32.const -16
            i32.add
            local.tee $l3
            i32.const 18
            i32.gt_u
            br_if $L18
          end
          local.get $l7
          local.get $p1
          i32.add
          local.set $l4
          local.get $l5
          local.get $p1
          i32.add
          i32.const 1
          i32.add
          local.set $l5
        end
        block $B19
          local.get $l3
          i32.const 16
          i32.and
          i32.eqz
          br_if $B19
          local.get $l4
          local.get $l5
          i32.load8_u
          i32.store8
          local.get $l4
          local.get $l5
          i32.load offset=1 align=1
          i32.store offset=1 align=1
          local.get $l4
          local.get $l5
          i64.load offset=5 align=1
          i64.store offset=5 align=1
          local.get $l4
          local.get $l5
          i32.load16_u offset=13 align=1
          i32.store16 offset=13 align=1
          local.get $l4
          local.get $l5
          i32.load8_u offset=15
          i32.store8 offset=15
          local.get $l4
          i32.const 16
          i32.add
          local.set $l4
          local.get $l5
          i32.const 16
          i32.add
          local.set $l5
        end
        block $B20
          local.get $l3
          i32.const 8
          i32.and
          i32.eqz
          br_if $B20
          local.get $l4
          local.get $l5
          i64.load align=1
          i64.store align=1
          local.get $l4
          i32.const 8
          i32.add
          local.set $l4
          local.get $l5
          i32.const 8
          i32.add
          local.set $l5
        end
        block $B21
          local.get $l3
          i32.const 4
          i32.and
          i32.eqz
          br_if $B21
          local.get $l4
          local.get $l5
          i32.load align=1
          i32.store align=1
          local.get $l4
          i32.const 4
          i32.add
          local.set $l4
          local.get $l5
          i32.const 4
          i32.add
          local.set $l5
        end
        block $B22
          local.get $l3
          i32.const 2
          i32.and
          i32.eqz
          br_if $B22
          local.get $l4
          local.get $l5
          i32.load16_u align=1
          i32.store16 align=1
          local.get $l4
          i32.const 2
          i32.add
          local.set $l4
          local.get $l5
          i32.const 2
          i32.add
          local.set $l5
        end
        local.get $l3
        i32.const 1
        i32.and
        i32.eqz
        br_if $B2
      end
      local.get $l4
      local.get $l5
      i32.load8_u
      i32.store8
    end
    local.get $p0)
  (func $strncmp (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32)
    block $B0
      local.get $p2
      br_if $B0
      i32.const 0
      return
    end
    i32.const 0
    local.set $l3
    block $B1
      local.get $p0
      i32.load8_u
      local.tee $l4
      i32.eqz
      br_if $B1
      local.get $p0
      i32.const 1
      i32.add
      local.set $p0
      local.get $p2
      i32.const -1
      i32.add
      local.set $p2
      loop $L2
        block $B3
          local.get $p1
          i32.load8_u
          local.tee $l5
          br_if $B3
          local.get $l4
          local.set $l3
          br $B1
        end
        block $B4
          local.get $p2
          br_if $B4
          local.get $l4
          local.set $l3
          br $B1
        end
        block $B5
          local.get $l4
          i32.const 255
          i32.and
          local.get $l5
          i32.eq
          br_if $B5
          local.get $l4
          local.set $l3
          br $B1
        end
        local.get $p2
        i32.const -1
        i32.add
        local.set $p2
        local.get $p1
        i32.const 1
        i32.add
        local.set $p1
        local.get $p0
        i32.load8_u
        local.set $l4
        local.get $p0
        i32.const 1
        i32.add
        local.set $p0
        local.get $l4
        br_if $L2
      end
    end
    local.get $l3
    i32.const 255
    i32.and
    local.get $p1
    i32.load8_u
    i32.sub)
  (func $__stpcpy (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32)
    block $B0
      block $B1
        block $B2
          local.get $p1
          local.get $p0
          i32.xor
          i32.const 3
          i32.and
          i32.eqz
          br_if $B2
          local.get $p0
          local.set $l2
          br $B1
        end
        block $B3
          block $B4
            local.get $p1
            i32.const 3
            i32.and
            br_if $B4
            local.get $p0
            local.set $l2
            br $B3
          end
          local.get $p0
          local.get $p1
          i32.load8_u
          local.tee $l2
          i32.store8
          block $B5
            local.get $l2
            br_if $B5
            local.get $p0
            return
          end
          local.get $p0
          i32.const 1
          i32.add
          local.set $l2
          block $B6
            local.get $p1
            i32.const 1
            i32.add
            local.tee $l3
            i32.const 3
            i32.and
            br_if $B6
            local.get $l3
            local.set $p1
            br $B3
          end
          local.get $l2
          local.get $l3
          i32.load8_u
          local.tee $l3
          i32.store8
          local.get $l3
          i32.eqz
          br_if $B0
          local.get $p0
          i32.const 2
          i32.add
          local.set $l2
          block $B7
            local.get $p1
            i32.const 2
            i32.add
            local.tee $l3
            i32.const 3
            i32.and
            br_if $B7
            local.get $l3
            local.set $p1
            br $B3
          end
          local.get $l2
          local.get $l3
          i32.load8_u
          local.tee $l3
          i32.store8
          local.get $l3
          i32.eqz
          br_if $B0
          local.get $p0
          i32.const 3
          i32.add
          local.set $l2
          block $B8
            local.get $p1
            i32.const 3
            i32.add
            local.tee $l3
            i32.const 3
            i32.and
            br_if $B8
            local.get $l3
            local.set $p1
            br $B3
          end
          local.get $l2
          local.get $l3
          i32.load8_u
          local.tee $l3
          i32.store8
          local.get $l3
          i32.eqz
          br_if $B0
          local.get $p0
          i32.const 4
          i32.add
          local.set $l2
          local.get $p1
          i32.const 4
          i32.add
          local.set $p1
        end
        local.get $p1
        i32.load
        local.tee $p0
        i32.const -1
        i32.xor
        local.get $p0
        i32.const -16843009
        i32.add
        i32.and
        i32.const -2139062144
        i32.and
        br_if $B1
        loop $L9
          local.get $l2
          local.get $p0
          i32.store
          local.get $l2
          i32.const 4
          i32.add
          local.set $l2
          local.get $p1
          i32.const 4
          i32.add
          local.tee $p1
          i32.load
          local.tee $p0
          i32.const -1
          i32.xor
          local.get $p0
          i32.const -16843009
          i32.add
          i32.and
          i32.const -2139062144
          i32.and
          i32.eqz
          br_if $L9
        end
      end
      local.get $l2
      local.get $p1
      i32.load8_u
      local.tee $p0
      i32.store8
      local.get $p0
      i32.eqz
      br_if $B0
      local.get $p1
      i32.const 1
      i32.add
      local.set $p1
      loop $L10
        local.get $l2
        i32.const 1
        i32.add
        local.tee $l2
        local.get $p1
        i32.load8_u
        local.tee $p0
        i32.store8
        local.get $p1
        i32.const 1
        i32.add
        local.set $p1
        local.get $p0
        br_if $L10
      end
    end
    local.get $l2)
  (func $strcpy (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    local.get $p1
    call $__stpcpy
    drop
    local.get $p0)
  (func $strerror (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32)
    block $B0
      i32.const 0
      i32.load offset=1060116
      local.tee $l1
      br_if $B0
      i32.const 1060092
      local.set $l1
      i32.const 0
      i32.const 1060092
      i32.store offset=1060116
    end
    i32.const 0
    local.get $p0
    local.get $p0
    i32.const 76
    i32.gt_u
    select
    i32.const 1
    i32.shl
    i32.const 1055152
    i32.add
    i32.load16_u
    i32.const 1053590
    i32.add
    local.get $l1
    i32.load offset=20
    call $__lctrans)
  (func $strerror_r (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32)
    block $B0
      block $B1
        local.get $p0
        call $strerror
        local.tee $p0
        call $strlen
        local.tee $l3
        local.get $p2
        i32.lt_u
        br_if $B1
        i32.const 68
        local.set $l3
        local.get $p2
        i32.eqz
        br_if $B0
        local.get $p1
        local.get $p0
        local.get $p2
        i32.const -1
        i32.add
        local.tee $p2
        call $memcpy
        local.get $p2
        i32.add
        i32.const 0
        i32.store8
        i32.const 68
        return
      end
      local.get $p1
      local.get $p0
      local.get $l3
      i32.const 1
      i32.add
      call $memcpy
      drop
      i32.const 0
      local.set $l3
    end
    local.get $l3)
  (func $dummy.1 (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0)
  (func $__lctrans (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    local.get $p1
    call $dummy.1)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h172715cbc817b0a1E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p0
    i32.load
    local.tee $p0
    i32.const 8
    i32.add
    i32.load
    local.set $l3
    local.get $p0
    i32.load
    local.set $p0
    local.get $l2
    local.get $p1
    call $_ZN4core3fmt9Formatter10debug_list17hec2a4885c09cdb02E
    block $B0
      local.get $l3
      i32.eqz
      br_if $B0
      loop $L1
        local.get $l2
        local.get $p0
        i32.store offset=12
        local.get $l2
        local.get $l2
        i32.const 12
        i32.add
        i32.const 1055308
        call $_ZN4core3fmt8builders8DebugSet5entry17h0fae2f4ef74004beE
        drop
        local.get $p0
        i32.const 1
        i32.add
        local.set $p0
        local.get $l3
        i32.const -1
        i32.add
        local.tee $l3
        br_if $L1
      end
    end
    local.get $l2
    call $_ZN4core3fmt8builders9DebugList6finish17h3099dece06213f22E
    local.set $p0
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h65a600520d4f6149E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.set $p0
    block $B0
      local.get $p1
      call $_ZN4core3fmt9Formatter15debug_lower_hex17h5784f1a3a7e69120E
      br_if $B0
      block $B1
        local.get $p1
        call $_ZN4core3fmt9Formatter15debug_upper_hex17h79028864c05f503cE
        br_if $B1
        local.get $p0
        local.get $p1
        call $_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$3fmt17h813a35a9627bd2a0E
        return
      end
      local.get $p0
      local.get $p1
      call $_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i32$GT$3fmt17h9146f2224828cde5E
      return
    end
    local.get $p0
    local.get $p1
    call $_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i32$GT$3fmt17hb8089c13c9c3b945E)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hd7d754d44c265e2fE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.set $p0
    block $B0
      local.get $p1
      call $_ZN4core3fmt9Formatter15debug_lower_hex17h5784f1a3a7e69120E
      br_if $B0
      block $B1
        local.get $p1
        call $_ZN4core3fmt9Formatter15debug_upper_hex17h79028864c05f503cE
        br_if $B1
        local.get $p0
        local.get $p1
        call $_ZN4core3fmt3num3imp51_$LT$impl$u20$core..fmt..Display$u20$for$u20$u8$GT$3fmt17h7776461bbca59d11E
        return
      end
      local.get $p0
      local.get $p1
      call $_ZN4core3fmt3num52_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i8$GT$3fmt17h9c814972bb8d4cf9E
      return
    end
    local.get $p0
    local.get $p1
    call $_ZN4core3fmt3num52_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i8$GT$3fmt17hac9e1b1b7f8c891dE)
  (func $_ZN4core10intrinsics17const_eval_select17heedb1790952cf4d6E (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core3ops8function6FnOnce9call_once17h909801d5b012f867E
    unreachable)
  (func $_ZN4core3ops8function6FnOnce9call_once17h909801d5b012f867E (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $_ZN5alloc5alloc18handle_alloc_error8rt_error17hd213496ee462765aE
    unreachable)
  (func $_ZN5alloc5alloc18handle_alloc_error8rt_error17hd213496ee462765aE (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $__rust_alloc_error_handler
    unreachable)
  (func $_ZN4core3ptr27drop_in_place$LT$$RF$u8$GT$17h5c92c0693187df84E (type $t1) (param $p0 i32))
  (func $_ZN5alloc7raw_vec11finish_grow17h019f4386be7579ddE (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32)
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              block $B5
                block $B6
                  local.get $p2
                  i32.eqz
                  br_if $B6
                  i32.const 1
                  local.set $l4
                  local.get $p1
                  i32.const 0
                  i32.lt_s
                  br_if $B5
                  local.get $p3
                  i32.load offset=8
                  i32.eqz
                  br_if $B3
                  local.get $p3
                  i32.load offset=4
                  local.tee $l5
                  br_if $B4
                  local.get $p1
                  br_if $B2
                  local.get $p2
                  local.set $p3
                  br $B1
                end
                local.get $p0
                local.get $p1
                i32.store offset=4
                i32.const 1
                local.set $l4
              end
              i32.const 0
              local.set $p1
              br $B0
            end
            local.get $p3
            i32.load
            local.get $l5
            local.get $p2
            local.get $p1
            call $__rust_realloc
            local.set $p3
            br $B1
          end
          local.get $p1
          br_if $B2
          local.get $p2
          local.set $p3
          br $B1
        end
        local.get $p1
        local.get $p2
        call $__rust_alloc
        local.set $p3
      end
      block $B7
        local.get $p3
        i32.eqz
        br_if $B7
        local.get $p0
        local.get $p3
        i32.store offset=4
        i32.const 0
        local.set $l4
        br $B0
      end
      local.get $p0
      local.get $p1
      i32.store offset=4
      local.get $p2
      local.set $p1
    end
    local.get $p0
    local.get $l4
    i32.store
    local.get $p0
    i32.const 8
    i32.add
    local.get $p1
    i32.store)
  (func $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core10intrinsics17const_eval_select17heedb1790952cf4d6E
    unreachable)
  (func $_ZN5alloc7raw_vec17capacity_overflow17h854a19520cb09142E (type $t0)
    (local $l0 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l0
    global.set $__stack_pointer
    local.get $l0
    i32.const 28
    i32.add
    i32.const 0
    i32.store
    local.get $l0
    i32.const 1055324
    i32.store offset=24
    local.get $l0
    i64.const 1
    i64.store offset=12 align=4
    local.get $l0
    i32.const 1055412
    i32.store offset=8
    local.get $l0
    i32.const 8
    i32.add
    i32.const 1055420
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$16reserve_for_push17h20dd89784b97e15eE (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      local.get $p1
      i32.const 1
      i32.add
      local.tee $l3
      local.get $p1
      i32.lt_u
      br_if $B0
      local.get $p0
      i32.const 4
      i32.add
      i32.load
      local.tee $l4
      i32.const 1
      i32.shl
      local.tee $p1
      local.get $l3
      local.get $p1
      local.get $l3
      i32.gt_u
      select
      local.tee $p1
      i32.const 8
      local.get $p1
      i32.const 8
      i32.gt_u
      select
      local.set $p1
      block $B1
        block $B2
          local.get $l4
          br_if $B2
          i32.const 0
          local.set $l3
          br $B1
        end
        local.get $l2
        local.get $l4
        i32.store offset=20
        local.get $l2
        local.get $p0
        i32.load
        i32.store offset=16
        i32.const 1
        local.set $l3
      end
      local.get $l2
      local.get $l3
      i32.store offset=24
      local.get $l2
      local.get $p1
      i32.const 1
      local.get $l2
      i32.const 16
      i32.add
      call $_ZN5alloc7raw_vec11finish_grow17h019f4386be7579ddE
      block $B3
        local.get $l2
        i32.load
        i32.eqz
        br_if $B3
        local.get $l2
        i32.const 8
        i32.add
        i32.load
        local.tee $p0
        i32.eqz
        br_if $B0
        local.get $l2
        i32.load offset=4
        local.get $p0
        call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
        unreachable
      end
      local.get $l2
      i32.load offset=4
      local.set $l3
      local.get $p0
      i32.const 4
      i32.add
      local.get $p1
      i32.store
      local.get $p0
      local.get $l3
      i32.store
      local.get $l2
      i32.const 32
      i32.add
      global.set $__stack_pointer
      return
    end
    call $_ZN5alloc7raw_vec17capacity_overflow17h854a19520cb09142E
    unreachable)
  (func $__rg_oom (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $rust_oom
    unreachable)
  (func $_ZN72_$LT$$RF$str$u20$as$u20$alloc..ffi..c_str..CString..new..SpecNewImpl$GT$13spec_new_impl17h2c1a395078d3e4cdE (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          local.get $p2
          i32.const 1
          i32.add
          local.tee $l4
          local.get $p2
          i32.lt_u
          br_if $B2
          local.get $l4
          i32.const -1
          i32.le_s
          br_if $B1
          local.get $l4
          i32.const 1
          call $__rust_alloc
          local.tee $l5
          i32.eqz
          br_if $B0
          local.get $l5
          local.get $p1
          local.get $p2
          call $memcpy
          local.set $l6
          block $B3
            block $B4
              local.get $p2
              i32.const 8
              i32.lt_u
              br_if $B4
              local.get $l3
              i32.const 8
              i32.add
              i32.const 0
              local.get $p1
              local.get $p2
              call $_ZN4core5slice6memchr19memchr_general_case17hb03e751cfda9b451E
              local.get $l3
              i32.load offset=12
              local.set $l7
              local.get $l3
              i32.load offset=8
              local.set $l5
              br $B3
            end
            block $B5
              local.get $p2
              br_if $B5
              i32.const 0
              local.set $l7
              i32.const 0
              local.set $l5
              br $B3
            end
            block $B6
              block $B7
                local.get $p1
                i32.load8_u
                br_if $B7
                i32.const 0
                local.set $l8
                br $B6
              end
              i32.const 1
              local.set $l8
              i32.const 0
              local.set $l5
              block $B8
                local.get $p2
                i32.const 1
                i32.ne
                br_if $B8
                local.get $p2
                local.set $l7
                br $B3
              end
              local.get $p1
              i32.load8_u offset=1
              i32.eqz
              br_if $B6
              i32.const 2
              local.set $l8
              block $B9
                local.get $p2
                i32.const 2
                i32.ne
                br_if $B9
                local.get $p2
                local.set $l7
                br $B3
              end
              local.get $p1
              i32.load8_u offset=2
              i32.eqz
              br_if $B6
              i32.const 3
              local.set $l8
              block $B10
                local.get $p2
                i32.const 3
                i32.ne
                br_if $B10
                local.get $p2
                local.set $l7
                br $B3
              end
              local.get $p1
              i32.load8_u offset=3
              i32.eqz
              br_if $B6
              i32.const 4
              local.set $l8
              block $B11
                local.get $p2
                i32.const 4
                i32.ne
                br_if $B11
                local.get $p2
                local.set $l7
                br $B3
              end
              local.get $p1
              i32.load8_u offset=4
              i32.eqz
              br_if $B6
              i32.const 5
              local.set $l8
              block $B12
                local.get $p2
                i32.const 5
                i32.ne
                br_if $B12
                local.get $p2
                local.set $l7
                br $B3
              end
              local.get $p1
              i32.load8_u offset=5
              i32.eqz
              br_if $B6
              i32.const 6
              local.set $l8
              block $B13
                local.get $p2
                i32.const 6
                i32.ne
                br_if $B13
                local.get $p2
                local.set $l7
                br $B3
              end
              local.get $p2
              local.set $l7
              local.get $p1
              i32.load8_u offset=6
              br_if $B3
            end
            i32.const 1
            local.set $l5
            local.get $l8
            local.set $l7
          end
          block $B14
            block $B15
              local.get $l5
              br_if $B15
              local.get $l3
              local.get $p2
              i32.store offset=24
              local.get $l3
              local.get $l4
              i32.store offset=20
              local.get $l3
              local.get $l6
              i32.store offset=16
              local.get $l3
              local.get $l3
              i32.const 16
              i32.add
              call $_ZN5alloc3ffi5c_str7CString19_from_vec_unchecked17hdb3275c8880a87afE
              local.get $p0
              local.get $l3
              i64.load
              i64.store offset=4 align=4
              i32.const 0
              local.set $p2
              br $B14
            end
            local.get $p0
            i32.const 16
            i32.add
            local.get $p2
            i32.store
            local.get $p0
            i32.const 12
            i32.add
            local.get $l4
            i32.store
            local.get $p0
            i32.const 8
            i32.add
            local.get $l6
            i32.store
            local.get $p0
            local.get $l7
            i32.store offset=4
            i32.const 1
            local.set $p2
          end
          local.get $p0
          local.get $p2
          i32.store
          local.get $l3
          i32.const 32
          i32.add
          global.set $__stack_pointer
          return
        end
        i32.const 1055324
        i32.const 43
        i32.const 1055468
        call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
        unreachable
      end
      call $_ZN5alloc7raw_vec17capacity_overflow17h854a19520cb09142E
      unreachable
    end
    local.get $l4
    i32.const 1
    call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
    unreachable)
  (func $_ZN5alloc3ffi5c_str7CString19_from_vec_unchecked17hdb3275c8880a87afE (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              block $B5
                local.get $p1
                i32.const 4
                i32.add
                i32.load
                local.tee $l3
                local.get $p1
                i32.load offset=8
                local.tee $l4
                i32.ne
                br_if $B5
                local.get $l4
                i32.const 1
                i32.add
                local.tee $l3
                local.get $l4
                i32.lt_u
                br_if $B1
                block $B6
                  block $B7
                    local.get $l4
                    br_if $B7
                    i32.const 0
                    local.set $l5
                    br $B6
                  end
                  local.get $l2
                  local.get $l4
                  i32.store offset=20
                  local.get $l2
                  local.get $p1
                  i32.load
                  i32.store offset=16
                  i32.const 1
                  local.set $l5
                end
                local.get $l2
                local.get $l5
                i32.store offset=24
                local.get $l2
                local.get $l3
                i32.const 1
                local.get $l2
                i32.const 16
                i32.add
                call $_ZN5alloc7raw_vec11finish_grow17h019f4386be7579ddE
                local.get $l2
                i32.load
                br_if $B4
                local.get $l2
                i32.load offset=4
                local.set $l5
                local.get $p1
                i32.const 4
                i32.add
                local.get $l3
                i32.store
                local.get $p1
                local.get $l5
                i32.store
              end
              block $B8
                local.get $l4
                local.get $l3
                i32.ne
                br_if $B8
                local.get $p1
                local.get $l4
                call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$16reserve_for_push17h20dd89784b97e15eE
                local.get $p1
                i32.const 4
                i32.add
                i32.load
                local.set $l3
                local.get $p1
                i32.load offset=8
                local.set $l4
              end
              local.get $p1
              local.get $l4
              i32.const 1
              i32.add
              local.tee $l5
              i32.store offset=8
              local.get $p1
              i32.load
              local.tee $p1
              local.get $l4
              i32.add
              i32.const 0
              i32.store8
              local.get $l3
              local.get $l5
              i32.gt_u
              br_if $B3
              local.get $p1
              local.set $l4
              br $B2
            end
            local.get $l2
            i32.const 8
            i32.add
            i32.load
            local.tee $p1
            i32.eqz
            br_if $B1
            local.get $l2
            i32.load offset=4
            local.get $p1
            call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
            unreachable
          end
          block $B9
            local.get $l5
            br_if $B9
            i32.const 1
            local.set $l4
            local.get $p1
            local.get $l3
            i32.const 1
            call $__rust_dealloc
            br $B2
          end
          local.get $p1
          local.get $l3
          i32.const 1
          local.get $l5
          call $__rust_realloc
          local.tee $l4
          i32.eqz
          br_if $B0
        end
        local.get $p0
        local.get $l5
        i32.store offset=4
        local.get $p0
        local.get $l4
        i32.store
        local.get $l2
        i32.const 32
        i32.add
        global.set $__stack_pointer
        return
      end
      call $_ZN5alloc7raw_vec17capacity_overflow17h854a19520cb09142E
      unreachable
    end
    local.get $l5
    i32.const 1
    call $_ZN5alloc5alloc18handle_alloc_error17h5e99240e3ddcbfa5E
    unreachable)
  (func $_ZN64_$LT$alloc..ffi..c_str..NulError$u20$as$u20$core..fmt..Debug$GT$3fmt17h93542ac89de10ef2E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p1
    i32.const 1055484
    i32.const 8
    call $_ZN4core3fmt9Formatter11debug_tuple17h75af657b8f60803eE
    local.get $l2
    local.get $p0
    i32.store offset=12
    local.get $l2
    local.get $l2
    i32.const 12
    i32.add
    i32.const 1055492
    call $_ZN4core3fmt8builders10DebugTuple5field17h6c59533708c678f2E
    drop
    local.get $l2
    local.get $p0
    i32.const 4
    i32.add
    i32.store offset=12
    local.get $l2
    local.get $l2
    i32.const 12
    i32.add
    i32.const 1055508
    call $_ZN4core3fmt8builders10DebugTuple5field17h6c59533708c678f2E
    drop
    local.get $l2
    call $_ZN4core3fmt8builders10DebugTuple6finish17h86934b71974f411eE
    local.set $p0
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core3ops8function6FnOnce9call_once17h017bd921d8fc3485E (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core5slice5index29slice_start_index_len_fail_rt17hf65d6e6ac3e92963E
    unreachable)
  (func $_ZN4core5slice5index29slice_start_index_len_fail_rt17hf65d6e6ac3e92963E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p1
    i32.store offset=4
    local.get $l2
    local.get $p0
    i32.store
    local.get $l2
    i32.const 28
    i32.add
    i32.const 2
    i32.store
    local.get $l2
    i32.const 44
    i32.add
    i32.const 11
    i32.store
    local.get $l2
    i64.const 2
    i64.store offset=12 align=4
    local.get $l2
    i32.const 1056272
    i32.store offset=8
    local.get $l2
    i32.const 11
    i32.store offset=36
    local.get $l2
    local.get $l2
    i32.const 32
    i32.add
    i32.store offset=24
    local.get $l2
    local.get $l2
    i32.const 4
    i32.add
    i32.store offset=40
    local.get $l2
    local.get $l2
    i32.store offset=32
    local.get $l2
    i32.const 8
    i32.add
    i32.const 1056320
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $_ZN4core3ops8function6FnOnce9call_once17h4d3e4db7bb7cb804E (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core5slice5index27slice_end_index_len_fail_rt17hdfef93bea5b444e3E
    unreachable)
  (func $_ZN4core5slice5index27slice_end_index_len_fail_rt17hdfef93bea5b444e3E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p1
    i32.store offset=4
    local.get $l2
    local.get $p0
    i32.store
    local.get $l2
    i32.const 28
    i32.add
    i32.const 2
    i32.store
    local.get $l2
    i32.const 44
    i32.add
    i32.const 11
    i32.store
    local.get $l2
    i64.const 2
    i64.store offset=12 align=4
    local.get $l2
    i32.const 1056352
    i32.store offset=8
    local.get $l2
    i32.const 11
    i32.store offset=36
    local.get $l2
    local.get $l2
    i32.const 32
    i32.add
    i32.store offset=24
    local.get $l2
    local.get $l2
    i32.const 4
    i32.add
    i32.store offset=40
    local.get $l2
    local.get $l2
    i32.store offset=32
    local.get $l2
    i32.const 8
    i32.add
    i32.const 1056368
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $_ZN4core3ops8function6FnOnce9call_once17hca35ec0ede346bb1E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    local.get $p0
    local.get $p1
    local.get $p2
    local.get $p3
    call $_ZN4core3str19slice_error_fail_rt17hfb973de7f8cfb62fE
    unreachable)
  (func $_ZN4core3str19slice_error_fail_rt17hfb973de7f8cfb62fE (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32)
    global.get $__stack_pointer
    i32.const 112
    i32.sub
    local.tee $l4
    global.set $__stack_pointer
    local.get $l4
    local.get $p3
    i32.store offset=12
    local.get $l4
    local.get $p2
    i32.store offset=8
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              block $B5
                block $B6
                  block $B7
                    local.get $p1
                    i32.const 257
                    i32.lt_u
                    br_if $B7
                    i32.const 256
                    local.set $l5
                    block $B8
                      local.get $p0
                      i32.load8_s offset=256
                      i32.const -65
                      i32.gt_s
                      br_if $B8
                      i32.const 255
                      local.set $l5
                      local.get $p0
                      i32.load8_s offset=255
                      i32.const -65
                      i32.gt_s
                      br_if $B8
                      i32.const 254
                      local.set $l5
                      local.get $p0
                      i32.load8_s offset=254
                      i32.const -65
                      i32.gt_s
                      br_if $B8
                      i32.const 253
                      local.set $l5
                    end
                    local.get $l5
                    local.get $p1
                    i32.lt_u
                    br_if $B6
                    local.get $l5
                    local.get $p1
                    i32.ne
                    br_if $B4
                  end
                  local.get $l4
                  local.get $p1
                  i32.store offset=20
                  local.get $l4
                  local.get $p0
                  i32.store offset=16
                  i32.const 0
                  local.set $l5
                  i32.const 1055524
                  local.set $l6
                  br $B5
                end
                local.get $l4
                local.get $l5
                i32.store offset=20
                local.get $l4
                local.get $p0
                i32.store offset=16
                i32.const 5
                local.set $l5
                i32.const 1056735
                local.set $l6
              end
              local.get $l4
              local.get $l5
              i32.store offset=28
              local.get $l4
              local.get $l6
              i32.store offset=24
              local.get $p2
              local.get $p1
              i32.gt_u
              local.tee $l5
              br_if $B3
              local.get $p3
              local.get $p1
              i32.gt_u
              br_if $B3
              block $B9
                local.get $p2
                local.get $p3
                i32.gt_u
                br_if $B9
                block $B10
                  block $B11
                    local.get $p2
                    i32.eqz
                    br_if $B11
                    block $B12
                      local.get $p2
                      local.get $p1
                      i32.lt_u
                      br_if $B12
                      local.get $p1
                      local.get $p2
                      i32.eq
                      br_if $B11
                      br $B10
                    end
                    local.get $p0
                    local.get $p2
                    i32.add
                    i32.load8_s
                    i32.const -64
                    i32.lt_s
                    br_if $B10
                  end
                  local.get $p3
                  local.set $p2
                end
                local.get $l4
                local.get $p2
                i32.store offset=32
                local.get $p1
                local.set $p3
                block $B13
                  local.get $p2
                  local.get $p1
                  i32.ge_u
                  br_if $B13
                  local.get $p2
                  i32.const 1
                  i32.add
                  local.tee $l5
                  i32.const 0
                  local.get $p2
                  i32.const -3
                  i32.add
                  local.tee $p3
                  local.get $p3
                  local.get $p2
                  i32.gt_u
                  select
                  local.tee $p3
                  i32.lt_u
                  br_if $B2
                  block $B14
                    local.get $p3
                    local.get $l5
                    i32.eq
                    br_if $B14
                    local.get $p0
                    local.get $l5
                    i32.add
                    local.get $p0
                    local.get $p3
                    i32.add
                    local.tee $l7
                    i32.sub
                    local.set $l5
                    block $B15
                      local.get $p0
                      local.get $p2
                      i32.add
                      local.tee $l8
                      i32.load8_s
                      i32.const -65
                      i32.le_s
                      br_if $B15
                      local.get $l5
                      i32.const -1
                      i32.add
                      local.set $l6
                      br $B14
                    end
                    local.get $p3
                    local.get $p2
                    i32.eq
                    br_if $B14
                    block $B16
                      local.get $l8
                      i32.const -1
                      i32.add
                      local.tee $p2
                      i32.load8_s
                      i32.const -65
                      i32.le_s
                      br_if $B16
                      local.get $l5
                      i32.const -2
                      i32.add
                      local.set $l6
                      br $B14
                    end
                    local.get $l7
                    local.get $p2
                    i32.eq
                    br_if $B14
                    block $B17
                      local.get $l8
                      i32.const -2
                      i32.add
                      local.tee $p2
                      i32.load8_s
                      i32.const -65
                      i32.le_s
                      br_if $B17
                      local.get $l5
                      i32.const -3
                      i32.add
                      local.set $l6
                      br $B14
                    end
                    local.get $l7
                    local.get $p2
                    i32.eq
                    br_if $B14
                    block $B18
                      local.get $l8
                      i32.const -3
                      i32.add
                      local.tee $p2
                      i32.load8_s
                      i32.const -65
                      i32.le_s
                      br_if $B18
                      local.get $l5
                      i32.const -4
                      i32.add
                      local.set $l6
                      br $B14
                    end
                    local.get $l7
                    local.get $p2
                    i32.eq
                    br_if $B14
                    local.get $l5
                    i32.const -5
                    i32.add
                    local.set $l6
                  end
                  local.get $l6
                  local.get $p3
                  i32.add
                  local.set $p3
                end
                block $B19
                  local.get $p3
                  i32.eqz
                  br_if $B19
                  block $B20
                    local.get $p3
                    local.get $p1
                    i32.lt_u
                    br_if $B20
                    local.get $p3
                    local.get $p1
                    i32.eq
                    br_if $B19
                    br $B0
                  end
                  local.get $p0
                  local.get $p3
                  i32.add
                  i32.load8_s
                  i32.const -65
                  i32.le_s
                  br_if $B0
                end
                local.get $p3
                local.get $p1
                i32.eq
                br_if $B1
                block $B21
                  block $B22
                    block $B23
                      block $B24
                        local.get $p0
                        local.get $p3
                        i32.add
                        local.tee $p2
                        i32.load8_s
                        local.tee $p1
                        i32.const -1
                        i32.gt_s
                        br_if $B24
                        local.get $p2
                        i32.load8_u offset=1
                        i32.const 63
                        i32.and
                        local.set $p0
                        local.get $p1
                        i32.const 31
                        i32.and
                        local.set $l5
                        local.get $p1
                        i32.const -33
                        i32.gt_u
                        br_if $B23
                        local.get $l5
                        i32.const 6
                        i32.shl
                        local.get $p0
                        i32.or
                        local.set $p2
                        br $B22
                      end
                      local.get $l4
                      local.get $p1
                      i32.const 255
                      i32.and
                      i32.store offset=36
                      i32.const 1
                      local.set $p1
                      br $B21
                    end
                    local.get $p0
                    i32.const 6
                    i32.shl
                    local.get $p2
                    i32.load8_u offset=2
                    i32.const 63
                    i32.and
                    i32.or
                    local.set $p0
                    block $B25
                      local.get $p1
                      i32.const -16
                      i32.ge_u
                      br_if $B25
                      local.get $p0
                      local.get $l5
                      i32.const 12
                      i32.shl
                      i32.or
                      local.set $p2
                      br $B22
                    end
                    local.get $p0
                    i32.const 6
                    i32.shl
                    local.get $p2
                    i32.load8_u offset=3
                    i32.const 63
                    i32.and
                    i32.or
                    local.get $l5
                    i32.const 18
                    i32.shl
                    i32.const 1835008
                    i32.and
                    i32.or
                    local.tee $p2
                    i32.const 1114112
                    i32.eq
                    br_if $B1
                  end
                  local.get $l4
                  local.get $p2
                  i32.store offset=36
                  i32.const 1
                  local.set $p1
                  local.get $p2
                  i32.const 128
                  i32.lt_u
                  br_if $B21
                  i32.const 2
                  local.set $p1
                  local.get $p2
                  i32.const 2048
                  i32.lt_u
                  br_if $B21
                  i32.const 3
                  i32.const 4
                  local.get $p2
                  i32.const 65536
                  i32.lt_u
                  select
                  local.set $p1
                end
                local.get $l4
                local.get $p3
                i32.store offset=40
                local.get $l4
                local.get $p1
                local.get $p3
                i32.add
                i32.store offset=44
                local.get $l4
                i32.const 48
                i32.add
                i32.const 20
                i32.add
                i32.const 5
                i32.store
                local.get $l4
                i32.const 108
                i32.add
                i32.const 78
                i32.store
                local.get $l4
                i32.const 100
                i32.add
                i32.const 78
                i32.store
                local.get $l4
                i32.const 72
                i32.add
                i32.const 20
                i32.add
                i32.const 79
                i32.store
                local.get $l4
                i32.const 84
                i32.add
                i32.const 80
                i32.store
                local.get $l4
                i64.const 5
                i64.store offset=52 align=4
                local.get $l4
                i32.const 1056968
                i32.store offset=48
                local.get $l4
                i32.const 11
                i32.store offset=76
                local.get $l4
                local.get $l4
                i32.const 72
                i32.add
                i32.store offset=64
                local.get $l4
                local.get $l4
                i32.const 24
                i32.add
                i32.store offset=104
                local.get $l4
                local.get $l4
                i32.const 16
                i32.add
                i32.store offset=96
                local.get $l4
                local.get $l4
                i32.const 40
                i32.add
                i32.store offset=88
                local.get $l4
                local.get $l4
                i32.const 36
                i32.add
                i32.store offset=80
                local.get $l4
                local.get $l4
                i32.const 32
                i32.add
                i32.store offset=72
                local.get $l4
                i32.const 48
                i32.add
                i32.const 1057008
                call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
                unreachable
              end
              local.get $l4
              i32.const 100
              i32.add
              i32.const 78
              i32.store
              local.get $l4
              i32.const 72
              i32.add
              i32.const 20
              i32.add
              i32.const 78
              i32.store
              local.get $l4
              i32.const 84
              i32.add
              i32.const 11
              i32.store
              local.get $l4
              i32.const 48
              i32.add
              i32.const 20
              i32.add
              i32.const 4
              i32.store
              local.get $l4
              i64.const 4
              i64.store offset=52 align=4
              local.get $l4
              i32.const 1056852
              i32.store offset=48
              local.get $l4
              i32.const 11
              i32.store offset=76
              local.get $l4
              local.get $l4
              i32.const 72
              i32.add
              i32.store offset=64
              local.get $l4
              local.get $l4
              i32.const 24
              i32.add
              i32.store offset=96
              local.get $l4
              local.get $l4
              i32.const 16
              i32.add
              i32.store offset=88
              local.get $l4
              local.get $l4
              i32.const 12
              i32.add
              i32.store offset=80
              local.get $l4
              local.get $l4
              i32.const 8
              i32.add
              i32.store offset=72
              local.get $l4
              i32.const 48
              i32.add
              i32.const 1056884
              call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
              unreachable
            end
            local.get $p0
            local.get $p1
            i32.const 0
            local.get $l5
            local.get $l4
            call $_ZN4core3str16slice_error_fail17he7b9c5dd5c7360b4E
            unreachable
          end
          local.get $l4
          local.get $p2
          local.get $p3
          local.get $l5
          select
          i32.store offset=40
          local.get $l4
          i32.const 48
          i32.add
          i32.const 20
          i32.add
          i32.const 3
          i32.store
          local.get $l4
          i32.const 72
          i32.add
          i32.const 20
          i32.add
          i32.const 78
          i32.store
          local.get $l4
          i32.const 84
          i32.add
          i32.const 78
          i32.store
          local.get $l4
          i64.const 3
          i64.store offset=52 align=4
          local.get $l4
          i32.const 1056776
          i32.store offset=48
          local.get $l4
          i32.const 11
          i32.store offset=76
          local.get $l4
          local.get $l4
          i32.const 72
          i32.add
          i32.store offset=64
          local.get $l4
          local.get $l4
          i32.const 24
          i32.add
          i32.store offset=88
          local.get $l4
          local.get $l4
          i32.const 16
          i32.add
          i32.store offset=80
          local.get $l4
          local.get $l4
          i32.const 40
          i32.add
          i32.store offset=72
          local.get $l4
          i32.const 48
          i32.add
          i32.const 1056800
          call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
          unreachable
        end
        local.get $p3
        local.get $l5
        local.get $l4
        call $_ZN4core5slice5index22slice_index_order_fail17h8a0c3e5cd8503fbbE
        unreachable
      end
      i32.const 1055616
      i32.const 43
      i32.const 1056900
      call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
      unreachable
    end
    local.get $p0
    local.get $p1
    local.get $p3
    local.get $p1
    local.get $l4
    call $_ZN4core3str16slice_error_fail17he7b9c5dd5c7360b4E
    unreachable)
  (func $_ZN4core3ops8function6FnOnce9call_once17hdb3170b66e26817cE (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core5slice5index25slice_index_order_fail_rt17h8e8ec67445ccb370E
    unreachable)
  (func $_ZN4core5slice5index25slice_index_order_fail_rt17h8e8ec67445ccb370E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p1
    i32.store offset=4
    local.get $l2
    local.get $p0
    i32.store
    local.get $l2
    i32.const 28
    i32.add
    i32.const 2
    i32.store
    local.get $l2
    i32.const 44
    i32.add
    i32.const 11
    i32.store
    local.get $l2
    i64.const 2
    i64.store offset=12 align=4
    local.get $l2
    i32.const 1056420
    i32.store offset=8
    local.get $l2
    i32.const 11
    i32.store offset=36
    local.get $l2
    local.get $l2
    i32.const 32
    i32.add
    i32.store offset=24
    local.get $l2
    local.get $l2
    i32.const 4
    i32.add
    i32.store offset=40
    local.get $l2
    local.get $l2
    i32.store offset=32
    local.get $l2
    i32.const 8
    i32.add
    i32.const 1056436
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $_ZN4core3ops8function6FnOnce9call_once17hf5d854cc46375908E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    drop
    loop $L0 (result i32)
      br $L0
    end)
  (func $_ZN4core3ptr102drop_in_place$LT$$RF$core..iter..adapters..copied..Copied$LT$core..slice..iter..Iter$LT$u8$GT$$GT$$GT$17h1668ae1a50824bfcE (type $t1) (param $p0 i32))
  (func $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    i32.const 1
    i32.store8 offset=24
    local.get $l2
    local.get $p1
    i32.store offset=20
    local.get $l2
    local.get $p0
    i32.store offset=16
    local.get $l2
    i32.const 1055684
    i32.store offset=12
    local.get $l2
    i32.const 1055524
    i32.store offset=8
    local.get $l2
    i32.const 8
    i32.add
    call $rust_begin_unwind
    unreachable)
  (func $_ZN4core9panicking18panic_bounds_check17h9e8bd6eddd89cb1fE (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    local.get $p1
    i32.store offset=4
    local.get $l3
    local.get $p0
    i32.store
    local.get $l3
    i32.const 28
    i32.add
    i32.const 2
    i32.store
    local.get $l3
    i32.const 44
    i32.add
    i32.const 11
    i32.store
    local.get $l3
    i64.const 2
    i64.store offset=12 align=4
    local.get $l3
    i32.const 1055600
    i32.store offset=8
    local.get $l3
    i32.const 11
    i32.store offset=36
    local.get $l3
    local.get $l3
    i32.const 32
    i32.add
    i32.store offset=24
    local.get $l3
    local.get $l3
    i32.store offset=40
    local.get $l3
    local.get $l3
    i32.const 4
    i32.add
    i32.store offset=32
    local.get $l3
    i32.const 8
    i32.add
    local.get $p2
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core10intrinsics17const_eval_select17h9191283354c236b7E
    unreachable)
  (func $_ZN4core5slice5index24slice_end_index_len_fail17h1cddbbbac67bee27E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core10intrinsics17const_eval_select17h91d50f9e8abb2097E
    unreachable)
  (func $_ZN4core3fmt9Formatter3pad17hc53f6fdd83e6dddeE (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32)
    local.get $p0
    i32.load offset=16
    local.set $l3
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              block $B5
                local.get $p0
                i32.load offset=8
                local.tee $l4
                i32.const 1
                i32.eq
                br_if $B5
                local.get $l3
                i32.const 1
                i32.ne
                br_if $B4
              end
              local.get $l3
              i32.const 1
              i32.ne
              br_if $B1
              local.get $p1
              local.get $p2
              i32.add
              local.set $l5
              local.get $p0
              i32.const 20
              i32.add
              i32.load
              local.tee $l6
              br_if $B3
              i32.const 0
              local.set $l7
              local.get $p1
              local.set $l8
              br $B2
            end
            local.get $p0
            i32.load offset=24
            local.get $p1
            local.get $p2
            local.get $p0
            i32.const 28
            i32.add
            i32.load
            i32.load offset=12
            call_indirect $T0 (type $t7)
            local.set $l3
            br $B0
          end
          i32.const 0
          local.set $l7
          local.get $p1
          local.set $l8
          loop $L6
            local.get $l8
            local.tee $l3
            local.get $l5
            i32.eq
            br_if $B1
            block $B7
              block $B8
                local.get $l3
                i32.load8_s
                local.tee $l8
                i32.const -1
                i32.le_s
                br_if $B8
                local.get $l3
                i32.const 1
                i32.add
                local.set $l8
                br $B7
              end
              block $B9
                local.get $l8
                i32.const -32
                i32.ge_u
                br_if $B9
                local.get $l3
                i32.const 2
                i32.add
                local.set $l8
                br $B7
              end
              block $B10
                local.get $l8
                i32.const -16
                i32.ge_u
                br_if $B10
                local.get $l3
                i32.const 3
                i32.add
                local.set $l8
                br $B7
              end
              local.get $l3
              i32.load8_u offset=2
              i32.const 63
              i32.and
              i32.const 6
              i32.shl
              local.get $l3
              i32.load8_u offset=1
              i32.const 63
              i32.and
              i32.const 12
              i32.shl
              i32.or
              local.get $l3
              i32.load8_u offset=3
              i32.const 63
              i32.and
              i32.or
              local.get $l8
              i32.const 255
              i32.and
              i32.const 18
              i32.shl
              i32.const 1835008
              i32.and
              i32.or
              i32.const 1114112
              i32.eq
              br_if $B1
              local.get $l3
              i32.const 4
              i32.add
              local.set $l8
            end
            local.get $l7
            local.get $l3
            i32.sub
            local.get $l8
            i32.add
            local.set $l7
            local.get $l6
            i32.const -1
            i32.add
            local.tee $l6
            br_if $L6
          end
        end
        local.get $l8
        local.get $l5
        i32.eq
        br_if $B1
        block $B11
          local.get $l8
          i32.load8_s
          local.tee $l3
          i32.const -1
          i32.gt_s
          br_if $B11
          local.get $l3
          i32.const -32
          i32.lt_u
          br_if $B11
          local.get $l3
          i32.const -16
          i32.lt_u
          br_if $B11
          local.get $l8
          i32.load8_u offset=2
          i32.const 63
          i32.and
          i32.const 6
          i32.shl
          local.get $l8
          i32.load8_u offset=1
          i32.const 63
          i32.and
          i32.const 12
          i32.shl
          i32.or
          local.get $l8
          i32.load8_u offset=3
          i32.const 63
          i32.and
          i32.or
          local.get $l3
          i32.const 255
          i32.and
          i32.const 18
          i32.shl
          i32.const 1835008
          i32.and
          i32.or
          i32.const 1114112
          i32.eq
          br_if $B1
        end
        block $B12
          block $B13
            block $B14
              local.get $l7
              br_if $B14
              i32.const 0
              local.set $l8
              br $B13
            end
            block $B15
              local.get $l7
              local.get $p2
              i32.lt_u
              br_if $B15
              i32.const 0
              local.set $l3
              local.get $p2
              local.set $l8
              local.get $l7
              local.get $p2
              i32.eq
              br_if $B13
              br $B12
            end
            i32.const 0
            local.set $l3
            local.get $l7
            local.set $l8
            local.get $p1
            local.get $l7
            i32.add
            i32.load8_s
            i32.const -64
            i32.lt_s
            br_if $B12
          end
          local.get $l8
          local.set $l7
          local.get $p1
          local.set $l3
        end
        local.get $l7
        local.get $p2
        local.get $l3
        select
        local.set $p2
        local.get $l3
        local.get $p1
        local.get $l3
        select
        local.set $p1
      end
      block $B16
        local.get $l4
        br_if $B16
        local.get $p0
        i32.load offset=24
        local.get $p1
        local.get $p2
        local.get $p0
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        return
      end
      local.get $p0
      i32.const 12
      i32.add
      i32.load
      local.set $l5
      block $B17
        block $B18
          local.get $p2
          i32.const 16
          i32.lt_u
          br_if $B18
          local.get $p1
          local.get $p2
          call $_ZN4core3str5count14do_count_chars17hd660a7601d857072E
          local.set $l8
          br $B17
        end
        block $B19
          local.get $p2
          br_if $B19
          i32.const 0
          local.set $l8
          br $B17
        end
        local.get $p2
        i32.const 3
        i32.and
        local.set $l7
        block $B20
          block $B21
            local.get $p2
            i32.const -1
            i32.add
            i32.const 3
            i32.ge_u
            br_if $B21
            i32.const 0
            local.set $l8
            local.get $p1
            local.set $l3
            br $B20
          end
          local.get $p2
          i32.const -4
          i32.and
          local.set $l6
          i32.const 0
          local.set $l8
          local.get $p1
          local.set $l3
          loop $L22
            local.get $l8
            local.get $l3
            i32.load8_s
            i32.const -65
            i32.gt_s
            i32.add
            local.get $l3
            i32.const 1
            i32.add
            i32.load8_s
            i32.const -65
            i32.gt_s
            i32.add
            local.get $l3
            i32.const 2
            i32.add
            i32.load8_s
            i32.const -65
            i32.gt_s
            i32.add
            local.get $l3
            i32.const 3
            i32.add
            i32.load8_s
            i32.const -65
            i32.gt_s
            i32.add
            local.set $l8
            local.get $l3
            i32.const 4
            i32.add
            local.set $l3
            local.get $l6
            i32.const -4
            i32.add
            local.tee $l6
            br_if $L22
          end
        end
        local.get $l7
        i32.eqz
        br_if $B17
        loop $L23
          local.get $l8
          local.get $l3
          i32.load8_s
          i32.const -65
          i32.gt_s
          i32.add
          local.set $l8
          local.get $l3
          i32.const 1
          i32.add
          local.set $l3
          local.get $l7
          i32.const -1
          i32.add
          local.tee $l7
          br_if $L23
        end
      end
      block $B24
        local.get $l5
        local.get $l8
        i32.le_u
        br_if $B24
        i32.const 0
        local.set $l3
        local.get $l5
        local.get $l8
        i32.sub
        local.tee $l7
        local.set $l6
        block $B25
          block $B26
            block $B27
              i32.const 0
              local.get $p0
              i32.load8_u offset=32
              local.tee $l8
              local.get $l8
              i32.const 3
              i32.eq
              select
              i32.const 3
              i32.and
              br_table $B25 $B27 $B26 $B25
            end
            i32.const 0
            local.set $l6
            local.get $l7
            local.set $l3
            br $B25
          end
          local.get $l7
          i32.const 1
          i32.shr_u
          local.set $l3
          local.get $l7
          i32.const 1
          i32.add
          i32.const 1
          i32.shr_u
          local.set $l6
        end
        local.get $l3
        i32.const 1
        i32.add
        local.set $l3
        local.get $p0
        i32.const 28
        i32.add
        i32.load
        local.set $l7
        local.get $p0
        i32.load offset=4
        local.set $l8
        local.get $p0
        i32.load offset=24
        local.set $p0
        block $B28
          loop $L29
            local.get $l3
            i32.const -1
            i32.add
            local.tee $l3
            i32.eqz
            br_if $B28
            local.get $p0
            local.get $l8
            local.get $l7
            i32.load offset=16
            call_indirect $T0 (type $t5)
            i32.eqz
            br_if $L29
          end
          i32.const 1
          return
        end
        i32.const 1
        local.set $l3
        local.get $l8
        i32.const 1114112
        i32.eq
        br_if $B0
        local.get $p0
        local.get $p1
        local.get $p2
        local.get $l7
        i32.load offset=12
        call_indirect $T0 (type $t7)
        br_if $B0
        i32.const 0
        local.set $l3
        loop $L30
          block $B31
            local.get $l6
            local.get $l3
            i32.ne
            br_if $B31
            local.get $l6
            local.get $l6
            i32.lt_u
            return
          end
          local.get $l3
          i32.const 1
          i32.add
          local.set $l3
          local.get $p0
          local.get $l8
          local.get $l7
          i32.load offset=16
          call_indirect $T0 (type $t5)
          i32.eqz
          br_if $L30
        end
        local.get $l3
        i32.const -1
        i32.add
        local.get $l6
        i32.lt_u
        return
      end
      local.get $p0
      i32.load offset=24
      local.get $p1
      local.get $p2
      local.get $p0
      i32.const 28
      i32.add
      i32.load
      i32.load offset=12
      call_indirect $T0 (type $t7)
      return
    end
    local.get $l3)
  (func $_ZN4core9panicking5panic17h68978bf8b4be9f2fE (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    i32.const 20
    i32.add
    i32.const 0
    i32.store
    local.get $l3
    i32.const 1055524
    i32.store offset=16
    local.get $l3
    i64.const 1
    i64.store offset=4 align=4
    local.get $l3
    local.get $p1
    i32.store offset=28
    local.get $l3
    local.get $p0
    i32.store offset=24
    local.get $l3
    local.get $l3
    i32.const 24
    i32.add
    i32.store
    local.get $l3
    local.get $p2
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $_ZN4core5slice5index22slice_index_order_fail17h8a0c3e5cd8503fbbE (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core10intrinsics17const_eval_select17hc9b5ef7a4b025c6cE
    unreachable)
  (func $_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$3fmt17h813a35a9627bd2a0E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i64.load32_u
    i32.const 1
    local.get $p1
    call $_ZN4core3fmt3num3imp7fmt_u6417h0b9ae8555cb01f7dE)
  (func $_ZN4core10intrinsics17const_eval_select17h9191283354c236b7E (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core3ops8function6FnOnce9call_once17h017bd921d8fc3485E
    unreachable)
  (func $_ZN4core10intrinsics17const_eval_select17h91d50f9e8abb2097E (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core3ops8function6FnOnce9call_once17h4d3e4db7bb7cb804E
    unreachable)
  (func $_ZN4core10intrinsics17const_eval_select17hc9b5ef7a4b025c6cE (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    call $_ZN4core3ops8function6FnOnce9call_once17hdb3170b66e26817cE
    unreachable)
  (func $_ZN4core10intrinsics17const_eval_select17hfee19707cf86810bE (type $t1) (param $p0 i32)
    local.get $p0
    i32.load
    local.get $p0
    i32.load offset=4
    local.get $p0
    i32.load offset=8
    local.get $p0
    i32.load offset=12
    call $_ZN4core3ops8function6FnOnce9call_once17hca35ec0ede346bb1E
    unreachable)
  (func $_ZN4core3fmt3num50_$LT$impl$u20$core..fmt..Debug$u20$for$u20$u32$GT$3fmt17h90714a0c65d14ba5E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 128
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              local.get $p1
              i32.load
              local.tee $l3
              i32.const 16
              i32.and
              br_if $B4
              local.get $l3
              i32.const 32
              i32.and
              br_if $B3
              local.get $p0
              i64.load32_u
              i32.const 1
              local.get $p1
              call $_ZN4core3fmt3num3imp7fmt_u6417h0b9ae8555cb01f7dE
              local.set $p0
              br $B0
            end
            local.get $p0
            i32.load
            local.set $p0
            i32.const 0
            local.set $l3
            loop $L5
              local.get $l2
              local.get $l3
              i32.add
              i32.const 127
              i32.add
              i32.const 48
              i32.const 87
              local.get $p0
              i32.const 15
              i32.and
              local.tee $l4
              i32.const 10
              i32.lt_u
              select
              local.get $l4
              i32.add
              i32.store8
              local.get $l3
              i32.const -1
              i32.add
              local.set $l3
              local.get $p0
              i32.const 15
              i32.gt_u
              local.set $l4
              local.get $p0
              i32.const 4
              i32.shr_u
              local.set $p0
              local.get $l4
              br_if $L5
            end
            local.get $l3
            i32.const 128
            i32.add
            local.tee $p0
            i32.const 129
            i32.ge_u
            br_if $B2
            local.get $p1
            i32.const 1
            i32.const 1055981
            i32.const 2
            local.get $l2
            local.get $l3
            i32.add
            i32.const 128
            i32.add
            i32.const 0
            local.get $l3
            i32.sub
            call $_ZN4core3fmt9Formatter12pad_integral17h34779d061fe7ddecE
            local.set $p0
            br $B0
          end
          local.get $p0
          i32.load
          local.set $p0
          i32.const 0
          local.set $l3
          loop $L6
            local.get $l2
            local.get $l3
            i32.add
            i32.const 127
            i32.add
            i32.const 48
            i32.const 55
            local.get $p0
            i32.const 15
            i32.and
            local.tee $l4
            i32.const 10
            i32.lt_u
            select
            local.get $l4
            i32.add
            i32.store8
            local.get $l3
            i32.const -1
            i32.add
            local.set $l3
            local.get $p0
            i32.const 15
            i32.gt_u
            local.set $l4
            local.get $p0
            i32.const 4
            i32.shr_u
            local.set $p0
            local.get $l4
            br_if $L6
          end
          local.get $l3
          i32.const 128
          i32.add
          local.tee $p0
          i32.const 129
          i32.ge_u
          br_if $B1
          local.get $p1
          i32.const 1
          i32.const 1055981
          i32.const 2
          local.get $l2
          local.get $l3
          i32.add
          i32.const 128
          i32.add
          i32.const 0
          local.get $l3
          i32.sub
          call $_ZN4core3fmt9Formatter12pad_integral17h34779d061fe7ddecE
          local.set $p0
          br $B0
        end
        local.get $p0
        i32.const 128
        local.get $p0
        call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
        unreachable
      end
      local.get $p0
      i32.const 128
      local.get $p0
      call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
      unreachable
    end
    local.get $l2
    i32.const 128
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core3fmt5write17h64a435d9d6b334f1E (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    i32.const 36
    i32.add
    local.get $p1
    i32.store
    local.get $l3
    i32.const 3
    i32.store8 offset=40
    local.get $l3
    i64.const 137438953472
    i64.store offset=8
    local.get $l3
    local.get $p0
    i32.store offset=32
    i32.const 0
    local.set $l4
    local.get $l3
    i32.const 0
    i32.store offset=24
    local.get $l3
    i32.const 0
    i32.store offset=16
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p2
            i32.load offset=8
            local.tee $l5
            br_if $B3
            local.get $p2
            i32.const 20
            i32.add
            i32.load
            local.tee $l6
            i32.eqz
            br_if $B2
            local.get $p2
            i32.load
            local.set $p1
            local.get $p2
            i32.load offset=16
            local.set $p0
            local.get $l6
            i32.const -1
            i32.add
            i32.const 536870911
            i32.and
            i32.const 1
            i32.add
            local.tee $l4
            local.set $l6
            loop $L4
              block $B5
                local.get $p1
                i32.const 4
                i32.add
                i32.load
                local.tee $l7
                i32.eqz
                br_if $B5
                local.get $l3
                i32.load offset=32
                local.get $p1
                i32.load
                local.get $l7
                local.get $l3
                i32.load offset=36
                i32.load offset=12
                call_indirect $T0 (type $t7)
                br_if $B1
              end
              local.get $p0
              i32.load
              local.get $l3
              i32.const 8
              i32.add
              local.get $p0
              i32.const 4
              i32.add
              i32.load
              call_indirect $T0 (type $t5)
              br_if $B1
              local.get $p0
              i32.const 8
              i32.add
              local.set $p0
              local.get $p1
              i32.const 8
              i32.add
              local.set $p1
              local.get $l6
              i32.const -1
              i32.add
              local.tee $l6
              br_if $L4
              br $B2
            end
          end
          local.get $p2
          i32.const 12
          i32.add
          i32.load
          local.tee $p0
          i32.eqz
          br_if $B2
          local.get $p0
          i32.const 5
          i32.shl
          local.set $l8
          local.get $p0
          i32.const -1
          i32.add
          i32.const 134217727
          i32.and
          i32.const 1
          i32.add
          local.set $l4
          local.get $p2
          i32.load
          local.set $p1
          i32.const 0
          local.set $l6
          loop $L6
            block $B7
              local.get $p1
              i32.const 4
              i32.add
              i32.load
              local.tee $p0
              i32.eqz
              br_if $B7
              local.get $l3
              i32.load offset=32
              local.get $p1
              i32.load
              local.get $p0
              local.get $l3
              i32.load offset=36
              i32.load offset=12
              call_indirect $T0 (type $t7)
              br_if $B1
            end
            local.get $l3
            local.get $l5
            local.get $l6
            i32.add
            local.tee $p0
            i32.const 28
            i32.add
            i32.load8_u
            i32.store8 offset=40
            local.get $l3
            local.get $p0
            i32.const 4
            i32.add
            i64.load align=4
            i64.const 32
            i64.rotl
            i64.store offset=8
            local.get $p0
            i32.const 24
            i32.add
            i32.load
            local.set $l9
            local.get $p2
            i32.load offset=16
            local.set $l10
            i32.const 0
            local.set $l11
            i32.const 0
            local.set $l7
            block $B8
              block $B9
                block $B10
                  local.get $p0
                  i32.const 20
                  i32.add
                  i32.load
                  br_table $B9 $B10 $B8 $B9
                end
                local.get $l9
                i32.const 3
                i32.shl
                local.set $l12
                i32.const 0
                local.set $l7
                local.get $l10
                local.get $l12
                i32.add
                local.tee $l12
                i32.load offset=4
                i32.const 81
                i32.ne
                br_if $B8
                local.get $l12
                i32.load
                i32.load
                local.set $l9
              end
              i32.const 1
              local.set $l7
            end
            local.get $l3
            local.get $l9
            i32.store offset=20
            local.get $l3
            local.get $l7
            i32.store offset=16
            local.get $p0
            i32.const 16
            i32.add
            i32.load
            local.set $l7
            block $B11
              block $B12
                block $B13
                  local.get $p0
                  i32.const 12
                  i32.add
                  i32.load
                  br_table $B12 $B13 $B11 $B12
                end
                local.get $l7
                i32.const 3
                i32.shl
                local.set $l9
                local.get $l10
                local.get $l9
                i32.add
                local.tee $l9
                i32.load offset=4
                i32.const 81
                i32.ne
                br_if $B11
                local.get $l9
                i32.load
                i32.load
                local.set $l7
              end
              i32.const 1
              local.set $l11
            end
            local.get $l3
            local.get $l7
            i32.store offset=28
            local.get $l3
            local.get $l11
            i32.store offset=24
            local.get $l10
            local.get $p0
            i32.load
            i32.const 3
            i32.shl
            i32.add
            local.tee $p0
            i32.load
            local.get $l3
            i32.const 8
            i32.add
            local.get $p0
            i32.load offset=4
            call_indirect $T0 (type $t5)
            br_if $B1
            local.get $p1
            i32.const 8
            i32.add
            local.set $p1
            local.get $l8
            local.get $l6
            i32.const 32
            i32.add
            local.tee $l6
            i32.ne
            br_if $L6
          end
        end
        i32.const 0
        local.set $p0
        local.get $l4
        local.get $p2
        i32.load offset=4
        i32.lt_u
        local.tee $p1
        i32.eqz
        br_if $B0
        local.get $l3
        i32.load offset=32
        local.get $p2
        i32.load
        local.get $l4
        i32.const 3
        i32.shl
        i32.add
        i32.const 0
        local.get $p1
        select
        local.tee $p1
        i32.load
        local.get $p1
        i32.load offset=4
        local.get $l3
        i32.load offset=36
        i32.load offset=12
        call_indirect $T0 (type $t7)
        i32.eqz
        br_if $B0
      end
      i32.const 1
      local.set $p0
    end
    local.get $l3
    i32.const 48
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h7503e30c839de4caE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    i32.const 1
    local.set $l3
    block $B0
      local.get $p0
      local.get $p1
      call $_ZN4core3fmt3num50_$LT$impl$u20$core..fmt..Debug$u20$for$u20$u32$GT$3fmt17h90714a0c65d14ba5E
      br_if $B0
      local.get $p1
      i32.const 28
      i32.add
      i32.load
      local.set $l4
      local.get $p1
      i32.load offset=24
      local.set $l5
      local.get $l2
      i32.const 28
      i32.add
      i32.const 0
      i32.store
      local.get $l2
      i32.const 1055524
      i32.store offset=24
      local.get $l2
      i64.const 1
      i64.store offset=12 align=4
      local.get $l2
      i32.const 1055528
      i32.store offset=8
      local.get $l5
      local.get $l4
      local.get $l2
      i32.const 8
      i32.add
      call $_ZN4core3fmt5write17h64a435d9d6b334f1E
      br_if $B0
      local.get $p0
      i32.const 4
      i32.add
      local.get $p1
      call $_ZN4core3fmt3num50_$LT$impl$u20$core..fmt..Debug$u20$for$u20$u32$GT$3fmt17h90714a0c65d14ba5E
      local.set $l3
    end
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $l3)
  (func $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17hd6e0e99b069667c6E (type $t2) (param $p0 i32) (result i64)
    i64.const 6368113575764679147)
  (func $_ZN63_$LT$core..cell..BorrowMutError$u20$as$u20$core..fmt..Debug$GT$3fmt17h22847665890af294E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p1
    i32.load offset=24
    i32.const 1055536
    i32.const 14
    local.get $p1
    i32.const 28
    i32.add
    i32.load
    i32.load offset=12
    call_indirect $T0 (type $t7))
  (func $_ZN4core4char7methods22_$LT$impl$u20$char$GT$16escape_debug_ext17ha8ae248e617d0d21E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i64)
    i32.const 48
    local.set $l3
    i32.const 2
    local.set $l4
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              block $B5
                block $B6
                  block $B7
                    block $B8
                      local.get $p1
                      br_table $B0 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B7 $B5 $B2 $B2 $B6 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B2 $B4 $B2 $B2 $B2 $B2 $B3 $B8
                    end
                    i32.const 92
                    local.set $l3
                    local.get $p1
                    i32.const 92
                    i32.eq
                    br_if $B1
                    br $B2
                  end
                  i32.const 116
                  local.set $l3
                  br $B1
                end
                i32.const 114
                local.set $l3
                br $B1
              end
              i32.const 110
              local.set $l3
              br $B1
            end
            local.get $p2
            i32.const 65536
            i32.and
            i32.eqz
            br_if $B2
            i32.const 34
            local.set $l3
            br $B1
          end
          local.get $p2
          i32.const 256
          i32.and
          i32.eqz
          br_if $B2
          i32.const 39
          local.set $l3
          br $B1
        end
        local.get $p1
        local.set $l3
        block $B9
          local.get $p2
          i32.const 1
          i32.and
          i32.eqz
          br_if $B9
          local.get $l3
          call $_ZN4core7unicode12unicode_data15grapheme_extend6lookup17hdda2b6bd9e7b2e20E
          i32.eqz
          br_if $B9
          local.get $p1
          i32.const 1
          i32.or
          i32.clz
          i32.const 2
          i32.shr_u
          i32.const 7
          i32.xor
          i64.extend_i32_u
          i64.const 21474836480
          i64.or
          local.set $l5
          i32.const 3
          local.set $l4
          br $B0
        end
        block $B10
          block $B11
            block $B12
              block $B13
                local.get $p1
                i32.const 65536
                i32.lt_u
                br_if $B13
                local.get $p1
                i32.const 131072
                i32.ge_u
                br_if $B12
                local.get $l3
                i32.const 1057751
                i32.const 42
                i32.const 1057835
                i32.const 192
                i32.const 1058027
                i32.const 438
                call $_ZN4core7unicode9printable5check17h68271d35e681663cE
                br_if $B10
                br $B11
              end
              local.get $l3
              i32.const 1057080
              i32.const 40
              i32.const 1057160
              i32.const 288
              i32.const 1057448
              i32.const 303
              call $_ZN4core7unicode9printable5check17h68271d35e681663cE
              i32.eqz
              br_if $B11
              br $B10
            end
            local.get $p1
            i32.const 917999
            i32.gt_u
            br_if $B11
            local.get $p1
            i32.const 2097150
            i32.and
            i32.const 178206
            i32.eq
            br_if $B11
            local.get $p1
            i32.const 2097120
            i32.and
            i32.const 173792
            i32.eq
            br_if $B11
            local.get $p1
            i32.const -177977
            i32.add
            i32.const 7
            i32.lt_u
            br_if $B11
            local.get $p1
            i32.const -183984
            i32.add
            i32.const -15
            i32.gt_u
            br_if $B11
            local.get $p1
            i32.const -194560
            i32.add
            i32.const -3104
            i32.gt_u
            br_if $B11
            local.get $p1
            i32.const -196608
            i32.add
            i32.const -1507
            i32.gt_u
            br_if $B11
            local.get $p1
            i32.const -917760
            i32.add
            i32.const -716213
            i32.lt_u
            br_if $B10
          end
          local.get $p1
          i32.const 1
          i32.or
          i32.clz
          i32.const 2
          i32.shr_u
          i32.const 7
          i32.xor
          i64.extend_i32_u
          i64.const 21474836480
          i64.or
          local.set $l5
          i32.const 3
          local.set $l4
          br $B0
        end
        i32.const 1
        local.set $l4
      end
    end
    local.get $p0
    local.get $l3
    i32.store offset=4
    local.get $p0
    local.get $l4
    i32.store
    local.get $p0
    i32.const 8
    i32.add
    local.get $l5
    i64.store align=4)
  (func $_ZN4core7unicode12unicode_data15grapheme_extend6lookup17hdda2b6bd9e7b2e20E (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    local.get $p0
    i32.const 11
    i32.shl
    local.set $l1
    i32.const 0
    local.set $l2
    i32.const 32
    local.set $l3
    i32.const 32
    local.set $l4
    block $B0
      block $B1
        loop $L2
          block $B3
            block $B4
              local.get $l3
              i32.const 1
              i32.shr_u
              local.get $l2
              i32.add
              local.tee $l3
              i32.const 2
              i32.shl
              i32.const 1058628
              i32.add
              i32.load
              i32.const 11
              i32.shl
              local.tee $l5
              local.get $l1
              i32.lt_u
              br_if $B4
              local.get $l5
              local.get $l1
              i32.eq
              br_if $B1
              local.get $l3
              local.set $l4
              br $B3
            end
            local.get $l3
            i32.const 1
            i32.add
            local.set $l2
          end
          local.get $l4
          local.get $l2
          i32.sub
          local.set $l3
          local.get $l4
          local.get $l2
          i32.gt_u
          br_if $L2
          br $B0
        end
      end
      local.get $l3
      i32.const 1
      i32.add
      local.set $l2
    end
    block $B5
      block $B6
        block $B7
          local.get $l2
          i32.const 31
          i32.gt_u
          br_if $B7
          local.get $l2
          i32.const 2
          i32.shl
          local.set $l3
          i32.const 707
          local.set $l4
          block $B8
            local.get $l2
            i32.const 31
            i32.eq
            br_if $B8
            local.get $l3
            i32.const 1058632
            i32.add
            i32.load
            i32.const 21
            i32.shr_u
            local.set $l4
          end
          i32.const 0
          local.set $l1
          block $B9
            local.get $l2
            i32.const -1
            i32.add
            local.tee $l5
            local.get $l2
            i32.gt_u
            br_if $B9
            local.get $l5
            i32.const 32
            i32.ge_u
            br_if $B6
            local.get $l5
            i32.const 2
            i32.shl
            i32.const 1058628
            i32.add
            i32.load
            i32.const 2097151
            i32.and
            local.set $l1
          end
          block $B10
            local.get $l4
            local.get $l3
            i32.const 1058628
            i32.add
            i32.load
            i32.const 21
            i32.shr_u
            local.tee $l2
            i32.const -1
            i32.xor
            i32.add
            i32.eqz
            br_if $B10
            local.get $p0
            local.get $l1
            i32.sub
            local.set $l1
            local.get $l2
            i32.const 707
            local.get $l2
            i32.const 707
            i32.gt_u
            select
            local.set $l3
            local.get $l4
            i32.const -1
            i32.add
            local.set $l5
            i32.const 0
            local.set $l4
            loop $L11
              local.get $l3
              local.get $l2
              i32.eq
              br_if $B5
              local.get $l4
              local.get $l2
              i32.const 1058756
              i32.add
              i32.load8_u
              i32.add
              local.tee $l4
              local.get $l1
              i32.gt_u
              br_if $B10
              local.get $l5
              local.get $l2
              i32.const 1
              i32.add
              local.tee $l2
              i32.ne
              br_if $L11
            end
            local.get $l5
            local.set $l2
          end
          local.get $l2
          i32.const 1
          i32.and
          return
        end
        local.get $l2
        i32.const 32
        i32.const 1058508
        call $_ZN4core9panicking18panic_bounds_check17h9e8bd6eddd89cb1fE
        unreachable
      end
      local.get $l5
      i32.const 32
      i32.const 1058540
      call $_ZN4core9panicking18panic_bounds_check17h9e8bd6eddd89cb1fE
      unreachable
    end
    local.get $l3
    i32.const 707
    i32.const 1058524
    call $_ZN4core9panicking18panic_bounds_check17h9e8bd6eddd89cb1fE
    unreachable)
  (func $_ZN4core7unicode9printable5check17h68271d35e681663cE (type $t12) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (param $p5 i32) (param $p6 i32) (result i32)
    (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32) (local $l13 i32)
    i32.const 1
    local.set $l7
    block $B0
      block $B1
        local.get $p2
        i32.eqz
        br_if $B1
        local.get $p1
        local.get $p2
        i32.const 1
        i32.shl
        i32.add
        local.set $l8
        local.get $p0
        i32.const 65280
        i32.and
        i32.const 8
        i32.shr_u
        local.set $l9
        i32.const 0
        local.set $l10
        local.get $p0
        i32.const 255
        i32.and
        local.set $l11
        block $B2
          loop $L3
            local.get $p1
            i32.const 2
            i32.add
            local.set $l12
            local.get $l10
            local.get $p1
            i32.load8_u offset=1
            local.tee $p2
            i32.add
            local.set $l13
            block $B4
              local.get $p1
              i32.load8_u
              local.tee $p1
              local.get $l9
              i32.eq
              br_if $B4
              local.get $p1
              local.get $l9
              i32.gt_u
              br_if $B1
              local.get $l13
              local.set $l10
              local.get $l12
              local.set $p1
              local.get $l12
              local.get $l8
              i32.ne
              br_if $L3
              br $B1
            end
            block $B5
              local.get $l13
              local.get $l10
              i32.lt_u
              br_if $B5
              local.get $l13
              local.get $p4
              i32.gt_u
              br_if $B2
              local.get $p3
              local.get $l10
              i32.add
              local.set $p1
              block $B6
                loop $L7
                  local.get $p2
                  i32.eqz
                  br_if $B6
                  local.get $p2
                  i32.const -1
                  i32.add
                  local.set $p2
                  local.get $p1
                  i32.load8_u
                  local.set $l10
                  local.get $p1
                  i32.const 1
                  i32.add
                  local.set $p1
                  local.get $l10
                  local.get $l11
                  i32.ne
                  br_if $L7
                end
                i32.const 0
                local.set $l7
                br $B0
              end
              local.get $l13
              local.set $l10
              local.get $l12
              local.set $p1
              local.get $l12
              local.get $l8
              i32.ne
              br_if $L3
              br $B1
            end
          end
          local.get $l10
          local.get $l13
          local.get $p2
          call $_ZN4core5slice5index22slice_index_order_fail17h8a0c3e5cd8503fbbE
          unreachable
        end
        local.get $l13
        local.get $p4
        local.get $p2
        call $_ZN4core5slice5index24slice_end_index_len_fail17h1cddbbbac67bee27E
        unreachable
      end
      local.get $p6
      i32.eqz
      br_if $B0
      local.get $p5
      local.get $p6
      i32.add
      local.set $l11
      local.get $p0
      i32.const 65535
      i32.and
      local.set $p1
      i32.const 1
      local.set $l7
      block $B8
        loop $L9
          local.get $p5
          i32.const 1
          i32.add
          local.set $l10
          block $B10
            block $B11
              local.get $p5
              i32.load8_u
              local.tee $p2
              i32.const 24
              i32.shl
              i32.const 24
              i32.shr_s
              local.tee $l13
              i32.const 0
              i32.lt_s
              br_if $B11
              local.get $l10
              local.set $p5
              br $B10
            end
            local.get $l10
            local.get $l11
            i32.eq
            br_if $B8
            local.get $l13
            i32.const 127
            i32.and
            i32.const 8
            i32.shl
            local.get $p5
            i32.load8_u offset=1
            i32.or
            local.set $p2
            local.get $p5
            i32.const 2
            i32.add
            local.set $p5
          end
          local.get $p1
          local.get $p2
          i32.sub
          local.tee $p1
          i32.const 0
          i32.lt_s
          br_if $B0
          local.get $l7
          i32.const 1
          i32.xor
          local.set $l7
          local.get $p5
          local.get $l11
          i32.ne
          br_if $L9
          br $B0
        end
      end
      i32.const 1055616
      i32.const 43
      i32.const 1057064
      call $_ZN4core9panicking5panic17h68978bf8b4be9f2fE
      unreachable
    end
    local.get $l7
    i32.const 1
    i32.and)
  (func $_ZN4core5slice6memchr19memchr_general_case17hb03e751cfda9b451E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32)
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p2
            i32.const 3
            i32.add
            i32.const -4
            i32.and
            local.get $p2
            i32.sub
            local.tee $l4
            i32.eqz
            br_if $B3
            local.get $p3
            local.get $l4
            local.get $l4
            local.get $p3
            i32.gt_u
            select
            local.tee $l4
            i32.eqz
            br_if $B3
            i32.const 0
            local.set $l5
            local.get $p1
            i32.const 255
            i32.and
            local.set $l6
            i32.const 1
            local.set $l7
            loop $L4
              local.get $p2
              local.get $l5
              i32.add
              i32.load8_u
              local.get $l6
              i32.eq
              br_if $B0
              local.get $l4
              local.get $l5
              i32.const 1
              i32.add
              local.tee $l5
              i32.ne
              br_if $L4
            end
            local.get $l4
            local.get $p3
            i32.const -8
            i32.add
            local.tee $l8
            i32.gt_u
            br_if $B1
            br $B2
          end
          local.get $p3
          i32.const -8
          i32.add
          local.set $l8
          i32.const 0
          local.set $l4
        end
        local.get $p1
        i32.const 255
        i32.and
        i32.const 16843009
        i32.mul
        local.set $l5
        block $B5
          loop $L6
            local.get $p2
            local.get $l4
            i32.add
            local.tee $l6
            i32.load
            local.get $l5
            i32.xor
            local.tee $l7
            i32.const -1
            i32.xor
            local.get $l7
            i32.const -16843009
            i32.add
            i32.and
            local.get $l6
            i32.const 4
            i32.add
            i32.load
            local.get $l5
            i32.xor
            local.tee $l6
            i32.const -1
            i32.xor
            local.get $l6
            i32.const -16843009
            i32.add
            i32.and
            i32.or
            i32.const -2139062144
            i32.and
            br_if $B5
            local.get $l4
            i32.const 8
            i32.add
            local.tee $l4
            local.get $l8
            i32.le_u
            br_if $L6
          end
        end
        local.get $l4
        local.get $p3
        i32.le_u
        br_if $B1
        local.get $l4
        local.get $p3
        local.get $l4
        call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
        unreachable
      end
      block $B7
        local.get $l4
        local.get $p3
        i32.eq
        br_if $B7
        local.get $l4
        local.get $p3
        i32.sub
        local.set $l8
        local.get $p2
        local.get $l4
        i32.add
        local.set $l6
        i32.const 0
        local.set $l5
        local.get $p1
        i32.const 255
        i32.and
        local.set $l7
        block $B8
          loop $L9
            local.get $l6
            local.get $l5
            i32.add
            i32.load8_u
            local.get $l7
            i32.eq
            br_if $B8
            local.get $l8
            local.get $l5
            i32.const 1
            i32.add
            local.tee $l5
            i32.add
            i32.eqz
            br_if $B7
            br $L9
          end
        end
        local.get $l4
        local.get $l5
        i32.add
        local.set $l5
        i32.const 1
        local.set $l7
        br $B0
      end
      i32.const 0
      local.set $l7
    end
    local.get $p0
    local.get $l5
    i32.store offset=4
    local.get $p0
    local.get $l7
    i32.store)
  (func $_ZN4core3str8converts9from_utf817h2ccf4e2b9987c885E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i64) (local $l9 i64) (local $l10 i32)
    block $B0
      local.get $p2
      i32.eqz
      br_if $B0
      i32.const 0
      local.get $p2
      i32.const -7
      i32.add
      local.tee $l3
      local.get $l3
      local.get $p2
      i32.gt_u
      select
      local.set $l4
      local.get $p1
      i32.const 3
      i32.add
      i32.const -4
      i32.and
      local.get $p1
      i32.sub
      local.set $l5
      i32.const 0
      local.set $l3
      block $B1
        block $B2
          block $B3
            block $B4
              loop $L5
                block $B6
                  block $B7
                    block $B8
                      local.get $p1
                      local.get $l3
                      i32.add
                      i32.load8_u
                      local.tee $l6
                      i32.const 24
                      i32.shl
                      i32.const 24
                      i32.shr_s
                      local.tee $l7
                      i32.const 0
                      i32.lt_s
                      br_if $B8
                      local.get $l5
                      i32.const -1
                      i32.eq
                      br_if $B7
                      local.get $l5
                      local.get $l3
                      i32.sub
                      i32.const 3
                      i32.and
                      br_if $B7
                      block $B9
                        local.get $l3
                        local.get $l4
                        i32.ge_u
                        br_if $B9
                        loop $L10
                          local.get $p1
                          local.get $l3
                          i32.add
                          local.tee $l6
                          i32.load
                          local.get $l6
                          i32.const 4
                          i32.add
                          i32.load
                          i32.or
                          i32.const -2139062144
                          i32.and
                          br_if $B9
                          local.get $l3
                          i32.const 8
                          i32.add
                          local.tee $l3
                          local.get $l4
                          i32.lt_u
                          br_if $L10
                        end
                      end
                      local.get $l3
                      local.get $p2
                      i32.ge_u
                      br_if $B6
                      loop $L11
                        local.get $p1
                        local.get $l3
                        i32.add
                        i32.load8_s
                        i32.const 0
                        i32.lt_s
                        br_if $B6
                        local.get $p2
                        local.get $l3
                        i32.const 1
                        i32.add
                        local.tee $l3
                        i32.ne
                        br_if $L11
                        br $B0
                      end
                    end
                    i64.const 1099511627776
                    local.set $l8
                    i64.const 4294967296
                    local.set $l9
                    block $B12
                      block $B13
                        block $B14
                          block $B15
                            block $B16
                              block $B17
                                block $B18
                                  block $B19
                                    block $B20
                                      local.get $l6
                                      i32.const 1056452
                                      i32.add
                                      i32.load8_u
                                      i32.const -2
                                      i32.add
                                      br_table $B20 $B19 $B18 $B1
                                    end
                                    local.get $l3
                                    i32.const 1
                                    i32.add
                                    local.tee $l6
                                    local.get $p2
                                    i32.lt_u
                                    br_if $B13
                                    i64.const 0
                                    local.set $l8
                                    br $B2
                                  end
                                  i64.const 0
                                  local.set $l8
                                  local.get $l3
                                  i32.const 1
                                  i32.add
                                  local.tee $l10
                                  local.get $p2
                                  i32.ge_u
                                  br_if $B2
                                  local.get $p1
                                  local.get $l10
                                  i32.add
                                  i32.load8_s
                                  local.set $l10
                                  local.get $l6
                                  i32.const -224
                                  i32.add
                                  br_table $B17 $B15 $B15 $B15 $B15 $B15 $B15 $B15 $B15 $B15 $B15 $B15 $B15 $B16 $B15
                                end
                                i64.const 0
                                local.set $l8
                                local.get $l3
                                i32.const 1
                                i32.add
                                local.tee $l10
                                local.get $p2
                                i32.ge_u
                                br_if $B2
                                local.get $p1
                                local.get $l10
                                i32.add
                                i32.load8_s
                                local.set $l10
                                block $B21
                                  block $B22
                                    block $B23
                                      block $B24
                                        local.get $l6
                                        i32.const -240
                                        i32.add
                                        br_table $B23 $B24 $B24 $B24 $B22 $B24
                                      end
                                      local.get $l7
                                      i32.const 15
                                      i32.add
                                      i32.const 255
                                      i32.and
                                      i32.const 2
                                      i32.gt_u
                                      br_if $B3
                                      local.get $l10
                                      i32.const -1
                                      i32.gt_s
                                      br_if $B3
                                      local.get $l10
                                      i32.const -64
                                      i32.ge_u
                                      br_if $B3
                                      br $B21
                                    end
                                    local.get $l10
                                    i32.const 112
                                    i32.add
                                    i32.const 255
                                    i32.and
                                    i32.const 48
                                    i32.ge_u
                                    br_if $B3
                                    br $B21
                                  end
                                  local.get $l10
                                  i32.const -113
                                  i32.gt_s
                                  br_if $B3
                                end
                                local.get $l3
                                i32.const 2
                                i32.add
                                local.tee $l6
                                local.get $p2
                                i32.ge_u
                                br_if $B2
                                local.get $p1
                                local.get $l6
                                i32.add
                                i32.load8_s
                                i32.const -65
                                i32.gt_s
                                br_if $B4
                                i64.const 0
                                local.set $l9
                                local.get $l3
                                i32.const 3
                                i32.add
                                local.tee $l6
                                local.get $p2
                                i32.ge_u
                                br_if $B1
                                local.get $p1
                                local.get $l6
                                i32.add
                                i32.load8_s
                                i32.const -65
                                i32.le_s
                                br_if $B12
                                i64.const 3298534883328
                                local.set $l8
                                i64.const 4294967296
                                local.set $l9
                                br $B1
                              end
                              local.get $l10
                              i32.const -32
                              i32.and
                              i32.const -96
                              i32.ne
                              br_if $B3
                              br $B14
                            end
                            local.get $l10
                            i32.const -96
                            i32.ge_s
                            br_if $B3
                            br $B14
                          end
                          block $B25
                            local.get $l7
                            i32.const 31
                            i32.add
                            i32.const 255
                            i32.and
                            i32.const 12
                            i32.lt_u
                            br_if $B25
                            local.get $l7
                            i32.const -2
                            i32.and
                            i32.const -18
                            i32.ne
                            br_if $B3
                            local.get $l10
                            i32.const -1
                            i32.gt_s
                            br_if $B3
                            local.get $l10
                            i32.const -64
                            i32.ge_u
                            br_if $B3
                            br $B14
                          end
                          local.get $l10
                          i32.const -65
                          i32.gt_s
                          br_if $B3
                        end
                        i64.const 0
                        local.set $l9
                        local.get $l3
                        i32.const 2
                        i32.add
                        local.tee $l6
                        local.get $p2
                        i32.ge_u
                        br_if $B1
                        local.get $p1
                        local.get $l6
                        i32.add
                        i32.load8_s
                        i32.const -65
                        i32.gt_s
                        br_if $B4
                        br $B12
                      end
                      i64.const 1099511627776
                      local.set $l8
                      i64.const 4294967296
                      local.set $l9
                      local.get $p1
                      local.get $l6
                      i32.add
                      i32.load8_s
                      i32.const -65
                      i32.gt_s
                      br_if $B1
                    end
                    local.get $l6
                    i32.const 1
                    i32.add
                    local.set $l3
                    br $B6
                  end
                  local.get $l3
                  i32.const 1
                  i32.add
                  local.set $l3
                end
                local.get $l3
                local.get $p2
                i32.lt_u
                br_if $L5
                br $B0
              end
            end
            i64.const 2199023255552
            local.set $l8
            i64.const 4294967296
            local.set $l9
            br $B1
          end
          i64.const 1099511627776
          local.set $l8
          i64.const 4294967296
          local.set $l9
          br $B1
        end
        i64.const 0
        local.set $l9
      end
      local.get $p0
      local.get $l8
      local.get $l3
      i64.extend_i32_u
      i64.or
      local.get $l9
      i64.or
      i64.store offset=4 align=4
      local.get $p0
      i32.const 1
      i32.store
      return
    end
    local.get $p0
    local.get $p1
    i32.store offset=4
    local.get $p0
    i32.const 8
    i32.add
    local.get $p2
    i32.store
    local.get $p0
    i32.const 0
    i32.store)
  (func $_ZN4core3fmt8builders11DebugStruct5field17h8ca46ab58b8a4d20E (type $t13) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (result i32)
    (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i64) (local $l11 i64)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee $l5
    global.set $__stack_pointer
    i32.const 1
    local.set $l6
    block $B0
      local.get $p0
      i32.load8_u offset=4
      br_if $B0
      local.get $p0
      i32.load8_u offset=5
      local.set $l7
      block $B1
        local.get $p0
        i32.load
        local.tee $l8
        i32.load
        local.tee $l9
        i32.const 4
        i32.and
        br_if $B1
        i32.const 1
        local.set $l6
        local.get $l8
        i32.load offset=24
        i32.const 1055933
        i32.const 1055935
        local.get $l7
        i32.const 255
        i32.and
        local.tee $l7
        select
        i32.const 2
        i32.const 3
        local.get $l7
        select
        local.get $l8
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        br_if $B0
        i32.const 1
        local.set $l6
        local.get $l8
        i32.load offset=24
        local.get $p1
        local.get $p2
        local.get $l8
        i32.load offset=28
        i32.load offset=12
        call_indirect $T0 (type $t7)
        br_if $B0
        i32.const 1
        local.set $l6
        local.get $l8
        i32.load offset=24
        i32.const 1055880
        i32.const 2
        local.get $l8
        i32.load offset=28
        i32.load offset=12
        call_indirect $T0 (type $t7)
        br_if $B0
        local.get $p3
        local.get $l8
        local.get $p4
        i32.load offset=12
        call_indirect $T0 (type $t5)
        local.set $l6
        br $B0
      end
      block $B2
        local.get $l7
        i32.const 255
        i32.and
        br_if $B2
        i32.const 1
        local.set $l6
        local.get $l8
        i32.load offset=24
        i32.const 1055928
        i32.const 3
        local.get $l8
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        br_if $B0
        local.get $l8
        i32.load
        local.set $l9
      end
      i32.const 1
      local.set $l6
      local.get $l5
      i32.const 1
      i32.store8 offset=23
      local.get $l5
      i32.const 52
      i32.add
      i32.const 1055900
      i32.store
      local.get $l5
      i32.const 16
      i32.add
      local.get $l5
      i32.const 23
      i32.add
      i32.store
      local.get $l5
      local.get $l9
      i32.store offset=24
      local.get $l5
      local.get $l8
      i64.load offset=24 align=4
      i64.store offset=8
      local.get $l8
      i64.load offset=8 align=4
      local.set $l10
      local.get $l8
      i64.load offset=16 align=4
      local.set $l11
      local.get $l5
      local.get $l8
      i32.load8_u offset=32
      i32.store8 offset=56
      local.get $l5
      local.get $l8
      i32.load offset=4
      i32.store offset=28
      local.get $l5
      local.get $l11
      i64.store offset=40
      local.get $l5
      local.get $l10
      i64.store offset=32
      local.get $l5
      local.get $l5
      i32.const 8
      i32.add
      i32.store offset=48
      local.get $l5
      i32.const 8
      i32.add
      local.get $p1
      local.get $p2
      call $_ZN68_$LT$core..fmt..builders..PadAdapter$u20$as$u20$core..fmt..Write$GT$9write_str17h3703129f2a2ebc77E
      br_if $B0
      local.get $l5
      i32.const 8
      i32.add
      i32.const 1055880
      i32.const 2
      call $_ZN68_$LT$core..fmt..builders..PadAdapter$u20$as$u20$core..fmt..Write$GT$9write_str17h3703129f2a2ebc77E
      br_if $B0
      local.get $p3
      local.get $l5
      i32.const 24
      i32.add
      local.get $p4
      i32.load offset=12
      call_indirect $T0 (type $t5)
      br_if $B0
      local.get $l5
      i32.load offset=48
      i32.const 1055931
      i32.const 2
      local.get $l5
      i32.load offset=52
      i32.load offset=12
      call_indirect $T0 (type $t7)
      local.set $l6
    end
    local.get $p0
    i32.const 1
    i32.store8 offset=5
    local.get $p0
    local.get $l6
    i32.store8 offset=4
    local.get $l5
    i32.const 64
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core6option13expect_failed17h2917b44da418e74cE (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    local.get $p0
    local.get $p1
    local.get $p2
    call $_ZN4core9panicking9panic_str17hf3560372bf18c81dE
    unreachable)
  (func $_ZN4core9panicking9panic_str17hf3560372bf18c81dE (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    local.get $l3
    local.get $p1
    i32.store offset=12
    local.get $l3
    local.get $p0
    i32.store offset=8
    local.get $l3
    i32.const 8
    i32.add
    local.get $p2
    call $_ZN4core9panicking13panic_display17hb00fe441b2cb14e9E
    unreachable)
  (func $_ZN70_$LT$core..panic..location..Location$u20$as$u20$core..fmt..Display$GT$3fmt17ha37547eb9066368cE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    i32.const 20
    i32.add
    i32.const 11
    i32.store
    local.get $l2
    i32.const 12
    i32.add
    i32.const 11
    i32.store
    local.get $l2
    i32.const 78
    i32.store offset=4
    local.get $l2
    local.get $p0
    i32.store
    local.get $l2
    local.get $p0
    i32.const 12
    i32.add
    i32.store offset=16
    local.get $l2
    local.get $p0
    i32.const 8
    i32.add
    i32.store offset=8
    local.get $p1
    i32.const 28
    i32.add
    i32.load
    local.set $p0
    local.get $p1
    i32.load offset=24
    local.set $p1
    local.get $l2
    i32.const 24
    i32.add
    i32.const 20
    i32.add
    i32.const 3
    i32.store
    local.get $l2
    i64.const 3
    i64.store offset=28 align=4
    local.get $l2
    i32.const 1055660
    i32.store offset=24
    local.get $l2
    local.get $l2
    i32.store offset=40
    local.get $p1
    local.get $p0
    local.get $l2
    i32.const 24
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p0
    local.get $l2
    i32.const 48
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17hab770d78211f774aE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p1
    local.get $p0
    i32.load
    local.get $p0
    i32.load offset=4
    call $_ZN4core3fmt9Formatter3pad17hc53f6fdd83e6dddeE)
  (func $_ZN4core5panic10panic_info9PanicInfo7payload17h930eb7a577a32bc1E (type $t3) (param $p0 i32) (param $p1 i32)
    local.get $p0
    local.get $p1
    i64.load align=4
    i64.store)
  (func $_ZN4core5panic10panic_info9PanicInfo7message17h444247787ebca30fE (type $t4) (param $p0 i32) (result i32)
    local.get $p0
    i32.load offset=8)
  (func $_ZN4core5panic10panic_info9PanicInfo8location17h6e78c86147694e2aE (type $t4) (param $p0 i32) (result i32)
    local.get $p0
    i32.load offset=12)
  (func $_ZN4core5panic10panic_info9PanicInfo10can_unwind17hfe60d6e3abc99a98E (type $t4) (param $p0 i32) (result i32)
    local.get $p0
    i32.load8_u offset=16)
  (func $_ZN73_$LT$core..panic..panic_info..PanicInfo$u20$as$u20$core..fmt..Display$GT$3fmt17h92aa18f5879f38f8E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    i32.const 1
    local.set $l3
    block $B0
      local.get $p1
      i32.load offset=24
      local.tee $l4
      i32.const 1055700
      i32.const 12
      local.get $p1
      i32.const 28
      i32.add
      i32.load
      local.tee $p1
      i32.load offset=12
      call_indirect $T0 (type $t7)
      br_if $B0
      block $B1
        block $B2
          local.get $p0
          i32.load offset=8
          local.tee $l3
          i32.eqz
          br_if $B2
          local.get $l2
          local.get $l3
          i32.store offset=12
          local.get $l2
          i32.const 82
          i32.store offset=20
          local.get $l2
          local.get $l2
          i32.const 12
          i32.add
          i32.store offset=16
          i32.const 1
          local.set $l3
          local.get $l2
          i32.const 60
          i32.add
          i32.const 1
          i32.store
          local.get $l2
          i64.const 2
          i64.store offset=44 align=4
          local.get $l2
          i32.const 1055716
          i32.store offset=40
          local.get $l2
          local.get $l2
          i32.const 16
          i32.add
          i32.store offset=56
          local.get $l4
          local.get $p1
          local.get $l2
          i32.const 40
          i32.add
          call $_ZN4core3fmt5write17h64a435d9d6b334f1E
          i32.eqz
          br_if $B1
          br $B0
        end
        local.get $p0
        i32.load
        local.tee $l3
        local.get $p0
        i32.load offset=4
        i32.load offset=12
        call_indirect $T0 (type $t2)
        i64.const -5139102199292759541
        i64.ne
        br_if $B1
        local.get $l2
        local.get $l3
        i32.store offset=12
        local.get $l2
        i32.const 83
        i32.store offset=20
        local.get $l2
        local.get $l2
        i32.const 12
        i32.add
        i32.store offset=16
        i32.const 1
        local.set $l3
        local.get $l2
        i32.const 60
        i32.add
        i32.const 1
        i32.store
        local.get $l2
        i64.const 2
        i64.store offset=44 align=4
        local.get $l2
        i32.const 1055716
        i32.store offset=40
        local.get $l2
        local.get $l2
        i32.const 16
        i32.add
        i32.store offset=56
        local.get $l4
        local.get $p1
        local.get $l2
        i32.const 40
        i32.add
        call $_ZN4core3fmt5write17h64a435d9d6b334f1E
        br_if $B0
      end
      local.get $p0
      i32.load offset=12
      local.set $l3
      local.get $l2
      i32.const 16
      i32.add
      i32.const 20
      i32.add
      i32.const 11
      i32.store
      local.get $l2
      i32.const 16
      i32.add
      i32.const 12
      i32.add
      i32.const 11
      i32.store
      local.get $l2
      local.get $l3
      i32.const 12
      i32.add
      i32.store offset=32
      local.get $l2
      local.get $l3
      i32.const 8
      i32.add
      i32.store offset=24
      local.get $l2
      i32.const 78
      i32.store offset=20
      local.get $l2
      local.get $l3
      i32.store offset=16
      local.get $l2
      i32.const 40
      i32.add
      i32.const 20
      i32.add
      i32.const 3
      i32.store
      local.get $l2
      i64.const 3
      i64.store offset=44 align=4
      local.get $l2
      i32.const 1055660
      i32.store offset=40
      local.get $l2
      local.get $l2
      i32.const 16
      i32.add
      i32.store offset=56
      local.get $l4
      local.get $p1
      local.get $l2
      i32.const 40
      i32.add
      call $_ZN4core3fmt5write17h64a435d9d6b334f1E
      local.set $l3
    end
    local.get $l2
    i32.const 64
    i32.add
    global.set $__stack_pointer
    local.get $l3)
  (func $_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17hec80a8178adb91c2E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p1
    i32.const 28
    i32.add
    i32.load
    local.set $l3
    local.get $p1
    i32.load offset=24
    local.set $l4
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p0
    i32.load
    local.tee $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $l4
    local.get $l3
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h7b04c3954d3816e8E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p1
    local.get $p0
    i32.load
    local.tee $p0
    i32.load
    local.get $p0
    i32.load offset=4
    call $_ZN4core3fmt9Formatter3pad17hc53f6fdd83e6dddeE)
  (func $_ZN4core9panicking13panic_display17hb00fe441b2cb14e9E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    i32.const 20
    i32.add
    i32.const 1
    i32.store
    local.get $l2
    i64.const 1
    i64.store offset=4 align=4
    local.get $l2
    i32.const 1055732
    i32.store
    local.get $l2
    i32.const 78
    i32.store offset=28
    local.get $l2
    local.get $p0
    i32.store offset=24
    local.get $l2
    local.get $l2
    i32.const 24
    i32.add
    i32.store offset=16
    local.get $l2
    local.get $p1
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $_ZN4core9panicking19assert_failed_inner17h109cd054b38eaec9E (type $t14) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (param $p5 i32) (param $p6 i32)
    (local $l7 i32)
    global.get $__stack_pointer
    i32.const 112
    i32.sub
    local.tee $l7
    global.set $__stack_pointer
    local.get $l7
    local.get $p2
    i32.store offset=12
    local.get $l7
    local.get $p1
    i32.store offset=8
    local.get $l7
    local.get $p4
    i32.store offset=20
    local.get $l7
    local.get $p3
    i32.store offset=16
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p0
            i32.const 255
            i32.and
            br_table $B3 $B2 $B1 $B3
          end
          local.get $l7
          i32.const 1055749
          i32.store offset=24
          i32.const 2
          local.set $p0
          br $B0
        end
        local.get $l7
        i32.const 1055747
        i32.store offset=24
        i32.const 2
        local.set $p0
        br $B0
      end
      local.get $l7
      i32.const 1055740
      i32.store offset=24
      i32.const 7
      local.set $p0
    end
    local.get $l7
    local.get $p0
    i32.store offset=28
    block $B4
      local.get $p5
      i32.load
      br_if $B4
      local.get $l7
      i32.const 56
      i32.add
      i32.const 20
      i32.add
      i32.const 84
      i32.store
      local.get $l7
      i32.const 68
      i32.add
      i32.const 84
      i32.store
      local.get $l7
      i32.const 88
      i32.add
      i32.const 20
      i32.add
      i32.const 3
      i32.store
      local.get $l7
      i64.const 4
      i64.store offset=92 align=4
      local.get $l7
      i32.const 1055848
      i32.store offset=88
      local.get $l7
      i32.const 78
      i32.store offset=60
      local.get $l7
      local.get $l7
      i32.const 56
      i32.add
      i32.store offset=104
      local.get $l7
      local.get $l7
      i32.const 16
      i32.add
      i32.store offset=72
      local.get $l7
      local.get $l7
      i32.const 8
      i32.add
      i32.store offset=64
      local.get $l7
      local.get $l7
      i32.const 24
      i32.add
      i32.store offset=56
      local.get $l7
      i32.const 88
      i32.add
      local.get $p6
      call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
      unreachable
    end
    local.get $l7
    i32.const 32
    i32.add
    i32.const 16
    i32.add
    local.get $p5
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l7
    i32.const 32
    i32.add
    i32.const 8
    i32.add
    local.get $p5
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l7
    local.get $p5
    i64.load align=4
    i64.store offset=32
    local.get $l7
    i32.const 88
    i32.add
    i32.const 20
    i32.add
    i32.const 4
    i32.store
    local.get $l7
    i32.const 84
    i32.add
    i32.const 6
    i32.store
    local.get $l7
    i32.const 56
    i32.add
    i32.const 20
    i32.add
    i32.const 84
    i32.store
    local.get $l7
    i32.const 68
    i32.add
    i32.const 84
    i32.store
    local.get $l7
    i64.const 4
    i64.store offset=92 align=4
    local.get $l7
    i32.const 1055812
    i32.store offset=88
    local.get $l7
    i32.const 78
    i32.store offset=60
    local.get $l7
    local.get $l7
    i32.const 56
    i32.add
    i32.store offset=104
    local.get $l7
    local.get $l7
    i32.const 32
    i32.add
    i32.store offset=80
    local.get $l7
    local.get $l7
    i32.const 16
    i32.add
    i32.store offset=72
    local.get $l7
    local.get $l7
    i32.const 8
    i32.add
    i32.store offset=64
    local.get $l7
    local.get $l7
    i32.const 24
    i32.add
    i32.store offset=56
    local.get $l7
    i32.const 88
    i32.add
    local.get $p6
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17had27c1012773a848E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p1
    local.get $p0
    i32.load offset=4
    i32.load offset=12
    call_indirect $T0 (type $t5))
  (func $_ZN59_$LT$core..fmt..Arguments$u20$as$u20$core..fmt..Display$GT$3fmt17hc140c5fbe5de628cE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p1
    i32.const 28
    i32.add
    i32.load
    local.set $l3
    local.get $p1
    i32.load offset=24
    local.set $p1
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p0
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p0
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p0
    i64.load align=4
    i64.store offset=8
    local.get $p1
    local.get $l3
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p0
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core6result13unwrap_failed17hd4950ca6f53bad26E (type $t11) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32)
    (local $l5 i32)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee $l5
    global.set $__stack_pointer
    local.get $l5
    local.get $p1
    i32.store offset=12
    local.get $l5
    local.get $p0
    i32.store offset=8
    local.get $l5
    local.get $p3
    i32.store offset=20
    local.get $l5
    local.get $p2
    i32.store offset=16
    local.get $l5
    i32.const 44
    i32.add
    i32.const 2
    i32.store
    local.get $l5
    i32.const 60
    i32.add
    i32.const 84
    i32.store
    local.get $l5
    i64.const 2
    i64.store offset=28 align=4
    local.get $l5
    i32.const 1055884
    i32.store offset=24
    local.get $l5
    i32.const 78
    i32.store offset=52
    local.get $l5
    local.get $l5
    i32.const 48
    i32.add
    i32.store offset=40
    local.get $l5
    local.get $l5
    i32.const 16
    i32.add
    i32.store offset=56
    local.get $l5
    local.get $l5
    i32.const 8
    i32.add
    i32.store offset=48
    local.get $l5
    i32.const 24
    i32.add
    local.get $p4
    call $_ZN4core9panicking9panic_fmt17h423206782b7e52d3E
    unreachable)
  (func $_ZN68_$LT$core..fmt..builders..PadAdapter$u20$as$u20$core..fmt..Write$GT$9write_str17h3703129f2a2ebc77E (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32)
    block $B0
      block $B1
        local.get $p2
        i32.eqz
        br_if $B1
        local.get $p0
        i32.load offset=4
        local.set $l3
        local.get $p0
        i32.load
        local.set $l4
        local.get $p0
        i32.load offset=8
        local.set $l5
        loop $L2
          block $B3
            local.get $l5
            i32.load8_u
            i32.eqz
            br_if $B3
            local.get $l4
            i32.const 1055924
            i32.const 4
            local.get $l3
            i32.load offset=12
            call_indirect $T0 (type $t7)
            i32.eqz
            br_if $B3
            i32.const 1
            return
          end
          i32.const 0
          local.set $l6
          local.get $p2
          local.set $l7
          block $B4
            block $B5
              block $B6
                block $B7
                  loop $L8
                    local.get $p1
                    local.get $l6
                    i32.add
                    local.set $l8
                    block $B9
                      block $B10
                        block $B11
                          block $B12
                            block $B13
                              local.get $l7
                              i32.const 8
                              i32.lt_u
                              br_if $B13
                              block $B14
                                local.get $l8
                                i32.const 3
                                i32.add
                                i32.const -4
                                i32.and
                                local.get $l8
                                i32.sub
                                local.tee $p0
                                br_if $B14
                                local.get $l7
                                i32.const -8
                                i32.add
                                local.set $l9
                                i32.const 0
                                local.set $p0
                                br $B11
                              end
                              local.get $l7
                              local.get $p0
                              local.get $p0
                              local.get $l7
                              i32.gt_u
                              select
                              local.set $p0
                              i32.const 0
                              local.set $l10
                              loop $L15
                                local.get $l8
                                local.get $l10
                                i32.add
                                i32.load8_u
                                i32.const 10
                                i32.eq
                                br_if $B9
                                local.get $p0
                                local.get $l10
                                i32.const 1
                                i32.add
                                local.tee $l10
                                i32.eq
                                br_if $B12
                                br $L15
                              end
                            end
                            local.get $l7
                            i32.eqz
                            br_if $B7
                            i32.const 0
                            local.set $l10
                            local.get $l8
                            i32.load8_u
                            i32.const 10
                            i32.eq
                            br_if $B9
                            local.get $l7
                            i32.const 1
                            i32.eq
                            br_if $B7
                            i32.const 1
                            local.set $l10
                            local.get $l8
                            i32.load8_u offset=1
                            i32.const 10
                            i32.eq
                            br_if $B9
                            local.get $l7
                            i32.const 2
                            i32.eq
                            br_if $B7
                            i32.const 2
                            local.set $l10
                            local.get $l8
                            i32.load8_u offset=2
                            i32.const 10
                            i32.eq
                            br_if $B9
                            local.get $l7
                            i32.const 3
                            i32.eq
                            br_if $B7
                            i32.const 3
                            local.set $l10
                            local.get $l8
                            i32.load8_u offset=3
                            i32.const 10
                            i32.eq
                            br_if $B9
                            local.get $l7
                            i32.const 4
                            i32.eq
                            br_if $B7
                            i32.const 4
                            local.set $l10
                            local.get $l8
                            i32.load8_u offset=4
                            i32.const 10
                            i32.eq
                            br_if $B9
                            local.get $l7
                            i32.const 5
                            i32.eq
                            br_if $B7
                            i32.const 5
                            local.set $l10
                            local.get $l8
                            i32.load8_u offset=5
                            i32.const 10
                            i32.eq
                            br_if $B9
                            local.get $l7
                            i32.const 6
                            i32.eq
                            br_if $B7
                            i32.const 6
                            local.set $l10
                            local.get $l8
                            i32.load8_u offset=6
                            i32.const 10
                            i32.ne
                            br_if $B7
                            br $B9
                          end
                          local.get $p0
                          local.get $l7
                          i32.const -8
                          i32.add
                          local.tee $l9
                          i32.gt_u
                          br_if $B10
                        end
                        block $B16
                          loop $L17
                            local.get $l8
                            local.get $p0
                            i32.add
                            local.tee $l10
                            i32.load
                            local.tee $l11
                            i32.const -1
                            i32.xor
                            local.get $l11
                            i32.const 168430090
                            i32.xor
                            i32.const -16843009
                            i32.add
                            i32.and
                            local.get $l10
                            i32.const 4
                            i32.add
                            i32.load
                            local.tee $l10
                            i32.const -1
                            i32.xor
                            local.get $l10
                            i32.const 168430090
                            i32.xor
                            i32.const -16843009
                            i32.add
                            i32.and
                            i32.or
                            i32.const -2139062144
                            i32.and
                            br_if $B16
                            local.get $p0
                            i32.const 8
                            i32.add
                            local.tee $p0
                            local.get $l9
                            i32.le_u
                            br_if $L17
                          end
                        end
                        local.get $p0
                        local.get $l7
                        i32.le_u
                        br_if $B10
                        local.get $p0
                        local.get $l7
                        local.get $p0
                        call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
                        unreachable
                      end
                      local.get $p0
                      local.get $l7
                      i32.eq
                      br_if $B7
                      local.get $p0
                      local.get $l7
                      i32.sub
                      local.set $l11
                      local.get $l8
                      local.get $p0
                      i32.add
                      local.set $l8
                      i32.const 0
                      local.set $l10
                      block $B18
                        loop $L19
                          local.get $l8
                          local.get $l10
                          i32.add
                          i32.load8_u
                          i32.const 10
                          i32.eq
                          br_if $B18
                          local.get $l11
                          local.get $l10
                          i32.const 1
                          i32.add
                          local.tee $l10
                          i32.add
                          br_if $L19
                          br $B7
                        end
                      end
                      local.get $p0
                      local.get $l10
                      i32.add
                      local.set $l10
                    end
                    block $B20
                      local.get $l10
                      local.get $l6
                      i32.add
                      local.tee $p0
                      i32.const 1
                      i32.add
                      local.tee $l6
                      local.get $p0
                      i32.lt_u
                      br_if $B20
                      local.get $p2
                      local.get $l6
                      i32.lt_u
                      br_if $B20
                      local.get $p1
                      local.get $p0
                      i32.add
                      i32.load8_u
                      i32.const 10
                      i32.ne
                      br_if $B20
                      local.get $l5
                      i32.const 1
                      i32.store8
                      local.get $p2
                      local.get $l6
                      i32.le_u
                      br_if $B6
                      local.get $l6
                      local.set $p0
                      local.get $p1
                      local.get $l6
                      i32.add
                      i32.load8_s
                      i32.const -65
                      i32.le_s
                      br_if $B5
                      br $B4
                    end
                    local.get $p2
                    local.get $l6
                    i32.sub
                    local.set $l7
                    local.get $p2
                    local.get $l6
                    i32.ge_u
                    br_if $L8
                  end
                end
                local.get $l5
                i32.const 0
                i32.store8
                local.get $p2
                local.set $l6
              end
              local.get $p2
              local.set $p0
              local.get $p2
              local.get $l6
              i32.eq
              br_if $B4
            end
            local.get $p1
            local.get $p2
            i32.const 0
            local.get $l6
            local.get $p0
            call $_ZN4core3str16slice_error_fail17he7b9c5dd5c7360b4E
            unreachable
          end
          block $B21
            local.get $l4
            local.get $p1
            local.get $p0
            local.get $l3
            i32.load offset=12
            call_indirect $T0 (type $t7)
            i32.eqz
            br_if $B21
            i32.const 1
            return
          end
          block $B22
            block $B23
              local.get $p2
              local.get $p0
              i32.gt_u
              br_if $B23
              local.get $p2
              local.get $p0
              i32.eq
              br_if $B22
              br $B0
            end
            local.get $p1
            local.get $p0
            i32.add
            i32.load8_s
            i32.const -65
            i32.le_s
            br_if $B0
          end
          local.get $p1
          local.get $p0
          i32.add
          local.set $p1
          local.get $p2
          local.get $p0
          i32.sub
          local.tee $p2
          br_if $L2
        end
      end
      i32.const 0
      return
    end
    local.get $p1
    local.get $p2
    local.get $p0
    local.get $p2
    local.get $p0
    call $_ZN4core3str16slice_error_fail17he7b9c5dd5c7360b4E
    unreachable)
  (func $_ZN4core3str16slice_error_fail17he7b9c5dd5c7360b4E (type $t11) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32)
    (local $l5 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l5
    global.set $__stack_pointer
    local.get $l5
    local.get $p3
    i32.store offset=12
    local.get $l5
    local.get $p2
    i32.store offset=8
    local.get $l5
    local.get $p1
    i32.store offset=4
    local.get $l5
    local.get $p0
    i32.store
    local.get $l5
    call $_ZN4core10intrinsics17const_eval_select17hfee19707cf86810bE
    unreachable)
  (func $_ZN4core3fmt8builders11DebugStruct21finish_non_exhaustive17h5098ad433d2bf0deE (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l1
    global.set $__stack_pointer
    i32.const 1
    local.set $l2
    block $B0
      local.get $p0
      i32.load8_u offset=4
      br_if $B0
      local.get $p0
      i32.load
      local.set $l3
      block $B1
        local.get $p0
        i32.load8_u offset=5
        br_if $B1
        local.get $l3
        i32.load offset=24
        i32.const 1055948
        i32.const 7
        local.get $l3
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        local.set $l2
        br $B0
      end
      block $B2
        local.get $l3
        i32.load8_u
        i32.const 4
        i32.and
        br_if $B2
        local.get $l3
        i32.load offset=24
        i32.const 1055942
        i32.const 6
        local.get $l3
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        local.set $l2
        br $B0
      end
      i32.const 1
      local.set $l2
      local.get $l1
      i32.const 1
      i32.store8 offset=15
      local.get $l1
      i32.const 8
      i32.add
      local.get $l1
      i32.const 15
      i32.add
      i32.store
      local.get $l1
      local.get $l3
      i64.load offset=24 align=4
      i64.store
      local.get $l1
      i32.const 1055938
      i32.const 3
      call $_ZN68_$LT$core..fmt..builders..PadAdapter$u20$as$u20$core..fmt..Write$GT$9write_str17h3703129f2a2ebc77E
      br_if $B0
      local.get $l3
      i32.load offset=24
      i32.const 1055941
      i32.const 1
      local.get $l3
      i32.load offset=28
      i32.load offset=12
      call_indirect $T0 (type $t7)
      local.set $l2
    end
    local.get $p0
    local.get $l2
    i32.store8 offset=4
    local.get $l1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $l2)
  (func $_ZN4core3fmt8builders10DebugTuple5field17h6c59533708c678f2E (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i64) (local $l9 i64)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    block $B0
      block $B1
        local.get $p0
        i32.load8_u offset=8
        i32.eqz
        br_if $B1
        local.get $p0
        i32.load offset=4
        local.set $l4
        i32.const 1
        local.set $l5
        br $B0
      end
      local.get $p0
      i32.load offset=4
      local.set $l4
      block $B2
        local.get $p0
        i32.load
        local.tee $l6
        i32.load
        local.tee $l7
        i32.const 4
        i32.and
        br_if $B2
        i32.const 1
        local.set $l5
        local.get $l6
        i32.load offset=24
        i32.const 1055933
        i32.const 1055959
        local.get $l4
        select
        i32.const 2
        i32.const 1
        local.get $l4
        select
        local.get $l6
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        br_if $B0
        local.get $p1
        local.get $l6
        local.get $p2
        i32.load offset=12
        call_indirect $T0 (type $t5)
        local.set $l5
        br $B0
      end
      block $B3
        local.get $l4
        br_if $B3
        block $B4
          local.get $l6
          i32.load offset=24
          i32.const 1055957
          i32.const 2
          local.get $l6
          i32.const 28
          i32.add
          i32.load
          i32.load offset=12
          call_indirect $T0 (type $t7)
          i32.eqz
          br_if $B4
          i32.const 1
          local.set $l5
          i32.const 0
          local.set $l4
          br $B0
        end
        local.get $l6
        i32.load
        local.set $l7
      end
      i32.const 1
      local.set $l5
      local.get $l3
      i32.const 1
      i32.store8 offset=23
      local.get $l3
      i32.const 52
      i32.add
      i32.const 1055900
      i32.store
      local.get $l3
      i32.const 16
      i32.add
      local.get $l3
      i32.const 23
      i32.add
      i32.store
      local.get $l3
      local.get $l7
      i32.store offset=24
      local.get $l3
      local.get $l6
      i64.load offset=24 align=4
      i64.store offset=8
      local.get $l6
      i64.load offset=8 align=4
      local.set $l8
      local.get $l6
      i64.load offset=16 align=4
      local.set $l9
      local.get $l3
      local.get $l6
      i32.load8_u offset=32
      i32.store8 offset=56
      local.get $l3
      local.get $l6
      i32.load offset=4
      i32.store offset=28
      local.get $l3
      local.get $l9
      i64.store offset=40
      local.get $l3
      local.get $l8
      i64.store offset=32
      local.get $l3
      local.get $l3
      i32.const 8
      i32.add
      i32.store offset=48
      local.get $p1
      local.get $l3
      i32.const 24
      i32.add
      local.get $p2
      i32.load offset=12
      call_indirect $T0 (type $t5)
      br_if $B0
      local.get $l3
      i32.load offset=48
      i32.const 1055931
      i32.const 2
      local.get $l3
      i32.load offset=52
      i32.load offset=12
      call_indirect $T0 (type $t7)
      local.set $l5
    end
    local.get $p0
    local.get $l5
    i32.store8 offset=8
    local.get $p0
    local.get $l4
    i32.const 1
    i32.add
    i32.store offset=4
    local.get $l3
    i32.const 64
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core3fmt8builders10DebugTuple6finish17h86934b71974f411eE (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32)
    local.get $p0
    i32.load8_u offset=8
    local.set $l1
    block $B0
      local.get $p0
      i32.load offset=4
      local.tee $l2
      i32.eqz
      br_if $B0
      local.get $l1
      i32.const 255
      i32.and
      local.set $l3
      i32.const 1
      local.set $l1
      block $B1
        local.get $l3
        br_if $B1
        local.get $p0
        i32.load
        local.set $l3
        block $B2
          local.get $l2
          i32.const 1
          i32.ne
          br_if $B2
          local.get $p0
          i32.load8_u offset=9
          i32.const 255
          i32.and
          i32.eqz
          br_if $B2
          local.get $l3
          i32.load8_u
          i32.const 4
          i32.and
          br_if $B2
          i32.const 1
          local.set $l1
          local.get $l3
          i32.load offset=24
          i32.const 1055960
          i32.const 1
          local.get $l3
          i32.const 28
          i32.add
          i32.load
          i32.load offset=12
          call_indirect $T0 (type $t7)
          br_if $B1
        end
        local.get $l3
        i32.load offset=24
        i32.const 1055524
        i32.const 1
        local.get $l3
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        local.set $l1
      end
      local.get $p0
      local.get $l1
      i32.store8 offset=8
    end
    local.get $l1
    i32.const 255
    i32.and
    i32.const 0
    i32.ne)
  (func $_ZN4core3fmt8builders10DebugInner5entry17h788b66bf1dea3691E (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i64) (local $l8 i64)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    i32.const 1
    local.set $l4
    block $B0
      local.get $p0
      i32.load8_u offset=4
      br_if $B0
      local.get $p0
      i32.load8_u offset=5
      local.set $l4
      block $B1
        block $B2
          block $B3
            block $B4
              local.get $p0
              i32.load
              local.tee $l5
              i32.load
              local.tee $l6
              i32.const 4
              i32.and
              br_if $B4
              local.get $l4
              i32.const 255
              i32.and
              br_if $B3
              br $B1
            end
            local.get $l4
            i32.const 255
            i32.and
            br_if $B2
            i32.const 1
            local.set $l4
            local.get $l5
            i32.load offset=24
            i32.const 1055961
            i32.const 1
            local.get $l5
            i32.const 28
            i32.add
            i32.load
            i32.load offset=12
            call_indirect $T0 (type $t7)
            br_if $B0
            local.get $l5
            i32.load
            local.set $l6
            br $B2
          end
          i32.const 1
          local.set $l4
          local.get $l5
          i32.load offset=24
          i32.const 1055933
          i32.const 2
          local.get $l5
          i32.const 28
          i32.add
          i32.load
          i32.load offset=12
          call_indirect $T0 (type $t7)
          i32.eqz
          br_if $B1
          br $B0
        end
        i32.const 1
        local.set $l4
        local.get $l3
        i32.const 1
        i32.store8 offset=23
        local.get $l3
        i32.const 52
        i32.add
        i32.const 1055900
        i32.store
        local.get $l3
        i32.const 16
        i32.add
        local.get $l3
        i32.const 23
        i32.add
        i32.store
        local.get $l3
        local.get $l6
        i32.store offset=24
        local.get $l3
        local.get $l5
        i64.load offset=24 align=4
        i64.store offset=8
        local.get $l5
        i64.load offset=8 align=4
        local.set $l7
        local.get $l5
        i64.load offset=16 align=4
        local.set $l8
        local.get $l3
        local.get $l5
        i32.load8_u offset=32
        i32.store8 offset=56
        local.get $l3
        local.get $l5
        i32.load offset=4
        i32.store offset=28
        local.get $l3
        local.get $l8
        i64.store offset=40
        local.get $l3
        local.get $l7
        i64.store offset=32
        local.get $l3
        local.get $l3
        i32.const 8
        i32.add
        i32.store offset=48
        local.get $p1
        local.get $l3
        i32.const 24
        i32.add
        local.get $p2
        i32.load offset=12
        call_indirect $T0 (type $t5)
        br_if $B0
        local.get $l3
        i32.load offset=48
        i32.const 1055931
        i32.const 2
        local.get $l3
        i32.load offset=52
        i32.load offset=12
        call_indirect $T0 (type $t7)
        local.set $l4
        br $B0
      end
      local.get $p1
      local.get $l5
      local.get $p2
      i32.load offset=12
      call_indirect $T0 (type $t5)
      local.set $l4
    end
    local.get $p0
    i32.const 1
    i32.store8 offset=5
    local.get $p0
    local.get $l4
    i32.store8 offset=4
    local.get $l3
    i32.const 64
    i32.add
    global.set $__stack_pointer)
  (func $_ZN4core3fmt8builders8DebugSet5entry17h0fae2f4ef74004beE (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    local.get $p0
    local.get $p1
    local.get $p2
    call $_ZN4core3fmt8builders10DebugInner5entry17h788b66bf1dea3691E
    local.get $p0)
  (func $_ZN4core3fmt8builders9DebugList6finish17h3099dece06213f22E (type $t4) (param $p0 i32) (result i32)
    (local $l1 i32)
    i32.const 1
    local.set $l1
    block $B0
      local.get $p0
      i32.load8_u offset=4
      br_if $B0
      local.get $p0
      i32.load
      local.tee $p0
      i32.load offset=24
      i32.const 1055980
      i32.const 1
      local.get $p0
      i32.load offset=28
      i32.load offset=12
      call_indirect $T0 (type $t7)
      local.set $l1
    end
    local.get $l1)
  (func $_ZN4core3fmt9Formatter12pad_integral17h34779d061fe7ddecE (type $t15) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (param $p5 i32) (result i32)
    (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32)
    block $B0
      block $B1
        local.get $p1
        i32.eqz
        br_if $B1
        i32.const 43
        i32.const 1114112
        local.get $p0
        i32.load
        local.tee $p1
        i32.const 1
        i32.and
        local.tee $l6
        select
        local.set $l7
        local.get $l6
        local.get $p5
        i32.add
        local.set $l8
        br $B0
      end
      local.get $p5
      i32.const 1
      i32.add
      local.set $l8
      local.get $p0
      i32.load
      local.set $p1
      i32.const 45
      local.set $l7
    end
    block $B2
      block $B3
        local.get $p1
        i32.const 4
        i32.and
        br_if $B3
        i32.const 0
        local.set $p2
        br $B2
      end
      block $B4
        block $B5
          local.get $p3
          i32.const 16
          i32.lt_u
          br_if $B5
          local.get $p2
          local.get $p3
          call $_ZN4core3str5count14do_count_chars17hd660a7601d857072E
          local.set $l6
          br $B4
        end
        block $B6
          local.get $p3
          br_if $B6
          i32.const 0
          local.set $l6
          br $B4
        end
        local.get $p3
        i32.const 3
        i32.and
        local.set $l9
        block $B7
          block $B8
            local.get $p3
            i32.const -1
            i32.add
            i32.const 3
            i32.ge_u
            br_if $B8
            i32.const 0
            local.set $l6
            local.get $p2
            local.set $p1
            br $B7
          end
          local.get $p3
          i32.const -4
          i32.and
          local.set $l10
          i32.const 0
          local.set $l6
          local.get $p2
          local.set $p1
          loop $L9
            local.get $l6
            local.get $p1
            i32.load8_s
            i32.const -65
            i32.gt_s
            i32.add
            local.get $p1
            i32.const 1
            i32.add
            i32.load8_s
            i32.const -65
            i32.gt_s
            i32.add
            local.get $p1
            i32.const 2
            i32.add
            i32.load8_s
            i32.const -65
            i32.gt_s
            i32.add
            local.get $p1
            i32.const 3
            i32.add
            i32.load8_s
            i32.const -65
            i32.gt_s
            i32.add
            local.set $l6
            local.get $p1
            i32.const 4
            i32.add
            local.set $p1
            local.get $l10
            i32.const -4
            i32.add
            local.tee $l10
            br_if $L9
          end
        end
        local.get $l9
        i32.eqz
        br_if $B4
        loop $L10
          local.get $l6
          local.get $p1
          i32.load8_s
          i32.const -65
          i32.gt_s
          i32.add
          local.set $l6
          local.get $p1
          i32.const 1
          i32.add
          local.set $p1
          local.get $l9
          i32.const -1
          i32.add
          local.tee $l9
          br_if $L10
        end
      end
      local.get $l6
      local.get $l8
      i32.add
      local.set $l8
    end
    block $B11
      block $B12
        local.get $p0
        i32.load offset=8
        br_if $B12
        i32.const 1
        local.set $p1
        local.get $p0
        local.get $l7
        local.get $p2
        local.get $p3
        call $_ZN4core3fmt9Formatter12pad_integral12write_prefix17h27a8fcb1f6babcf5E
        br_if $B11
        local.get $p0
        i32.load offset=24
        local.get $p4
        local.get $p5
        local.get $p0
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        return
      end
      block $B13
        block $B14
          block $B15
            block $B16
              block $B17
                local.get $p0
                i32.const 12
                i32.add
                i32.load
                local.tee $l6
                local.get $l8
                i32.le_u
                br_if $B17
                local.get $p0
                i32.load8_u
                i32.const 8
                i32.and
                br_if $B13
                i32.const 0
                local.set $p1
                local.get $l6
                local.get $l8
                i32.sub
                local.tee $l9
                local.set $l8
                i32.const 1
                local.get $p0
                i32.load8_u offset=32
                local.tee $l6
                local.get $l6
                i32.const 3
                i32.eq
                select
                i32.const 3
                i32.and
                br_table $B14 $B16 $B15 $B14
              end
              i32.const 1
              local.set $p1
              local.get $p0
              local.get $l7
              local.get $p2
              local.get $p3
              call $_ZN4core3fmt9Formatter12pad_integral12write_prefix17h27a8fcb1f6babcf5E
              br_if $B11
              local.get $p0
              i32.load offset=24
              local.get $p4
              local.get $p5
              local.get $p0
              i32.const 28
              i32.add
              i32.load
              i32.load offset=12
              call_indirect $T0 (type $t7)
              return
            end
            i32.const 0
            local.set $l8
            local.get $l9
            local.set $p1
            br $B14
          end
          local.get $l9
          i32.const 1
          i32.shr_u
          local.set $p1
          local.get $l9
          i32.const 1
          i32.add
          i32.const 1
          i32.shr_u
          local.set $l8
        end
        local.get $p1
        i32.const 1
        i32.add
        local.set $p1
        local.get $p0
        i32.const 28
        i32.add
        i32.load
        local.set $l9
        local.get $p0
        i32.load offset=4
        local.set $l6
        local.get $p0
        i32.load offset=24
        local.set $l10
        block $B18
          loop $L19
            local.get $p1
            i32.const -1
            i32.add
            local.tee $p1
            i32.eqz
            br_if $B18
            local.get $l10
            local.get $l6
            local.get $l9
            i32.load offset=16
            call_indirect $T0 (type $t5)
            i32.eqz
            br_if $L19
          end
          i32.const 1
          return
        end
        i32.const 1
        local.set $p1
        local.get $l6
        i32.const 1114112
        i32.eq
        br_if $B11
        local.get $p0
        local.get $l7
        local.get $p2
        local.get $p3
        call $_ZN4core3fmt9Formatter12pad_integral12write_prefix17h27a8fcb1f6babcf5E
        br_if $B11
        local.get $p0
        i32.load offset=24
        local.get $p4
        local.get $p5
        local.get $p0
        i32.load offset=28
        i32.load offset=12
        call_indirect $T0 (type $t7)
        br_if $B11
        local.get $p0
        i32.load offset=28
        local.set $l9
        local.get $p0
        i32.load offset=24
        local.set $p0
        i32.const 0
        local.set $p1
        block $B20
          loop $L21
            block $B22
              local.get $l8
              local.get $p1
              i32.ne
              br_if $B22
              local.get $l8
              local.set $p1
              br $B20
            end
            local.get $p1
            i32.const 1
            i32.add
            local.set $p1
            local.get $p0
            local.get $l6
            local.get $l9
            i32.load offset=16
            call_indirect $T0 (type $t5)
            i32.eqz
            br_if $L21
          end
          local.get $p1
          i32.const -1
          i32.add
          local.set $p1
        end
        local.get $p1
        local.get $l8
        i32.lt_u
        local.set $p1
        br $B11
      end
      local.get $p0
      i32.load offset=4
      local.set $l11
      local.get $p0
      i32.const 48
      i32.store offset=4
      local.get $p0
      i32.load8_u offset=32
      local.set $l12
      i32.const 1
      local.set $p1
      local.get $p0
      i32.const 1
      i32.store8 offset=32
      local.get $p0
      local.get $l7
      local.get $p2
      local.get $p3
      call $_ZN4core3fmt9Formatter12pad_integral12write_prefix17h27a8fcb1f6babcf5E
      br_if $B11
      i32.const 0
      local.set $p1
      local.get $l6
      local.get $l8
      i32.sub
      local.tee $l9
      local.set $p3
      block $B23
        block $B24
          block $B25
            i32.const 1
            local.get $p0
            i32.load8_u offset=32
            local.tee $l6
            local.get $l6
            i32.const 3
            i32.eq
            select
            i32.const 3
            i32.and
            br_table $B23 $B25 $B24 $B23
          end
          i32.const 0
          local.set $p3
          local.get $l9
          local.set $p1
          br $B23
        end
        local.get $l9
        i32.const 1
        i32.shr_u
        local.set $p1
        local.get $l9
        i32.const 1
        i32.add
        i32.const 1
        i32.shr_u
        local.set $p3
      end
      local.get $p1
      i32.const 1
      i32.add
      local.set $p1
      local.get $p0
      i32.const 28
      i32.add
      i32.load
      local.set $l9
      local.get $p0
      i32.load offset=4
      local.set $l6
      local.get $p0
      i32.load offset=24
      local.set $l10
      block $B26
        loop $L27
          local.get $p1
          i32.const -1
          i32.add
          local.tee $p1
          i32.eqz
          br_if $B26
          local.get $l10
          local.get $l6
          local.get $l9
          i32.load offset=16
          call_indirect $T0 (type $t5)
          i32.eqz
          br_if $L27
        end
        i32.const 1
        return
      end
      i32.const 1
      local.set $p1
      local.get $l6
      i32.const 1114112
      i32.eq
      br_if $B11
      local.get $p0
      i32.load offset=24
      local.get $p4
      local.get $p5
      local.get $p0
      i32.load offset=28
      i32.load offset=12
      call_indirect $T0 (type $t7)
      br_if $B11
      local.get $p0
      i32.load offset=28
      local.set $p1
      local.get $p0
      i32.load offset=24
      local.set $l10
      i32.const 0
      local.set $l9
      block $B28
        loop $L29
          local.get $p3
          local.get $l9
          i32.eq
          br_if $B28
          local.get $l9
          i32.const 1
          i32.add
          local.set $l9
          local.get $l10
          local.get $l6
          local.get $p1
          i32.load offset=16
          call_indirect $T0 (type $t5)
          i32.eqz
          br_if $L29
        end
        i32.const 1
        local.set $p1
        local.get $l9
        i32.const -1
        i32.add
        local.get $p3
        i32.lt_u
        br_if $B11
      end
      local.get $p0
      local.get $l12
      i32.store8 offset=32
      local.get $p0
      local.get $l11
      i32.store offset=4
      i32.const 0
      return
    end
    local.get $p1)
  (func $_ZN4core3fmt5Write10write_char17he27bd04cb173bf5eE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    i32.const 0
    i32.store offset=12
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p1
            i32.const 128
            i32.lt_u
            br_if $B3
            local.get $p1
            i32.const 2048
            i32.lt_u
            br_if $B2
            local.get $p1
            i32.const 65536
            i32.ge_u
            br_if $B1
            local.get $l2
            local.get $p1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=14
            local.get $l2
            local.get $p1
            i32.const 12
            i32.shr_u
            i32.const 224
            i32.or
            i32.store8 offset=12
            local.get $l2
            local.get $p1
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=13
            i32.const 3
            local.set $p1
            br $B0
          end
          local.get $l2
          local.get $p1
          i32.store8 offset=12
          i32.const 1
          local.set $p1
          br $B0
        end
        local.get $l2
        local.get $p1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=13
        local.get $l2
        local.get $p1
        i32.const 6
        i32.shr_u
        i32.const 192
        i32.or
        i32.store8 offset=12
        i32.const 2
        local.set $p1
        br $B0
      end
      local.get $l2
      local.get $p1
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=15
      local.get $l2
      local.get $p1
      i32.const 18
      i32.shr_u
      i32.const 240
      i32.or
      i32.store8 offset=12
      local.get $l2
      local.get $p1
      i32.const 6
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=14
      local.get $l2
      local.get $p1
      i32.const 12
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=13
      i32.const 4
      local.set $p1
    end
    local.get $p0
    local.get $l2
    i32.const 12
    i32.add
    local.get $p1
    call $_ZN68_$LT$core..fmt..builders..PadAdapter$u20$as$u20$core..fmt..Write$GT$9write_str17h3703129f2a2ebc77E
    local.set $p1
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN4core3fmt5Write9write_fmt17hae929550dd37b3daE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p0
    i32.store offset=4
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $l2
    i32.const 4
    i32.add
    i32.const 1056184
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17h0bcbeb4e8005a6f0E (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p1
    local.get $p2
    call $_ZN68_$LT$core..fmt..builders..PadAdapter$u20$as$u20$core..fmt..Write$GT$9write_str17h3703129f2a2ebc77E)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17haeb61a38da6b2cc4E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p0
    i32.load
    local.set $p0
    local.get $l2
    i32.const 0
    i32.store offset=12
    block $B0
      block $B1
        block $B2
          block $B3
            local.get $p1
            i32.const 128
            i32.lt_u
            br_if $B3
            local.get $p1
            i32.const 2048
            i32.lt_u
            br_if $B2
            local.get $p1
            i32.const 65536
            i32.ge_u
            br_if $B1
            local.get $l2
            local.get $p1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=14
            local.get $l2
            local.get $p1
            i32.const 12
            i32.shr_u
            i32.const 224
            i32.or
            i32.store8 offset=12
            local.get $l2
            local.get $p1
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=13
            i32.const 3
            local.set $p1
            br $B0
          end
          local.get $l2
          local.get $p1
          i32.store8 offset=12
          i32.const 1
          local.set $p1
          br $B0
        end
        local.get $l2
        local.get $p1
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=13
        local.get $l2
        local.get $p1
        i32.const 6
        i32.shr_u
        i32.const 192
        i32.or
        i32.store8 offset=12
        i32.const 2
        local.set $p1
        br $B0
      end
      local.get $l2
      local.get $p1
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=15
      local.get $l2
      local.get $p1
      i32.const 18
      i32.shr_u
      i32.const 240
      i32.or
      i32.store8 offset=12
      local.get $l2
      local.get $p1
      i32.const 6
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=14
      local.get $l2
      local.get $p1
      i32.const 12
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=13
      i32.const 4
      local.set $p1
    end
    local.get $p0
    local.get $l2
    i32.const 12
    i32.add
    local.get $p1
    call $_ZN68_$LT$core..fmt..builders..PadAdapter$u20$as$u20$core..fmt..Write$GT$9write_str17h3703129f2a2ebc77E
    local.set $p1
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17hf53b98eb9a081c42E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $l2
    local.get $p0
    i32.load
    i32.store offset=4
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $l2
    i32.const 4
    i32.add
    i32.const 1056184
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN4core3str5count14do_count_chars17hd660a7601d857072E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32)
    block $B0
      block $B1
        local.get $p0
        i32.const 3
        i32.add
        i32.const -4
        i32.and
        local.tee $l2
        local.get $p0
        i32.sub
        local.tee $l3
        local.get $p1
        i32.gt_u
        br_if $B1
        local.get $l3
        i32.const 4
        i32.gt_u
        br_if $B1
        local.get $p1
        local.get $l3
        i32.sub
        local.tee $l4
        i32.const 4
        i32.lt_u
        br_if $B1
        local.get $l4
        i32.const 3
        i32.and
        local.set $l5
        i32.const 0
        local.set $l6
        i32.const 0
        local.set $p1
        block $B2
          local.get $l3
          i32.eqz
          br_if $B2
          local.get $l3
          i32.const 3
          i32.and
          local.set $l7
          block $B3
            block $B4
              local.get $l2
              local.get $p0
              i32.const -1
              i32.xor
              i32.add
              i32.const 3
              i32.ge_u
              br_if $B4
              i32.const 0
              local.set $p1
              local.get $p0
              local.set $l2
              br $B3
            end
            local.get $l3
            i32.const -4
            i32.and
            local.set $l8
            i32.const 0
            local.set $p1
            local.get $p0
            local.set $l2
            loop $L5
              local.get $p1
              local.get $l2
              i32.load8_s
              i32.const -65
              i32.gt_s
              i32.add
              local.get $l2
              i32.const 1
              i32.add
              i32.load8_s
              i32.const -65
              i32.gt_s
              i32.add
              local.get $l2
              i32.const 2
              i32.add
              i32.load8_s
              i32.const -65
              i32.gt_s
              i32.add
              local.get $l2
              i32.const 3
              i32.add
              i32.load8_s
              i32.const -65
              i32.gt_s
              i32.add
              local.set $p1
              local.get $l2
              i32.const 4
              i32.add
              local.set $l2
              local.get $l8
              i32.const -4
              i32.add
              local.tee $l8
              br_if $L5
            end
          end
          local.get $l7
          i32.eqz
          br_if $B2
          loop $L6
            local.get $p1
            local.get $l2
            i32.load8_s
            i32.const -65
            i32.gt_s
            i32.add
            local.set $p1
            local.get $l2
            i32.const 1
            i32.add
            local.set $l2
            local.get $l7
            i32.const -1
            i32.add
            local.tee $l7
            br_if $L6
          end
        end
        local.get $p0
        local.get $l3
        i32.add
        local.set $p0
        block $B7
          local.get $l5
          i32.eqz
          br_if $B7
          local.get $p0
          local.get $l4
          i32.const -4
          i32.and
          i32.add
          local.tee $l2
          i32.load8_s
          i32.const -65
          i32.gt_s
          local.set $l6
          local.get $l5
          i32.const 1
          i32.eq
          br_if $B7
          local.get $l6
          local.get $l2
          i32.load8_s offset=1
          i32.const -65
          i32.gt_s
          i32.add
          local.set $l6
          local.get $l5
          i32.const 2
          i32.eq
          br_if $B7
          local.get $l6
          local.get $l2
          i32.load8_s offset=2
          i32.const -65
          i32.gt_s
          i32.add
          local.set $l6
        end
        local.get $l4
        i32.const 2
        i32.shr_u
        local.set $l3
        local.get $l6
        local.get $p1
        i32.add
        local.set $l8
        loop $L8
          local.get $p0
          local.set $l6
          local.get $l3
          i32.eqz
          br_if $B0
          local.get $l3
          i32.const 192
          local.get $l3
          i32.const 192
          i32.lt_u
          select
          local.tee $l4
          i32.const 3
          i32.and
          local.set $l5
          local.get $l4
          i32.const 2
          i32.shl
          local.set $l9
          block $B9
            block $B10
              local.get $l4
              i32.const 252
              i32.and
              local.tee $l10
              i32.const 2
              i32.shl
              local.tee $p0
              br_if $B10
              i32.const 0
              local.set $l2
              br $B9
            end
            local.get $l6
            local.get $p0
            i32.add
            local.set $l7
            i32.const 0
            local.set $l2
            local.get $l6
            local.set $p0
            loop $L11
              local.get $p0
              i32.const 12
              i32.add
              i32.load
              local.tee $p1
              i32.const -1
              i32.xor
              i32.const 7
              i32.shr_u
              local.get $p1
              i32.const 6
              i32.shr_u
              i32.or
              i32.const 16843009
              i32.and
              local.get $p0
              i32.const 8
              i32.add
              i32.load
              local.tee $p1
              i32.const -1
              i32.xor
              i32.const 7
              i32.shr_u
              local.get $p1
              i32.const 6
              i32.shr_u
              i32.or
              i32.const 16843009
              i32.and
              local.get $p0
              i32.const 4
              i32.add
              i32.load
              local.tee $p1
              i32.const -1
              i32.xor
              i32.const 7
              i32.shr_u
              local.get $p1
              i32.const 6
              i32.shr_u
              i32.or
              i32.const 16843009
              i32.and
              local.get $p0
              i32.load
              local.tee $p1
              i32.const -1
              i32.xor
              i32.const 7
              i32.shr_u
              local.get $p1
              i32.const 6
              i32.shr_u
              i32.or
              i32.const 16843009
              i32.and
              local.get $l2
              i32.add
              i32.add
              i32.add
              i32.add
              local.set $l2
              local.get $p0
              i32.const 16
              i32.add
              local.tee $p0
              local.get $l7
              i32.ne
              br_if $L11
            end
          end
          local.get $l6
          local.get $l9
          i32.add
          local.set $p0
          local.get $l3
          local.get $l4
          i32.sub
          local.set $l3
          local.get $l2
          i32.const 8
          i32.shr_u
          i32.const 16711935
          i32.and
          local.get $l2
          i32.const 16711935
          i32.and
          i32.add
          i32.const 65537
          i32.mul
          i32.const 16
          i32.shr_u
          local.get $l8
          i32.add
          local.set $l8
          local.get $l5
          i32.eqz
          br_if $L8
        end
        local.get $l6
        local.get $l10
        i32.const 2
        i32.shl
        i32.add
        local.set $p0
        local.get $l5
        i32.const 1073741823
        i32.add
        local.tee $l4
        i32.const 1073741823
        i32.and
        local.tee $l2
        i32.const 1
        i32.add
        local.tee $p1
        i32.const 3
        i32.and
        local.set $l3
        block $B12
          block $B13
            local.get $l2
            i32.const 3
            i32.ge_u
            br_if $B13
            i32.const 0
            local.set $l2
            br $B12
          end
          local.get $p1
          i32.const 2147483644
          i32.and
          local.set $p1
          i32.const 0
          local.set $l2
          loop $L14
            local.get $p0
            i32.const 12
            i32.add
            i32.load
            local.tee $l7
            i32.const -1
            i32.xor
            i32.const 7
            i32.shr_u
            local.get $l7
            i32.const 6
            i32.shr_u
            i32.or
            i32.const 16843009
            i32.and
            local.get $p0
            i32.const 8
            i32.add
            i32.load
            local.tee $l7
            i32.const -1
            i32.xor
            i32.const 7
            i32.shr_u
            local.get $l7
            i32.const 6
            i32.shr_u
            i32.or
            i32.const 16843009
            i32.and
            local.get $p0
            i32.const 4
            i32.add
            i32.load
            local.tee $l7
            i32.const -1
            i32.xor
            i32.const 7
            i32.shr_u
            local.get $l7
            i32.const 6
            i32.shr_u
            i32.or
            i32.const 16843009
            i32.and
            local.get $p0
            i32.load
            local.tee $l7
            i32.const -1
            i32.xor
            i32.const 7
            i32.shr_u
            local.get $l7
            i32.const 6
            i32.shr_u
            i32.or
            i32.const 16843009
            i32.and
            local.get $l2
            i32.add
            i32.add
            i32.add
            i32.add
            local.set $l2
            local.get $p0
            i32.const 16
            i32.add
            local.set $p0
            local.get $p1
            i32.const -4
            i32.add
            local.tee $p1
            br_if $L14
          end
        end
        block $B15
          local.get $l3
          i32.eqz
          br_if $B15
          local.get $l4
          i32.const -1073741823
          i32.add
          local.set $p1
          loop $L16
            local.get $p0
            i32.load
            local.tee $l7
            i32.const -1
            i32.xor
            i32.const 7
            i32.shr_u
            local.get $l7
            i32.const 6
            i32.shr_u
            i32.or
            i32.const 16843009
            i32.and
            local.get $l2
            i32.add
            local.set $l2
            local.get $p0
            i32.const 4
            i32.add
            local.set $p0
            local.get $p1
            i32.const -1
            i32.add
            local.tee $p1
            br_if $L16
          end
        end
        local.get $l2
        i32.const 8
        i32.shr_u
        i32.const 16711935
        i32.and
        local.get $l2
        i32.const 16711935
        i32.and
        i32.add
        i32.const 65537
        i32.mul
        i32.const 16
        i32.shr_u
        local.get $l8
        i32.add
        return
      end
      block $B17
        local.get $p1
        br_if $B17
        i32.const 0
        return
      end
      local.get $p1
      i32.const 3
      i32.and
      local.set $l2
      block $B18
        block $B19
          local.get $p1
          i32.const -1
          i32.add
          i32.const 3
          i32.ge_u
          br_if $B19
          i32.const 0
          local.set $l8
          br $B18
        end
        local.get $p1
        i32.const -4
        i32.and
        local.set $p1
        i32.const 0
        local.set $l8
        loop $L20
          local.get $l8
          local.get $p0
          i32.load8_s
          i32.const -65
          i32.gt_s
          i32.add
          local.get $p0
          i32.const 1
          i32.add
          i32.load8_s
          i32.const -65
          i32.gt_s
          i32.add
          local.get $p0
          i32.const 2
          i32.add
          i32.load8_s
          i32.const -65
          i32.gt_s
          i32.add
          local.get $p0
          i32.const 3
          i32.add
          i32.load8_s
          i32.const -65
          i32.gt_s
          i32.add
          local.set $l8
          local.get $p0
          i32.const 4
          i32.add
          local.set $p0
          local.get $p1
          i32.const -4
          i32.add
          local.tee $p1
          br_if $L20
        end
      end
      local.get $l2
      i32.eqz
      br_if $B0
      loop $L21
        local.get $l8
        local.get $p0
        i32.load8_s
        i32.const -65
        i32.gt_s
        i32.add
        local.set $l8
        local.get $p0
        i32.const 1
        i32.add
        local.set $p0
        local.get $l2
        i32.const -1
        i32.add
        local.tee $l2
        br_if $L21
      end
    end
    local.get $l8)
  (func $_ZN4core3fmt9Formatter12pad_integral12write_prefix17h27a8fcb1f6babcf5E (type $t8) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    (local $l4 i32)
    block $B0
      block $B1
        block $B2
          local.get $p1
          i32.const 1114112
          i32.eq
          br_if $B2
          i32.const 1
          local.set $l4
          local.get $p0
          i32.load offset=24
          local.get $p1
          local.get $p0
          i32.const 28
          i32.add
          i32.load
          i32.load offset=16
          call_indirect $T0 (type $t5)
          br_if $B1
        end
        local.get $p2
        br_if $B0
        i32.const 0
        local.set $l4
      end
      local.get $l4
      return
    end
    local.get $p0
    i32.load offset=24
    local.get $p2
    local.get $p3
    local.get $p0
    i32.const 28
    i32.add
    i32.load
    i32.load offset=12
    call_indirect $T0 (type $t7))
  (func $_ZN4core3fmt9Formatter9write_fmt17h3c92d3032e5cf8d7E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p0
    i32.const 28
    i32.add
    i32.load
    local.set $l3
    local.get $p0
    i32.load offset=24
    local.set $p0
    local.get $l2
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get $p1
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get $p1
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get $l2
    local.get $p1
    i64.load align=4
    i64.store offset=8
    local.get $p0
    local.get $l3
    local.get $l2
    i32.const 8
    i32.add
    call $_ZN4core3fmt5write17h64a435d9d6b334f1E
    local.set $p1
    local.get $l2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN4core3fmt9Formatter15debug_lower_hex17h5784f1a3a7e69120E (type $t4) (param $p0 i32) (result i32)
    local.get $p0
    i32.load8_u
    i32.const 16
    i32.and
    i32.const 4
    i32.shr_u)
  (func $_ZN4core3fmt9Formatter15debug_upper_hex17h79028864c05f503cE (type $t4) (param $p0 i32) (result i32)
    local.get $p0
    i32.load8_u
    i32.const 32
    i32.and
    i32.const 5
    i32.shr_u)
  (func $_ZN4core3fmt9Formatter12debug_struct17hbab99b39a6f88cb8E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    local.get $p1
    i32.load offset=24
    local.get $p2
    local.get $p3
    local.get $p1
    i32.const 28
    i32.add
    i32.load
    i32.load offset=12
    call_indirect $T0 (type $t7)
    local.set $p2
    local.get $p0
    i32.const 0
    i32.store8 offset=5
    local.get $p0
    local.get $p2
    i32.store8 offset=4
    local.get $p0
    local.get $p1
    i32.store)
  (func $_ZN4core3fmt9Formatter11debug_tuple17h75af657b8f60803eE (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    local.get $p0
    local.get $p1
    i32.load offset=24
    local.get $p2
    local.get $p3
    local.get $p1
    i32.const 28
    i32.add
    i32.load
    i32.load offset=12
    call_indirect $T0 (type $t7)
    i32.store8 offset=8
    local.get $p0
    local.get $p1
    i32.store
    local.get $p0
    local.get $p3
    i32.eqz
    i32.store8 offset=9
    local.get $p0
    i32.const 0
    i32.store offset=4)
  (func $_ZN4core3fmt9Formatter10debug_list17hec2a4885c09cdb02E (type $t3) (param $p0 i32) (param $p1 i32)
    (local $l2 i32)
    local.get $p1
    i32.load offset=24
    i32.const 1055962
    i32.const 1
    local.get $p1
    i32.const 28
    i32.add
    i32.load
    i32.load offset=12
    call_indirect $T0 (type $t7)
    local.set $l2
    local.get $p0
    i32.const 0
    i32.store8 offset=5
    local.get $p0
    local.get $l2
    i32.store8 offset=4
    local.get $p0
    local.get $p1
    i32.store)
  (func $_ZN43_$LT$bool$u20$as$u20$core..fmt..Display$GT$3fmt17h006a38274750e12bE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    block $B0
      local.get $p0
      i32.load8_u
      br_if $B0
      local.get $p1
      i32.const 1056212
      i32.const 5
      call $_ZN4core3fmt9Formatter3pad17hc53f6fdd83e6dddeE
      return
    end
    local.get $p1
    i32.const 1056208
    i32.const 4
    call $_ZN4core3fmt9Formatter3pad17hc53f6fdd83e6dddeE)
  (func $_ZN42_$LT$str$u20$as$u20$core..fmt..Display$GT$3fmt17hea89db8dbf1ee6c5E (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    local.get $p2
    local.get $p0
    local.get $p1
    call $_ZN4core3fmt9Formatter3pad17hc53f6fdd83e6dddeE)
  (func $_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h2b60a9a92e5cb373E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    i32.const 1
    local.set $l3
    block $B0
      local.get $p1
      i32.load offset=24
      local.tee $l4
      i32.const 39
      local.get $p1
      i32.const 28
      i32.add
      i32.load
      i32.load offset=16
      local.tee $l5
      call_indirect $T0 (type $t5)
      br_if $B0
      local.get $l2
      local.get $p0
      i32.load
      i32.const 257
      call $_ZN4core4char7methods22_$LT$impl$u20$char$GT$16escape_debug_ext17ha8ae248e617d0d21E
      local.get $l2
      i32.const 12
      i32.add
      i32.load8_u
      local.set $l6
      local.get $l2
      i32.const 8
      i32.add
      i32.load
      local.set $l7
      local.get $l2
      i32.load
      local.set $p1
      block $B1
        block $B2
          block $B3
            local.get $l2
            i32.load offset=4
            local.tee $l8
            i32.const 1114112
            i32.eq
            br_if $B3
            loop $L4
              local.get $p1
              local.set $p0
              i32.const 92
              local.set $l3
              i32.const 1
              local.set $p1
              block $B5
                block $B6
                  block $B7
                    block $B8
                      local.get $p0
                      br_table $B1 $B7 $B5 $B8 $B1
                    end
                    local.get $l6
                    i32.const 255
                    i32.and
                    local.set $p0
                    i32.const 0
                    local.set $l6
                    i32.const 3
                    local.set $p1
                    i32.const 125
                    local.set $l3
                    block $B9
                      block $B10
                        block $B11
                          local.get $p0
                          br_table $B1 $B5 $B6 $B11 $B10 $B9 $B1
                        end
                        i32.const 2
                        local.set $l6
                        i32.const 123
                        local.set $l3
                        br $B5
                      end
                      i32.const 3
                      local.set $p1
                      i32.const 117
                      local.set $l3
                      i32.const 3
                      local.set $l6
                      br $B5
                    end
                    i32.const 4
                    local.set $l6
                    i32.const 92
                    local.set $l3
                    br $B5
                  end
                  i32.const 0
                  local.set $p1
                  local.get $l8
                  local.set $l3
                  br $B5
                end
                i32.const 2
                i32.const 1
                local.get $l7
                select
                local.set $l6
                i32.const 48
                i32.const 87
                local.get $l8
                local.get $l7
                i32.const 2
                i32.shl
                i32.shr_u
                i32.const 15
                i32.and
                local.tee $l3
                i32.const 10
                i32.lt_u
                select
                local.get $l3
                i32.add
                local.set $l3
                local.get $l7
                i32.const -1
                i32.add
                i32.const 0
                local.get $l7
                select
                local.set $l7
              end
              local.get $l4
              local.get $l3
              local.get $l5
              call_indirect $T0 (type $t5)
              i32.eqz
              br_if $L4
              br $B2
            end
          end
          loop $L12
            local.get $p1
            local.set $p0
            i32.const 92
            local.set $l3
            i32.const 1
            local.set $p1
            block $B13
              block $B14
                local.get $p0
                br_table $B1 $B1 $B13 $B14 $B1
              end
              local.get $l6
              i32.const 255
              i32.and
              local.set $p0
              i32.const 0
              local.set $l6
              i32.const 3
              local.set $p1
              i32.const 125
              local.set $l3
              block $B15
                block $B16
                  block $B17
                    block $B18
                      local.get $p0
                      br_table $B1 $B13 $B15 $B16 $B17 $B18 $B1
                    end
                    i32.const 4
                    local.set $l6
                    i32.const 92
                    local.set $l3
                    br $B13
                  end
                  i32.const 3
                  local.set $p1
                  i32.const 117
                  local.set $l3
                  i32.const 3
                  local.set $l6
                  br $B13
                end
                i32.const 2
                local.set $l6
                i32.const 123
                local.set $l3
                br $B13
              end
              i32.const 2
              i32.const 1
              local.get $l7
              select
              local.set $l6
              i32.const 1114112
              local.get $l7
              i32.const 2
              i32.shl
              i32.shr_u
              i32.const 1
              i32.and
              i32.const 48
              i32.or
              local.set $l3
              local.get $l7
              i32.const -1
              i32.add
              i32.const 0
              local.get $l7
              select
              local.set $l7
            end
            local.get $l4
            local.get $l3
            local.get $l5
            call_indirect $T0 (type $t5)
            i32.eqz
            br_if $L12
          end
        end
        i32.const 1
        local.set $l3
        br $B0
      end
      local.get $l4
      i32.const 39
      local.get $l5
      call_indirect $T0 (type $t5)
      local.set $l3
    end
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $l3)
  (func $_ZN4core5slice6memchr7memrchr17h9ee09338dacac280E (type $t10) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32)
    local.get $p3
    i32.const 0
    local.get $p3
    local.get $p2
    i32.const 3
    i32.add
    i32.const -4
    i32.and
    local.get $p2
    i32.sub
    local.tee $l4
    i32.sub
    i32.const 7
    i32.and
    local.get $p3
    local.get $l4
    i32.lt_u
    local.tee $l5
    select
    local.tee $l6
    i32.sub
    local.set $l7
    block $B0
      block $B1
        local.get $p3
        local.get $l6
        i32.lt_u
        br_if $B1
        block $B2
          block $B3
            block $B4
              local.get $l6
              i32.eqz
              br_if $B4
              local.get $p2
              local.get $p3
              i32.add
              local.tee $l6
              local.get $p2
              local.get $l7
              i32.add
              local.tee $l8
              i32.sub
              local.set $l9
              block $B5
                local.get $l6
                i32.const -1
                i32.add
                local.tee $l10
                i32.load8_u
                local.get $p1
                i32.const 255
                i32.and
                i32.ne
                br_if $B5
                local.get $l9
                i32.const -1
                i32.add
                local.get $l7
                i32.add
                local.set $l6
                br $B3
              end
              local.get $l8
              local.get $l10
              i32.eq
              br_if $B4
              block $B6
                local.get $l6
                i32.const -2
                i32.add
                local.tee $l10
                i32.load8_u
                local.get $p1
                i32.const 255
                i32.and
                i32.ne
                br_if $B6
                local.get $l9
                i32.const -2
                i32.add
                local.get $l7
                i32.add
                local.set $l6
                br $B3
              end
              local.get $l8
              local.get $l10
              i32.eq
              br_if $B4
              block $B7
                local.get $l6
                i32.const -3
                i32.add
                local.tee $l10
                i32.load8_u
                local.get $p1
                i32.const 255
                i32.and
                i32.ne
                br_if $B7
                local.get $l9
                i32.const -3
                i32.add
                local.get $l7
                i32.add
                local.set $l6
                br $B3
              end
              local.get $l8
              local.get $l10
              i32.eq
              br_if $B4
              block $B8
                local.get $l6
                i32.const -4
                i32.add
                local.tee $l10
                i32.load8_u
                local.get $p1
                i32.const 255
                i32.and
                i32.ne
                br_if $B8
                local.get $l9
                i32.const -4
                i32.add
                local.get $l7
                i32.add
                local.set $l6
                br $B3
              end
              local.get $l8
              local.get $l10
              i32.eq
              br_if $B4
              block $B9
                local.get $l6
                i32.const -5
                i32.add
                local.tee $l10
                i32.load8_u
                local.get $p1
                i32.const 255
                i32.and
                i32.ne
                br_if $B9
                local.get $l9
                i32.const -5
                i32.add
                local.get $l7
                i32.add
                local.set $l6
                br $B3
              end
              local.get $l8
              local.get $l10
              i32.eq
              br_if $B4
              block $B10
                local.get $l6
                i32.const -6
                i32.add
                local.tee $l10
                i32.load8_u
                local.get $p1
                i32.const 255
                i32.and
                i32.ne
                br_if $B10
                local.get $l9
                i32.const -6
                i32.add
                local.get $l7
                i32.add
                local.set $l6
                br $B3
              end
              local.get $l8
              local.get $l10
              i32.eq
              br_if $B4
              block $B11
                local.get $l6
                i32.const -7
                i32.add
                local.tee $l6
                i32.load8_u
                local.get $p1
                i32.const 255
                i32.and
                i32.ne
                br_if $B11
                local.get $l9
                i32.const -7
                i32.add
                local.get $l7
                i32.add
                local.set $l6
                br $B3
              end
              local.get $l8
              local.get $l6
              i32.eq
              br_if $B4
              local.get $l9
              i32.const -8
              i32.add
              local.get $l7
              i32.add
              local.set $l6
              br $B3
            end
            local.get $p3
            local.get $l4
            local.get $l5
            select
            local.set $l8
            local.get $p1
            i32.const 255
            i32.and
            i32.const 16843009
            i32.mul
            local.set $l4
            block $B12
              loop $L13
                local.get $l7
                local.tee $l6
                local.get $l8
                i32.le_u
                br_if $B12
                local.get $l6
                i32.const -8
                i32.add
                local.set $l7
                local.get $p2
                local.get $l6
                i32.add
                local.tee $l5
                i32.const -8
                i32.add
                i32.load
                local.get $l4
                i32.xor
                local.tee $l9
                i32.const -1
                i32.xor
                local.get $l9
                i32.const -16843009
                i32.add
                i32.and
                local.get $l5
                i32.const -4
                i32.add
                i32.load
                local.get $l4
                i32.xor
                local.tee $l5
                i32.const -1
                i32.xor
                local.get $l5
                i32.const -16843009
                i32.add
                i32.and
                i32.or
                i32.const -2139062144
                i32.and
                i32.eqz
                br_if $L13
              end
            end
            local.get $l6
            local.get $p3
            i32.gt_u
            br_if $B0
            local.get $p2
            i32.const -1
            i32.add
            local.set $l4
            local.get $p1
            i32.const 255
            i32.and
            local.set $l5
            loop $L14
              block $B15
                local.get $l6
                br_if $B15
                i32.const 0
                local.set $l7
                br $B2
              end
              local.get $l4
              local.get $l6
              i32.add
              local.set $l7
              local.get $l6
              i32.const -1
              i32.add
              local.set $l6
              local.get $l7
              i32.load8_u
              local.get $l5
              i32.ne
              br_if $L14
            end
          end
          i32.const 1
          local.set $l7
        end
        local.get $p0
        local.get $l6
        i32.store offset=4
        local.get $p0
        local.get $l7
        i32.store
        return
      end
      local.get $l7
      local.get $p3
      local.get $l6
      call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
      unreachable
    end
    local.get $l6
    local.get $p3
    local.get $l6
    call $_ZN4core5slice5index24slice_end_index_len_fail17h1cddbbbac67bee27E
    unreachable)
  (func $_ZN4core3fmt3num3imp51_$LT$impl$u20$core..fmt..Display$u20$for$u20$u8$GT$3fmt17h7776461bbca59d11E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i64.load8_u
    i32.const 1
    local.get $p1
    call $_ZN4core3fmt3num3imp7fmt_u6417h0b9ae8555cb01f7dE)
  (func $_ZN4core3fmt3num52_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i8$GT$3fmt17hac9e1b1b7f8c891dE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 128
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p0
    i32.load8_u
    local.set $l3
    i32.const 0
    local.set $p0
    loop $L0
      local.get $l2
      local.get $p0
      i32.add
      i32.const 127
      i32.add
      i32.const 48
      i32.const 87
      local.get $l3
      i32.const 15
      i32.and
      local.tee $l4
      i32.const 10
      i32.lt_u
      select
      local.get $l4
      i32.add
      i32.store8
      local.get $p0
      i32.const -1
      i32.add
      local.set $p0
      local.get $l3
      i32.const 255
      i32.and
      local.tee $l4
      i32.const 4
      i32.shr_u
      local.set $l3
      local.get $l4
      i32.const 15
      i32.gt_u
      br_if $L0
    end
    block $B1
      local.get $p0
      i32.const 128
      i32.add
      local.tee $l3
      i32.const 129
      i32.lt_u
      br_if $B1
      local.get $l3
      i32.const 128
      local.get $p0
      call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
      unreachable
    end
    local.get $p1
    i32.const 1
    i32.const 1055981
    i32.const 2
    local.get $l2
    local.get $p0
    i32.add
    i32.const 128
    i32.add
    i32.const 0
    local.get $p0
    i32.sub
    call $_ZN4core3fmt9Formatter12pad_integral17h34779d061fe7ddecE
    local.set $p0
    local.get $l2
    i32.const 128
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..LowerHex$u20$for$u20$i32$GT$3fmt17hb8089c13c9c3b945E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 128
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p0
    i32.load
    local.set $p0
    i32.const 0
    local.set $l3
    loop $L0
      local.get $l2
      local.get $l3
      i32.add
      i32.const 127
      i32.add
      i32.const 48
      i32.const 87
      local.get $p0
      i32.const 15
      i32.and
      local.tee $l4
      i32.const 10
      i32.lt_u
      select
      local.get $l4
      i32.add
      i32.store8
      local.get $l3
      i32.const -1
      i32.add
      local.set $l3
      local.get $p0
      i32.const 15
      i32.gt_u
      local.set $l4
      local.get $p0
      i32.const 4
      i32.shr_u
      local.set $p0
      local.get $l4
      br_if $L0
    end
    block $B1
      local.get $l3
      i32.const 128
      i32.add
      local.tee $p0
      i32.const 129
      i32.lt_u
      br_if $B1
      local.get $p0
      i32.const 128
      local.get $p0
      call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
      unreachable
    end
    local.get $p1
    i32.const 1
    i32.const 1055981
    i32.const 2
    local.get $l2
    local.get $l3
    i32.add
    i32.const 128
    i32.add
    i32.const 0
    local.get $l3
    i32.sub
    call $_ZN4core3fmt9Formatter12pad_integral17h34779d061fe7ddecE
    local.set $p0
    local.get $l2
    i32.const 128
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core3fmt3num49_$LT$impl$u20$core..fmt..Debug$u20$for$u20$u8$GT$3fmt17h472cebcfaead1301E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 128
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      block $B1
        block $B2
          block $B3
            block $B4
              local.get $p1
              i32.load
              local.tee $l3
              i32.const 16
              i32.and
              br_if $B4
              local.get $l3
              i32.const 32
              i32.and
              br_if $B3
              local.get $p0
              i64.load8_u
              i32.const 1
              local.get $p1
              call $_ZN4core3fmt3num3imp7fmt_u6417h0b9ae8555cb01f7dE
              local.set $p0
              br $B0
            end
            local.get $p0
            i32.load8_u
            local.set $l3
            i32.const 0
            local.set $p0
            loop $L5
              local.get $l2
              local.get $p0
              i32.add
              i32.const 127
              i32.add
              i32.const 48
              i32.const 87
              local.get $l3
              i32.const 15
              i32.and
              local.tee $l4
              i32.const 10
              i32.lt_u
              select
              local.get $l4
              i32.add
              i32.store8
              local.get $p0
              i32.const -1
              i32.add
              local.set $p0
              local.get $l3
              i32.const 255
              i32.and
              local.tee $l4
              i32.const 4
              i32.shr_u
              local.set $l3
              local.get $l4
              i32.const 15
              i32.gt_u
              br_if $L5
            end
            local.get $p0
            i32.const 128
            i32.add
            local.tee $l3
            i32.const 129
            i32.ge_u
            br_if $B2
            local.get $p1
            i32.const 1
            i32.const 1055981
            i32.const 2
            local.get $l2
            local.get $p0
            i32.add
            i32.const 128
            i32.add
            i32.const 0
            local.get $p0
            i32.sub
            call $_ZN4core3fmt9Formatter12pad_integral17h34779d061fe7ddecE
            local.set $p0
            br $B0
          end
          local.get $p0
          i32.load8_u
          local.set $l3
          i32.const 0
          local.set $p0
          loop $L6
            local.get $l2
            local.get $p0
            i32.add
            i32.const 127
            i32.add
            i32.const 48
            i32.const 55
            local.get $l3
            i32.const 15
            i32.and
            local.tee $l4
            i32.const 10
            i32.lt_u
            select
            local.get $l4
            i32.add
            i32.store8
            local.get $p0
            i32.const -1
            i32.add
            local.set $p0
            local.get $l3
            i32.const 255
            i32.and
            local.tee $l4
            i32.const 4
            i32.shr_u
            local.set $l3
            local.get $l4
            i32.const 15
            i32.gt_u
            br_if $L6
          end
          local.get $p0
          i32.const 128
          i32.add
          local.tee $l3
          i32.const 129
          i32.ge_u
          br_if $B1
          local.get $p1
          i32.const 1
          i32.const 1055981
          i32.const 2
          local.get $l2
          local.get $p0
          i32.add
          i32.const 128
          i32.add
          i32.const 0
          local.get $p0
          i32.sub
          call $_ZN4core3fmt9Formatter12pad_integral17h34779d061fe7ddecE
          local.set $p0
          br $B0
        end
        local.get $l3
        i32.const 128
        local.get $p0
        call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
        unreachable
      end
      local.get $l3
      i32.const 128
      local.get $p0
      call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
      unreachable
    end
    local.get $l2
    i32.const 128
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core3fmt3num3imp7fmt_u6417h0b9ae8555cb01f7dE (type $t16) (param $p0 i64) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i64) (local $l6 i32) (local $l7 i32) (local $l8 i32)
    global.get $__stack_pointer
    i32.const 48
    i32.sub
    local.tee $l3
    global.set $__stack_pointer
    i32.const 39
    local.set $l4
    block $B0
      block $B1
        local.get $p0
        i64.const 10000
        i64.ge_u
        br_if $B1
        local.get $p0
        local.set $l5
        br $B0
      end
      i32.const 39
      local.set $l4
      loop $L2
        local.get $l3
        i32.const 9
        i32.add
        local.get $l4
        i32.add
        local.tee $l6
        i32.const -4
        i32.add
        local.get $p0
        local.get $p0
        i64.const 10000
        i64.div_u
        local.tee $l5
        i64.const 10000
        i64.mul
        i64.sub
        i32.wrap_i64
        local.tee $l7
        i32.const 65535
        i32.and
        i32.const 100
        i32.div_u
        local.tee $l8
        i32.const 1
        i32.shl
        i32.const 1055983
        i32.add
        i32.load16_u align=1
        i32.store16 align=1
        local.get $l6
        i32.const -2
        i32.add
        local.get $l7
        local.get $l8
        i32.const 100
        i32.mul
        i32.sub
        i32.const 65535
        i32.and
        i32.const 1
        i32.shl
        i32.const 1055983
        i32.add
        i32.load16_u align=1
        i32.store16 align=1
        local.get $l4
        i32.const -4
        i32.add
        local.set $l4
        local.get $p0
        i64.const 99999999
        i64.gt_u
        local.set $l6
        local.get $l5
        local.set $p0
        local.get $l6
        br_if $L2
      end
    end
    block $B3
      local.get $l5
      i32.wrap_i64
      local.tee $l6
      i32.const 99
      i32.le_u
      br_if $B3
      local.get $l3
      i32.const 9
      i32.add
      local.get $l4
      i32.const -2
      i32.add
      local.tee $l4
      i32.add
      local.get $l5
      i32.wrap_i64
      local.tee $l6
      local.get $l6
      i32.const 65535
      i32.and
      i32.const 100
      i32.div_u
      local.tee $l6
      i32.const 100
      i32.mul
      i32.sub
      i32.const 65535
      i32.and
      i32.const 1
      i32.shl
      i32.const 1055983
      i32.add
      i32.load16_u align=1
      i32.store16 align=1
    end
    block $B4
      block $B5
        local.get $l6
        i32.const 10
        i32.lt_u
        br_if $B5
        local.get $l3
        i32.const 9
        i32.add
        local.get $l4
        i32.const -2
        i32.add
        local.tee $l4
        i32.add
        local.get $l6
        i32.const 1
        i32.shl
        i32.const 1055983
        i32.add
        i32.load16_u align=1
        i32.store16 align=1
        br $B4
      end
      local.get $l3
      i32.const 9
      i32.add
      local.get $l4
      i32.const -1
      i32.add
      local.tee $l4
      i32.add
      local.get $l6
      i32.const 48
      i32.add
      i32.store8
    end
    local.get $p2
    local.get $p1
    i32.const 1055524
    i32.const 0
    local.get $l3
    i32.const 9
    i32.add
    local.get $l4
    i32.add
    i32.const 39
    local.get $l4
    i32.sub
    call $_ZN4core3fmt9Formatter12pad_integral17h34779d061fe7ddecE
    local.set $l4
    local.get $l3
    i32.const 48
    i32.add
    global.set $__stack_pointer
    local.get $l4)
  (func $_ZN4core3fmt3num52_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i8$GT$3fmt17h9c814972bb8d4cf9E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 128
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p0
    i32.load8_u
    local.set $l3
    i32.const 0
    local.set $p0
    loop $L0
      local.get $l2
      local.get $p0
      i32.add
      i32.const 127
      i32.add
      i32.const 48
      i32.const 55
      local.get $l3
      i32.const 15
      i32.and
      local.tee $l4
      i32.const 10
      i32.lt_u
      select
      local.get $l4
      i32.add
      i32.store8
      local.get $p0
      i32.const -1
      i32.add
      local.set $p0
      local.get $l3
      i32.const 255
      i32.and
      local.tee $l4
      i32.const 4
      i32.shr_u
      local.set $l3
      local.get $l4
      i32.const 15
      i32.gt_u
      br_if $L0
    end
    block $B1
      local.get $p0
      i32.const 128
      i32.add
      local.tee $l3
      i32.const 129
      i32.lt_u
      br_if $B1
      local.get $l3
      i32.const 128
      local.get $p0
      call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
      unreachable
    end
    local.get $p1
    i32.const 1
    i32.const 1055981
    i32.const 2
    local.get $l2
    local.get $p0
    i32.add
    i32.const 128
    i32.add
    i32.const 0
    local.get $p0
    i32.sub
    call $_ZN4core3fmt9Formatter12pad_integral17h34779d061fe7ddecE
    local.set $p0
    local.get $l2
    i32.const 128
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core3fmt3num53_$LT$impl$u20$core..fmt..UpperHex$u20$for$u20$i32$GT$3fmt17h9146f2224828cde5E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32)
    global.get $__stack_pointer
    i32.const 128
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p0
    i32.load
    local.set $p0
    i32.const 0
    local.set $l3
    loop $L0
      local.get $l2
      local.get $l3
      i32.add
      i32.const 127
      i32.add
      i32.const 48
      i32.const 55
      local.get $p0
      i32.const 15
      i32.and
      local.tee $l4
      i32.const 10
      i32.lt_u
      select
      local.get $l4
      i32.add
      i32.store8
      local.get $l3
      i32.const -1
      i32.add
      local.set $l3
      local.get $p0
      i32.const 15
      i32.gt_u
      local.set $l4
      local.get $p0
      i32.const 4
      i32.shr_u
      local.set $p0
      local.get $l4
      br_if $L0
    end
    block $B1
      local.get $l3
      i32.const 128
      i32.add
      local.tee $p0
      i32.const 129
      i32.lt_u
      br_if $B1
      local.get $p0
      i32.const 128
      local.get $p0
      call $_ZN4core5slice5index26slice_start_index_len_fail17h4638bbdf7a6fad90E
      unreachable
    end
    local.get $p1
    i32.const 1
    i32.const 1055981
    i32.const 2
    local.get $l2
    local.get $l3
    i32.add
    i32.const 128
    i32.add
    i32.const 0
    local.get $l3
    i32.sub
    call $_ZN4core3fmt9Formatter12pad_integral17h34779d061fe7ddecE
    local.set $p0
    local.get $l2
    i32.const 128
    i32.add
    global.set $__stack_pointer
    local.get $p0)
  (func $_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$i32$GT$3fmt17haf8bfd1843cbb42cE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.tee $p0
    i64.extend_i32_u
    local.get $p0
    i32.const -1
    i32.xor
    i64.extend_i32_s
    i64.const 1
    i64.add
    local.get $p0
    i32.const -1
    i32.gt_s
    local.tee $p0
    select
    local.get $p0
    local.get $p1
    call $_ZN4core3fmt3num3imp7fmt_u6417h0b9ae8555cb01f7dE)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h0a58d0f1d41d2cbdE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p1
    call $_ZN4core3fmt3num50_$LT$impl$u20$core..fmt..Debug$u20$for$u20$u32$GT$3fmt17h90714a0c65d14ba5E)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h171d95bacc72a31aE (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    local.get $p0
    i32.load
    local.get $p1
    call $_ZN4core3fmt3num49_$LT$impl$u20$core..fmt..Debug$u20$for$u20$u8$GT$3fmt17h472cebcfaead1301E)
  (func $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h98a01424480af070E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    block $B0
      block $B1
        local.get $p0
        i32.load
        local.tee $p0
        i32.load8_u
        br_if $B1
        local.get $p1
        i32.load offset=24
        i32.const 1058560
        i32.const 4
        local.get $p1
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        local.set $p1
        br $B0
      end
      local.get $l2
      local.get $p1
      i32.load offset=24
      i32.const 1058556
      i32.const 4
      local.get $p1
      i32.const 28
      i32.add
      i32.load
      i32.load offset=12
      call_indirect $T0 (type $t7)
      i32.store8 offset=8
      local.get $l2
      local.get $p1
      i32.store
      local.get $l2
      i32.const 0
      i32.store8 offset=9
      local.get $l2
      i32.const 0
      i32.store offset=4
      i32.const 1
      local.set $p1
      local.get $l2
      local.get $p0
      i32.const 1
      i32.add
      i32.store offset=12
      local.get $l2
      local.get $l2
      i32.const 12
      i32.add
      i32.const 1055964
      call $_ZN4core3fmt8builders10DebugTuple5field17h6c59533708c678f2E
      drop
      local.get $l2
      i32.load8_u offset=8
      local.set $p0
      block $B2
        block $B3
          local.get $l2
          i32.load offset=4
          local.tee $l3
          br_if $B3
          local.get $p0
          local.set $p1
          br $B2
        end
        local.get $p0
        i32.const 255
        i32.and
        br_if $B2
        local.get $l2
        i32.load
        local.set $p0
        block $B4
          local.get $l3
          i32.const 1
          i32.ne
          br_if $B4
          local.get $l2
          i32.load8_u offset=9
          i32.const 255
          i32.and
          i32.eqz
          br_if $B4
          local.get $p0
          i32.load8_u
          i32.const 4
          i32.and
          br_if $B4
          i32.const 1
          local.set $p1
          local.get $p0
          i32.load offset=24
          i32.const 1055960
          i32.const 1
          local.get $p0
          i32.const 28
          i32.add
          i32.load
          i32.load offset=12
          call_indirect $T0 (type $t7)
          br_if $B2
        end
        local.get $p0
        i32.load offset=24
        i32.const 1055524
        i32.const 1
        local.get $p0
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        local.set $p1
      end
      local.get $p1
      i32.const 255
      i32.and
      i32.const 0
      i32.ne
      local.set $p1
    end
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p1)
  (func $_ZN64_$LT$core..str..error..Utf8Error$u20$as$u20$core..fmt..Debug$GT$3fmt17hb01aa63801957529E (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee $l2
    global.set $__stack_pointer
    local.get $p1
    i32.load offset=24
    i32.const 1058580
    i32.const 9
    local.get $p1
    i32.const 28
    i32.add
    i32.load
    i32.load offset=12
    call_indirect $T0 (type $t7)
    local.set $l3
    local.get $l2
    i32.const 0
    i32.store8 offset=5
    local.get $l2
    local.get $l3
    i32.store8 offset=4
    local.get $l2
    local.get $p1
    i32.store
    local.get $l2
    local.get $p0
    i32.store offset=12
    local.get $l2
    i32.const 1058589
    i32.const 11
    local.get $l2
    i32.const 12
    i32.add
    i32.const 1058564
    call $_ZN4core3fmt8builders11DebugStruct5field17h8ca46ab58b8a4d20E
    local.set $p1
    local.get $l2
    local.get $p0
    i32.const 4
    i32.add
    i32.store offset=12
    local.get $p1
    i32.const 1058600
    i32.const 9
    local.get $l2
    i32.const 12
    i32.add
    i32.const 1058612
    call $_ZN4core3fmt8builders11DebugStruct5field17h8ca46ab58b8a4d20E
    drop
    local.get $l2
    i32.load8_u offset=4
    local.set $p1
    block $B0
      local.get $l2
      i32.load8_u offset=5
      i32.eqz
      br_if $B0
      local.get $p1
      i32.const 255
      i32.and
      local.set $p0
      i32.const 1
      local.set $p1
      local.get $p0
      br_if $B0
      block $B1
        local.get $l2
        i32.load
        local.tee $p1
        i32.load8_u
        i32.const 4
        i32.and
        br_if $B1
        local.get $p1
        i32.load offset=24
        i32.const 1055955
        i32.const 2
        local.get $p1
        i32.const 28
        i32.add
        i32.load
        i32.load offset=12
        call_indirect $T0 (type $t7)
        local.set $p1
        br $B0
      end
      local.get $p1
      i32.load offset=24
      i32.const 1055941
      i32.const 1
      local.get $p1
      i32.const 28
      i32.add
      i32.load
      i32.load offset=12
      call_indirect $T0 (type $t7)
      local.set $p1
    end
    local.get $l2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get $p1
    i32.const 255
    i32.and
    i32.const 0
    i32.ne)
  (func $_start.command_export (type $t0)
    call $__wasm_call_ctors
    call $_start
    call $__wasm_call_dtors)
  (func $fib_recursive.command_export (type $t2) (param $p0 i32) (result i64)
    call $__wasm_call_ctors
    local.get $p0
    call $fib_recursive
    call $__wasm_call_dtors)
  (func $fib_iterative.command_export (type $t2) (param $p0 i32) (result i64)
    call $__wasm_call_ctors
    local.get $p0
    call $fib_iterative
    call $__wasm_call_dtors)
  (func $main.command_export (type $t5) (param $p0 i32) (param $p1 i32) (result i32)
    call $__wasm_call_ctors
    local.get $p0
    local.get $p1
    call $main
    call $__wasm_call_dtors)
  (table $T0 96 96 funcref)
  (memory $memory 17)
  (global $__stack_pointer (mut i32) (i32.const 1048576))
  (global $__heap_base i32 (i32.const 1060128))
  (global $__data_end i32 (i32.const 1060120))
  (export "memory" (memory $memory))
  (export "__heap_base" (global $__heap_base))
  (export "__data_end" (global $__data_end))
  (export "_start" (func $_start.command_export))
  (export "fib_recursive" (func $fib_recursive.command_export))
  (export "fib_iterative" (func $fib_iterative.command_export))
  (export "main" (func $main.command_export))
  (elem $e0 (i32.const 1) func $_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$i32$GT$3fmt17haf8bfd1843cbb42cE $_ZN9fibonacci4main17hf7c881588373479aE $_ZN4core3ptr85drop_in_place$LT$std..rt..lang_start$LT$$LP$$RP$$GT$..$u7b$$u7b$closure$u7d$$u7d$$GT$17h8347ee127e12f099E.llvm.12393469044335151983 $_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17hdd5f6e23e7aa570cE.llvm.12393469044335151983 $_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17hda35c9318378c65fE.llvm.12393469044335151983 $_ZN59_$LT$core..fmt..Arguments$u20$as$u20$core..fmt..Display$GT$3fmt17hc140c5fbe5de628cE $_ZN70_$LT$core..result..Result$LT$T$C$E$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17he855ed501478c391E $_ZN60_$LT$alloc..string..String$u20$as$u20$core..fmt..Display$GT$3fmt17h6636b07faeedd941E $_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17hab8798528b645c70E $_ZN60_$LT$std..io..error..Error$u20$as$u20$core..fmt..Display$GT$3fmt17hc82007c165b2732bE $_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$3fmt17h813a35a9627bd2a0E $_ZN3std5alloc24default_alloc_error_hook17h2ca49935547869e3E $_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h41599c7ebfcbddfcE $_ZN91_$LT$std..sys_common..backtrace.._print..DisplayBacktrace$u20$as$u20$core..fmt..Display$GT$3fmt17h9f1e240acab2cdb1E $_ZN73_$LT$core..panic..panic_info..PanicInfo$u20$as$u20$core..fmt..Display$GT$3fmt17h92aa18f5879f38f8E $_ZN4core3ptr100drop_in_place$LT$$RF$mut$u20$std..io..Write..write_fmt..Adapter$LT$alloc..vec..Vec$LT$u8$GT$$GT$$GT$17h023d344833e89da3E $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17h7901cb51779d4b4cE $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17hd8e75667bbe06bd4E $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17hd3abdebe1b974cf4E $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17hc5a7aed674d57871E $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h4dbabd655517b3ebE $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17hf3b6dd4ac505270cE $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17h733b40fd9a71eda9E $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h55c92bf5255df7acE $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17hc1cd0b26048ce4eeE $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17h26c407ff69ca40f6E $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17h3dc2852957e98fb1E $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17h4116da28c54ce459E $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17h615ca163282f35faE $_ZN63_$LT$core..cell..BorrowMutError$u20$as$u20$core..fmt..Debug$GT$3fmt17h22847665890af294E $_ZN4core3ptr103drop_in_place$LT$std..sync..poison..PoisonError$LT$std..sync..mutex..MutexGuard$LT$$LP$$RP$$GT$$GT$$GT$17h9727c741a7219826E $_ZN76_$LT$std..sync..poison..PoisonError$LT$T$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h8c1c8865a1d136dfE $_ZN64_$LT$core..str..error..Utf8Error$u20$as$u20$core..fmt..Debug$GT$3fmt17hb01aa63801957529E $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h80292035a4d7d273E $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h68c2448d75804436E $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h03c19a5cab87a8bcE $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h9e3e1337724c321bE $_ZN4core3ptr87drop_in_place$LT$std..io..Write..write_fmt..Adapter$LT$$RF$mut$u20$$u5b$u8$u5d$$GT$$GT$17h79521407f097e01cE $_ZN80_$LT$std..io..Write..write_fmt..Adapter$LT$T$GT$$u20$as$u20$core..fmt..Write$GT$9write_str17h65bd1b8bee6953cbE $_ZN4core3fmt5Write10write_char17h495658827dcb6b00E $_ZN4core3fmt5Write9write_fmt17ha2304c6abd7cc588E $_ZN80_$LT$std..io..Write..write_fmt..Adapter$LT$T$GT$$u20$as$u20$core..fmt..Write$GT$9write_str17h742c36c2aa138293E $_ZN4core3fmt5Write10write_char17h12aa92d150748a24E $_ZN4core3fmt5Write9write_fmt17h8b8853e9f8c4a51bE $_ZN80_$LT$std..io..Write..write_fmt..Adapter$LT$T$GT$$u20$as$u20$core..fmt..Write$GT$9write_str17h824f0cbe3c4a395fE $_ZN4core3fmt5Write10write_char17hbf9e79e156fc6a02E $_ZN4core3fmt5Write9write_fmt17h0f5a126dbc39caaeE $_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17heb7056d347e601d2E $_ZN3std4sync4once4Once9call_once28_$u7b$$u7b$closure$u7d$$u7d$17hc39a8a731846cbe3E $_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h47241f009bb1a74bE $_ZN3std4sync4once4Once15call_once_force28_$u7b$$u7b$closure$u7d$$u7d$17h799a8c877c6843f0E $_ZN64_$LT$std..sys..wasi..stdio..Stderr$u20$as$u20$std..io..Write$GT$5write17he638b47b4b5fcaa0E $_ZN64_$LT$std..sys..wasi..stdio..Stderr$u20$as$u20$std..io..Write$GT$14write_vectored17hb1358e89f45f13c6E $_ZN64_$LT$std..sys..wasi..stdio..Stderr$u20$as$u20$std..io..Write$GT$17is_write_vectored17hd0e798cc29d02535E $_ZN64_$LT$std..sys..wasi..stdio..Stderr$u20$as$u20$std..io..Write$GT$5flush17h44579201a8bfbb2eE $_ZN3std2io5Write9write_all17hdb7bcfec18f35a47E $_ZN3std2io5Write18write_all_vectored17h924f39f54efaec1aE $_ZN3std2io5Write9write_fmt17h623738e85fdccfedE $_ZN4core3ptr226drop_in_place$LT$std..error..$LT$impl$u20$core..convert..From$LT$alloc..string..String$GT$$u20$for$u20$alloc..boxed..Box$LT$dyn$u20$std..error..Error$u2b$core..marker..Send$u2b$core..marker..Sync$GT$$GT$..from..StringError$GT$17h2690405bcf1255fcE $_ZN3std2io5impls74_$LT$impl$u20$std..io..Write$u20$for$u20$alloc..vec..Vec$LT$u8$C$A$GT$$GT$5write17hcb5efe1f65675387E $_ZN3std2io5impls74_$LT$impl$u20$std..io..Write$u20$for$u20$alloc..vec..Vec$LT$u8$C$A$GT$$GT$14write_vectored17h3dc0fad2eb0646c6E $_ZN3std2io5impls74_$LT$impl$u20$std..io..Write$u20$for$u20$alloc..vec..Vec$LT$u8$C$A$GT$$GT$17is_write_vectored17hda3f832df0321a28E $_ZN3std2io5impls74_$LT$impl$u20$std..io..Write$u20$for$u20$alloc..vec..Vec$LT$u8$C$A$GT$$GT$5flush17h5a7fbf237751575fE $_ZN3std2io5impls74_$LT$impl$u20$std..io..Write$u20$for$u20$alloc..vec..Vec$LT$u8$C$A$GT$$GT$9write_all17h6bc7ff6998e1df05E $_ZN3std2io5Write18write_all_vectored17h874fd4c946a0a9aeE $_ZN3std2io5Write9write_fmt17hf640f722c5242650E $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17h9b54eaeb5c3690b9E $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17h4bb391f6be197f05E $_ZN4core3ptr70drop_in_place$LT$std..panicking..begin_panic_handler..PanicPayload$GT$17hec9230cd384f36f4E $_ZN90_$LT$std..panicking..begin_panic_handler..PanicPayload$u20$as$u20$core..panic..BoxMeUp$GT$8take_box17hf881bad967b4c231E $_ZN90_$LT$std..panicking..begin_panic_handler..PanicPayload$u20$as$u20$core..panic..BoxMeUp$GT$3get17hc921f629bee27affE $_ZN93_$LT$std..panicking..begin_panic_handler..StrPanicPayload$u20$as$u20$core..panic..BoxMeUp$GT$8take_box17hf696dea4ccae274aE $_ZN93_$LT$std..panicking..begin_panic_handler..StrPanicPayload$u20$as$u20$core..panic..BoxMeUp$GT$3get17h30812c9a258bb7c9E $_ZN4core3ptr27drop_in_place$LT$$RF$u8$GT$17h5c92c0693187df84E $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17hd7d754d44c265e2fE $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h65a600520d4f6149E $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h172715cbc817b0a1E $_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17hab770d78211f774aE $_ZN71_$LT$core..ops..range..Range$LT$Idx$GT$$u20$as$u20$core..fmt..Debug$GT$3fmt17h7503e30c839de4caE $_ZN41_$LT$char$u20$as$u20$core..fmt..Debug$GT$3fmt17h2b60a9a92e5cb373E $_ZN4core3ops8function6FnOnce9call_once17hf5d854cc46375908E $_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17hec80a8178adb91c2E $_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h7b04c3954d3816e8E $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17had27c1012773a848E $_ZN4core3ptr102drop_in_place$LT$$RF$core..iter..adapters..copied..Copied$LT$core..slice..iter..Iter$LT$u8$GT$$GT$$GT$17h1668ae1a50824bfcE $_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$7type_id17hd6e0e99b069667c6E $_ZN68_$LT$core..fmt..builders..PadAdapter$u20$as$u20$core..fmt..Write$GT$9write_str17h3703129f2a2ebc77E $_ZN4core3fmt5Write10write_char17he27bd04cb173bf5eE $_ZN4core3fmt5Write9write_fmt17hae929550dd37b3daE $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h171d95bacc72a31aE $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_str17h0bcbeb4e8005a6f0E $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$10write_char17haeb61a38da6b2cc4E $_ZN50_$LT$$RF$mut$u20$W$u20$as$u20$core..fmt..Write$GT$9write_fmt17hf53b98eb9a081c42E $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h0a58d0f1d41d2cbdE $_ZN42_$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$3fmt17h98a01424480af070E)
  (data $.rodata (i32.const 1048576) "What\00\00\10\00\04\00\00\00wasm-programs/fibonacci/src/main.rs\00\0c\00\10\00#\00\00\00\04\00\00\00\09\00\00\00\0c\00\10\00#\00\00\00\07\00\00\00\0e\00\00\00 is negative!\00\00\00\00\00\10\00\00\00\00\00P\00\10\00\0d\00\00\00\0c\00\10\00#\00\00\00\10\00\00\00\09\00\00\00zero is not a right argument to fibonacci()!\80\00\10\00,\00\00\00\0c\00\10\00#\00\00\00\12\00\00\00\09\00\00\00Hello, world!\0a\00\00\c4\00\10\00\0e\00\00\00\03\00\00\00\04\00\00\00\04\00\00\00\04\00\00\00\05\00\00\00\05\00\00\00()\00\00\10\00\00\00\04\00\00\00\04\00\00\00\11\00\00\00\12\00\00\00\13\00\00\00\10\00\00\00\04\00\00\00\04\00\00\00\14\00\00\00\15\00\00\00\16\00\00\00\10\00\00\00\04\00\00\00\04\00\00\00\17\00\00\00\18\00\00\00\19\00\00\00\10\00\00\00\04\00\00\00\04\00\00\00\1a\00\00\00\1b\00\00\00\1c\00\00\00already borrowed\10\00\00\00\00\00\00\00\01\00\00\00\1d\00\00\00assertion failed: mid <= self.len()called `Option::unwrap()` on a `None` value\00\00\10\00\00\00\00\00\00\00\01\00\00\00\1e\00\00\00called `Result::unwrap()` on an `Err` value\00\1f\00\00\00\08\00\00\00\04\00\00\00 \00\00\00\10\00\00\00\08\00\00\00\04\00\00\00!\00\00\00\10\00\00\00\04\00\00\00\04\00\00\00\22\00\00\00\10\00\00\00\04\00\00\00\04\00\00\00#\00\00\00internal error: entered unreachable code/rustc/cd282d7f75da9080fda0f1740a729516e7fbec68/library/alloc/src/vec/mod.rsl\02\10\00L\00\00\00<\07\00\00$\00\00\00ErrOk\00\00\00\10\00\00\00\04\00\00\00\04\00\00\00$\00\00\00\10\00\00\00\04\00\00\00\04\00\00\00%\00\00\00mainfatal runtime error: \0a\00\00\f4\02\10\00\15\00\00\00\09\03\10\00\01\00\00\00unwrap failed: CString::new(\22main\22) = \00\00\1c\03\10\00&\00\00\00library/std/src/rt.rs\00\00\00L\03\10\00\15\00\00\00_\00\00\00\0d\00\00\00use of std::thread::current() is not possible after the thread's local data has been destroyedlibrary/std/src/thread/mod.rs\00\d2\03\10\00\1d\00\00\00\a5\02\00\00#\00\00\00failed to generate unique thread ID: bitspace exhausted\00\00\04\10\007\00\00\00\d2\03\10\00\1d\00\00\00\13\04\00\00\11\00\00\00\d2\03\10\00\1d\00\00\00\19\04\00\00*\00\00\00RUST_BACKTRACE\00\00X\01\10\00\00\00\00\00: \00failed to write the buffered data{\04\10\00!\00\00\00\17\00\00\00library/std/src/io/buffered/bufwriter.rs\a8\04\10\00(\00\00\00\8d\00\00\00\12\00\00\00library/std/src/io/buffered/linewritershim.rs\00\00\00\e0\04\10\00-\00\00\00\01\01\00\00)\00\00\00uncategorized errorother errorout of memoryunexpected end of fileunsupportedoperation interruptedargument list too longinvalid filenametoo many linkscross-device link or renamedeadlockexecutable file busyresource busyfile too largefilesystem quota exceededseek on unseekable fileno storage spacewrite zerotimed outinvalid datainvalid input parameterstale network file handlefilesystem loop or indirection limit (e.g. symlink loop)read-only filesystem or storage mediumdirectory not emptyis a directorynot a directoryoperation would blockentity already existsbroken pipenetwork downaddress not availableaddress in usenot connectedconnection abortednetwork unreachablehost unreachableconnection resetconnection refusedpermission deniedentity not found (os error )\00\00\00X\01\10\00\00\00\00\00\0d\08\10\00\0b\00\00\00\18\08\10\00\01\00\00\00failed to write whole buffer4\08\10\00\1c\00\00\00\17\00\00\00library/std/src/io/stdio.rs\00\5c\08\10\00\1b\00\00\00o\02\00\00\13\00\00\00\5c\08\10\00\1b\00\00\00\dc\02\00\00\14\00\00\00failed printing to \00\98\08\10\00\13\00\00\00x\04\10\00\02\00\00\00\5c\08\10\00\1b\00\00\00\f8\03\00\00\09\00\00\00stdoutlibrary/std/src/io/mod.rs\00\d2\08\10\00\19\00\00\00\0a\05\00\00\16\00\00\00\d2\08\10\00\19\00\00\00\f1\05\00\00!\00\00\00formatter error\00\0c\09\10\00\0f\00\00\00(\00\00\00&\00\00\00\0c\00\00\00\04\00\00\00'\00\00\00(\00\00\00)\00\00\00&\00\00\00\0c\00\00\00\04\00\00\00*\00\00\00+\00\00\00,\00\00\00&\00\00\00\0c\00\00\00\04\00\00\00-\00\00\00.\00\00\00/\00\00\00library/std/src/panic.rsp\09\10\00\18\00\00\00\f0\00\00\00\12\00\00\00\10\00\00\00\04\00\00\00\04\00\00\000\00\00\001\00\00\00library/std/src/sync/once.rs\ac\09\10\00\1c\00\00\00\14\01\00\002\00\00\00\ac\09\10\00\1c\00\00\00N\01\00\00\0e\00\00\00\10\00\00\00\04\00\00\00\04\00\00\002\00\00\003\00\00\00\ac\09\10\00\1c\00\00\00N\01\00\001\00\00\00assertion failed: state_and_queue.addr() & STATE_MASK == RUNNINGOnce instance has previously been poisoned\00\00L\0a\10\00*\00\00\00\02\00\00\00\ac\09\10\00\1c\00\00\00\ff\01\00\00\09\00\00\00\ac\09\10\00\1c\00\00\00\0c\02\00\005\00\00\00PoisonErrorstack backtrace:\0a\af\0a\10\00\11\00\00\00note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.\0a\c8\0a\10\00X\00\00\00lock count overflow in reentrant mutexlibrary/std/src/sys_common/remutex.rs\00N\0b\10\00%\00\00\00\a7\00\00\00\0e\00\00\00library/std/src/sys_common/thread_info.rs\00\00\00\84\0b\10\00)\00\00\00\16\00\00\003\00\00\00\84\0b\10\00)\00\00\00+\00\00\00+\00\00\00assertion failed: thread_info.is_none()\00\d0\0b\10\00'\00\00\00memory allocation of  bytes failed\0a\00\00\0c\10\00\15\00\00\00\15\0c\10\00\0e\00\00\00library/std/src/alloc.rs4\0c\10\00\18\00\00\00D\01\00\00\09\00\00\00library/std/src/panicking.rs\5c\0c\10\00\1c\00\00\00\11\01\00\00$\00\00\00Box<dyn Any><unnamed>\00\00\00\10\00\00\00\00\00\00\00\01\00\00\004\00\00\005\00\00\006\00\00\007\00\00\008\00\00\009\00\00\00:\00\00\00;\00\00\00\0c\00\00\00\04\00\00\00<\00\00\00=\00\00\00>\00\00\00?\00\00\00@\00\00\00A\00\00\00B\00\00\00thread '' panicked at '', \00\00\f0\0c\10\00\08\00\00\00\f8\0c\10\00\0f\00\00\00\07\0d\10\00\03\00\00\00\09\03\10\00\01\00\00\00note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace\0a\00\00,\0d\10\00N\00\00\00\5c\0c\10\00\1c\00\00\00F\02\00\00\1f\00\00\00\5c\0c\10\00\1c\00\00\00G\02\00\00\1e\00\00\00;\00\00\00\0c\00\00\00\04\00\00\00C\00\00\00\10\00\00\00\08\00\00\00\04\00\00\00D\00\00\00E\00\00\00\10\00\00\00\04\00\00\00F\00\00\00G\00\00\00\10\00\00\00\08\00\00\00\04\00\00\00H\00\00\00I\00\00\00thread panicked while processing panic. aborting.\0a\00\00\ec\0d\10\002\00\00\00\0apanicked after panic::always_abort(), aborting.\0a\00\00\00X\01\10\00\00\00\00\00(\0e\10\001\00\00\00thread panicked while panicking. aborting.\0a\00l\0e\10\00+\00\00\00failed to initiate panic, error \a0\0e\10\00 \00\00\00advancing IoSlice beyond its length\00\c8\0e\10\00#\00\00\00library/std/src/sys/wasi/io.rs\00\00\f4\0e\10\00\1e\00\00\00\16\00\00\00\0d\00\00\00condvar wait not supported\00\00$\0f\10\00\1a\00\00\00library/std/src/sys/wasi/../unsupported/locks/condvar.rsH\0f\10\008\00\00\00\17\00\00\00\09\00\00\00cannot recursively acquire mutex\90\0f\10\00 \00\00\00library/std/src/sys/wasi/../unsupported/locks/mutex.rs\00\00\b8\0f\10\006\00\00\00\17\00\00\00\09\00\00\00rwlock locked for writing\00\00\00\00\10\10\00\19\00\00\00strerror_r failure\00\00$\10\10\00\12\00\00\00library/std/src/sys/wasi/os.rs\00\00@\10\10\00\1e\00\00\00/\00\00\00\0d\00\00\00@\10\10\00\1e\00\00\001\00\00\006\00\00\00\08\00\0e\00\0f\00?\00\02\00@\005\00\0d\00\04\00\03\00,\00\1b\00\1c\00I\00\14\00\06\004\000\00library/std/src/sys_common/thread_parker/generic.rs\00\a4\10\10\003\00\00\00'\00\00\00&\00\00\00inconsistent park state\00\e8\10\10\00\17\00\00\00\a4\10\10\003\00\00\005\00\00\00\17\00\00\00park state changed unexpectedly\00\18\11\10\00\1f\00\00\00\a4\10\10\003\00\00\002\00\00\00\11\00\00\00inconsistent state in unparkP\11\10\00\1c\00\00\00\a4\10\10\003\00\00\00l\00\00\00\12\00\00\00\a4\10\10\003\00\00\00z\00\00\00\1f\00\00\00\0e\00\00\00\10\00\00\00\16\00\00\00\15\00\00\00\0b\00\00\00\16\00\00\00\0d\00\00\00\0b\00\00\00\13\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\10\00\00\00\11\00\00\00\12\00\00\00\10\00\00\00\10\00\00\00\13\00\00\00\12\00\00\00\0d\00\00\00\0e\00\00\00\15\00\00\00\0c\00\00\00\0b\00\00\00\15\00\00\00\15\00\00\00\0f\00\00\00\0e\00\00\00\13\00\00\00&\00\00\008\00\00\00\19\00\00\00\17\00\00\00\0c\00\00\00\09\00\00\00\0a\00\00\00\10\00\00\00\17\00\00\00\19\00\00\00\0e\00\00\00\0d\00\00\00\14\00\00\00\08\00\00\00\1b\00\00\00\a7\05\10\00\97\05\10\00\81\05\10\00l\05\10\00a\05\10\00K\05\10\00>\05\10\003\05\10\00 \05\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\fd\07\10\00\ec\07\10\00\da\07\10\00\ca\07\10\00\ba\07\10\00\a7\07\10\00\95\07\10\00\88\07\10\00z\07\10\00e\07\10\00Y\07\10\00N\07\10\009\07\10\00$\07\10\00\15\07\10\00\07\07\10\00\f4\06\10\00\ce\06\10\00\96\06\10\00}\06\10\00f\06\10\00Z\06\10\00Q\06\10\00G\06\10\007\06\10\00 \06\10\00\07\06\10\00\f9\05\10\00\ec\05\10\00\d8\05\10\00\d0\05\10\00\b5\05\10\00/\00Success\00Illegal byte sequence\00Domain error\00Result not representable\00Not a tty\00Permission denied\00Operation not permitted\00No such file or directory\00No such process\00File exists\00Value too large for data type\00No space left on device\00Out of memory\00Resource busy\00Interrupted system call\00Resource temporarily unavailable\00Invalid seek\00Cross-device link\00Read-only file system\00Directory not empty\00Connection reset by peer\00Operation timed out\00Connection refused\00Host is unreachable\00Address in use\00Broken pipe\00I/O error\00No such device or address\00No such device\00Not a directory\00Is a directory\00Text file busy\00Exec format error\00Invalid argument\00Argument list too long\00Symbolic link loop\00Filename too long\00Too many open files in system\00No file descriptors available\00Bad file descriptor\00No child process\00Bad address\00File too large\00Too many links\00No locks available\00Resource deadlock would occur\00State not recoverable\00Previous owner died\00Operation canceled\00Function not implemented\00No message of desired type\00Identifier removed\00Link has been severed\00Protocol error\00Bad message\00Not a socket\00Destination address required\00Message too large\00Protocol wrong type for socket\00Protocol not available\00Protocol not supported\00Not supported\00Address family not supported by protocol\00Address not available\00Network is down\00Network unreachable\00Connection reset by network\00Connection aborted\00No buffer space available\00Socket is connected\00Socket not connected\00Operation already in progress\00Operation in progress\00Stale file handle\00Quota exceeded\00Multihop attempted\00Capabilities insufficient\00\00\00\00\00\00\00\00\00\00\00\00\00u\02N\00\d6\01\e2\04\b9\04\18\01\8e\05\ed\02\16\04\f2\00\97\03\01\038\05\af\01\82\01O\03/\04\1e\00\d4\05\a2\00\12\03\1e\03\c2\01\de\03\08\00\ac\05\00\01d\02\f1\01e\054\02\8c\02\cf\02-\03L\04\e3\05\9f\02\f8\04\1c\05\08\05\b1\02K\05\15\02x\00R\02<\03\f1\03\e4\00\c3\03}\04\cc\00\aa\03y\05$\02n\01m\03\22\04\ab\04D\00\fb\01\ae\00\83\03`\00\e5\01\07\04\94\04^\04+\00X\019\01\92\00\c2\05\9b\01C\02F\01\f6\05\00\00J\00\00\00\04\00\00\00\04\00\00\00K\00\00\00called `Option::unwrap()` on a `None` valuelibrary/alloc/src/raw_vec.rscapacity overflow\a3\1a\10\00\11\00\00\00\87\1a\10\00\1c\00\00\00\05\02\00\00\05\00\00\00library/alloc/src/ffi/c_str.rs\00\00\cc\1a\10\00\1e\00\00\00\1b\01\00\007\00\00\00NulErrorJ\00\00\00\04\00\00\00\04\00\00\00L\00\00\00J\00\00\00\04\00\00\00\04\00\00\00M\00\00\00)..\00%\1b\10\00\02\00\00\00BorrowMutErrorindex out of bounds: the len is  but the index is >\1b\10\00 \00\00\00^\1b\10\00\12\00\00\00called `Option::unwrap()` on a `None` value:$\1b\10\00\00\00\00\00\ab\1b\10\00\01\00\00\00\ab\1b\10\00\01\00\00\00U\00\00\00\00\00\00\00\01\00\00\00V\00\00\00panicked at '', \e0\1b\10\00\01\00\00\00\e1\1b\10\00\03\00\00\00$\1b\10\00\00\00\00\00matches!===assertion failed: `(left  right)`\0a  left: ``,\0a right: ``: \00\00\00\07\1c\10\00\19\00\00\00 \1c\10\00\12\00\00\002\1c\10\00\0c\00\00\00>\1c\10\00\03\00\00\00`\00\00\00\07\1c\10\00\19\00\00\00 \1c\10\00\12\00\00\002\1c\10\00\0c\00\00\00d\1c\10\00\01\00\00\00: \00\00$\1b\10\00\00\00\00\00\88\1c\10\00\02\00\00\00U\00\00\00\0c\00\00\00\04\00\00\00W\00\00\00X\00\00\00Y\00\00\00     {\0a,\0a,  { ..\0a}, .. } { .. } }(\0a(,\0a[\00U\00\00\00\04\00\00\00\04\00\00\00Z\00\00\00]0x00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899\00U\00\00\00\04\00\00\00\04\00\00\00[\00\00\00\5c\00\00\00]\00\00\00truefalserange start index  out of range for slice of length \00\00\00\d9\1d\10\00\12\00\00\00\eb\1d\10\00\22\00\00\00library/core/src/slice/index.rs\00 \1e\10\00\1f\00\00\004\00\00\00\05\00\00\00range end index P\1e\10\00\10\00\00\00\eb\1d\10\00\22\00\00\00 \1e\10\00\1f\00\00\00I\00\00\00\05\00\00\00slice index starts at  but ends at \00\80\1e\10\00\16\00\00\00\96\1e\10\00\0d\00\00\00 \1e\10\00\1f\00\00\00\5c\00\00\00\05\00\00\00\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\02\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\03\04\04\04\04\04\00\00\00\00\00\00\00\00\00\00\00library/core/src/str/mod.rs[...]byte index  is out of bounds of `\00\00\00\e4\1f\10\00\0b\00\00\00\ef\1f\10\00\16\00\00\00d\1c\10\00\01\00\00\00\c4\1f\10\00\1b\00\00\00k\00\00\00\09\00\00\00begin <= end ( <= ) when slicing `\00\000 \10\00\0e\00\00\00> \10\00\04\00\00\00B \10\00\10\00\00\00d\1c\10\00\01\00\00\00\c4\1f\10\00\1b\00\00\00o\00\00\00\05\00\00\00\c4\1f\10\00\1b\00\00\00}\00\00\00-\00\00\00 is not a char boundary; it is inside  (bytes ) of `\e4\1f\10\00\0b\00\00\00\94 \10\00&\00\00\00\ba \10\00\08\00\00\00\c2 \10\00\06\00\00\00d\1c\10\00\01\00\00\00\c4\1f\10\00\1b\00\00\00\7f\00\00\00\05\00\00\00library/core/src/unicode/printable.rs\00\00\00\00!\10\00%\00\00\00\1a\00\00\006\00\00\00\00\01\03\05\05\06\06\02\07\06\08\07\09\11\0a\1c\0b\19\0c\1a\0d\10\0e\0d\0f\04\10\03\12\12\13\09\16\01\17\04\18\01\19\03\1a\07\1b\01\1c\02\1f\16 \03+\03-\0b.\010\031\022\01\a7\02\a9\02\aa\04\ab\08\fa\02\fb\05\fd\02\fe\03\ff\09\adxy\8b\8d\a20WX\8b\8c\90\1c\dd\0e\0fKL\fb\fc./?\5c]_\e2\84\8d\8e\91\92\a9\b1\ba\bb\c5\c6\c9\ca\de\e4\e5\ff\00\04\11\12)147:;=IJ]\84\8e\92\a9\b1\b4\ba\bb\c6\ca\ce\cf\e4\e5\00\04\0d\0e\11\12)14:;EFIJ^de\84\91\9b\9d\c9\ce\cf\0d\11):;EIW[\5c^_de\8d\91\a9\b4\ba\bb\c5\c9\df\e4\e5\f0\0d\11EIde\80\84\b2\bc\be\bf\d5\d7\f0\f1\83\85\8b\a4\a6\be\bf\c5\c7\ce\cf\da\dbH\98\bd\cd\c6\ce\cfINOWY^_\89\8e\8f\b1\b6\b7\bf\c1\c6\c7\d7\11\16\17[\5c\f6\f7\fe\ff\80mq\de\df\0e\1fno\1c\1d_}~\ae\af\7f\bb\bc\16\17\1e\1fFGNOXZ\5c^~\7f\b5\c5\d4\d5\dc\f0\f1\f5rs\8ftu\96&./\a7\af\b7\bf\c7\cf\d7\df\9a@\97\980\8f\1f\d2\d4\ce\ffNOZ[\07\08\0f\10'/\ee\efno7=?BE\90\91Sgu\c8\c9\d0\d1\d8\d9\e7\fe\ff\00 _\22\82\df\04\82D\08\1b\04\06\11\81\ac\0e\80\ab\05\1f\09\81\1b\03\19\08\01\04/\044\04\07\03\01\07\06\07\11\0aP\0f\12\07U\07\03\04\1c\0a\09\03\08\03\07\03\02\03\03\03\0c\04\05\03\0b\06\01\0e\15\05N\07\1b\07W\07\02\06\16\0dP\04C\03-\03\01\04\11\06\0f\0c:\04\1d%_ m\04j%\80\c8\05\82\b0\03\1a\06\82\fd\03Y\07\16\09\18\09\14\0c\14\0cj\06\0a\06\1a\06Y\07+\05F\0a,\04\0c\04\01\031\0b,\04\1a\06\0b\03\80\ac\06\0a\06/1M\03\80\a4\08<\03\0f\03<\078\08+\05\82\ff\11\18\08/\11-\03!\0f!\0f\80\8c\04\82\97\19\0b\15\88\94\05/\05;\07\02\0e\18\09\80\be\22t\0c\80\d6\1a\0c\05\80\ff\05\80\df\0c\f2\9d\037\09\81\5c\14\80\b8\08\80\cb\05\0a\18;\03\0a\068\08F\08\0c\06t\0b\1e\03Z\04Y\09\80\83\18\1c\0a\16\09L\04\80\8a\06\ab\a4\0c\17\041\a1\04\81\da&\07\0c\05\05\80\a6\10\81\f5\07\01 *\06L\04\80\8d\04\80\be\03\1b\03\0f\0d\00\06\01\01\03\01\04\02\05\07\07\02\08\08\09\02\0a\05\0b\02\0e\04\10\01\11\02\12\05\13\11\14\01\15\02\17\02\19\0d\1c\05\1d\08$\01j\04k\02\af\03\bc\02\cf\02\d1\02\d4\0c\d5\09\d6\02\d7\02\da\01\e0\05\e1\02\e7\04\e8\02\ee \f0\04\f8\02\fa\02\fb\01\0c';>NO\8f\9e\9e\9f{\8b\93\96\a2\b2\ba\86\b1\06\07\096=>V\f3\d0\d1\04\14\1867VW\7f\aa\ae\af\bd5\e0\12\87\89\8e\9e\04\0d\0e\11\12)14:EFIJNOde\5c\b6\b7\1b\1c\07\08\0a\0b\14\1769:\a8\a9\d8\d9\097\90\91\a8\07\0a;>fi\8f\92o_\bf\ee\efZb\f4\fc\ff\9a\9b./'(U\9d\a0\a1\a3\a4\a7\a8\ad\ba\bc\c4\06\0b\0c\15\1d:?EQ\a6\a7\cc\cd\a0\07\19\1a\22%>?\e7\ec\ef\ff\c5\c6\04 #%&(38:HJLPSUVXZ\5c^`cefksx}\7f\8a\a4\aa\af\b0\c0\d0\ae\afno\93^\22{\05\03\04-\03f\03\01/.\80\82\1d\031\0f\1c\04$\09\1e\05+\05D\04\0e*\80\aa\06$\04$\04(\084\0bNC\817\09\16\0a\08\18;E9\03c\08\090\16\05!\03\1b\05\01@8\04K\05/\04\0a\07\09\07@ '\04\0c\096\03:\05\1a\07\04\0c\07PI73\0d3\07.\08\0a\81&RN(\08*\16\1a&\1c\14\17\09N\04$\09D\0d\19\07\0a\06H\08'\09u\0b?A*\06;\05\0a\06Q\06\01\05\10\03\05\80\8bb\1eH\08\0a\80\a6^\22E\0b\0a\06\0d\13:\06\0a6,\04\17\80\b9<dS\0cH\09\0aFE\1bH\08S\0dI\81\07F\0a\1d\03GI7\03\0e\08\0a\069\07\0a\816\19\80\b7\01\0f2\0d\83\9bfu\0b\80\c4\8aLc\0d\84/\8f\d1\82G\a1\b9\829\07*\04\5c\06&\0aF\0a(\05\13\82\b0[eK\049\07\11@\05\0b\02\0e\97\f8\08\84\d6*\09\a2\e7\813-\03\11\04\08\81\8c\89\04k\05\0d\03\09\07\10\92`G\09t<\80\f6\0as\08p\15F\80\9a\14\0cW\09\19\80\87\81G\03\85B\0f\15\84P\1f\80\e1+\80\d5-\03\1a\04\02\81@\1f\11:\05\01\84\e0\80\f7)L\04\0a\04\02\83\11DL=\80\c2<\06\01\04U\05\1b4\02\81\0e,\04d\0cV\0a\80\ae8\1d\0d,\04\09\07\02\0e\06\80\9a\83\d8\05\10\03\0d\03t\0cY\07\0c\04\01\0f\0c\048\08\0a\06(\08\22N\81T\0c\15\03\05\03\07\09\1d\03\0b\05\06\0a\0a\06\08\08\07\09\80\cb%\0a\84\06library/core/src/unicode/unicode_data.rs\00\00\00\a1&\10\00(\00\00\00K\00\00\00(\00\00\00\a1&\10\00(\00\00\00W\00\00\00\16\00\00\00\a1&\10\00(\00\00\00R\00\00\00>\00\00\00SomeNoneU\00\00\00\04\00\00\00\04\00\00\00^\00\00\00Utf8Errorvalid_up_toerror_len\00\00\00U\00\00\00\04\00\00\00\04\00\00\00_\00\00\00\00\03\00\00\83\04 \00\91\05`\00]\13\a0\00\12\17 \1f\0c `\1f\ef,\a0+*0 ,o\a6\e0,\02\a8`-\1e\fb`.\00\fe 6\9e\ff`6\fd\01\e16\01\0a!7$\0d\e17\ab\0ea9/\18\a190\1c\e1G\f3\1e!L\f0j\e1OOo!P\9d\bc\a1P\00\cfaQe\d1\a1Q\00\da!R\00\e0\e1S0\e1aU\ae\e2\a1V\d0\e8\e1V \00nW\f0\01\ffW\00p\00\07\00-\01\01\01\02\01\02\01\01H\0b0\15\10\01e\07\02\06\02\02\01\04#\01\1e\1b[\0b:\09\09\01\18\04\01\09\01\03\01\05+\03<\08*\18\01 7\01\01\01\04\08\04\01\03\07\0a\02\1d\01:\01\01\01\02\04\08\01\09\01\0a\02\1a\01\02\029\01\04\02\04\02\02\03\03\01\1e\02\03\01\0b\029\01\04\05\01\02\04\01\14\02\16\06\01\01:\01\01\02\01\04\08\01\07\03\0a\02\1e\01;\01\01\01\0c\01\09\01(\01\03\017\01\01\03\05\03\01\04\07\02\0b\02\1d\01:\01\02\01\02\01\03\01\05\02\07\02\0b\02\1c\029\02\01\01\02\04\08\01\09\01\0a\02\1d\01H\01\04\01\02\03\01\01\08\01Q\01\02\07\0c\08b\01\02\09\0b\06J\02\1b\01\01\01\01\017\0e\01\05\01\02\05\0b\01$\09\01f\04\01\06\01\02\02\02\19\02\04\03\10\04\0d\01\02\02\06\01\0f\01\00\03\00\03\1d\02\1e\02\1e\02@\02\01\07\08\01\02\0b\09\01-\03\01\01u\02\22\01v\03\04\02\09\01\06\03\db\02\02\01:\01\01\07\01\01\01\01\02\08\06\0a\02\010\1f1\040\07\01\01\05\01(\09\0c\02 \04\02\02\01\038\01\01\02\03\01\01\03:\08\02\02\98\03\01\0d\01\07\04\01\06\01\03\02\c6@\00\01\c3!\00\03\8d\01` \00\06i\02\00\04\01\0a \02P\02\00\01\03\01\04\01\19\02\05\01\97\02\1a\12\0d\01&\08\19\0b.\030\01\02\04\02\02'\01C\06\02\02\02\02\0c\01\08\01/\013\01\01\03\02\02\05\02\01\01*\02\08\01\ee\01\02\01\04\01\00\01\00\10\10\10\00\02\00\01\e2\01\95\05\00\03\01\02\05\04(\03\04\01\a5\02\00\04\00\02\99\0b1\04{\016\0f)\01\02\02\0a\031\04\02\02\07\01=\03$\05\01\08>\01\0c\024\09\0a\04\02\01_\03\02\01\01\02\06\01\a0\01\03\08\15\029\02\01\01\01\01\16\01\0e\07\03\05\c3\08\02\03\01\01\17\01Q\01\02\06\01\01\02\01\01\02\01\02\eb\01\02\04\06\02\01\02\1b\02U\08\02\01\01\02j\01\01\01\02\06\01\01e\03\02\04\01\05\00\09\01\02\f5\01\0a\02\01\01\04\01\90\04\02\02\04\01 \0a(\06\02\04\08\01\09\06\02\03.\0d\01\02\00\07\01\06\01\01R\16\02\07\01\02\01\02z\06\03\01\01\02\01\07\01\01H\02\03\01\01\01\00\02\00\05;\07\00\01?\04Q\01\00\02\00.\02\17\00\01\01\03\04\05\08\08\02\07\1e\04\94\03\007\042\08\01\0e\01\16\05\01\0f\00\07\01\11\02\07\01\02\01\05\00\07\00\01=\04\00\07m\07\00`\80\f0\00")
  (data $.data (i32.const 1059464) "\01\00\00\00\00\00\00\00\01\00\00\00\94\13\10\00"))
