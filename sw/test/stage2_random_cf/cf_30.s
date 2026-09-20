    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1042487425
    li x2, -441530102
    li x3, 608073536
    li x4, 2099428162
    li x5, -165214454
    li x6, -1105200157
    li x7, 1792988484
    li x8, 663245278
    li x9, -1857010582
    li x10, -2046508694
    li x11, 738604298
    li x12, 1129626827
    li x13, 281975230
    li x14, 746868006
    li x15, -819505297
    li x16, 1414525666
    li x17, 1619533334
    li x18, -1802415316
    li x19, -796222469
    li x20, 1158073657
    li x21, -854893078
    li x22, -1347036246
    li x23, 624420858
    li x24, 56284997
    li x25, 1926133204
    li x26, 85978544
    li x27, -1854328103
    li x28, 1910589727
    li x29, -61630277
    li x30, 1857724029
    mulhu x9, x19, x9
    or x22, x6, x27
    slt x10, x14, x22
    andi x16, x12, 405
    rem x17, x13, x22
blk1:
    sll x12, x10, x17
    addi x10, x17, -502
    mul x4, x25, x11
    xori x19, x18, -1746
    sll x23, x15, x22
    la x29, blk9
    jalr x30, x29, 0
blk2:
    mulhu x9, x15, x27
    ori x5, x28, -1448
    slt x24, x30, x11
    sll x14, x19, x16
    sltu x14, x3, x13
    blt x29, x11, blk7
blk3:
    andi x1, x16, -1222
    ori x12, x16, -595
    xori x4, x8, -1182
    mulh x7, x7, x16
    sll x4, x13, x4
    la x29, blk9
    jalr x30, x29, 0
blk4:
    mulhu x1, x29, x22
    divu x25, x28, x25
    and x17, x18, x10
    slt x12, x5, x19
    sll x23, x20, x20
    bne x20, x30, blk8
blk5:
    slt x11, x21, x17
    sltu x6, x10, x14
    andi x1, x24, 323
    andi x1, x27, -1063
    andi x16, x9, 1751
    beq x16, x30, blk10
blk6:
    remu x8, x2, x18
    mul x20, x28, x7
    div x5, x4, x16
    xor x1, x18, x25
    andi x6, x17, 1913
blk7:
    sll x3, x7, x24
    sub x1, x20, x20
    sltu x4, x11, x21
    divu x1, x20, x15
    add x23, x18, x13
    bgeu x28, x26, blk10
blk8:
    rem x29, x21, x4
    srl x10, x9, x29
    srl x6, x9, x3
    divu x14, x22, x5
    addi x29, x12, -1684
blk9:
    andi x1, x12, 760
    or x25, x13, x22
    or x23, x24, x28
    sltiu x12, x21, -1890
    sll x1, x21, x22
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
