    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 206669761
    li x2, -907967073
    li x3, -670812570
    li x4, -362950793
    li x5, 2035208040
    li x6, -646106684
    li x7, 2142072459
    li x8, 989790753
    li x9, -1415467504
    li x10, 746659503
    li x11, -865971008
    li x12, 1228846564
    li x13, 67447445
    li x14, 1083718509
    li x15, 1102687951
    li x16, 623458907
    li x17, -1550002817
    li x18, -438687685
    li x19, 667208129
    li x20, -143504298
    li x21, 684509902
    li x22, -951937928
    li x23, -2053524869
    li x24, 1820016310
    li x25, -1563795238
    li x26, -1499912464
    li x27, 1786488527
    li x28, 1587652541
    li x29, 964243961
    li x30, -825267343
    add x1, x21, x17
    sll x17, x25, x1
    sub x23, x15, x12
    xori x1, x24, -1866
    mulhu x5, x7, x4
blk1:
    or x28, x8, x7
    and x8, x11, x8
    div x4, x26, x23
    addi x11, x8, 590
    sltu x14, x10, x19
    bge x14, x2, blk8
blk2:
    xor x14, x16, x26
    xor x13, x5, x5
    mulh x20, x16, x13
    sra x11, x7, x16
    sra x27, x8, x19
    la x29, blk5
    jalr x30, x29, 0
blk3:
    remu x6, x6, x2
    remu x2, x21, x18
    sltu x23, x10, x2
    slt x8, x11, x8
    slt x23, x28, x20
    la x29, blk4
    jalr x30, x29, 0
blk4:
    sll x11, x30, x12
    srl x12, x7, x27
    sltiu x8, x30, 705
    slti x11, x13, -1116
    mulh x24, x6, x25
    la x29, blk10
    jalr x30, x29, 0
blk5:
    slt x3, x26, x26
    sltiu x7, x5, 563
    mulh x24, x3, x10
    divu x21, x26, x27
    sltiu x26, x24, -1038
    la x29, blk8
    jalr x30, x29, 0
blk6:
    divu x29, x28, x4
    mulhu x5, x30, x17
    xor x17, x1, x15
    mulhsu x7, x25, x14
    xori x30, x7, -1558
    jal x30, blk8
blk7:
    ori x15, x23, 380
    sltu x17, x28, x18
    slt x17, x24, x29
    slt x23, x7, x8
    sub x16, x21, x10
    jal x30, blk9
blk8:
    divu x1, x9, x30
    addi x13, x20, -11
    sub x3, x22, x26
    srl x20, x10, x6
    slti x26, x22, 1728
    beq x12, x5, blk9
blk9:
    srl x2, x17, x13
    rem x1, x3, x17
    and x23, x14, x25
    slti x20, x22, -1204
    andi x24, x9, -1914
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
