    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1173789389
    li x2, 1985542055
    li x3, -1604896559
    li x4, 879682010
    li x5, -1781615711
    li x6, -1248127672
    li x7, 609320300
    li x8, -175519158
    li x9, -201294668
    li x10, 1419578049
    li x11, -1762802220
    li x12, -396580689
    li x13, -1037850026
    li x14, -1876519824
    li x15, -527399931
    li x16, 690816163
    li x17, -693900969
    li x18, 821629702
    li x19, 1723892329
    li x20, 1915776330
    li x21, -1314887044
    li x22, 339138294
    li x23, 1636209378
    li x24, 1623826238
    li x25, -1567767271
    li x26, 816822302
    li x27, 868207965
    li x28, 1475291067
    li x29, -1298591270
    li x30, -1502551912
    lw x10, 4(x31)
    sb x8, 12(x31)
    srli x11, x8, 2
    slli x13, x10, 26
    sb x4, 0(x31)
    li x6, 1135151976
    slli x27, x6, 27
    xori x14, x19, 1287
    sub x19, x3, x10
    or x3, x22, x4
    lbu x12, 28(x31)
    lh x3, 8(x31)
    div x22, x19, x4
    slli x11, x12, 31
    and x29, x20, x2
    addi x6, x11, 1568
    sra x7, x20, x8
    li x16, -510724156
    sll x19, x24, x15
    sw x17, 4(x31)
    divu x19, x13, x27
    mul x8, x2, x7
    mul x4, x4, x7
    sw x20, 0(x31)
    srai x27, x14, 5
    li x20, -1162070461
    lb x13, 12(x31)
    srai x20, x10, 5
    srai x30, x30, 14
    srai x3, x18, 23
    li x11, 1963023901
    li x29, 1484841603
    slti x16, x12, 507
    srai x13, x20, 22
    lbu x19, 24(x31)
    mulh x27, x17, x17
    srli x6, x3, 17
    li x4, 1395700336
    srli x9, x26, 17
    sb x8, 12(x31)
    li x17, -1074175680
    li x26, 1416157527
    srli x16, x25, 7
    and x21, x6, x25
    mulhu x30, x2, x26
    sltu x20, x7, x22
    sltu x4, x15, x15
    lb x3, 20(x31)
    slli x26, x2, 5
    sb x12, 4(x31)
    sb x20, 20(x31)
    srai x24, x12, 4
    xor x30, x24, x20
    rem x6, x6, x9
    addi x14, x24, -1515
    lh x8, 8(x31)
    sw x4, 0(x31)
    li x24, 599574693
    slli x29, x8, 30
    lbu x23, 8(x31)
done: j done
    .section .data
    .align 4
scratch: .space 64
