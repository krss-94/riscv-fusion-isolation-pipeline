    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1667598694
    li x2, -429520775
    li x3, 67505222
    li x4, -2009265617
    li x5, 1396259599
    li x6, 1473816259
    li x7, 1801910664
    li x8, 119268419
    li x9, -1748389082
    li x10, -91292181
    li x11, -1476991415
    li x12, -1828282797
    li x13, -1677692187
    li x14, -1175279449
    li x15, 28227600
    li x16, -966068353
    li x17, -706159552
    li x18, 1597057543
    li x19, -1358306664
    li x20, -851546173
    li x21, 759063522
    li x22, -1650172414
    li x23, 258132872
    li x24, 183004927
    li x25, -1864797736
    li x26, 1538706927
    li x27, -855373726
    li x28, -1997005853
    li x29, 1180669638
    li x30, -1779009465
    mulhu x15, x21, x6
    li x13, 694447003
    rem x23, x5, x26
    sb x13, 24(x31)
    srl x2, x7, x4
    li x11, -794709517
    remu x8, x9, x13
    slli x10, x18, 15
    lh x11, 24(x31)
    sb x20, 28(x31)
    sw x11, 24(x31)
    sll x28, x27, x3
    sb x20, 12(x31)
    slli x30, x10, 0
    sb x24, 24(x31)
    lw x8, 4(x31)
    srai x24, x21, 26
    andi x7, x2, -776
    mulhu x9, x13, x21
    slli x30, x4, 21
    srai x25, x10, 22
    sh x20, 4(x31)
    lw x16, 12(x31)
    rem x16, x26, x21
    lbu x14, 4(x31)
    mulh x5, x5, x26
    li x14, -1851106986
    lbu x11, 0(x31)
    li x19, -567613751
    slli x20, x14, 29
    sltiu x11, x10, 533
    slli x7, x6, 0
    sw x24, 28(x31)
    sub x5, x11, x30
    slti x10, x3, 1655
    slt x5, x30, x25
    addi x6, x28, 927
    sltu x8, x11, x16
    ori x24, x27, 1150
    sh x13, 20(x31)
    li x28, -573476630
    addi x30, x14, -1161
    li x22, 1818903810
    slli x13, x12, 18
    sltu x24, x5, x11
    rem x1, x2, x24
    li x18, 51605682
    sh x29, 24(x31)
    mul x20, x10, x9
    mulhu x9, x2, x4
    slli x28, x27, 3
    srli x10, x2, 2
    mul x7, x20, x23
    srai x22, x11, 8
    sb x21, 24(x31)
    lbu x18, 8(x31)
    sh x21, 20(x31)
    lw x24, 24(x31)
    sltiu x5, x11, 831
    li x18, -365541999
done: j done
    .section .data
    .align 4
scratch: .space 64
