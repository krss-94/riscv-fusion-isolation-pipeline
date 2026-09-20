    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1860219139
    li x2, -1672869430
    li x3, 1013330490
    li x4, -1484556540
    li x5, 1003926686
    li x6, 18378755
    li x7, 440479943
    li x8, 315064494
    li x9, -429156120
    li x10, -1554829726
    li x11, -532314682
    li x12, 1170203334
    li x13, 516627807
    li x14, 692597955
    li x15, -779778212
    li x16, -1193107760
    li x17, 481205227
    li x18, -519451681
    li x19, 206152428
    li x20, -1508684289
    li x21, 1411226215
    li x22, -1877235574
    li x23, 704169935
    li x24, -1829497911
    li x25, -316013895
    li x26, 932547161
    li x27, -1467143796
    li x28, -258789795
    li x29, 2004030547
    li x30, -398481450
    li x15, 447082818
    sh x8, 24(x31)
    lh x19, 8(x31)
    slli x29, x4, 7
    lb x9, 24(x31)
    srli x25, x30, 8
    sw x25, 28(x31)
    sltiu x24, x22, -1830
    lhu x4, 20(x31)
    sb x17, 12(x31)
    xori x2, x11, 1944
    srli x26, x29, 1
    sb x27, 16(x31)
    mul x8, x28, x28
    rem x19, x5, x9
    slti x9, x30, -224
    li x8, -1227419858
    sub x14, x2, x23
    srl x30, x3, x17
    slti x17, x23, 223
    div x15, x21, x29
    srai x24, x28, 19
    sb x27, 20(x31)
    xor x2, x4, x24
    slt x20, x14, x25
    xor x28, x23, x8
    lh x9, 8(x31)
    li x18, -1877258202
    slt x16, x3, x23
    sltiu x11, x16, 526
    sb x10, 0(x31)
    mulh x10, x15, x3
    sb x8, 8(x31)
    sw x2, 0(x31)
    slli x23, x30, 24
    lbu x6, 20(x31)
    add x12, x11, x16
    li x9, 587688861
    srai x2, x7, 30
    sltu x16, x6, x29
    mul x15, x4, x16
    addi x29, x13, -1078
    lw x6, 0(x31)
    xor x6, x3, x10
    lb x2, 28(x31)
    mulhu x3, x9, x23
    rem x13, x2, x16
    divu x17, x17, x12
    slli x8, x18, 14
    srai x3, x10, 25
    andi x1, x24, -1923
    li x22, -549853289
    srl x7, x1, x11
    sw x6, 20(x31)
    sw x19, 28(x31)
    mulhsu x6, x17, x7
    li x10, 441336671
    lh x1, 16(x31)
    li x4, 1541248885
    slli x11, x7, 22
done: j done
    .section .data
    .align 4
scratch: .space 64
