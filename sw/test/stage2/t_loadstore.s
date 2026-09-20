    .section .text.init
    .global _start
_start:
    la   x1, scratch
    li   x2, 0x1
    li   x3, -1
    sb   x2, 0(x1)
    sb   x3, 1(x1)
    lb   x4, 0(x1)
    lbu  x5, 1(x1)
    li   x6, 0x1234
    sh   x6, 4(x1)
    lh   x7, 4(x1)
    lhu  x8, 4(x1)
    li   x9, 0xDEADBEEF
    sw   x9, 8(x1)
    lw   x10, 8(x1)
done: j done
    .section .data
    .align 4
scratch: .space 32
