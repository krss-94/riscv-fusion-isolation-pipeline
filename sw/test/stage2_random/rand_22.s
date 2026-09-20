    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1544605122
    li x2, 2141602361
    li x3, 1673108568
    li x4, -1152161526
    li x5, 1973473326
    li x6, 434402832
    li x7, 1820418307
    li x8, 1637960475
    li x9, 384639318
    li x10, -813118041
    li x11, -1330869418
    li x12, 1502415980
    li x13, 284811817
    li x14, 852058413
    li x15, 482430580
    li x16, -1037617245
    li x17, 1961584672
    li x18, -1536638833
    li x19, 1396834857
    li x20, -1352792862
    li x21, -1936492912
    li x22, -2008909401
    li x23, 1825708550
    li x24, 26971060
    li x25, -388943110
    li x26, 1788697370
    li x27, -542117342
    li x28, 354737960
    li x29, 121292948
    li x30, -1769056412
    rem x12, x4, x14
    or x30, x27, x7
    slti x13, x1, 1711
    slti x1, x18, 812
    srli x30, x12, 12
    slt x3, x18, x5
    sh x4, 12(x31)
    and x27, x5, x30
    remu x2, x28, x4
    sw x5, 16(x31)
    sw x16, 4(x31)
    sb x26, 16(x31)
    sub x6, x17, x12
    srai x4, x6, 27
    srli x6, x2, 12
    sh x7, 16(x31)
    li x3, -1255361545
    slli x4, x24, 11
    slti x13, x27, -1778
    addi x25, x16, 1084
    li x23, -152635840
    addi x29, x8, 133
    sb x6, 20(x31)
    sltu x16, x6, x20
    add x28, x16, x23
    srai x25, x25, 13
    li x15, -1145382779
    lh x14, 20(x31)
    li x27, 871448410
    lh x21, 20(x31)
    li x28, -1338537258
    srai x17, x6, 31
    mulhsu x27, x5, x18
    mulh x13, x11, x28
    mulhsu x22, x21, x17
    sh x3, 24(x31)
    slti x2, x17, -796
    lw x12, 0(x31)
    srai x25, x25, 7
    sb x26, 4(x31)
    lw x3, 16(x31)
    srai x11, x30, 26
    lh x17, 20(x31)
    sw x24, 12(x31)
    sb x22, 0(x31)
    sltiu x2, x4, 529
    sub x30, x11, x4
    mulhu x27, x11, x30
    sltiu x16, x10, 1180
    ori x27, x13, -125
    addi x29, x20, 1021
    mulhsu x9, x17, x18
    sltu x5, x27, x8
    lbu x5, 16(x31)
    li x5, -82757538
    li x6, -688708875
    remu x5, x30, x22
    rem x21, x18, x2
    sh x26, 28(x31)
    addi x10, x23, -1377
done: j done
    .section .data
    .align 4
scratch: .space 64
