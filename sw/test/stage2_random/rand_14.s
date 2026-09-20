    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1891299130
    li x2, -1048936187
    li x3, 1005277327
    li x4, 680537650
    li x5, -846160206
    li x6, -443783326
    li x7, -1638961366
    li x8, 1724270823
    li x9, -1029064159
    li x10, -1504511745
    li x11, 704370583
    li x12, -1439036296
    li x13, 651539210
    li x14, -699795223
    li x15, -1790107984
    li x16, 2052992355
    li x17, 461843062
    li x18, 574363288
    li x19, 1609727647
    li x20, -1314952733
    li x21, -1210373758
    li x22, 1280939216
    li x23, 2062125
    li x24, -1707558617
    li x25, -1762932721
    li x26, -942020491
    li x27, -2027235701
    li x28, 1032257771
    li x29, -1748121702
    li x30, 796167253
    lhu x13, 28(x31)
    mulh x14, x20, x27
    srai x16, x13, 28
    remu x3, x19, x5
    sw x19, 0(x31)
    divu x14, x1, x12
    mulhsu x9, x12, x10
    sltu x21, x18, x16
    slt x13, x4, x2
    srai x1, x1, 18
    li x12, -1292617241
    slti x9, x28, 119
    sltiu x7, x20, 671
    sw x29, 0(x31)
    lw x24, 8(x31)
    sh x7, 28(x31)
    xori x13, x18, 527
    lhu x2, 24(x31)
    li x11, 1319201254
    slti x7, x2, -896
    slli x16, x15, 24
    li x4, -322096174
    andi x15, x8, -848
    andi x5, x1, -230
    li x22, 872788848
    lh x14, 28(x31)
    or x28, x12, x2
    li x4, -1852853012
    li x4, 1852122498
    sltu x1, x26, x22
    and x5, x13, x29
    xori x1, x29, 1791
    sh x1, 4(x31)
    ori x10, x22, -2044
    li x8, 1839543141
    srl x28, x4, x13
    divu x10, x12, x24
    and x9, x5, x10
    li x25, 2009585785
    lb x19, 28(x31)
    sw x15, 24(x31)
    rem x9, x22, x25
    slti x26, x1, 1851
    mulhsu x27, x17, x4
    li x8, -1825471371
    li x3, -1931669123
    xori x22, x26, 270
    mulh x8, x29, x24
    sw x23, 8(x31)
    slli x15, x23, 24
    lh x12, 20(x31)
    mul x18, x27, x10
    sltiu x20, x21, -958
    mul x29, x10, x18
    xori x2, x17, 464
    slli x21, x10, 11
    li x1, 1158863526
    xori x29, x19, 485
    lbu x16, 20(x31)
    srli x8, x28, 22
done: j done
    .section .data
    .align 4
scratch: .space 64
