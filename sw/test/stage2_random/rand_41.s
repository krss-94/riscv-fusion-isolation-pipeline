    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -511012255
    li x2, 1777401080
    li x3, 816613560
    li x4, 227888720
    li x5, 328255612
    li x6, 1207785888
    li x7, 1457273915
    li x8, 958506432
    li x9, -1428030328
    li x10, -1891936761
    li x11, -2005722990
    li x12, 1575787855
    li x13, -1220314667
    li x14, 971684740
    li x15, 997893185
    li x16, 729939606
    li x17, -1615905936
    li x18, 1774773120
    li x19, 2061605478
    li x20, -1917576063
    li x21, -782542073
    li x22, 514966240
    li x23, -1365411153
    li x24, 1488323649
    li x25, -852910498
    li x26, -1520815275
    li x27, 720090758
    li x28, -398611037
    li x29, -451725481
    li x30, -2054434117
    xori x3, x15, 1243
    lb x24, 0(x31)
    sb x11, 8(x31)
    sw x24, 4(x31)
    sw x29, 24(x31)
    sw x3, 24(x31)
    li x4, -268917601
    sh x22, 24(x31)
    slt x22, x9, x18
    sw x9, 20(x31)
    remu x26, x29, x10
    sb x7, 8(x31)
    slt x8, x6, x16
    and x8, x18, x19
    xori x16, x11, -178
    sw x4, 28(x31)
    sh x7, 28(x31)
    slli x29, x9, 22
    ori x19, x23, -795
    lb x21, 24(x31)
    xor x17, x22, x20
    sltiu x22, x13, 473
    addi x9, x28, -159
    li x23, 375333854
    slli x13, x26, 15
    lhu x16, 12(x31)
    slti x29, x16, -1458
    rem x16, x19, x27
    or x20, x27, x23
    slt x25, x25, x21
    divu x26, x16, x11
    lbu x6, 0(x31)
    slti x28, x20, 1233
    srl x21, x19, x17
    sltu x8, x27, x28
    lhu x1, 12(x31)
    sw x2, 20(x31)
    lw x23, 4(x31)
    lbu x24, 20(x31)
    slli x16, x3, 28
    sb x4, 24(x31)
    lh x27, 28(x31)
    lh x26, 4(x31)
    remu x12, x6, x28
    addi x9, x6, -1316
    li x1, -803164520
    li x1, 1728695948
    li x29, 944815245
    lh x28, 16(x31)
    ori x25, x29, 1821
    li x29, 681029292
    sw x20, 16(x31)
    sh x29, 0(x31)
    lh x2, 20(x31)
    srli x9, x30, 18
    srai x3, x3, 16
    srli x5, x13, 0
    sw x12, 24(x31)
    sb x14, 12(x31)
    li x7, 476946280
done: j done
    .section .data
    .align 4
scratch: .space 64
