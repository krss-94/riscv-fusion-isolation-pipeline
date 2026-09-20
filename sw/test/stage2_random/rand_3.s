    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 189963082
    li x2, 446333181
    li x3, 1449418665
    li x4, -1141039821
    li x5, -101562192
    li x6, -1500591035
    li x7, 579222143
    li x8, 99562544
    li x9, 1036168857
    li x10, -1872470703
    li x11, 391269738
    li x12, 1569927520
    li x13, 1626988600
    li x14, 1808605022
    li x15, 1870830728
    li x16, 1627219933
    li x17, -1728920548
    li x18, -1563501829
    li x19, -1215531812
    li x20, -854585969
    li x21, 365390516
    li x22, 361858708
    li x23, 1736033392
    li x24, 1842307337
    li x25, 1530728784
    li x26, 1548926410
    li x27, 296814478
    li x28, 315819066
    li x29, -923600659
    li x30, -1874922558
    li x21, -1861387227
    addi x1, x10, 1353
    add x20, x20, x25
    div x23, x19, x11
    lb x8, 0(x31)
    slt x20, x18, x2
    mulhu x10, x20, x9
    sh x28, 20(x31)
    xori x29, x28, 1038
    li x17, -982256319
    sh x23, 16(x31)
    slli x17, x10, 21
    li x14, -2061357134
    lh x19, 0(x31)
    divu x12, x22, x30
    lb x23, 28(x31)
    lh x2, 20(x31)
    sb x10, 20(x31)
    srai x6, x11, 23
    slli x10, x26, 6
    lw x22, 16(x31)
    sltiu x21, x26, -93
    addi x22, x14, -1254
    lhu x11, 12(x31)
    li x28, 645243145
    lb x15, 4(x31)
    lh x7, 8(x31)
    srai x26, x27, 5
    srai x19, x5, 18
    li x28, -356887313
    rem x19, x14, x2
    ori x7, x1, 1510
    sw x2, 28(x31)
    sb x10, 20(x31)
    li x3, 2022775556
    add x26, x8, x2
    li x23, -1935497549
    div x24, x4, x6
    addi x22, x1, 1341
    lw x4, 16(x31)
    divu x26, x26, x2
    slti x7, x4, -1072
    addi x26, x9, -996
    rem x21, x19, x28
    sltu x25, x9, x8
    lhu x17, 0(x31)
    slli x25, x27, 3
    sra x4, x2, x3
    or x28, x23, x3
    lb x16, 20(x31)
    srli x13, x21, 19
    slli x7, x11, 7
    lb x1, 24(x31)
    lw x6, 28(x31)
    sw x18, 0(x31)
    remu x2, x12, x21
    li x23, -350929286
    sltu x8, x7, x18
    sb x3, 24(x31)
    divu x5, x29, x1
done: j done
    .section .data
    .align 4
scratch: .space 64
