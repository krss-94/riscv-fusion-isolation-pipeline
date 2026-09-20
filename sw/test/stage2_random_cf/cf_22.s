    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1544605122
    li x2, 2141602361
    li x3, 1673108568
    li x4, -1152161526
    li x5, 1973473326
    li x6, 434402832
    li x7, 1820418307
    li x8, 1637960475
    li x9, 384639318
    li x10, -813118041
    li x11, -1330869418
    li x12, 1502415980
    li x13, 284811817
    li x14, 852058413
    li x15, 482430580
    li x16, -1037617245
    li x17, 1961584672
    li x18, -1536638833
    li x19, 1396834857
    li x20, -1352792862
    li x21, -1936492912
    li x22, -2008909401
    li x23, 1825708550
    li x24, 26971060
    li x25, -388943110
    li x26, 1788697370
    li x27, -542117342
    li x28, 354737960
    li x29, 121292948
    li x30, -1769056412
    xori x15, x12, -1573
    mulhsu x30, x27, x7
    slti x13, x1, -644
    slti x1, x18, 641
    sra x30, x12, x21
    bgeu x18, x5, blk1
blk1:
    mulh x24, x7, x21
    sll x2, x7, x14
    sub x30, x19, x15
    and x16, x23, x17
    xori x10, x22, -1509
    bltu x27, x26, blk7
blk2:
    or x9, x4, x1
    addi x12, x21, -645
    andi x21, x23, 155
    xor x6, x2, x3
    div x22, x4, x7
    blt x6, x1, blk10
blk3:
    ori x25, x4, -347
    mulhu x13, x12, x4
    mul x2, x8, x13
    andi x7, x7, 1084
    rem x2, x25, x23
    la x29, blk7
    jalr x30, x29, 0
blk4:
    sltu x8, x29, x8
    mulhu x30, x3, x30
    addi x6, x29, -1803
    addi x16, x6, 1939
    slt x23, x1, x9
blk5:
    ori x28, x22, 1472
    andi x5, x12, -1974
    mulh x23, x13, x20
    divu x6, x28, x26
    div x9, x28, x28
    la x29, blk7
    jalr x30, x29, 0
blk6:
    ori x9, x17, 2013
    or x23, x16, x27
    addi x7, x16, 1120
    sll x22, x21, x17
    sltiu x3, x2, -116
    jal x30, blk7
blk7:
    mul x7, x18, x12
    sub x17, x11, x25
    mulh x17, x22, x2
    sltu x4, x19, x3
    ori x17, x10, 674
    bltu x29, x8, blk9
blk8:
    addi x21, x11, -95
    sltiu x8, x2, -1853
    sra x30, x11, x4
    sll x27, x11, x30
    sltiu x16, x10, -903
    la x29, blk10
    jalr x30, x29, 0
blk9:
    divu x8, x18, x8
    ori x29, x2, -266
    sltu x3, x5, x27
    sltu x18, x5, x15
    or x8, x27, x5
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
