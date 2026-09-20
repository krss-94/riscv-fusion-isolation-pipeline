    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 302058296
    li x2, 567936413
    li x3, -956528493
    li x4, 14576436
    li x5, 121402504
    li x6, -235131847
    li x7, 582482729
    li x8, -853433797
    li x9, 1488583553
    li x10, 1838179633
    li x11, 778903489
    li x12, -1906881497
    li x13, 1703647465
    li x14, 1072965041
    li x15, -976220585
    li x16, -2120112318
    li x17, -454367086
    li x18, -2006116381
    li x19, -1615586809
    li x20, -1507749891
    li x21, -787899724
    li x22, -1900106017
    li x23, -964631243
    li x24, 660260444
    li x25, 167563702
    li x26, -824605503
    li x27, -1845862316
    li x28, -80869527
    li x29, 1204764096
    li x30, 1600854469
    sra x30, x18, x21
    sh x28, 8(x31)
    sw x16, 4(x31)
    sw x15, 24(x31)
    remu x9, x16, x29
    divu x1, x25, x13
    li x11, 1967382571
    sw x20, 8(x31)
    srai x27, x14, 21
    li x12, 49164864
    li x24, 950168026
    ori x16, x3, 166
    slt x19, x4, x7
    ori x20, x3, -1958
    mul x17, x22, x12
    li x5, 1789326149
    li x28, 1205323933
    li x18, -1663277640
    srli x3, x26, 31
    add x25, x22, x27
    li x1, -734652503
    lh x5, 4(x31)
    div x16, x25, x15
    slti x28, x3, -385
    slli x4, x6, 8
    li x16, -171413359
    sb x8, 0(x31)
    xor x5, x11, x6
    sh x8, 0(x31)
    div x20, x13, x19
    sh x8, 0(x31)
    addi x13, x1, -1372
    li x7, -724240995
    li x13, 1265533431
    lw x6, 24(x31)
    li x3, -9188213
    li x7, 1368354366
    li x27, -279210833
    lhu x22, 28(x31)
    sb x4, 28(x31)
    slli x7, x27, 6
    xori x13, x11, -613
    ori x25, x8, -939
    mulh x29, x5, x30
    li x28, 132852776
    remu x1, x19, x4
    div x7, x17, x28
    ori x18, x18, 271
    mulhsu x30, x30, x22
    mulhu x9, x1, x10
    li x16, 993624921
    srli x15, x2, 15
    lh x14, 20(x31)
    sh x7, 24(x31)
    andi x18, x24, 642
    slli x12, x1, 7
    li x17, 930061973
    xor x27, x14, x17
    srli x29, x4, 22
    srai x8, x2, 0
done: j done
    .section .data
    .align 4
scratch: .space 64
