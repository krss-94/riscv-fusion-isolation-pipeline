    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1133664809
    li x2, -446426455
    li x3, -1481882790
    li x4, -1861803471
    li x5, 1795103241
    li x6, 1138864728
    li x7, 157539438
    li x8, -1691429874
    li x9, 1835993865
    li x10, 1317061808
    li x11, 1290413637
    li x12, -1316683993
    li x13, -816688224
    li x14, 1632305552
    li x15, 454630388
    li x16, 737452156
    li x17, 25571273
    li x18, -1383880669
    li x19, -113439163
    li x20, -857938010
    li x21, 1756084543
    li x22, 1642040057
    li x23, 35959074
    li x24, -369598927
    li x25, 424825853
    li x26, -296167990
    li x27, -1454616925
    li x28, -837039304
    li x29, -1961775832
    li x30, -1948532166
    sw x17, 28(x31)
    srli x5, x22, 4
    slti x21, x21, 215
    srai x14, x24, 20
    lb x7, 4(x31)
    sb x9, 12(x31)
    slli x30, x6, 29
    sltu x12, x23, x3
    sh x11, 20(x31)
    srai x5, x25, 26
    sh x3, 12(x31)
    srli x5, x9, 10
    lbu x1, 28(x31)
    srai x26, x26, 18
    slt x15, x7, x14
    sll x2, x2, x2
    lw x22, 0(x31)
    mul x19, x8, x11
    srl x27, x17, x10
    sh x16, 12(x31)
    rem x16, x2, x8
    rem x8, x21, x29
    li x7, -2011546370
    slli x9, x8, 13
    divu x28, x9, x5
    and x29, x30, x11
    add x19, x13, x29
    mulhsu x13, x3, x14
    li x19, -1436857366
    srli x22, x16, 20
    lh x7, 16(x31)
    div x16, x3, x28
    sw x7, 24(x31)
    slti x25, x9, -1553
    sw x15, 28(x31)
    mul x30, x13, x7
    addi x30, x6, 60
    rem x26, x25, x26
    slti x18, x2, -396
    sw x11, 28(x31)
    mulh x1, x3, x2
    mulhu x18, x28, x9
    or x12, x3, x25
    sub x10, x27, x12
    slt x18, x15, x13
    li x10, 1111158163
    li x13, 1655035135
    lb x14, 28(x31)
    sh x7, 16(x31)
    mulhu x4, x26, x18
    srli x28, x6, 9
    mul x28, x11, x9
    sb x1, 16(x31)
    lw x4, 28(x31)
    sltu x17, x8, x14
    srai x8, x25, 0
    or x20, x30, x11
    div x26, x30, x19
    li x17, -248826816
    andi x9, x25, 918
done: j done
    .section .data
    .align 4
scratch: .space 64
