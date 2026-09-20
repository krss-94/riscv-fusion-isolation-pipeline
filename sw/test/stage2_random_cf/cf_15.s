    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1998199804
    li x2, 1013576293
    li x3, 2088812051
    li x4, -2074981764
    li x5, 778895189
    li x6, 2146694380
    li x7, -1117914766
    li x8, -695450730
    li x9, 894187856
    li x10, -942394472
    li x11, -1016557507
    li x12, 1536898626
    li x13, 1608605304
    li x14, 1278250944
    li x15, -1188025712
    li x16, 48833561
    li x17, -344132852
    li x18, -1808356070
    li x19, -601448105
    li x20, 298997184
    li x21, 625223744
    li x22, 2126751478
    li x23, -2066952797
    li x24, 940951493
    li x25, -21538937
    li x26, -1648314924
    li x27, -1943832750
    li x28, 236182330
    li x29, 8832838
    li x30, -627918163
    xor x8, x10, x10
    xori x13, x29, -1441
    xori x25, x30, -884
    xori x4, x22, -1922
    mulh x27, x9, x30
    beq x2, x15, blk5
blk1:
    ori x9, x6, 1892
    mul x28, x16, x2
    remu x16, x27, x3
    remu x8, x25, x25
    mulh x23, x24, x9
    bgeu x11, x25, blk2
blk2:
    addi x27, x13, 428
    mul x20, x15, x10
    addi x26, x14, 803
    mul x20, x13, x30
    ori x5, x9, 663
    jal x30, blk8
blk3:
    sltiu x22, x19, -2028
    xor x20, x12, x23
    or x30, x2, x28
    rem x24, x4, x27
    xor x11, x28, x29
    la x29, blk4
    jalr x30, x29, 0
blk4:
    remu x11, x15, x24
    ori x19, x30, -2011
    sra x4, x26, x28
    and x27, x6, x21
    sltiu x18, x18, 1275
    bge x17, x24, blk6
blk5:
    divu x19, x6, x27
    rem x15, x28, x20
    sltu x1, x9, x11
    andi x12, x6, -306
    slti x4, x3, -1469
    jal x30, blk9
blk6:
    slti x29, x29, -1592
    andi x12, x14, -655
    or x12, x25, x19
    xori x6, x16, -647
    xori x14, x3, -24
blk7:
    mulhu x11, x13, x29
    and x2, x22, x19
    xor x22, x15, x15
    div x15, x29, x15
    xori x13, x15, -1027
    la x29, blk8
    jalr x30, x29, 0
blk8:
    andi x15, x30, 1789
    sll x17, x3, x7
    andi x25, x18, -1157
    sltiu x23, x13, 1636
    xori x9, x6, -1061
    jal x30, blk10
blk9:
    sltiu x9, x6, -804
    sll x15, x22, x17
    mulhsu x16, x17, x4
    slti x26, x7, 301
    remu x27, x14, x23
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
