    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1904597345
    li x2, -1782961187
    li x3, 1440956708
    li x4, -824047624
    li x5, 455026734
    li x6, 458709969
    li x7, 1930138874
    li x8, -2029608891
    li x9, -515331985
    li x10, 110607312
    li x11, 259890040
    li x12, -1133341320
    li x13, -2045013968
    li x14, -751005387
    li x15, 43911088
    li x16, 1690376882
    li x17, 1274574148
    li x18, 1129084575
    li x19, -627980133
    li x20, 1983849424
    li x21, 1090939186
    li x22, 130376819
    li x23, -42889869
    li x24, 1824639843
    li x25, 1644332189
    li x26, -167451468
    li x27, 961097509
    li x28, 1766854345
    li x29, -817920137
    li x30, 377719670
    srai x24, x7, 23
    lb x29, 20(x31)
    li x7, 656743152
    srai x19, x8, 6
    addi x28, x9, -324
    mul x29, x23, x25
    slt x12, x12, x6
    sb x3, 4(x31)
    xor x24, x30, x1
    srai x5, x27, 10
    ori x17, x23, 1110
    add x26, x8, x5
    sub x12, x20, x21
    srli x11, x16, 19
    lh x25, 0(x31)
    li x13, 881950656
    divu x8, x3, x22
    li x4, 1924550134
    lw x19, 28(x31)
    srli x5, x28, 16
    lb x14, 8(x31)
    slli x2, x5, 10
    mul x21, x8, x17
    sltiu x8, x23, -1446
    and x19, x8, x20
    sh x9, 24(x31)
    lhu x25, 0(x31)
    mulh x6, x4, x17
    slti x4, x4, -560
    sra x7, x1, x17
    rem x10, x18, x21
    andi x22, x30, -327
    li x14, 392314688
    mulhu x30, x17, x19
    xor x22, x26, x16
    and x17, x30, x4
    srli x10, x23, 23
    sub x28, x22, x14
    add x10, x7, x27
    li x15, 589676718
    mulh x7, x29, x19
    sltu x10, x1, x12
    sb x8, 28(x31)
    sra x19, x12, x13
    sltiu x25, x12, -1051
    xor x4, x3, x20
    sb x7, 4(x31)
    lhu x22, 0(x31)
    srli x12, x15, 23
    rem x17, x28, x16
    rem x27, x22, x10
    ori x6, x16, 77
    mulh x23, x22, x23
    lb x24, 4(x31)
    slli x6, x18, 26
    li x3, -1986113933
    srli x13, x8, 21
    ori x17, x10, -770
    li x14, 70872814
    sh x9, 8(x31)
done: j done
    .section .data
    .align 4
scratch: .space 64
