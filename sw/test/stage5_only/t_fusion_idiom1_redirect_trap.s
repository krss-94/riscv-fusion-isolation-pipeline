# Part 10 §4.6c — LUI+ADDI idiom straddling an interrupt/trap-entry
# boundary. Illegal instruction resolves in EX same cycle LUI (its
# fall-through successor) sits in ID -- same redirect-timing hazard as
# 4.6a/4.6b, mtvec redirect instead of branch/JALR.
.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter5, x0   # x10 <- 0 (before)
    .word 0b00000000000000000010000000001011   # reserved FISOL funct3=010 -> illegal, traps to mtvec (0x80001000)
    lui   x5, 0x12345             # wrong-path fall-through
    addi  x5, x5, 0x678           # wrong-path, syntactically matches idiom1
.org 0x1000
handler:
    csrrs x11, mhpmcounter5, x0   # x11 <- must still be 0
loop:
    j loop
