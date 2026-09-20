    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1499591369
    li x2, 648258640
    li x3, 154112043
    li x4, 31936245
    li x5, -1986441000
    li x6, -284989606
    li x7, -1847456881
    li x8, -324187610
    li x9, 1922895273
    li x10, -443753964
    li x11, 2045500108
    li x12, 1539610315
    li x13, -903621226
    li x14, -1371269749
    li x15, 596628807
    li x16, -548048381
    li x17, -1262897697
    li x18, -798231825
    li x19, -201071568
    li x20, -859994195
    li x21, 1264350247
    li x22, -1099097093
    li x23, 319647407
    li x24, 108218145
    li x25, 1611203271
    li x26, 985460000
    li x27, 2062335288
    li x28, -351659800
    li x29, 1104411903
    li x30, -47403134
    or x22, x3, x25
    lh x26, 20(x31)
    sb x20, 28(x31)
    li x3, -1868310862
    sh x10, 28(x31)
    sb x29, 20(x31)
    mulh x12, x6, x20
    div x2, x7, x25
    xori x24, x8, 1154
    or x6, x15, x13
    srai x29, x5, 27
    slli x23, x14, 24
    andi x3, x6, -148
    sltiu x1, x16, -555
    srai x1, x5, 23
    lhu x11, 0(x31)
    li x25, -462229085
    rem x13, x4, x16
    sra x7, x3, x7
    addi x4, x11, -1618
    sub x19, x5, x18
    srai x20, x1, 13
    divu x5, x21, x9
    lhu x12, 4(x31)
    mulh x16, x16, x10
    xori x4, x24, 120
    li x23, -2048288269
    lw x12, 0(x31)
    srai x21, x28, 16
    srai x30, x6, 14
    lw x25, 12(x31)
    li x26, 1302775549
    addi x17, x16, -1811
    li x9, -668808329
    li x30, -581384443
    sltiu x4, x8, -437
    xori x16, x20, -2033
    sw x26, 4(x31)
    slt x30, x13, x26
    divu x29, x6, x14
    sra x26, x24, x13
    mulhu x24, x3, x24
    andi x5, x1, 1764
    andi x20, x27, 1837
    slli x5, x18, 8
    sub x26, x24, x21
    lbu x24, 24(x31)
    li x28, -1065861366
    srli x17, x8, 20
    lh x14, 0(x31)
    rem x22, x19, x27
    li x30, 45299097
    li x15, 466238647
    li x26, -1539492496
    lh x24, 0(x31)
    sb x17, 28(x31)
    lb x2, 16(x31)
    li x4, 265125696
    li x29, -243746294
    lh x17, 12(x31)
done: j done
    .section .data
    .align 4
scratch: .space 64
