    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1368956985
    li x2, 693338914
    li x3, -710560667
    li x4, -25620853
    li x5, -86876270
    li x6, -1011334632
    li x7, 824118758
    li x8, 1233403818
    li x9, -1140065261
    li x10, -1127872446
    li x11, 1008568695
    li x12, 1442191700
    li x13, -863505558
    li x14, -2118866580
    li x15, 2043028570
    li x16, 975405388
    li x17, 162767625
    li x18, 114829292
    li x19, 1398136147
    li x20, -1654291680
    li x21, -1523844539
    li x22, -1459166420
    li x23, -270636944
    li x24, 878749930
    li x25, 379587218
    li x26, 192684667
    li x27, -1766585095
    li x28, -1512207077
    li x29, -1493837984
    li x30, -1808858254
    slti x21, x3, 1174
    mul x26, x19, x27
    sra x5, x25, x23
    srl x13, x27, x13
    rem x14, x5, x9
    jal x30, blk6
blk1:
    div x11, x11, x24
    mul x30, x5, x14
    sll x29, x19, x14
    rem x20, x24, x26
    remu x1, x17, x18
    bltu x1, x25, blk10
blk2:
    rem x25, x9, x14
    xori x16, x20, -813
    xor x8, x6, x28
    addi x24, x21, -1281
    mulhu x30, x12, x25
    jal x30, blk5
blk3:
    mulhsu x9, x3, x6
    and x5, x30, x10
    addi x12, x3, 136
    srl x30, x12, x24
    rem x23, x14, x27
    bge x9, x30, blk9
blk4:
    div x26, x24, x2
    sltu x13, x9, x3
    remu x6, x12, x5
    andi x3, x4, 83
    ori x25, x27, -1328
    blt x28, x15, blk6
blk5:
    slt x6, x25, x24
    remu x12, x28, x18
    rem x17, x25, x30
    xori x28, x13, -1880
    slt x17, x21, x30
    blt x13, x22, blk6
blk6:
    sltu x23, x3, x19
    xor x7, x8, x18
    remu x1, x5, x8
    andi x9, x1, -683
    ori x9, x14, -63
blk7:
    divu x2, x17, x20
    sltiu x17, x2, 301
    slt x23, x30, x20
    mulhsu x22, x21, x28
    slt x1, x6, x10
    bne x27, x18, blk9
blk8:
    mulhsu x1, x15, x18
    remu x15, x3, x24
    sltiu x16, x7, 109
    srl x14, x10, x5
    div x27, x21, x11
    jal x30, blk10
blk9:
    mulh x2, x22, x21
    srl x20, x30, x30
    sltiu x3, x3, -308
    xor x16, x3, x29
    srl x5, x11, x11
    jal x30, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
