# Idiom 4 BEQ/not-taken test: exercises fuse4_branch_taken's other arm
# (BEQ taken iff alu_result==0) with a not-taken outcome -- idiom1_pos-
# style tests only ever exercised BNE-taken so far.
.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter5, x0   # x10 <- fusion count before (expect 0)
    addi  x6, x0, 5
    addi  x7, x0, 3
slt_pc:
    slt   x5, x7, x6              # x5 <- (3<5) = 1 (nonzero)
    beq   x5, x0, wrong           # x5 != 0 -> BEQ NOT taken -> falls through (correct)
    addi  x22, x0, 0xBB           # correct fallthrough path
    j done
wrong:
    lui   x8, 0xdead              # must NOT be reached
done:
    csrrs x11, mhpmcounter5, x0   # x11 <- fusion count after (expect 1: pattern still fused)
loop:
    j loop
