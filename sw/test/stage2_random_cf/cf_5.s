    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 527858757
    li x2, 1038467225
    li x3, 1904202612
    li x4, 639840853
    li x5, 1721854523
    li x6, -1661267722
    li x7, -1088461400
    li x8, 187951464
    li x9, 317574981
    li x10, -1216636254
    li x11, -947116003
    li x12, 1141282117
    li x13, 1276236631
    li x14, 504454731
    li x15, -1603314586
    li x16, 1595171242
    li x17, 2071982903
    li x18, 1599479168
    li x19, -904927395
    li x20, 1982032882
    li x21, -1267962325
    li x22, 818800919
    li x23, 1691107634
    li x24, -864195088
    li x25, -596184694
    li x26, -1521698716
    li x27, -1867710720
    li x28, -696227655
    li x29, -816224473
    li x30, 1368024730
    sra x16, x23, x11
    sltu x16, x23, x6
    addi x1, x24, 1383
    sra x12, x13, x19
    mulhsu x2, x23, x6
    jal x30, blk2
blk1:
    ori x30, x27, 858
    addi x29, x17, 960
    addi x28, x10, -341
    slti x11, x17, 736
    mulh x9, x30, x23
    la x29, blk6
    jalr x30, x29, 0
blk2:
    sll x10, x6, x26
    slti x24, x23, -1651
    addi x3, x20, -104
    xori x24, x20, 1407
    mul x5, x2, x30
    la x29, blk10
    jalr x30, x29, 0
blk3:
    mulhu x27, x7, x5
    addi x21, x29, -666
    srl x14, x12, x5
    mulhu x10, x5, x15
    divu x17, x15, x16
    la x29, blk7
    jalr x30, x29, 0
blk4:
    sub x10, x16, x13
    sra x13, x27, x18
    sra x28, x11, x6
    divu x9, x17, x26
    andi x3, x26, -1767
    la x29, blk7
    jalr x30, x29, 0
blk5:
    xori x18, x23, 121
    sltiu x25, x23, -585
    ori x19, x28, 5
    sltiu x11, x22, 873
    andi x12, x9, 1298
    jal x30, blk8
blk6:
    sltiu x28, x28, 690
    slt x17, x5, x17
    sltiu x27, x12, -1403
    slti x24, x22, 1399
    div x10, x20, x18
    jal x30, blk7
blk7:
    mulhu x6, x19, x15
    add x8, x25, x22
    sll x16, x8, x6
    slti x4, x11, -1756
    andi x14, x15, -1459
    jal x30, blk10
blk8:
    addi x8, x23, 823
    addi x13, x9, 1014
    addi x2, x18, 370
    div x18, x17, x11
    xori x12, x27, 978
    jal x30, blk10
blk9:
    remu x6, x20, x13
    xor x7, x5, x20
    srl x27, x29, x22
    mulhu x4, x11, x19
    rem x11, x21, x29
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
