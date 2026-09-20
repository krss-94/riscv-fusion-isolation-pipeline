    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1998199804
    li x2, 1013576293
    li x3, 2088812051
    li x4, -2074981764
    li x5, 778895189
    li x6, 2146694380
    li x7, -1117914766
    li x8, -695450730
    li x9, 894187856
    li x10, -942394472
    li x11, -1016557507
    li x12, 1536898626
    li x13, 1608605304
    li x14, 1278250944
    li x15, -1188025712
    li x16, 48833561
    li x17, -344132852
    li x18, -1808356070
    li x19, -601448105
    li x20, 298997184
    li x21, 625223744
    li x22, 2126751478
    li x23, -2066952797
    li x24, 940951493
    li x25, -21538937
    li x26, -1648314924
    li x27, -1943832750
    li x28, 236182330
    li x29, 8832838
    li x30, -627918163
    xori x10, x10, 559
    mulh x11, x28, x15
    li x30, -977330676
    xori x4, x22, 1145
    sub x27, x9, x30
    srli x3, x2, 3
    xori x27, x16, 1892
    sub x17, x2, x16
    lh x15, 28(x31)
    sh x20, 0(x31)
    li x21, -285084657
    sltu x20, x30, x23
    lhu x15, 0(x31)
    li x29, 1780798133
    lbu x13, 0(x31)
    srli x8, x16, 21
    sltiu x22, x19, 1981
    slt x20, x12, x23
    srai x30, x2, 11
    li x17, -433250372
    li x29, -705920288
    srai x11, x15, 30
    and x13, x30, x26
    sll x4, x26, x28
    sw x15, 8(x31)
    sltiu x19, x18, 591
    mulh x8, x18, x21
    lh x24, 8(x31)
    rem x28, x20, x19
    sltu x9, x11, x5
    slli x6, x2, 13
    sub x21, x9, x7
    li x29, 151655310
    sltiu x11, x6, -1592
    mulhu x8, x14, x24
    srli x25, x19, 11
    mulhu x30, x15, x15
    remu x3, x14, x9
    sh x22, 28(x31)
    mul x29, x21, x6
    sh x1, 28(x31)
    sra x11, x15, x29
    lhu x26, 28(x31)
    mulh x23, x21, x17
    sltiu x22, x11, 1880
    sb x15, 4(x31)
    li x8, -723794321
    li x28, 1577193738
    mulhsu x4, x10, x29
    slli x6, x19, 18
    mulhu x22, x17, x8
    mulhsu x17, x4, x21
    li x7, 624284605
    sb x22, 28(x31)
    srli x26, x13, 21
    srli x22, x11, 8
    slti x22, x24, -1452
    sb x23, 16(x31)
    slti x16, x9, -533
    li x26, -553900185
done: j done
    .section .data
    .align 4
scratch: .space 64
