    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1475092522
    li x2, 1596474189
    li x3, 586098746
    li x4, -1049330653
    li x5, -326073217
    li x6, 1426962201
    li x7, 536784836
    li x8, 355520872
    li x9, -367537632
    li x10, -168605296
    li x11, -1845247443
    li x12, 270917124
    li x13, -1408439744
    li x14, 255905173
    li x15, -74137066
    li x16, 1358655028
    li x17, -932655833
    li x18, 1350527498
    li x19, -183677501
    li x20, -1204198083
    li x21, -1588664434
    li x22, -1749668360
    li x23, 792418593
    li x24, 1097346825
    li x25, -541243388
    li x26, -206403184
    li x27, -842785391
    li x28, -22892297
    li x29, -182465608
    li x30, 778832769
    mulh x13, x12, x17
    li x25, 1774204595
    lw x1, 16(x31)
    and x24, x26, x9
    li x2, 1339119495
    sw x2, 8(x31)
    srai x3, x4, 9
    srai x5, x9, 5
    lb x7, 8(x31)
    xor x20, x30, x1
    sh x17, 12(x31)
    sub x23, x3, x23
    srli x1, x15, 18
    srli x9, x9, 10
    li x14, -827687940
    srli x3, x24, 9
    remu x2, x8, x16
    srli x27, x17, 19
    srli x10, x30, 9
    mulh x3, x8, x2
    slti x27, x19, -1949
    sltiu x22, x3, 522
    lb x28, 0(x31)
    li x12, -2008970830
    sb x25, 28(x31)
    li x26, -1783836149
    srl x16, x6, x25
    li x20, -1451351067
    sb x18, 0(x31)
    slli x24, x30, 12
    sra x17, x13, x4
    slt x20, x21, x30
    mulhu x6, x26, x26
    lbu x7, 24(x31)
    srl x28, x29, x15
    slti x10, x8, -600
    remu x25, x2, x11
    li x23, -1249175675
    srli x14, x20, 28
    sra x28, x7, x12
    sb x17, 4(x31)
    lb x13, 8(x31)
    slli x14, x14, 20
    sra x28, x14, x16
    xori x2, x18, 141
    xor x14, x1, x3
    addi x3, x2, -2008
    sub x16, x2, x19
    or x28, x21, x29
    li x30, 112520392
    mulhu x19, x14, x17
    li x20, 1518043255
    srai x1, x13, 3
    slli x24, x25, 9
    mul x11, x9, x1
    srai x19, x29, 28
    srai x12, x28, 27
    lw x29, 4(x31)
    li x30, 901803545
    sltiu x10, x5, 196
done: j done
    .section .data
    .align 4
scratch: .space 64
