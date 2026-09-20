# Idiom 5 positive test: ADD/ADDI rd,... + LW rd2,0(rd).
# Filler instructions between the idiom-1 setup and idiom-5 pair give x6
# time to land in the register file -- idiom5's ID-time operand read has
# no forwarding, so immediate reuse correctly declines to fuse (verified).
.section .data
.align 2
data_word:
    .word 0xcafebabe

.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter5, x0
    lui   x6, %hi(data_word)
    addi  x6, x6, %lo(data_word)   # x6 <- addr(data_word) (idiom-1)
    addi  x0, x0, 0                # filler
    addi  x0, x0, 0                # filler
    addi  x5, x6, 0                # x5 <- x6; idiom-5 ADD/ADDI half
    lw    x7, 0(x5)                # x7 <- *x5; idiom-5 LW half
    csrrs x11, mhpmcounter5, x0    # must be 2 (idiom1 + idiom5)
    addi  x20, x5, 0
    addi  x21, x7, 0
loop:
    j loop
