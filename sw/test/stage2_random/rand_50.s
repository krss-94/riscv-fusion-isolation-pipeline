    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1004276211
    li x2, 2020078392
    li x3, -784351584
    li x4, -1488989877
    li x5, 1397040570
    li x6, 2060393961
    li x7, -775934618
    li x8, -1335868020
    li x9, 461684096
    li x10, 579772299
    li x11, 1986221454
    li x12, 1395450845
    li x13, -299392958
    li x14, -1171576427
    li x15, 1846909867
    li x16, -1693096942
    li x17, 1764425339
    li x18, -171832103
    li x19, 339626728
    li x20, 1371986184
    li x21, -16729181
    li x22, -1610143907
    li x23, 71258783
    li x24, 71857507
    li x25, -2118519874
    li x26, -382466758
    li x27, -1184620150
    li x28, -1559687624
    li x29, -1091994320
    li x30, 76758151
    li x3, -338490035
    lhu x14, 24(x31)
    add x13, x4, x12
    li x25, -2109534788
    slli x28, x12, 31
    srai x6, x14, 7
    add x1, x6, x5
    addi x1, x10, 864
    andi x17, x2, 474
    lhu x1, 24(x31)
    srai x18, x5, 1
    lhu x10, 20(x31)
    srli x2, x5, 30
    andi x26, x4, 1060
    li x9, -1620624577
    lhu x3, 16(x31)
    li x15, 480264316
    li x9, 1972846954
    slti x10, x8, 2032
    addi x4, x23, 1064
    sb x18, 4(x31)
    sw x8, 24(x31)
    sub x17, x10, x16
    ori x6, x30, 693
    sltiu x1, x8, 1984
    sb x15, 4(x31)
    sub x12, x1, x7
    addi x5, x4, 1557
    srli x24, x16, 10
    li x13, 1131725761
    mul x20, x28, x1
    rem x16, x20, x11
    li x4, -166901898
    mulh x21, x23, x28
    li x24, 704755982
    lw x1, 16(x31)
    sw x13, 24(x31)
    xori x19, x5, -267
    divu x9, x11, x22
    slli x10, x12, 30
    li x4, 142273098
    lhu x29, 24(x31)
    lw x1, 8(x31)
    li x26, 1360122868
    sb x2, 12(x31)
    slti x17, x12, 981
    srl x30, x30, x17
    sh x14, 20(x31)
    slli x15, x30, 12
    lhu x14, 24(x31)
    li x23, 2143545897
    sb x14, 12(x31)
    sra x18, x12, x20
    sra x12, x21, x18
    slti x9, x14, 110
    and x29, x10, x20
    sub x22, x11, x27
    sh x25, 0(x31)
    and x1, x15, x3
    srai x13, x30, 7
done: j done
    .section .data
    .align 4
scratch: .space 64
