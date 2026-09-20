    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 189963082
    li x2, 446333181
    li x3, 1449418665
    li x4, -1141039821
    li x5, -101562192
    li x6, -1500591035
    li x7, 579222143
    li x8, 99562544
    li x9, 1036168857
    li x10, -1872470703
    li x11, 391269738
    li x12, 1569927520
    li x13, 1626988600
    li x14, 1808605022
    li x15, 1870830728
    li x16, 1627219933
    li x17, -1728920548
    li x18, -1563501829
    li x19, -1215531812
    li x20, -854585969
    li x21, 365390516
    li x22, 361858708
    li x23, 1736033392
    li x24, 1842307337
    li x25, 1530728784
    li x26, 1548926410
    li x27, 296814478
    li x28, 315819066
    li x29, -923600659
    li x30, -1874922558
    xor x28, x21, x16
    add x26, x3, x14
    addi x10, x14, -1686
    srl x20, x20, x25
    div x23, x19, x11
    jal x30, blk9
blk1:
    sub x2, x10, x1
    srl x20, x18, x2
    add x10, x20, x9
    slti x28, x11, 1046
    rem x13, x15, x28
    bltu x20, x26, blk10
blk2:
    mulhsu x9, x14, x21
    ori x30, x10, 434
    ori x18, x11, 531
    mulhu x1, x13, x20
    xori x2, x21, 843
    la x29, blk8
    jalr x30, x29, 0
blk3:
    mul x24, x16, x1
    andi x22, x1, 1690
    slti x10, x19, 933
    ori x6, x11, 115
    add x10, x26, x13
    jal x30, blk8
blk4:
    div x10, x17, x8
    rem x8, x11, x6
    and x21, x23, x4
    sra x11, x11, x22
    xor x26, x28, x6
    jal x30, blk10
blk5:
    slti x29, x19, -1058
    ori x2, x17, -545
    mulh x28, x9, x11
    mulhu x26, x20, x12
    xori x14, x10, 789
    la x29, blk9
    jalr x30, x29, 0
blk6:
    srl x14, x19, x14
    ori x5, x7, 1510
    add x18, x30, x23
    div x24, x15, x27
    sub x18, x11, x29
    beq x26, x8, blk9
blk7:
    mulhsu x2, x29, x26
    ori x29, x29, -1644
    sll x1, x16, x24
    mul x17, x10, x8
    and x17, x18, x14
    la x29, blk8
    jalr x30, x29, 0
blk8:
    remu x5, x9, x28
    slti x26, x26, -432
    sll x4, x18, x29
    add x8, x26, x9
    addi x16, x21, 175
    la x29, blk9
    jalr x30, x29, 0
blk9:
    addi x20, x17, 1825
    add x11, x25, x27
    add x25, x5, x2
    mulh x3, x16, x2
    slti x17, x17, 529
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
