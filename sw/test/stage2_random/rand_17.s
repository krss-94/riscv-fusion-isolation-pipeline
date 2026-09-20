    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 94420161
    li x2, 1317226848
    li x3, 1977810007
    li x4, -903552102
    li x5, 693134957
    li x6, -2031791066
    li x7, 1058259313
    li x8, -422663686
    li x9, -1880367624
    li x10, 1611972096
    li x11, -1245497532
    li x12, 171641309
    li x13, 596026272
    li x14, -819481764
    li x15, 1340907052
    li x16, 1803778984
    li x17, -2070885850
    li x18, -624308978
    li x19, 1973559882
    li x20, 1178431337
    li x21, 1579640331
    li x22, -1121215946
    li x23, 244025538
    li x24, 1964484469
    li x25, -602550319
    li x26, -999866845
    li x27, 1230377967
    li x28, -1591345782
    li x29, 681032079
    li x30, 1788979395
    srli x6, x11, 17
    add x2, x25, x12
    mul x24, x9, x16
    sw x10, 4(x31)
    sh x16, 8(x31)
    rem x24, x19, x27
    slti x7, x9, -1144
    xor x27, x18, x10
    li x11, 1829480277
    sltu x23, x25, x10
    sw x16, 4(x31)
    sw x8, 16(x31)
    ori x26, x10, 1939
    rem x27, x16, x8
    lbu x21, 28(x31)
    sltiu x16, x11, -502
    lb x1, 24(x31)
    li x11, 239915745
    lh x11, 12(x31)
    mulh x12, x15, x19
    lw x4, 12(x31)
    sh x25, 28(x31)
    remu x28, x17, x5
    mulhu x1, x10, x9
    xor x27, x29, x15
    li x11, -999991237
    lb x22, 0(x31)
    mulhsu x23, x29, x10
    li x4, 2084312986
    mulhsu x18, x27, x25
    li x21, -1620322908
    slt x24, x18, x2
    lw x9, 20(x31)
    lw x27, 0(x31)
    li x11, 1262782054
    sh x28, 20(x31)
    slt x11, x5, x18
    mulh x27, x10, x15
    srli x8, x3, 26
    sb x16, 8(x31)
    lb x26, 16(x31)
    rem x15, x17, x29
    li x17, 1718108016
    sh x5, 20(x31)
    li x28, -398816329
    lbu x8, 8(x31)
    remu x18, x11, x18
    li x17, -1105517734
    srai x17, x7, 0
    srl x11, x16, x3
    slt x29, x17, x13
    sltiu x3, x30, -1452
    slli x30, x25, 20
    sltiu x24, x9, 1092
    lb x17, 24(x31)
    li x25, -1041744249
    andi x7, x18, 977
    div x13, x9, x3
    divu x30, x21, x7
    and x2, x28, x19
done: j done
    .section .data
    .align 4
scratch: .space 64
