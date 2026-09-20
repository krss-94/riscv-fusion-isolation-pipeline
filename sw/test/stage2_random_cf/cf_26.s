    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1266333950
    li x2, -1903712941
    li x3, 1135637217
    li x4, 11757332
    li x5, 581726284
    li x6, 1948766907
    li x7, 1478084879
    li x8, -1192791013
    li x9, -1591666061
    li x10, 418578386
    li x11, 1961399074
    li x12, -582918362
    li x13, -2015238744
    li x14, -2114456118
    li x15, 262522399
    li x16, 1356976144
    li x17, -328766475
    li x18, -1285348019
    li x19, -1071407693
    li x20, 78684101
    li x21, -1894437775
    li x22, -1825829795
    li x23, -1955289138
    li x24, -400500964
    li x25, 187638363
    li x26, -1700011677
    li x27, 1218654826
    li x28, 1899307744
    li x29, 886804084
    li x30, 350218100
    mulhsu x2, x12, x4
    div x26, x3, x5
    rem x12, x29, x30
    rem x12, x17, x16
    and x23, x2, x2
    bgeu x20, x27, blk1
blk1:
    and x16, x2, x19
    addi x2, x23, 345
    slti x14, x6, -1242
    add x3, x20, x28
    ori x28, x22, -1862
blk2:
    rem x27, x30, x11
    sra x1, x4, x4
    and x8, x10, x8
    divu x17, x13, x13
    mulh x23, x3, x17
    bge x1, x5, blk5
blk3:
    sltu x8, x11, x3
    sra x11, x14, x16
    mulh x8, x1, x17
    sub x4, x1, x7
    add x5, x18, x24
    jal x30, blk8
blk4:
    add x26, x6, x17
    srl x13, x16, x18
    slti x24, x24, -159
    sltiu x2, x18, 1369
    ori x7, x22, 1987
    la x29, blk7
    jalr x30, x29, 0
blk5:
    andi x25, x25, 344
    addi x27, x19, 96
    and x13, x29, x2
    div x26, x10, x6
    ori x8, x8, 1385
    blt x20, x23, blk10
blk6:
    addi x25, x7, -1939
    add x25, x17, x4
    mulh x24, x30, x22
    mulh x5, x13, x22
    addi x25, x23, 1914
blk7:
    srl x25, x21, x28
    sra x9, x20, x9
    slti x21, x3, 134
    ori x5, x23, -245
    divu x30, x24, x22
blk8:
    remu x2, x19, x25
    slti x4, x15, 1597
    sll x24, x15, x16
    mulhsu x3, x9, x3
    mulhsu x19, x24, x27
    bgeu x9, x25, blk9
blk9:
    addi x21, x8, -595
    xori x26, x12, 1417
    sub x17, x7, x9
    or x23, x20, x25
    mulh x13, x10, x16
    bltu x10, x5, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
