# Part 10 §4.7 (adapted -- no async interrupts in this core, only
# synchronous illegal-instr traps). Confirms: (a) the global muldiv_busy
# freeze prevents the illegal instruction right after MUL from reaching
# EX until the multiply retires -- MUL completes correctly, not
# corrupted/interrupted mid-iteration; (b) mepc correctly reflects the
# illegal instruction's own PC after the stall releases.
.section .text
.globl _start
_start:
    li   x1, 6
    li   x2, 7
    mul  x3, x1, x2                # multi-cycle, freezes whole pipeline
    .word 0b00000000000000000010000000001011   # illegal, right after MUL
    addi x4, x0, 0x99              # must NOT execute
.org 0x1000
handler:
    csrrs x20, mepc, x0
    csrrs x21, mcause, x0
loop:
    j loop
