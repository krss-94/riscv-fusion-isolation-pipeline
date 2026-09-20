    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1133664809
    li x2, -446426455
    li x3, -1481882790
    li x4, -1861803471
    li x5, 1795103241
    li x6, 1138864728
    li x7, 157539438
    li x8, -1691429874
    li x9, 1835993865
    li x10, 1317061808
    li x11, 1290413637
    li x12, -1316683993
    li x13, -816688224
    li x14, 1632305552
    li x15, 454630388
    li x16, 737452156
    li x17, 25571273
    li x18, -1383880669
    li x19, -113439163
    li x20, -857938010
    li x21, 1756084543
    li x22, 1642040057
    li x23, 35959074
    li x24, -369598927
    li x25, 424825853
    li x26, -296167990
    li x27, -1454616925
    li x28, -837039304
    li x29, -1961775832
    li x30, -1948532166
    remu x21, x9, x17
    mulhsu x23, x11, x5
    sra x3, x14, x30
    andi x9, x6, 578
    addi x21, x18, -1544
    la x29, blk4
    jalr x30, x29, 0
blk1:
    sub x25, x19, x20
    xori x11, x30, -1838
    sltu x2, x12, x23
    xor x24, x22, x11
    rem x10, x11, x5
    la x29, blk3
    jalr x30, x29, 0
blk2:
    sltiu x20, x7, -931
    xor x9, x13, x20
    sra x19, x1, x12
    sltiu x6, x12, -1253
    sub x15, x7, x14
    bne x2, x24, blk3
blk3:
    mul x20, x22, x5
    xor x18, x16, x19
    div x2, x4, x27
    sra x25, x14, x21
    xori x7, x8, -1746
blk4:
    slti x15, x8, 2036
    sltiu x7, x2, -63
    srl x17, x7, x25
    addi x28, x9, 528
    andi x19, x4, -1717
blk5:
    mulhu x3, x14, x7
    andi x11, x10, 532
    sltu x27, x14, x17
    addi x11, x30, 246
    srl x21, x22, x7
    jal x30, blk10
blk6:
    sll x25, x9, x22
    remu x23, x21, x15
    slti x24, x13, -2022
    and x7, x30, x6
    xori x29, x9, -227
    jal x30, blk7
blk7:
    ori x6, x22, 1814
    sub x30, x17, x15
    sra x2, x23, x20
    mulhu x18, x28, x9
    mul x2, x12, x3
    la x29, blk9
    jalr x30, x29, 0
blk8:
    remu x27, x3, x3
    xori x13, x7, -134
    addi x25, x16, -1416
    ori x4, x30, 1506
    addi x14, x28, -444
blk9:
    mulhu x14, x4, x26
    sll x12, x28, x6
    sltiu x11, x16, -2009
    div x23, x6, x1
    andi x4, x18, 1918
    jal x30, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
