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
    xori x15, x28, 363
    xori x8, x2, 1519
    sw x9, 8(x31)
    lh x17, 28(x31)
    sb x3, 24(x31)
    lh x4, 4(x31)
    li x17, -227242492
    ori x25, x25, -649
    or x15, x17, x11
    rem x29, x24, x26
    mulh x25, x13, x28
    srai x8, x26, 21
    lh x30, 4(x31)
    li x4, -443799345
    mulhu x28, x15, x28
    sb x3, 12(x31)
    addi x10, x16, -385
    sb x5, 28(x31)
    mulh x1, x8, x3
    div x2, x2, x24
    rem x27, x11, x11
    srai x7, x25, 22
    lh x25, 0(x31)
    lb x4, 4(x31)
    lhu x7, 16(x31)
    mulhu x21, x27, x16
    slti x27, x12, 15
    remu x2, x9, x27
    lh x8, 16(x31)
    lh x12, 24(x31)
    slt x18, x11, x28
    sh x19, 8(x31)
    lb x6, 28(x31)
    sw x1, 20(x31)
    sltu x16, x10, x27
    li x22, 1350950923
    mulh x9, x4, x13
    remu x6, x30, x3
    li x24, 551105094
    mulh x9, x20, x13
    lw x28, 24(x31)
    lhu x9, 4(x31)
    mulhu x25, x7, x7
    srai x9, x19, 14
    slt x21, x10, x20
    lhu x6, 28(x31)
    li x25, 438178593
    xor x28, x26, x10
    rem x28, x1, x9
    sll x13, x9, x26
    sra x24, x8, x10
    sb x27, 12(x31)
    xori x5, x30, 633
    slli x4, x4, 14
    sltiu x19, x27, -1740
    mul x1, x27, x28
    srai x9, x19, 16
    rem x21, x22, x19
    slli x23, x12, 31
    srli x23, x29, 21
done: j done
    .section .data
    .align 4
scratch: .space 64
