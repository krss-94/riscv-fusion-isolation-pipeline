    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1230006498
    li x2, 1718904690
    li x3, -16095411
    li x4, 945926071
    li x5, -1716976011
    li x6, 38341435
    li x7, 1473487022
    li x8, 1639819093
    li x9, -2107064407
    li x10, 1472494999
    li x11, 1445589488
    li x12, -1281316515
    li x13, -1797440526
    li x14, -1628866059
    li x15, -1462254124
    li x16, -2061156560
    li x17, -631221117
    li x18, -1446251530
    li x19, 1841725814
    li x20, 1023737348
    li x21, 325107346
    li x22, 1160261333
    li x23, 374065401
    li x24, -1162667076
    li x25, -732385529
    li x26, 2092773230
    li x27, -99875961
    li x28, 1342983384
    li x29, -233858235
    li x30, -1879459800
    sb x2, 16(x31)
    mul x2, x7, x19
    divu x1, x17, x17
    srai x16, x16, 15
    slli x17, x19, 14
    divu x13, x19, x24
    ori x27, x28, -995
    sb x12, 20(x31)
    lb x8, 0(x31)
    xor x19, x28, x6
    li x14, -187590266
    xor x11, x14, x6
    slli x3, x30, 13
    li x23, 1749352372
    mul x3, x27, x25
    lb x28, 0(x31)
    lhu x24, 20(x31)
    andi x4, x13, -488
    xori x8, x20, -1574
    sh x1, 28(x31)
    xor x18, x3, x5
    or x24, x29, x4
    sltiu x22, x28, -1437
    lb x6, 4(x31)
    sltiu x1, x1, 560
    sw x17, 8(x31)
    add x20, x23, x12
    sll x18, x17, x1
    slt x3, x22, x24
    mulhu x19, x16, x2
    mulhsu x9, x23, x7
    slli x3, x22, 14
    srai x15, x18, 17
    sltiu x27, x19, 1835
    lhu x4, 20(x31)
    andi x9, x30, 377
    sb x1, 28(x31)
    slti x2, x26, 1400
    and x20, x1, x26
    sb x25, 16(x31)
    srli x13, x17, 31
    remu x19, x1, x19
    mulhu x9, x28, x23
    srli x12, x17, 22
    lw x7, 4(x31)
    and x22, x12, x19
    sltu x28, x18, x19
    srli x3, x8, 28
    mulh x22, x1, x21
    sb x28, 0(x31)
    lbu x20, 24(x31)
    sw x6, 4(x31)
    sw x13, 4(x31)
    slti x27, x18, -675
    slti x14, x15, 1106
    ori x10, x21, 1560
    lh x28, 8(x31)
    srli x4, x17, 9
    mulh x5, x18, x14
    slli x14, x23, 14
done: j done
    .section .data
    .align 4
scratch: .space 64
