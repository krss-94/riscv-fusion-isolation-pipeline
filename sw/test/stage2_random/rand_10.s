    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 306671827
    li x2, -305419184
    li x3, 335399608
    li x4, -1262298496
    li x5, 1345704537
    li x6, 1389803639
    li x7, -1459302929
    li x8, 88774231
    li x9, -739710141
    li x10, 2132696047
    li x11, -1956115428
    li x12, 1546879875
    li x13, 443200297
    li x14, -508498423
    li x15, 751468301
    li x16, -185408787
    li x17, 798269022
    li x18, 695124659
    li x19, -1576346870
    li x20, 2071949149
    li x21, 2016006815
    li x22, 486734992
    li x23, -2130066937
    li x24, -1572076031
    li x25, 1710239870
    li x26, 210376882
    li x27, -274744937
    li x28, 363123287
    li x29, -374219585
    li x30, -1988892516
    mulh x10, x27, x20
    lhu x30, 8(x31)
    lb x12, 8(x31)
    li x25, 1320486646
    srai x14, x14, 15
    slli x5, x20, 11
    slli x15, x10, 11
    rem x25, x12, x11
    sltiu x1, x18, -1691
    srli x8, x3, 28
    lbu x6, 28(x31)
    sw x30, 28(x31)
    remu x3, x6, x16
    divu x5, x14, x18
    lw x13, 8(x31)
    mul x4, x14, x27
    li x1, -1868565387
    srli x3, x5, 29
    sltiu x15, x28, 1614
    sh x29, 28(x31)
    srai x21, x17, 9
    andi x11, x20, -446
    lb x19, 28(x31)
    li x4, -1765031396
    lh x30, 4(x31)
    ori x22, x16, 909
    divu x30, x26, x7
    slti x3, x19, 1447
    sra x22, x10, x29
    li x24, 955520671
    mulhsu x22, x24, x18
    slli x20, x12, 0
    rem x20, x14, x28
    li x26, -1910187572
    srai x12, x15, 12
    sw x15, 16(x31)
    rem x17, x30, x9
    div x21, x11, x12
    remu x29, x15, x28
    lhu x16, 20(x31)
    li x6, 1445071695
    xor x19, x11, x21
    xor x24, x13, x20
    srli x20, x6, 10
    add x18, x26, x27
    slti x19, x24, 1406
    lhu x19, 0(x31)
    ori x11, x28, -486
    li x19, -1932142366
    lh x12, 24(x31)
    lb x21, 8(x31)
    lb x26, 8(x31)
    sb x18, 20(x31)
    divu x15, x19, x29
    sra x5, x30, x28
    sw x20, 28(x31)
    ori x12, x27, 764
    lhu x15, 4(x31)
    sw x2, 8(x31)
    sw x19, 20(x31)
done: j done
    .section .data
    .align 4
scratch: .space 64
