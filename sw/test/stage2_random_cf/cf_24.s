    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 912006184
    li x2, -1363257452
    li x3, 2140107612
    li x4, -1313849899
    li x5, 887188596
    li x6, 1142215581
    li x7, -251780636
    li x8, -1651012212
    li x9, 72561223
    li x10, 1967785814
    li x11, -839232411
    li x12, 1119079266
    li x13, -835980166
    li x14, 1690888754
    li x15, 1823781492
    li x16, -789550905
    li x17, -1848509130
    li x18, -1731279749
    li x19, 1284500622
    li x20, 2113029379
    li x21, 1545014602
    li x22, 1042753940
    li x23, 1823874231
    li x24, -1532872029
    li x25, -87825309
    li x26, -1583344173
    li x27, 23387196
    li x28, 1138194629
    li x29, -1105496406
    li x30, 562499959
    mulhsu x9, x11, x21
    xori x13, x7, -1503
    sltiu x16, x12, -529
    sltiu x24, x19, -9
    sra x29, x12, x2
blk1:
    add x15, x26, x25
    xori x3, x11, 2025
    slti x19, x17, 259
    xor x10, x12, x10
    mul x24, x30, x3
    bge x23, x21, blk6
blk2:
    sltiu x13, x21, 1643
    sltiu x13, x22, -1979
    xori x13, x30, -1491
    or x6, x26, x8
    sra x21, x29, x19
    jal x30, blk5
blk3:
    add x27, x2, x4
    remu x8, x30, x1
    sltiu x2, x6, -1198
    or x28, x6, x4
    remu x25, x3, x20
    la x29, blk8
    jalr x30, x29, 0
blk4:
    xori x9, x22, 1052
    mulhu x14, x30, x22
    mulhu x11, x3, x7
    sltiu x6, x5, -146
    sub x21, x20, x5
    jal x30, blk7
blk5:
    slt x30, x9, x15
    remu x7, x13, x20
    andi x19, x11, -774
    sll x28, x2, x30
    add x27, x7, x24
    la x29, blk7
    jalr x30, x29, 0
blk6:
    mulhsu x10, x16, x22
    sltu x29, x11, x9
    slt x16, x18, x10
    div x12, x21, x20
    or x30, x8, x12
    la x29, blk10
    jalr x30, x29, 0
blk7:
    xori x3, x3, 878
    slti x15, x16, -1772
    sltu x4, x6, x17
    and x21, x26, x18
    mulhsu x22, x12, x7
    jal x30, blk9
blk8:
    mulhsu x4, x21, x27
    divu x17, x9, x20
    sltiu x6, x9, -706
    srl x10, x28, x19
    slt x20, x1, x29
    bge x8, x17, blk10
blk9:
    mulhsu x25, x16, x5
    and x27, x20, x12
    andi x21, x21, -580
    and x22, x20, x25
    rem x7, x11, x6
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
