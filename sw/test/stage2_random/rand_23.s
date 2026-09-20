    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1926747151
    li x2, -1788636200
    li x3, 395253927
    li x4, -327502391
    li x5, 129227022
    li x6, -1322862141
    li x7, -238054685
    li x8, -2041110322
    li x9, 901978345
    li x10, -338235690
    li x11, 1005920330
    li x12, -1900288816
    li x13, 1215915377
    li x14, 382782463
    li x15, 678229940
    li x16, 519654362
    li x17, 309438575
    li x18, -111383853
    li x19, 935933504
    li x20, 611510879
    li x21, -1656563696
    li x22, -1723981833
    li x23, 312767675
    li x24, -726687618
    li x25, 1192207749
    li x26, 210425366
    li x27, -1037584530
    li x28, 1218950656
    li x29, 1411177314
    li x30, -1125168064
    lhu x5, 4(x31)
    xori x15, x2, 1361
    add x6, x26, x8
    andi x26, x24, 1598
    srl x12, x1, x26
    div x7, x2, x3
    remu x18, x7, x25
    srai x7, x3, 10
    lb x18, 16(x31)
    remu x6, x29, x1
    li x11, 1333496514
    slt x23, x27, x29
    lw x10, 16(x31)
    lb x18, 16(x31)
    or x21, x5, x11
    sw x14, 8(x31)
    or x11, x18, x23
    sra x8, x29, x18
    li x15, -2130552951
    rem x1, x26, x5
    andi x26, x22, -630
    rem x24, x14, x3
    sw x16, 8(x31)
    lbu x10, 4(x31)
    srl x28, x29, x16
    li x1, 451287486
    srli x22, x11, 22
    slli x30, x11, 24
    remu x29, x27, x22
    li x18, 166636427
    sb x13, 16(x31)
    lb x12, 28(x31)
    slli x19, x25, 0
    srai x26, x28, 15
    sh x2, 4(x31)
    slti x12, x19, -1308
    sh x13, 20(x31)
    and x20, x30, x23
    addi x2, x4, -553
    xori x20, x22, 364
    sb x19, 0(x31)
    lb x25, 20(x31)
    slti x12, x3, -293
    mulhsu x11, x25, x20
    lw x19, 20(x31)
    sh x24, 16(x31)
    sh x5, 24(x31)
    li x30, -450692913
    sb x25, 8(x31)
    srli x14, x14, 2
    sw x16, 8(x31)
    mul x12, x8, x11
    sh x15, 8(x31)
    li x12, 2007979525
    lw x29, 24(x31)
    addi x30, x15, 1476
    rem x27, x1, x13
    srli x2, x24, 26
    srai x24, x22, 17
    ori x5, x20, 1754
done: j done
    .section .data
    .align 4
scratch: .space 64
