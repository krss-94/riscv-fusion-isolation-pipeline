    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1382782102
    li x2, -1023827911
    li x3, -2145543544
    li x4, -544772047
    li x5, 1160241785
    li x6, -976254300
    li x7, 1296717143
    li x8, 781906281
    li x9, 797531995
    li x10, 1478681337
    li x11, -1747473626
    li x12, 1289704459
    li x13, 1309026637
    li x14, -896859768
    li x15, 1938632292
    li x16, -599665211
    li x17, 1758837219
    li x18, -595383727
    li x19, 437001078
    li x20, -840420274
    li x21, 382925280
    li x22, 108504562
    li x23, 698968001
    li x24, -1304707409
    li x25, -69817790
    li x26, -2093699045
    li x27, 1194247920
    li x28, -832688831
    li x29, -476030203
    li x30, 2146962235
    rem x2, x6, x14
    and x4, x15, x8
    xori x22, x28, 1065
    xori x26, x3, 437
    slt x23, x27, x14
blk1:
    add x16, x24, x26
    ori x1, x18, 909
    sltiu x7, x9, 39
    ori x14, x30, 1928
    remu x9, x20, x16
    jal x30, blk9
blk2:
    andi x24, x13, 1779
    and x11, x12, x22
    sltiu x13, x23, 1214
    sltu x16, x24, x26
    addi x18, x1, -553
    blt x22, x23, blk3
blk3:
    mul x12, x16, x28
    ori x30, x7, -1927
    remu x14, x26, x26
    xor x3, x16, x8
    mulhsu x12, x5, x22
    la x29, blk8
    jalr x30, x29, 0
blk4:
    mulh x5, x2, x21
    remu x23, x4, x2
    add x15, x24, x29
    mulh x23, x18, x5
    andi x6, x20, 1654
    bne x26, x21, blk8
blk5:
    xori x27, x7, 1552
    andi x15, x18, -1527
    sltiu x27, x26, 902
    sltiu x2, x3, 197
    addi x16, x14, -1347
    jal x30, blk7
blk6:
    mulhu x18, x24, x2
    slt x11, x12, x2
    sll x23, x14, x11
    ori x24, x22, -937
    mulh x15, x24, x16
    beq x12, x17, blk8
blk7:
    sll x6, x17, x23
    rem x10, x24, x5
    mulhu x26, x8, x8
    slti x14, x23, -2009
    slti x26, x26, 616
blk8:
    mulhu x1, x13, x28
    divu x23, x8, x21
    sll x9, x22, x6
    addi x23, x21, -1548
    sub x1, x2, x16
    la x29, blk9
    jalr x30, x29, 0
blk9:
    mulhsu x20, x2, x2
    div x26, x14, x8
    mul x3, x16, x3
    addi x6, x29, -1129
    mul x23, x6, x2
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
