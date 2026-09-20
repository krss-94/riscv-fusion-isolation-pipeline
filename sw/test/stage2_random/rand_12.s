    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -109218082
    li x2, 714727545
    li x3, -1535019803
    li x4, -537925359
    li x5, 1332934744
    li x6, 435754673
    li x7, 249924358
    li x8, -257462711
    li x9, -1450550792
    li x10, 1743640679
    li x11, 1369322020
    li x12, 1470611294
    li x13, 38336515
    li x14, 2092224555
    li x15, 1918617807
    li x16, 1355911088
    li x17, 412192216
    li x18, 972068901
    li x19, 2007720616
    li x20, 702639655
    li x21, 816535418
    li x22, 746348603
    li x23, -1658577194
    li x24, -1138284760
    li x25, -587025920
    li x26, 52064
    li x27, -2026609224
    li x28, -299984670
    li x29, 81592826
    li x30, -312488680
    mulh x7, x25, x20
    li x18, -971577539
    mul x9, x16, x12
    lh x15, 20(x31)
    remu x16, x23, x28
    slti x6, x15, 935
    sltiu x25, x24, -1994
    li x26, -1975586402
    lb x4, 8(x31)
    srai x29, x26, 17
    or x8, x26, x17
    div x16, x21, x12
    sh x29, 8(x31)
    srli x20, x28, 17
    li x17, 1254589713
    sw x17, 0(x31)
    or x23, x1, x5
    srli x14, x5, 12
    div x2, x18, x19
    li x2, 379827339
    divu x26, x7, x19
    slli x21, x24, 10
    sb x5, 0(x31)
    slt x30, x14, x18
    li x30, -630633526
    srai x9, x30, 31
    lw x4, 24(x31)
    addi x3, x14, 602
    sw x5, 4(x31)
    srli x10, x23, 27
    xori x1, x7, 1586
    xori x2, x22, 747
    addi x29, x11, -211
    srai x12, x9, 12
    mulhu x10, x8, x17
    lw x29, 8(x31)
    mulhsu x13, x20, x17
    mul x15, x26, x28
    li x25, 744698574
    sh x4, 16(x31)
    li x24, 1181406570
    srli x21, x10, 8
    xori x26, x18, 15
    sltu x14, x26, x12
    div x30, x21, x20
    divu x27, x28, x26
    andi x5, x9, -1782
    lhu x26, 24(x31)
    lhu x22, 24(x31)
    mulhu x13, x13, x27
    addi x26, x7, 38
    srai x17, x29, 22
    slli x25, x5, 19
    sb x28, 16(x31)
    sll x26, x6, x7
    slti x23, x26, -492
    li x10, 1764385072
    srli x22, x16, 12
    sll x17, x1, x21
    li x13, 582179621
done: j done
    .section .data
    .align 4
scratch: .space 64
