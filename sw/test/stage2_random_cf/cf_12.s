    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -109218082
    li x2, 714727545
    li x3, -1535019803
    li x4, -537925359
    li x5, 1332934744
    li x6, 435754673
    li x7, 249924358
    li x8, -257462711
    li x9, -1450550792
    li x10, 1743640679
    li x11, 1369322020
    li x12, 1470611294
    li x13, 38336515
    li x14, 2092224555
    li x15, 1918617807
    li x16, 1355911088
    li x17, 412192216
    li x18, 972068901
    li x19, 2007720616
    li x20, 702639655
    li x21, 816535418
    li x22, 746348603
    li x23, -1658577194
    li x24, -1138284760
    li x25, -587025920
    li x26, 52064
    li x27, -2026609224
    li x28, -299984670
    li x29, 81592826
    li x30, -312488680
    mulh x13, x7, x25
    sub x25, x18, x8
    sltiu x23, x9, 2034
    mul x12, x20, x21
    xor x17, x15, x12
blk1:
    slti x16, x23, -676
    slti x15, x30, -498
    mul x25, x24, x8
    slti x9, x30, -69
    slt x26, x1, x17
    la x29, blk3
    jalr x30, x29, 0
blk2:
    xor x18, x17, x5
    andi x29, x26, -1081
    remu x8, x26, x17
    andi x16, x21, 1596
    sltiu x29, x24, -1672
    la x29, blk7
    jalr x30, x29, 0
blk3:
    remu x28, x17, x21
    div x23, x26, x7
    mul x17, x9, x1
    div x23, x1, x5
    srl x14, x5, x8
    bltu x18, x19, blk7
blk4:
    addi x24, x30, 1373
    slti x14, x19, 798
    ori x12, x21, -730
    add x1, x23, x23
    srl x26, x2, x29
    jal x30, blk9
blk5:
    xor x26, x30, x13
    remu x7, x10, x9
    or x20, x20, x4
    ori x20, x23, -35
    addi x3, x14, 675
    blt x24, x10, blk7
blk6:
    rem x23, x6, x25
    sra x12, x6, x1
    add x20, x15, x16
    slti x22, x20, 634
    sltiu x4, x8, 243
blk7:
    or x10, x8, x17
    or x29, x23, x11
    mulhsu x15, x13, x20
    slt x15, x15, x26
    ori x14, x18, 1555
    bltu x4, x18, blk10
blk8:
    mul x22, x10, x12
    andi x11, x25, 468
    or x6, x5, x16
    srl x5, x9, x16
    andi x26, x12, 268
    la x29, blk10
    jalr x30, x29, 0
blk9:
    mul x5, x5, x9
    xori x27, x22, 1424
    xori x20, x22, 1062
    sll x16, x13, x13
    addi x26, x7, 146
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
