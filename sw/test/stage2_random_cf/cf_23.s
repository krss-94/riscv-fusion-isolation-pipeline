    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1926747151
    li x2, -1788636200
    li x3, 395253927
    li x4, -327502391
    li x5, 129227022
    li x6, -1322862141
    li x7, -238054685
    li x8, -2041110322
    li x9, 901978345
    li x10, -338235690
    li x11, 1005920330
    li x12, -1900288816
    li x13, 1215915377
    li x14, 382782463
    li x15, 678229940
    li x16, 519654362
    li x17, 309438575
    li x18, -111383853
    li x19, 935933504
    li x20, 611510879
    li x21, -1656563696
    li x22, -1723981833
    li x23, 312767675
    li x24, -726687618
    li x25, 1192207749
    li x26, 210425366
    li x27, -1037584530
    li x28, 1218950656
    li x29, 1411177314
    li x30, -1125168064
    mulh x18, x5, x30
    add x13, x6, x15
    sll x21, x14, x13
    slt x26, x8, x22
    remu x26, x24, x2
    la x29, blk2
    jalr x30, x29, 0
blk1:
    slti x1, x26, -1745
    mulhsu x3, x9, x15
    slti x25, x30, -1298
    mulhu x4, x18, x17
    sltu x23, x18, x18
blk2:
    sltiu x6, x29, 1347
    rem x27, x6, x29
    mulhsu x3, x23, x27
    sltiu x18, x10, -1626
    sll x27, x10, x4
blk3:
    xor x8, x6, x22
    slt x18, x23, x18
    andi x29, x18, 181
    sll x1, x11, x13
    add x24, x28, x13
blk4:
    andi x24, x14, 223
    mulhu x16, x20, x23
    addi x17, x18, -193
    xori x29, x2, -1902
    sltiu x22, x15, 570
    la x29, blk8
    jalr x30, x29, 0
blk5:
    slti x26, x10, 1126
    remu x2, x14, x29
    ori x25, x18, 229
    sltu x23, x3, x13
    addi x28, x5, 1742
    la x29, blk6
    jalr x30, x29, 0
blk6:
    add x19, x25, x15
    slt x9, x26, x28
    addi x25, x19, 1284
    xor x26, x3, x9
    sll x19, x5, x20
    la x29, blk10
    jalr x30, x29, 0
blk7:
    mulhu x10, x3, x20
    mulhu x2, x4, x30
    mulhu x1, x5, x20
    andi x30, x24, 368
    add x19, x26, x25
    bne x11, x1, blk10
blk8:
    slt x12, x3, x6
    mulhsu x14, x11, x25
    andi x18, x19, 916
    div x18, x21, x8
    mulhu x15, x29, x22
blk9:
    sra x25, x10, x27
    or x13, x12, x24
    xori x6, x7, -1569
    xori x2, x11, -735
    slti x19, x30, 534
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
