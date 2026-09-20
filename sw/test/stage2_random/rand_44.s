    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1554935455
    li x2, -1388710485
    li x3, -1180430850
    li x4, -2022511894
    li x5, -2109663772
    li x6, 2102356052
    li x7, -746809454
    li x8, -1831574054
    li x9, 1466829679
    li x10, 503455896
    li x11, -1741061422
    li x12, 1971060347
    li x13, 2016776980
    li x14, -1997145484
    li x15, -490146623
    li x16, -97577488
    li x17, 1790526592
    li x18, -1337482158
    li x19, -1936150906
    li x20, -735930437
    li x21, 1419408052
    li x22, 560743207
    li x23, 174072402
    li x24, -1145633175
    li x25, -1960123488
    li x26, -1472017320
    li x27, 185549854
    li x28, -1292583504
    li x29, -1668512389
    li x30, -686634330
    li x8, 528658183
    add x5, x6, x30
    lh x21, 4(x31)
    sll x1, x14, x9
    sb x21, 12(x31)
    srai x16, x9, 21
    li x16, -38063419
    remu x13, x10, x18
    sll x11, x9, x5
    sh x3, 28(x31)
    sh x30, 4(x31)
    lbu x25, 20(x31)
    sra x23, x8, x18
    srl x17, x9, x28
    sb x15, 8(x31)
    lh x12, 20(x31)
    mulh x5, x30, x1
    rem x21, x22, x23
    remu x19, x21, x24
    andi x8, x6, -839
    or x11, x10, x1
    sb x20, 8(x31)
    lhu x1, 4(x31)
    lhu x17, 16(x31)
    andi x9, x30, -724
    lw x23, 20(x31)
    li x10, 1269940183
    sub x7, x1, x6
    xori x18, x4, -757
    sb x29, 20(x31)
    lhu x9, 16(x31)
    li x26, 1923439628
    remu x6, x10, x15
    remu x10, x26, x10
    mulh x13, x16, x15
    li x23, -1317286143
    li x8, -1399490504
    srl x12, x8, x14
    slli x2, x9, 27
    sltu x8, x26, x18
    slt x6, x25, x21
    sh x11, 20(x31)
    mul x1, x19, x19
    srai x6, x21, 21
    sra x12, x6, x2
    srl x23, x3, x10
    add x6, x15, x9
    addi x17, x1, -1416
    or x1, x18, x25
    srai x27, x21, 7
    slli x15, x8, 31
    or x1, x13, x1
    sw x4, 12(x31)
    lhu x19, 0(x31)
    mulhsu x30, x27, x19
    or x18, x13, x4
    li x30, -1736550880
    slli x9, x8, 21
    lh x17, 0(x31)
    xori x14, x1, 1628
done: j done
    .section .data
    .align 4
scratch: .space 64
