# Part 10 §4.6a — LUI+ADDI idiom straddling a taken branch: LUI is the
# fall-through (wrong-path) instruction sitting in ID exactly when the
# branch resolves in EX. Confirms fusion_active does not spuriously
# pulse for a pair that gets squashed by the redirect same-cycle.
.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter5, x0   # x10 <- 0 (before)
    li    x1, 1
    beq   x1, x1, target          # always taken
    lui   x5, 0x12345             # wrong-path fall-through
    addi  x5, x5, 0x678           # wrong-path, syntactically matches idiom1
target:
    csrrs x11, mhpmcounter5, x0   # x11 <- must still be 0: no real fusion happened
loop:
    j loop
