    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 209141734
    li x2, 1076065195
    li x3, 1062174304
    li x4, 1567856881
    li x5, -919523314
    li x6, 1999618525
    li x7, 286646244
    li x8, 1075321848
    li x9, -582867226
    li x10, -2099053753
    li x11, 952116519
    li x12, -2039167190
    li x13, 751979670
    li x14, -1925959311
    li x15, -751679523
    li x16, -1472985272
    li x17, -1831310069
    li x18, 1486427143
    li x19, -1790747123
    li x20, 1758449696
    li x21, 1385054337
    li x22, -20387034
    li x23, -477081797
    li x24, 2002699328
    li x25, 1102293549
    li x26, 1417715757
    li x27, 733143765
    li x28, 207569617
    li x29, -1727173496
    li x30, -526700785
    li x7, 776466112
    slli x30, x19, 14
    li x19, 709790525
    add x4, x23, x6
    andi x23, x29, -1960
    mulhu x17, x27, x25
    li x25, 198398208
    sw x26, 24(x31)
    sh x9, 8(x31)
    lh x16, 4(x31)
    li x18, 1280134755
    sra x15, x29, x20
    xor x8, x23, x26
    sb x18, 28(x31)
    addi x30, x27, 450
    xori x14, x2, 826
    lhu x23, 4(x31)
    srai x26, x25, 6
    lbu x8, 28(x31)
    andi x7, x13, 66
    xori x24, x18, 1208
    li x7, -1725313912
    lw x18, 0(x31)
    slli x24, x14, 16
    sb x7, 20(x31)
    lh x6, 20(x31)
    sra x3, x13, x19
    lhu x2, 24(x31)
    sll x12, x9, x1
    sh x5, 28(x31)
    sra x10, x24, x11
    mulh x4, x1, x19
    slti x12, x17, -1726
    li x11, 569668501
    mul x25, x14, x3
    xor x17, x25, x19
    srl x2, x23, x7
    andi x3, x27, 411
    xor x25, x12, x19
    sb x9, 16(x31)
    andi x15, x15, -1465
    remu x25, x6, x22
    andi x12, x28, -774
    mulhsu x8, x24, x2
    ori x9, x17, -2041
    xori x2, x30, 364
    ori x23, x26, 286
    srli x17, x16, 2
    sw x11, 28(x31)
    slli x9, x28, 11
    slli x5, x30, 13
    lbu x28, 20(x31)
    xori x6, x5, 1992
    li x5, -2098109747
    mulh x23, x10, x14
    divu x14, x5, x15
    srai x30, x2, 31
    addi x25, x20, -1441
    ori x17, x5, 486
    slt x26, x7, x3
done: j done
    .section .data
    .align 4
scratch: .space 64
