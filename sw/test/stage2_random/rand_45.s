    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -979787644
    li x2, -51418461
    li x3, -1795814534
    li x4, -692634370
    li x5, -1836813164
    li x6, -2100082807
    li x7, 536602723
    li x8, -1567615122
    li x9, 1017768196
    li x10, 933303791
    li x11, -394572678
    li x12, 860930881
    li x13, 1816591843
    li x14, -1407842185
    li x15, -1065740350
    li x16, 1987162404
    li x17, -1744810683
    li x18, -1761674118
    li x19, 1078807262
    li x20, 615257104
    li x21, -1890365189
    li x22, 1759268452
    li x23, 1768514500
    li x24, -638474735
    li x25, -2074902799
    li x26, 529884608
    li x27, -885689670
    li x28, -367232513
    li x29, 1440713893
    li x30, -496421582
    lh x20, 16(x31)
    slli x6, x6, 17
    divu x28, x4, x1
    lh x9, 12(x31)
    srli x8, x21, 14
    sltu x5, x1, x20
    li x16, 475344834
    li x3, 441454053
    sra x22, x23, x22
    li x28, -956060973
    li x13, -2018352793
    slli x19, x21, 26
    srli x12, x15, 13
    lw x18, 24(x31)
    sra x28, x28, x21
    sb x19, 0(x31)
    lb x8, 0(x31)
    and x20, x26, x12
    sw x27, 28(x31)
    li x23, 1157026497
    sw x24, 24(x31)
    srl x13, x8, x27
    sltu x3, x12, x23
    srl x27, x18, x5
    srai x8, x1, 20
    ori x22, x3, 1305
    lbu x26, 8(x31)
    sltu x24, x1, x5
    srai x21, x28, 9
    lhu x24, 16(x31)
    ori x1, x7, -1257
    and x27, x16, x2
    remu x18, x11, x11
    sh x17, 16(x31)
    li x1, 1706852096
    andi x16, x18, -114
    and x26, x30, x6
    remu x17, x25, x28
    or x3, x29, x19
    divu x12, x7, x17
    li x30, -377014823
    li x28, 575610797
    sb x14, 24(x31)
    li x9, -2049153779
    and x4, x27, x8
    sh x16, 28(x31)
    ori x12, x2, 358
    addi x29, x6, 417
    srli x30, x16, 11
    lbu x20, 4(x31)
    li x6, -458245373
    sb x30, 16(x31)
    sltiu x27, x30, 1366
    li x25, -245315427
    lbu x17, 24(x31)
    div x4, x9, x4
    sll x10, x9, x3
    sltu x28, x18, x6
    add x30, x2, x3
    rem x8, x25, x15
done: j done
    .section .data
    .align 4
scratch: .space 64
