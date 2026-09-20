    .section .text.init
    .global _start
_start:
    li x1, 5
    li x2, 3
    add  x3, x1, x2
    sub  x4, x1, x2
    sll  x5, x1, x2
    slt  x6, x2, x1
    sltu x7, x2, x1
    xor  x8, x1, x2
    srl  x9, x1, x2
    sra  x10, x1, x2
    or   x11, x1, x2
    and  x12, x1, x2
    li x13, -8
    li x14, 2
    sra  x15, x13, x14
done: j done
