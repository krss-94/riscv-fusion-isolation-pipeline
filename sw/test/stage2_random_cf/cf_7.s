    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1499591369
    li x2, 648258640
    li x3, 154112043
    li x4, 31936245
    li x5, -1986441000
    li x6, -284989606
    li x7, -1847456881
    li x8, -324187610
    li x9, 1922895273
    li x10, -443753964
    li x11, 2045500108
    li x12, 1539610315
    li x13, -903621226
    li x14, -1371269749
    li x15, 596628807
    li x16, -548048381
    li x17, -1262897697
    li x18, -798231825
    li x19, -201071568
    li x20, -859994195
    li x21, 1264350247
    li x22, -1099097093
    li x23, 319647407
    li x24, 108218145
    li x25, 1611203271
    li x26, 985460000
    li x27, 2062335288
    li x28, -351659800
    li x29, 1104411903
    li x30, -47403134
    divu x2, x22, x3
    remu x11, x23, x12
    sub x19, x26, x15
    mulh x9, x16, x23
    andi x2, x24, 1602
blk1:
    sra x29, x22, x12
    sra x12, x6, x20
    slti x2, x7, -20
    addi x13, x13, -686
    slti x15, x13, 1478
    la x29, blk10
    jalr x30, x29, 0
blk2:
    rem x23, x14, x12
    sll x8, x5, x3
    sra x8, x22, x8
    sltiu x27, x19, -2015
    ori x5, x14, 562
    bgeu x15, x29, blk5
blk3:
    xori x26, x18, 1180
    addi x4, x16, -487
    sub x3, x7, x15
    add x11, x20, x2
    xor x19, x5, x18
    bne x3, x28, blk8
blk4:
    div x20, x13, x5
    addi x12, x20, -1104
    xori x28, x16, 506
    divu x3, x5, x4
    mulhu x24, x9, x16
    blt x7, x17, blk9
blk5:
    or x5, x23, x18
    sltu x10, x21, x28
    xor x17, x12, x30
    divu x25, x8, x18
    slt x21, x8, x20
    jal x30, blk9
blk6:
    andi x7, x17, -1811
    sltiu x1, x26, -462
    andi x23, x20, 815
    slt x12, x3, x8
    sra x16, x7, x11
blk7:
    mulh x30, x21, x12
    andi x27, x22, -416
    andi x16, x29, 675
    xori x3, x26, 1240
    sll x24, x3, x24
    bge x5, x19, blk8
blk8:
    remu x26, x21, x5
    or x22, x30, x12
    sub x18, x5, x1
    srl x17, x24, x30
    add x28, x7, x27
    jal x30, blk10
blk9:
    divu x10, x17, x8
    add x9, x18, x14
    andi x30, x24, 1397
    mulhu x27, x30, x29
    mul x18, x5, x17
    jal x30, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
