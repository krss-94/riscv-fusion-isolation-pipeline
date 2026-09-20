    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1737813524
    li x2, 1739228534
    li x3, 1598287794
    li x4, -1420010287
    li x5, -380005548
    li x6, 2121018115
    li x7, -1704037703
    li x8, -776791444
    li x9, -217322084
    li x10, -1251327662
    li x11, -706226562
    li x12, -311935752
    li x13, -33871896
    li x14, -1797589913
    li x15, 314434332
    li x16, -1996742527
    li x17, -1741501982
    li x18, -1329990135
    li x19, -929978853
    li x20, 817116718
    li x21, -2047218809
    li x22, 883834323
    li x23, -1127130961
    li x24, -855789081
    li x25, 630817125
    li x26, 595585954
    li x27, -288187932
    li x28, -1440224555
    li x29, 1559805686
    li x30, 815197173
    li x19, -1185310308
    lbu x2, 24(x31)
    addi x27, x3, 356
    li x21, 968401684
    li x22, 1881534945
    lb x11, 4(x31)
    srai x9, x21, 19
    slt x26, x1, x7
    lb x17, 8(x31)
    sh x17, 8(x31)
    li x5, -1678376127
    slt x7, x8, x7
    srl x10, x5, x18
    addi x21, x3, 1944
    xori x7, x27, 502
    li x4, -874101594
    slli x20, x10, 6
    srai x2, x29, 23
    slli x13, x27, 29
    add x19, x16, x7
    sw x17, 20(x31)
    and x6, x9, x10
    li x4, 1928656545
    sh x3, 20(x31)
    mulhu x2, x26, x21
    lhu x13, 24(x31)
    slli x1, x26, 29
    lbu x28, 12(x31)
    slli x15, x29, 24
    lh x2, 4(x31)
    slt x25, x4, x16
    lbu x5, 0(x31)
    sb x12, 8(x31)
    xori x14, x17, -23
    div x23, x18, x27
    lw x20, 16(x31)
    li x25, -28532449
    srli x24, x5, 15
    andi x12, x28, 636
    lh x5, 4(x31)
    sh x17, 20(x31)
    xori x18, x17, 467
    sh x29, 8(x31)
    sub x19, x22, x30
    li x6, -782295396
    sltiu x9, x9, -964
    add x16, x2, x17
    mulh x16, x13, x23
    sw x5, 16(x31)
    lhu x14, 28(x31)
    sb x25, 28(x31)
    slti x7, x7, -1084
    div x13, x15, x3
    sw x4, 12(x31)
    li x28, 2095077104
    lb x10, 28(x31)
    srai x17, x8, 11
    lb x12, 8(x31)
    srai x26, x13, 18
    li x29, 44419708
done: j done
    .section .data
    .align 4
scratch: .space 64
