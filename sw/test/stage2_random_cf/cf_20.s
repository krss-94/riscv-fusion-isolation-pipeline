    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1737813524
    li x2, 1739228534
    li x3, 1598287794
    li x4, -1420010287
    li x5, -380005548
    li x6, 2121018115
    li x7, -1704037703
    li x8, -776791444
    li x9, -217322084
    li x10, -1251327662
    li x11, -706226562
    li x12, -311935752
    li x13, -33871896
    li x14, -1797589913
    li x15, 314434332
    li x16, -1996742527
    li x17, -1741501982
    li x18, -1329990135
    li x19, -929978853
    li x20, 817116718
    li x21, -2047218809
    li x22, 883834323
    li x23, -1127130961
    li x24, -855789081
    li x25, 630817125
    li x26, 595585954
    li x27, -288187932
    li x28, -1440224555
    li x29, 1559805686
    li x30, 815197173
    slti x25, x19, -1095
    mulhsu x30, x20, x2
    sub x14, x6, x6
    xor x26, x29, x10
    ori x22, x24, -1603
    blt x15, x18, blk3
blk1:
    mulh x1, x3, x19
    mulh x3, x11, x9
    mul x22, x25, x10
    or x26, x1, x7
    add x17, x23, x1
    jal x30, blk10
blk2:
    srl x29, x10, x28
    slt x9, x4, x13
    sub x8, x7, x28
    slti x10, x5, -1371
    slt x15, x16, x1
blk3:
    slti x28, x4, 937
    mulh x20, x10, x5
    sltiu x1, x9, 266
    addi x13, x27, -1503
    or x19, x16, x7
    la x29, blk4
    jalr x30, x29, 0
blk4:
    sltiu x23, x1, -1230
    mulhsu x1, x2, x7
    mulh x20, x13, x23
    xori x19, x28, -1640
    rem x26, x21, x5
blk5:
    addi x13, x9, 1982
    sltu x11, x8, x25
    slti x15, x29, -1619
    divu x12, x5, x3
    slti x1, x25, -888
    blt x5, x22, blk8
blk6:
    slt x12, x17, x5
    srl x14, x17, x15
    div x13, x23, x18
    div x17, x20, x21
    sra x20, x25, x25
    la x29, blk9
    jalr x30, x29, 0
blk7:
    mulhsu x24, x5, x15
    andi x16, x5, -890
    mulh x21, x24, x23
    or x24, x9, x21
    or x7, x12, x13
    la x29, blk10
    jalr x30, x29, 0
blk8:
    sll x27, x16, x21
    and x5, x9, x29
    xor x22, x30, x3
    divu x9, x8, x25
    addi x3, x5, -964
    bltu x16, x2, blk10
blk9:
    andi x2, x16, -1268
    div x21, x29, x5
    sra x17, x18, x14
    remu x15, x22, x29
    slt x27, x5, x6
    bge x7, x15, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
