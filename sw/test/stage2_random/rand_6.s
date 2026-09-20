    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1382782102
    li x2, -1023827911
    li x3, -2145543544
    li x4, -544772047
    li x5, 1160241785
    li x6, -976254300
    li x7, 1296717143
    li x8, 781906281
    li x9, 797531995
    li x10, 1478681337
    li x11, -1747473626
    li x12, 1289704459
    li x13, 1309026637
    li x14, -896859768
    li x15, 1938632292
    li x16, -599665211
    li x17, 1758837219
    li x18, -595383727
    li x19, 437001078
    li x20, -840420274
    li x21, 382925280
    li x22, 108504562
    li x23, 698968001
    li x24, -1304707409
    li x25, -69817790
    li x26, -2093699045
    li x27, 1194247920
    li x28, -832688831
    li x29, -476030203
    li x30, 2146962235
    srl x6, x14, x20
    sub x15, x8, x26
    lhu x22, 28(x31)
    li x27, -316020325
    slli x23, x27, 5
    sw x9, 28(x31)
    li x6, 162960894
    srli x19, x26, 12
    lhu x15, 16(x31)
    remu x20, x16, x9
    sh x16, 24(x31)
    srli x21, x26, 20
    sw x30, 24(x31)
    lhu x9, 24(x31)
    sw x6, 16(x31)
    sll x20, x15, x2
    sub x20, x25, x19
    sw x12, 28(x31)
    sltu x30, x7, x5
    lb x1, 28(x31)
    divu x8, x4, x12
    slti x22, x21, 559
    sub x21, x22, x4
    sub x21, x16, x15
    sw x23, 8(x31)
    li x30, 1766942441
    li x29, 590339979
    li x7, -253889947
    li x15, -960324343
    sh x3, 16(x31)
    srli x12, x2, 17
    slli x16, x14, 23
    sw x8, 12(x31)
    sh x24, 20(x31)
    slt x2, x24, x25
    sb x11, 4(x31)
    sh x4, 8(x31)
    sb x21, 8(x31)
    slli x17, x1, 9
    slli x24, x5, 24
    xori x23, x19, -1018
    sw x25, 12(x31)
    lbu x1, 24(x31)
    li x11, 112949166
    or x13, x28, x17
    li x22, 1043156913
    srai x22, x6, 10
    sb x13, 0(x31)
    sub x16, x25, x2
    sw x18, 20(x31)
    srl x2, x18, x8
    addi x25, x19, 356
    mul x3, x24, x19
    addi x29, x22, -1065
    sw x2, 0(x31)
    sh x21, 16(x31)
    mulhsu x8, x7, x27
    srai x19, x1, 21
    add x19, x20, x21
    slli x12, x23, 14
done: j done
    .section .data
    .align 4
scratch: .space 64
