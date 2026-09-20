    .section .text.init
    .global _start
_start:
    li   x1, 100
    addi x2, x1, -50
    slti x3, x1, 200
    sltiu x4, x1, 50
    xori x5, x1, 15
    ori  x6, x1, 15
    andi x7, x1, 15
    slli x8, x1, 3
    srli x9, x1, 3
    li   x10, -100
    srai x11, x10, 3
done: j done
