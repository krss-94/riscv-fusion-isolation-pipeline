# Stage 3 — Bare-Metal Execution: Status

## Result
crt0 (.bss zero, stack init) + hand-rolled UART "hello\n" runs correctly on
the Stage 2 single-cycle RTL core. Verified via testbench-level UART byte
capture (store to 0x80000000 -> stderr), output exactly h,e,l,l,o,\n.

## Deviations, flagged
1. No libc on this VM at all (no newlib-nano, no picolibc -- confirmed
   absent during Stage 2 toolchain checks). Used a hand-rolled uart_putc
   loop instead of printf. Real gap against Part 9 §4's literal spec.
   ATTEMPTED FIX, BLOCKED (not silently abandoned): tried building picolibc
   from source against this VM's toolchain. Failed with "Cannot find
   suitable multilib set for rv32im_zicsr/ilp32" -- this toolchain was
   built `--disable-multilib --with-arch=rv32imf --with-abi=ilp32f`
   (confirmed via `gcc -v`), meaning it has exactly ONE hardcoded runtime-
   library target and cannot resolve default libgcc/crt/libc for any other
   march/abi pair, including ours. -nostdlib code (everything built so far
   in Stages 2-3) sidesteps this since it never asks the compiler to
   resolve runtime libs. Building any real libc needs either (a) a full
   `riscv-gnu-toolchain` rebuild with multilib enabled (multi-hour build,
   not attempted), or (b) building picolibc against the toolchain's actual
   rv32imf/ilp32f target and accepting an ilp32/ilp32f ABI mismatch between
   our own -nostdlib code and the library -- a real FP-calling-convention
   correctness risk, not a clean fix. Left unresolved and flagged rather
   than either grinding through the rebuild or accepting the ABI risk
   silently.
2. link_stage3.ld uses MEM_BASE=0x80000000 (matching Stage 2 RTL's own
   parameter, chosen for Spike-harness parity), not the real fixed 0x0 boot
   address (Part 7 §5 / Part 8 §2.7). Same caveat as Stage 1's
   link_spike.ld -- not authoritative, must reconcile at Stage 4/5.
3. UART is testbench-level only (tb_core.cpp watches for stores to
   0x80000000 and prints them) -- no actual UART peripheral RTL exists.
   Standard early-bring-up practice, not a real peripheral model.

## Update: real crt0.s (with csrw mtvec) verified
Re-ran with Part 9's actual crt0.s, unmodified, including the csrw mtvec
setup this core doesn't implement -- confirmed harmless no-op (falls
through decoder.sv's default case, same as FISOL/SYSTEM generally). Output
"hello2\n" via a real main() called from crt0, not the earlier standalone
asm smoke test. Full crt0->bss-zero->CSR-noop->main->UART path confirmed.

## Not done
- No actual libc (see deviation #1) -- both hello tests hand-roll their own
  UART output; printf-based output remains unverified on this VM.
