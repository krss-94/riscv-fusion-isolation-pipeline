    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1382784373
    li x2, -354042872
    li x3, -1231241921
    li x4, -465242821
    li x5, -1341807016
    li x6, -2028098932
    li x7, -1117176407
    li x8, -1739525461
    li x9, -1591550269
    li x10, 770772299
    li x11, -1583015395
    li x12, 1164161450
    li x13, -1030305746
    li x14, -1427907261
    li x15, -566472821
    li x16, -2007374936
    li x17, 1316297613
    li x18, -542673471
    li x19, 1949400876
    li x20, -1396066907
    li x21, -1407184755
    li x22, -2014107111
    li x23, -1298484013
    li x24, -762936981
    li x25, -435594956
    li x26, 1546955331
    li x27, 975028897
    li x28, 89996627
    li x29, -315560184
    li x30, 734570841
    xori x8, x15, -153
    xori x8, x2, 19
    mul x15, x5, x27
    divu x21, x15, x12
    or x3, x8, x13
    jal x30, blk2
blk1:
    ori x4, x22, 1614
    sll x3, x5, x25
    sra x26, x17, x29
    andi x17, x11, 1156
    mulh x13, x25, x13
    jal x30, blk7
blk2:
    divu x26, x17, x11
    addi x17, x3, 1201
    slti x10, x13, -1303
    sll x13, x8, x29
    mulhsu x10, x16, x27
    jal x30, blk3
blk3:
    sra x20, x19, x16
    srl x1, x8, x3
    xori x2, x2, 756
    add x11, x13, x12
    andi x26, x25, -469
    la x29, blk4
    jalr x30, x29, 0
blk4:
    addi x17, x4, -1535
    or x20, x7, x19
    andi x9, x22, 2018
    xor x24, x17, x6
    srl x13, x19, x9
    la x29, blk5
    jalr x30, x29, 0
blk5:
    xor x27, x16, x17
    ori x11, x21, 996
    sltiu x17, x5, -1761
    mulhsu x18, x11, x28
    slti x22, x11, 678
    jal x30, blk10
blk6:
    addi x12, x29, 1083
    ori x1, x2, -1026
    andi x16, x10, 72
    addi x14, x9, 1860
    andi x6, x30, 357
    jal x30, blk9
blk7:
    mulhu x29, x15, x25
    addi x15, x9, 1424
    div x16, x13, x26
    xori x7, x4, -430
    sltu x7, x20, x30
    jal x30, blk9
blk8:
    div x8, x24, x2
    slt x20, x8, x17
    xori x30, x26, 599
    mulhsu x24, x21, x19
    sltiu x3, x28, 1392
    la x29, blk9
    jalr x30, x29, 0
blk9:
    sltiu x13, x29, -515
    xori x2, x24, -167
    sll x27, x2, x8
    xori x5, x30, 28
    mulhsu x4, x4, x30
    jal x30, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
