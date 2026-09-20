    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -594755157
    li x2, -83834892
    li x3, -356685734
    li x4, -228667235
    li x5, -1035708234
    li x6, 579803096
    li x7, -2103982619
    li x8, -815578841
    li x9, 1242284908
    li x10, -1058683618
    li x11, 1690244452
    li x12, -2029933182
    li x13, -816944923
    li x14, -1038372573
    li x15, 1236199887
    li x16, -653777583
    li x17, 614276322
    li x18, -1958476705
    li x19, 2035317895
    li x20, 1246963025
    li x21, 100384856
    li x22, -1139023664
    li x23, -1483870807
    li x24, -840791014
    li x25, -168009167
    li x26, -1865167041
    li x27, 855923512
    li x28, -2091357979
    li x29, -36370100
    li x30, 1270186271
    remu x27, x20, x3
    sh x5, 12(x31)
    srai x2, x18, 25
    slli x16, x17, 4
    slli x4, x23, 7
    sub x13, x21, x2
    sb x2, 24(x31)
    sw x9, 8(x31)
    sub x8, x17, x8
    srl x21, x5, x9
    remu x2, x13, x15
    mul x9, x2, x2
    sw x14, 16(x31)
    mulh x4, x26, x7
    mulh x21, x4, x10
    rem x14, x5, x27
    xori x5, x29, 1258
    lhu x8, 20(x31)
    li x6, -2053158832
    srli x19, x10, 4
    sb x8, 28(x31)
    lw x15, 28(x31)
    sub x25, x21, x22
    sb x11, 28(x31)
    li x16, -1411040225
    sb x13, 24(x31)
    andi x7, x15, -1941
    and x8, x11, x13
    lhu x7, 0(x31)
    sb x5, 12(x31)
    lw x26, 16(x31)
    or x20, x20, x26
    slti x16, x19, 813
    sb x24, 8(x31)
    andi x1, x3, 1014
    slli x21, x27, 6
    sub x6, x30, x20
    sw x8, 12(x31)
    mulh x3, x6, x30
    mulhu x3, x29, x2
    slti x22, x24, -756
    mulh x2, x25, x12
    sb x13, 16(x31)
    lhu x13, 20(x31)
    slli x14, x1, 12
    ori x13, x14, -1600
    addi x14, x25, 750
    lhu x13, 8(x31)
    xori x11, x6, -1587
    sra x28, x13, x21
    sb x2, 0(x31)
    sw x7, 16(x31)
    sb x14, 0(x31)
    or x29, x27, x17
    and x5, x11, x20
    sra x19, x18, x10
    ori x20, x14, 1298
    sll x29, x23, x25
    lhu x2, 16(x31)
    sh x3, 16(x31)
done: j done
    .section .data
    .align 4
scratch: .space 64
