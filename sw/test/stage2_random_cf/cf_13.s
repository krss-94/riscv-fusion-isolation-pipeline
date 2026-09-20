    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1035050629
    li x2, 1005123725
    li x3, -1588222948
    li x4, -881942512
    li x5, -293860246
    li x6, -1517367605
    li x7, 1314461158
    li x8, 1401728461
    li x9, 1051193913
    li x10, 1929829377
    li x11, -1044931275
    li x12, 1502976610
    li x13, -1643426075
    li x14, 2085984805
    li x15, 820006544
    li x16, -1568291153
    li x17, -1388847487
    li x18, -1277208876
    li x19, 97466987
    li x20, -1059517922
    li x21, -174122173
    li x22, 453113804
    li x23, -573636195
    li x24, -1832766565
    li x25, 1948480806
    li x26, -473783153
    li x27, 940090999
    li x28, -1961904356
    li x29, -1538691101
    li x30, 1452323356
    rem x21, x9, x6
    slti x24, x28, 1022
    and x17, x23, x22
    and x8, x24, x16
    mul x2, x19, x23
    la x29, blk6
    jalr x30, x29, 0
blk1:
    or x6, x10, x7
    sub x4, x29, x8
    mul x14, x21, x20
    mulh x15, x27, x11
    addi x17, x1, 1294
    la x29, blk6
    jalr x30, x29, 0
blk2:
    sra x19, x20, x23
    add x17, x12, x28
    ori x11, x11, 1836
    addi x8, x22, 1033
    sll x17, x23, x30
blk3:
    sltu x22, x27, x28
    slti x14, x19, 306
    xori x14, x7, -1736
    sub x11, x13, x15
    sltu x25, x2, x20
blk4:
    addi x16, x18, 323
    add x17, x14, x5
    slt x4, x12, x27
    sltiu x10, x10, -1775
    xori x12, x5, 1571
blk5:
    slti x2, x12, -1646
    mulhu x11, x6, x29
    sll x29, x1, x29
    addi x3, x16, 778
    add x9, x26, x27
    jal x30, blk7
blk6:
    slti x17, x26, 1172
    mul x20, x2, x27
    divu x4, x20, x5
    or x18, x13, x10
    addi x10, x9, -1799
    bgeu x4, x17, blk8
blk7:
    andi x9, x28, 1428
    div x6, x20, x27
    sub x30, x25, x2
    xori x10, x13, 145
    sltiu x5, x26, -2018
    blt x18, x9, blk10
blk8:
    xor x11, x8, x30
    xori x14, x6, 93
    remu x5, x15, x19
    remu x7, x25, x13
    mul x27, x7, x1
    jal x30, blk10
blk9:
    mulhu x5, x4, x1
    ori x10, x3, -1595
    rem x7, x23, x24
    mulhu x1, x18, x1
    add x10, x27, x20
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
