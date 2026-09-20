    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1368956985
    li x2, 693338914
    li x3, -710560667
    li x4, -25620853
    li x5, -86876270
    li x6, -1011334632
    li x7, 824118758
    li x8, 1233403818
    li x9, -1140065261
    li x10, -1127872446
    li x11, 1008568695
    li x12, 1442191700
    li x13, -863505558
    li x14, -2118866580
    li x15, 2043028570
    li x16, 975405388
    li x17, 162767625
    li x18, 114829292
    li x19, 1398136147
    li x20, -1654291680
    li x21, -1523844539
    li x22, -1459166420
    li x23, -270636944
    li x24, 878749930
    li x25, 379587218
    li x26, 192684667
    li x27, -1766585095
    li x28, -1512207077
    li x29, -1493837984
    li x30, -1808858254
    sw x18, 12(x31)
    mul x26, x19, x27
    xori x25, x23, -1334
    rem x27, x13, x6
    rem x5, x9, x23
    sh x12, 20(x31)
    sh x20, 8(x31)
    sb x28, 24(x31)
    li x6, 1678928206
    sra x17, x18, x18
    lhu x4, 16(x31)
    sh x16, 28(x31)
    li x29, 1254778053
    sltiu x6, x28, -608
    sb x10, 0(x31)
    srai x25, x18, 11
    slti x30, x7, -1423
    li x19, -1156861809
    srli x4, x19, 4
    srai x3, x20, 22
    andi x13, x23, 1305
    lb x23, 24(x31)
    lbu x9, 4(x31)
    slli x6, x12, 28
    sltu x25, x27, x11
    li x27, 312237388
    sltiu x23, x3, 1782
    sltiu x25, x24, -243
    li x18, -823828405
    li x1, 1433683300
    sw x1, 24(x31)
    li x12, 332172385
    srai x7, x8, 8
    sw x1, 12(x31)
    sw x9, 24(x31)
    sb x6, 24(x31)
    div x20, x8, x20
    divu x2, x17, x20
    lh x2, 16(x31)
    sw x20, 12(x31)
    sb x17, 12(x31)
    xori x10, x27, -505
    sll x27, x18, x28
    slt x15, x18, x21
    remu x3, x24, x23
    remu x7, x7, x25
    slli x21, x9, 19
    andi x13, x27, 651
    sh x18, 16(x31)
    ori x2, x22, -1530
    sltiu x13, x3, 1989
    srli x7, x16, 4
    sltiu x11, x11, 1483
    slti x2, x30, -331
    addi x20, x5, -389
    lbu x2, 20(x31)
    sll x8, x22, x26
    srai x10, x23, 20
    srli x28, x17, 21
    srli x12, x8, 23
done: j done
    .section .data
    .align 4
scratch: .space 64
