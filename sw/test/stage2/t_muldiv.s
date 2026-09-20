    .section .text.init
    .global _start
_start:
    li x1, 100
    li x2, -7
    mul    x3, x1, x2
    mulh   x4, x1, x2
    mulhu  x5, x1, x2
    mulhsu x6, x1, x2
    div    x7, x1, x2
    divu   x8, x1, x2
    rem    x9, x1, x2
    remu   x10, x1, x2
    li x11, 5
    li x12, 0
    div  x13, x11, x12
    rem  x14, x11, x12
    divu x15, x11, x12
    remu x16, x11, x12
    li x17, 0x80000000
    li x18, -1
    div  x19, x17, x18
    rem  x20, x17, x18
done: j done
