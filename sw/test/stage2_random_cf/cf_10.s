    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 306671827
    li x2, -305419184
    li x3, 335399608
    li x4, -1262298496
    li x5, 1345704537
    li x6, 1389803639
    li x7, -1459302929
    li x8, 88774231
    li x9, -739710141
    li x10, 2132696047
    li x11, -1956115428
    li x12, 1546879875
    li x13, 443200297
    li x14, -508498423
    li x15, 751468301
    li x16, -185408787
    li x17, 798269022
    li x18, 695124659
    li x19, -1576346870
    li x20, 2071949149
    li x21, 2016006815
    li x22, 486734992
    li x23, -2130066937
    li x24, -1572076031
    li x25, 1710239870
    li x26, 210376882
    li x27, -274744937
    li x28, 363123287
    li x29, -374219585
    li x30, -1988892516
    mulh x16, x10, x27
    sll x18, x30, x28
    mulhu x13, x19, x12
    sra x4, x25, x25
    xori x6, x26, 1344
    jal x30, blk8
blk1:
    mulhu x22, x9, x5
    sltiu x28, x4, -697
    sll x22, x21, x27
    xori x16, x25, -216
    xor x1, x18, x23
    jal x30, blk7
blk2:
    ori x3, x9, -752
    andi x13, x30, -71
    ori x24, x17, 1905
    sra x20, x16, x3
    slti x22, x15, 1396
blk3:
    remu x16, x23, x6
    add x4, x14, x27
    xor x15, x18, x3
    remu x3, x5, x4
    sra x27, x26, x16
blk4:
    sltiu x25, x17, 74
    xori x29, x26, 642
    mulhu x21, x17, x30
    mul x24, x8, x11
    remu x22, x7, x21
    bne x10, x14, blk5
blk5:
    add x23, x10, x29
    sltu x20, x30, x18
    xor x6, x22, x16
    xor x20, x13, x30
    srl x6, x3, x19
    bge x22, x10, blk7
blk6:
    rem x28, x24, x25
    mulhsu x15, x22, x24
    add x9, x20, x12
    xori x7, x14, -412
    add x3, x25, x14
    la x29, blk9
    jalr x30, x29, 0
blk7:
    sltu x12, x15, x14
    remu x15, x23, x10
    xori x17, x30, 749
    xori x12, x24, 1859
    divu x19, x16, x3
blk8:
    rem x30, x26, x6
    div x24, x19, x3
    divu x1, x19, x11
    divu x3, x24, x13
    sll x10, x20, x6
    beq x18, x26, blk10
blk9:
    srl x8, x19, x24
    ori x7, x19, -1917
    mulhsu x13, x7, x11
    divu x17, x30, x26
    mul x28, x2, x22
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
