# Idiom 4 negative test: SLT+BNE syntactically adjacent but rs2 != x0,
# which breaks the exact idiom4 pattern (id_branch_rs2 == 5'd0 required).
# Must NOT fuse; must still execute correctly via normal unfused path.
.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter5, x0   # x10 <- fusion count before (expect 0)
    addi  x6, x0, 5
    addi  x7, x0, 3
    addi  x9, x0, 1
    slt   x5, x7, x6              # x5 <- (3<5) = 1
    bne   x5, x9, wrong           # rs2=x9 (not x0) -> NOT idiom4; x5==x9==1 -> not taken
    addi  x22, x0, 0xAA           # correct fallthrough path
    j done
wrong:
    lui   x8, 0xdead              # must NOT be reached
done:
    csrrs x11, mhpmcounter5, x0   # x11 <- fusion count after (expect still 0: no fuse)
loop:
    j loop
