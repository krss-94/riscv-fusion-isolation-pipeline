    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1132903364
    li x2, -1051970500
    li x3, -216934237
    li x4, 651086875
    li x5, 1240057366
    li x6, -1744359796
    li x7, 1442100146
    li x8, -234560211
    li x9, 1912423074
    li x10, 1724117817
    li x11, -2016100644
    li x12, 177865246
    li x13, -1146393543
    li x14, -2055186059
    li x15, 611149651
    li x16, 1545958589
    li x17, 731456842
    li x18, -844525795
    li x19, 1642734788
    li x20, 22693829
    li x21, -1999196329
    li x22, 1277341528
    li x23, -1404422504
    li x24, -538146417
    li x25, 36191509
    li x26, 1195901923
    li x27, -458465863
    li x28, -2020460154
    li x29, -1960707156
    li x30, -1415839410
    or x17, x8, x1
    srl x30, x28, x18
    divu x17, x12, x28
    mul x15, x30, x9
    mulhu x13, x26, x28
    jal x30, blk9
blk1:
    ori x14, x2, -411
    xori x17, x14, 787
    divu x1, x18, x18
    sll x15, x20, x1
    or x18, x19, x6
    beq x27, x22, blk6
blk2:
    addi x3, x28, 255
    mulhu x8, x9, x4
    sll x12, x10, x3
    div x9, x17, x6
    andi x21, x23, 589
blk3:
    sltiu x4, x1, 1400
    sltu x26, x7, x9
    and x29, x24, x17
    add x14, x27, x1
    mulhu x13, x5, x2
blk4:
    remu x18, x27, x8
    srl x8, x17, x21
    andi x22, x19, 1444
    slt x2, x24, x10
    sub x29, x2, x10
    la x29, blk7
    jalr x30, x29, 0
blk5:
    div x24, x6, x14
    and x5, x1, x18
    remu x27, x7, x29
    mul x6, x27, x28
    slt x13, x7, x12
blk6:
    srl x19, x7, x16
    xor x10, x17, x16
    addi x20, x28, -763
    mulhu x7, x28, x11
    andi x11, x14, -1259
    la x29, blk10
    jalr x30, x29, 0
blk7:
    remu x30, x29, x27
    add x25, x18, x8
    or x3, x5, x6
    ori x7, x9, 43
    sltu x12, x11, x11
blk8:
    xor x5, x19, x18
    slti x2, x14, -1024
    rem x11, x4, x20
    and x3, x19, x18
    ori x3, x9, -1112
    la x29, blk10
    jalr x30, x29, 0
blk9:
    addi x4, x26, -1929
    slt x3, x14, x4
    slti x8, x26, -1102
    sll x15, x6, x22
    xori x24, x28, 360
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
