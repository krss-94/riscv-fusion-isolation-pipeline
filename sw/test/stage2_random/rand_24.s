    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 912006184
    li x2, -1363257452
    li x3, 2140107612
    li x4, -1313849899
    li x5, 887188596
    li x6, 1142215581
    li x7, -251780636
    li x8, -1651012212
    li x9, 72561223
    li x10, 1967785814
    li x11, -839232411
    li x12, 1119079266
    li x13, -835980166
    li x14, 1690888754
    li x15, 1823781492
    li x16, -789550905
    li x17, -1848509130
    li x18, -1731279749
    li x19, 1284500622
    li x20, 2113029379
    li x21, 1545014602
    li x22, 1042753940
    li x23, 1823874231
    li x24, -1532872029
    li x25, -87825309
    li x26, -1583344173
    li x27, 23387196
    li x28, 1138194629
    li x29, -1105496406
    li x30, 562499959
    srli x11, x21, 14
    xori x26, x10, -1503
    srai x27, x11, 11
    lh x27, 12(x31)
    xor x2, x28, x15
    mulh x15, x26, x25
    srl x3, x11, x23
    li x13, -1199157092
    srai x12, x10, 21
    add x26, x19, x21
    srli x30, x18, 26
    sh x29, 16(x31)
    divu x22, x25, x12
    li x24, 1757065279
    mulhu x15, x26, x3
    li x8, -233146720
    addi x27, x2, -1376
    addi x30, x1, 1956
    addi x30, x11, 482
    li x6, 1138029821
    lh x26, 16(x31)
    sw x30, 28(x31)
    mulhu x14, x30, x22
    slli x3, x7, 9
    andi x15, x11, -146
    lw x5, 16(x31)
    lhu x29, 16(x31)
    and x7, x7, x13
    lhu x26, 20(x31)
    sb x5, 0(x31)
    addi x27, x7, -194
    sltiu x9, x10, -96
    slli x8, x10, 18
    slti x12, x21, 356
    srli x27, x8, 25
    sra x3, x12, x15
    slli x15, x16, 26
    add x4, x6, x17
    li x28, 682367077
    sltiu x30, x23, -298
    ori x4, x21, -299
    slli x20, x21, 23
    slli x17, x28, 18
    srai x28, x19, 24
    slt x29, x28, x3
    remu x30, x1, x8
    li x16, 436095275
    sub x20, x21, x21
    srai x21, x24, 14
    slti x11, x6, 1400
    li x9, 253780518
    mulhsu x18, x12, x10
    mulhsu x27, x24, x26
    sh x18, 0(x31)
    sw x18, 12(x31)
    li x15, 1746357077
    lw x7, 20(x31)
    li x25, -1960013483
    sh x11, 16(x31)
    ori x21, x4, 1508
done: j done
    .section .data
    .align 4
scratch: .space 64
