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
    mulh x17, x10, x17
    mulhsu x26, x29, x28
    sltu x12, x8, x30
    srl x11, x8, x9
    rem x9, x13, x10
blk1:
    mul x4, x6, x30
    addi x7, x25, -1940
    slti x26, x25, 1520
    ori x29, x8, 1606
    mulh x14, x14, x3
    bgeu x2, x3, blk6
blk2:
    divu x4, x25, x17
    remu x5, x26, x30
    slt x23, x5, x20
    xori x1, x30, -1059
    sltiu x24, x10, -2024
    jal x30, blk10
blk3:
    and x2, x29, x20
    xori x6, x6, -1058
    sra x3, x7, x20
    srl x26, x16, x26
    remu x4, x4, x19
    jal x30, blk9
blk4:
    mulh x24, x15, x17
    rem x23, x30, x16
    add x27, x12, x15
    sub x7, x2, x15
    mul x7, x24, x1
    la x29, blk10
    jalr x30, x29, 0
blk5:
    and x27, x14, x17
    mulhsu x17, x27, x23
    rem x17, x8, x11
    add x24, x17, x21
    xor x10, x20, x10
    jal x30, blk9
blk6:
    rem x21, x10, x3
    divu x24, x12, x26
    sltiu x17, x10, -1153
    ori x7, x16, 507
    rem x7, x10, x13
    la x29, blk9
    jalr x30, x29, 0
blk7:
    ori x22, x14, -1377
    andi x9, x6, 171
    div x14, x25, x4
    div x10, x9, x26
    slti x9, x29, 912
    jal x30, blk8
blk8:
    slti x26, x17, -130
    mulhsu x27, x26, x20
    sub x12, x16, x25
    and x13, x3, x21
    add x14, x30, x2
    la x29, blk9
    jalr x30, x29, 0
blk9:
    andi x3, x4, 264
    and x30, x19, x3
    xor x12, x28, x21
    sll x26, x2, x27
    slt x21, x26, x12
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
