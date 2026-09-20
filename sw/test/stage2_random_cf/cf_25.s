    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1475092522
    li x2, 1596474189
    li x3, 586098746
    li x4, -1049330653
    li x5, -326073217
    li x6, 1426962201
    li x7, 536784836
    li x8, 355520872
    li x9, -367537632
    li x10, -168605296
    li x11, -1845247443
    li x12, 270917124
    li x13, -1408439744
    li x14, 255905173
    li x15, -74137066
    li x16, 1358655028
    li x17, -932655833
    li x18, 1350527498
    li x19, -183677501
    li x20, -1204198083
    li x21, -1588664434
    li x22, -1749668360
    li x23, 792418593
    li x24, 1097346825
    li x25, -541243388
    li x26, -206403184
    li x27, -842785391
    li x28, -22892297
    li x29, -182465608
    li x30, 778832769
    mulh x15, x13, x12
    sltiu x28, x25, -1819
    mulhsu x23, x19, x26
    div x19, x1, x6
    ori x17, x4, -1783
    jal x30, blk1
blk1:
    slti x23, x28, 561
    mulhu x3, x4, x14
    addi x18, x12, -1288
    mulhu x23, x19, x7
    xor x3, x3, x20
    jal x30, blk4
blk2:
    sub x9, x3, x23
    div x10, x1, x15
    sltiu x26, x26, 195
    xori x2, x28, -1725
    addi x17, x10, -875
blk3:
    sltiu x2, x8, -1644
    slti x10, x15, 901
    sub x14, x3, x8
    ori x5, x27, -1949
    mulh x5, x29, x5
    la x29, blk9
    jalr x30, x29, 0
blk4:
    sub x10, x29, x18
    or x28, x12, x4
    sra x27, x20, x2
    sub x2, x26, x26
    srl x7, x3, x16
    la x29, blk9
    jalr x30, x29, 0
blk5:
    mulhu x24, x30, x24
    mulh x13, x23, x12
    mulhsu x2, x3, x10
    addi x6, x3, 1622
    srl x3, x20, x21
    jal x30, blk7
blk6:
    xori x17, x7, -400
    xori x3, x28, -916
    sll x10, x8, x12
    xori x14, x25, -154
    xori x24, x7, 1603
    blt x28, x7, blk9
blk7:
    or x21, x16, x24
    or x1, x22, x4
    mulhu x13, x9, x26
    xor x29, x21, x26
    addi x14, x14, -1528
blk8:
    div x15, x8, x2
    addi x13, x29, -1497
    add x11, x7, x3
    and x4, x2, x16
    div x4, x4, x28
blk9:
    mulhu x16, x19, x14
    or x25, x20, x19
    addi x20, x28, 1025
    andi x14, x2, -834
    sltiu x29, x25, 105
    bltu x9, x19, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
