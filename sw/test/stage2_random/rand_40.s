    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -2010704054
    li x2, 705743586
    li x3, -651163291
    li x4, -1589678743
    li x5, 606733207
    li x6, 1984211197
    li x7, 449875875
    li x8, -1659559168
    li x9, 1999727295
    li x10, -1728440058
    li x11, 1620431761
    li x12, 1101564883
    li x13, -1486823451
    li x14, 1401224149
    li x15, 2100407677
    li x16, -1243561210
    li x17, -1870894981
    li x18, 359577308
    li x19, 366453978
    li x20, -1766936157
    li x21, 478305804
    li x22, -1665310092
    li x23, 1464666932
    li x24, -166010358
    li x25, -1721042064
    li x26, 1845099044
    li x27, 1247630696
    li x28, -494459218
    li x29, 958994774
    li x30, 1006591560
    ori x19, x1, 1877
    slti x29, x8, -462
    slti x10, x9, -1297
    li x11, -1077288372
    slti x6, x2, -113
    div x22, x14, x16
    slli x17, x8, 25
    li x6, -1449635491
    li x26, -588969710
    sw x25, 20(x31)
    sw x18, 16(x31)
    mul x9, x21, x23
    lw x30, 0(x31)
    slli x10, x24, 7
    lh x17, 0(x31)
    sll x9, x4, x6
    lbu x19, 20(x31)
    slli x30, x20, 30
    sh x6, 0(x31)
    sra x8, x30, x15
    srli x30, x24, 14
    lhu x26, 28(x31)
    xor x7, x14, x27
    sh x5, 24(x31)
    and x18, x25, x7
    or x1, x21, x6
    sh x4, 20(x31)
    lw x26, 12(x31)
    and x25, x5, x6
    mulh x24, x19, x4
    addi x14, x16, -1971
    srli x10, x1, 30
    lhu x5, 4(x31)
    ori x3, x20, -1772
    rem x18, x8, x15
    lw x20, 28(x31)
    div x8, x16, x5
    rem x15, x25, x12
    li x8, -1613751190
    lhu x1, 12(x31)
    srai x30, x27, 15
    mulhsu x6, x23, x16
    mulh x14, x26, x10
    sw x6, 24(x31)
    li x23, -1287729611
    slli x19, x25, 24
    sub x30, x22, x14
    li x9, -1208157441
    lb x24, 24(x31)
    lhu x24, 20(x31)
    mulhsu x12, x29, x22
    li x16, 1983301605
    sb x11, 28(x31)
    sra x28, x27, x9
    lbu x6, 0(x31)
    lw x27, 24(x31)
    srai x19, x13, 10
    lbu x10, 0(x31)
    ori x6, x21, -726
    slli x3, x13, 4
done: j done
    .section .data
    .align 4
scratch: .space 64
