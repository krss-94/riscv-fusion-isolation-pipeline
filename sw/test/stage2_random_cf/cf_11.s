    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -147531839
    li x2, 375314994
    li x3, 51147202
    li x4, 1258326099
    li x5, -1743226477
    li x6, -844385151
    li x7, 2071004980
    li x8, 1996119480
    li x9, 121896630
    li x10, -1891713581
    li x11, -154900306
    li x12, 1470713325
    li x13, 82137440
    li x14, 602548301
    li x15, -974295
    li x16, 697715439
    li x17, -952783076
    li x18, 1461214682
    li x19, 892535548
    li x20, -906066512
    li x21, 1143697776
    li x22, -427779567
    li x23, 1488565340
    li x24, -487420646
    li x25, 1967277085
    li x26, -2145143166
    li x27, 1762104543
    li x28, -128903672
    li x29, -440558901
    li x30, 556004609
    addi x25, x22, 501
    sll x11, x1, x14
    add x8, x23, x4
    or x15, x26, x16
    sll x7, x15, x17
blk1:
    add x4, x13, x14
    div x9, x28, x26
    srl x29, x1, x7
    mulh x28, x20, x21
    sltiu x2, x5, -1970
    la x29, blk7
    jalr x30, x29, 0
blk2:
    slt x13, x3, x3
    and x19, x21, x8
    slti x12, x12, 1914
    slti x27, x19, -786
    mulhsu x10, x30, x8
    jal x30, blk6
blk3:
    srl x24, x21, x18
    srl x29, x16, x20
    or x2, x4, x4
    rem x9, x8, x24
    remu x9, x14, x27
    jal x30, blk6
blk4:
    slt x30, x24, x3
    mulh x16, x18, x21
    add x9, x7, x30
    slti x3, x9, -1553
    ori x2, x6, -971
    la x29, blk5
    jalr x30, x29, 0
blk5:
    andi x5, x29, -899
    sra x19, x2, x30
    addi x30, x12, -1874
    addi x20, x21, 500
    sra x11, x5, x3
    la x29, blk10
    jalr x30, x29, 0
blk6:
    mulhu x24, x2, x29
    addi x26, x30, 1829
    addi x29, x3, 2047
    rem x19, x1, x20
    mulh x13, x19, x1
    blt x21, x4, blk7
blk7:
    xori x29, x14, 1701
    mulh x15, x15, x27
    sltu x17, x25, x17
    slt x20, x3, x16
    remu x23, x4, x16
    bne x12, x10, blk9
blk8:
    mulhu x22, x20, x7
    remu x25, x29, x11
    xori x16, x29, 4
    slt x7, x21, x14
    slti x13, x8, -933
blk9:
    sub x12, x27, x29
    sra x9, x27, x6
    srl x16, x9, x30
    andi x13, x21, 535
    remu x23, x27, x27
    blt x27, x2, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
