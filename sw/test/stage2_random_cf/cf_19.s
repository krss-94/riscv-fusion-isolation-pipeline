    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 760749655
    li x2, 87901487
    li x3, 49356480
    li x4, -457265134
    li x5, -1026159702
    li x6, -1028914420
    li x7, -811469323
    li x8, -1277529305
    li x9, 182289563
    li x10, 1002748496
    li x11, 1301630790
    li x12, -367487739
    li x13, 979230563
    li x14, -446404606
    li x15, 1433689588
    li x16, 1949550149
    li x17, 993757694
    li x18, 1294822014
    li x19, -471243338
    li x20, -1552443812
    li x21, 542528716
    li x22, 882013872
    li x23, 284867
    li x24, -562333532
    li x25, 1572259418
    li x26, 1677333874
    li x27, -1095716793
    li x28, -2036319755
    li x29, -529948966
    li x30, -1596081680
    andi x10, x15, -647
    andi x15, x15, -1677
    rem x3, x7, x10
    ori x4, x15, 1648
    andi x22, x1, 203
    bge x5, x6, blk2
blk1:
    slt x10, x29, x15
    mulh x20, x16, x29
    add x14, x21, x21
    div x29, x13, x20
    divu x21, x30, x2
    jal x30, blk6
blk2:
    add x9, x17, x11
    sub x25, x9, x21
    ori x7, x10, -935
    ori x11, x26, 459
    div x21, x24, x22
blk3:
    sll x30, x2, x28
    or x2, x15, x28
    andi x19, x28, 1776
    sltiu x23, x13, 978
    andi x6, x15, -1273
blk4:
    addi x14, x20, 548
    divu x14, x12, x15
    addi x2, x10, -193
    sra x13, x2, x6
    and x22, x23, x18
    bltu x28, x2, blk9
blk5:
    mulhu x14, x2, x23
    mul x20, x11, x8
    sltu x9, x7, x5
    slti x4, x19, -1457
    rem x23, x15, x10
    jal x30, blk10
blk6:
    slt x12, x24, x26
    ori x9, x5, -238
    addi x18, x15, 1541
    sra x4, x7, x20
    xori x5, x13, 821
    beq x17, x14, blk10
blk7:
    ori x19, x8, -52
    andi x4, x26, -932
    sra x23, x18, x8
    addi x6, x23, 238
    mulh x25, x13, x15
    beq x24, x8, blk10
blk8:
    or x9, x8, x16
    addi x13, x9, -905
    sltu x4, x6, x14
    divu x20, x26, x16
    or x8, x10, x6
    beq x4, x3, blk10
blk9:
    remu x22, x25, x3
    andi x3, x2, 1980
    slti x10, x12, -1069
    slti x20, x2, -1096
    sltiu x21, x11, 1775
    jal x30, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
