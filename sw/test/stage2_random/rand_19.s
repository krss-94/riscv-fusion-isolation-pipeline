    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 760749655
    li x2, 87901487
    li x3, 49356480
    li x4, -457265134
    li x5, -1026159702
    li x6, -1028914420
    li x7, -811469323
    li x8, -1277529305
    li x9, 182289563
    li x10, 1002748496
    li x11, 1301630790
    li x12, -367487739
    li x13, 979230563
    li x14, -446404606
    li x15, 1433689588
    li x16, 1949550149
    li x17, 993757694
    li x18, 1294822014
    li x19, -471243338
    li x20, -1552443812
    li x21, 542528716
    li x22, 882013872
    li x23, 284867
    li x24, -562333532
    li x25, 1572259418
    li x26, 1677333874
    li x27, -1095716793
    li x28, -2036319755
    li x29, -529948966
    li x30, -1596081680
    srli x15, x13, 10
    mul x10, x10, x22
    srl x7, x10, x22
    or x15, x3, x15
    rem x22, x1, x6
    sb x3, 8(x31)
    mulh x10, x29, x15
    xori x20, x16, -1492
    sw x5, 24(x31)
    sw x21, 0(x31)
    lh x19, 12(x31)
    lbu x11, 16(x31)
    sra x7, x10, x17
    li x17, 1303440878
    lw x29, 16(x31)
    srli x21, x17, 27
    sll x28, x28, x8
    sub x15, x28, x30
    lhu x19, 16(x31)
    sh x22, 20(x31)
    andi x15, x28, 669
    or x21, x22, x22
    divu x14, x20, x2
    sra x11, x14, x12
    lh x24, 16(x31)
    slli x3, x8, 2
    andi x16, x22, -1173
    lw x17, 0(x31)
    mulhu x2, x23, x22
    lh x11, 0(x31)
    ori x5, x8, -1053
    li x15, 836668305
    srli x18, x13, 14
    sh x4, 12(x31)
    ori x12, x15, -238
    remu x29, x10, x2
    sra x7, x20, x3
    sltiu x13, x17, 1956
    mul x2, x17, x14
    lb x8, 12(x31)
    li x13, 146627720
    addi x15, x6, 1863
    srai x25, x13, 4
    sh x24, 4(x31)
    sltiu x16, x6, 1203
    mulhu x14, x26, x1
    add x6, x14, x26
    slli x20, x26, 21
    slli x6, x25, 19
    sub x3, x2, x22
    lhu x15, 4(x31)
    sh x10, 20(x31)
    sltiu x4, x20, -1691
    sltiu x4, x21, 1956
    srai x23, x21, 6
    sw x19, 0(x31)
    sltiu x9, x25, 1116
    sub x7, x18, x16
    slt x24, x26, x16
    sb x29, 8(x31)
done: j done
    .section .data
    .align 4
scratch: .space 64
