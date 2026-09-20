# Idiom 4 positive test: SLT{,U,I} rd,rs1,rs2 + BEQ/BNE rd,x0,off,
# immediately lookahead-adjacent (Part 8 SS2.2 idiom 4). Verifies the
# compare's own rd write survives fusion (x5) and that the fused branch
# actually redirects control flow (taken path reached, not fallthrough).
.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter5, x0   # x10 <- 0 (before any fusion)
    addi  x6, x0, 5
    addi  x7, x0, 3
slt_pc:
    slt   x5, x7, x6              # x5 <- (x7 < x6) = 1
    bne   x5, x0, taken           # fused compare+branch; x5 != 0 -> taken
    lui   x8, 0xdead              # wrong-path fall-through (skipped)
taken:
    csrrs x11, mhpmcounter5, x0   # x11 <- must be 1 (exactly one fusion)
    addi  x20, x5, 0              # x20 <- x5, to check SLT's rd survived
loop:
    j loop
