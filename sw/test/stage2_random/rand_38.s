    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 599034954
    li x2, 963356107
    li x3, -1863021639
    li x4, 849814744
    li x5, -537164088
    li x6, -667579365
    li x7, 973225970
    li x8, 355801175
    li x9, 484462426
    li x10, 120470218
    li x11, -1542625840
    li x12, 115303749
    li x13, -2097309573
    li x14, -2041922751
    li x15, -105081058
    li x16, -1072878999
    li x17, 1062086031
    li x18, 1690631351
    li x19, -1774766184
    li x20, 1166640506
    li x21, -1362234413
    li x22, -348934873
    li x23, -1014196506
    li x24, -285621799
    li x25, -546210183
    li x26, -1082128671
    li x27, -2023903150
    li x28, 1864742018
    li x29, 1271338108
    li x30, 1471306398
    and x30, x24, x17
    slli x28, x29, 2
    mulh x5, x22, x15
    addi x20, x19, 1581
    slti x13, x5, 112
    add x11, x23, x9
    li x3, 2109346045
    slli x9, x5, 11
    lb x10, 24(x31)
    sub x17, x18, x30
    lh x23, 24(x31)
    sh x1, 24(x31)
    remu x29, x21, x16
    srai x6, x7, 6
    sb x20, 8(x31)
    sb x25, 12(x31)
    lh x10, 4(x31)
    or x14, x15, x2
    mulhsu x16, x21, x8
    slti x19, x12, -1174
    li x18, -1030227835
    li x25, 1737151035
    srl x30, x21, x17
    srai x9, x12, 17
    li x14, -297796039
    sb x19, 12(x31)
    lhu x24, 8(x31)
    sh x9, 12(x31)
    sh x30, 20(x31)
    lw x10, 8(x31)
    srai x1, x2, 15
    slli x9, x25, 7
    div x2, x24, x27
    or x24, x22, x3
    sh x29, 12(x31)
    sll x6, x30, x6
    srai x30, x26, 26
    xori x25, x4, 359
    or x21, x17, x21
    remu x23, x17, x2
    lh x23, 0(x31)
    mulhu x1, x27, x26
    lh x21, 16(x31)
    li x25, 1372402907
    srl x25, x21, x14
    slti x20, x15, 364
    ori x19, x6, 292
    addi x13, x19, -1334
    srl x28, x9, x11
    sltiu x6, x22, 89
    lh x30, 16(x31)
    li x8, 1895698179
    srai x5, x5, 20
    srai x1, x5, 9
    ori x26, x19, -926
    add x13, x17, x9
    add x18, x30, x27
    rem x28, x9, x27
    li x6, 1493509680
    slti x16, x27, 1660
done: j done
    .section .data
    .align 4
scratch: .space 64
