    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -594755157
    li x2, -83834892
    li x3, -356685734
    li x4, -228667235
    li x5, -1035708234
    li x6, 579803096
    li x7, -2103982619
    li x8, -815578841
    li x9, 1242284908
    li x10, -1058683618
    li x11, 1690244452
    li x12, -2029933182
    li x13, -816944923
    li x14, -1038372573
    li x15, 1236199887
    li x16, -653777583
    li x17, 614276322
    li x18, -1958476705
    li x19, 2035317895
    li x20, 1246963025
    li x21, 100384856
    li x22, -1139023664
    li x23, -1483870807
    li x24, -840791014
    li x25, -168009167
    li x26, -1865167041
    li x27, 855923512
    li x28, -2091357979
    li x29, -36370100
    li x30, 1270186271
    sra x15, x27, x20
    mulhsu x21, x1, x5
    addi x30, x13, -1696
    divu x22, x21, x13
    mulh x16, x17, x22
    la x29, blk4
    jalr x30, x29, 0
blk1:
    mulh x4, x23, x3
    mul x8, x1, x13
    mul x30, x27, x4
    sltu x28, x25, x13
    slt x8, x6, x19
    jal x30, blk10
blk2:
    mulhu x30, x4, x4
    srl x9, x13, x14
    xori x15, x29, 80
    mulhsu x2, x2, x1
    rem x14, x22, x9
    jal x30, blk4
blk3:
    sltu x4, x14, x21
    srl x4, x15, x14
    srl x8, x5, x29
    slti x14, x17, 920
    srl x22, x16, x27
blk4:
    ori x28, x1, 368
    andi x4, x28, 2039
    slti x8, x18, 1572
    mulh x17, x5, x16
    xor x25, x21, x22
blk5:
    mul x3, x26, x16
    sub x17, x11, x18
    xori x23, x12, -1518
    add x8, x7, x15
    xori x21, x1, -382
    la x29, blk6
    jalr x30, x29, 0
blk6:
    andi x29, x21, -1576
    mulhsu x5, x22, x18
    div x7, x17, x26
    mulhsu x17, x1, x20
    slti x16, x19, 1726
    beq x7, x1, blk8
blk7:
    andi x30, x12, -1253
    mulh x5, x2, x6
    slti x24, x25, 1525
    sra x3, x6, x30
    mulhu x3, x29, x2
    jal x30, blk8
blk8:
    xor x25, x7, x14
    xori x4, x22, 73
    mulhsu x4, x20, x13
    xori x12, x24, -1910
    slt x12, x7, x27
blk9:
    mulhsu x29, x26, x2
    divu x14, x25, x24
    addi x2, x17, -847
    srl x14, x8, x11
    andi x2, x13, 1617
    jal x30, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
