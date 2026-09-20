    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 527858757
    li x2, 1038467225
    li x3, 1904202612
    li x4, 639840853
    li x5, 1721854523
    li x6, -1661267722
    li x7, -1088461400
    li x8, 187951464
    li x9, 317574981
    li x10, -1216636254
    li x11, -947116003
    li x12, 1141282117
    li x13, 1276236631
    li x14, 504454731
    li x15, -1603314586
    li x16, 1595171242
    li x17, 2071982903
    li x18, 1599479168
    li x19, -904927395
    li x20, 1982032882
    li x21, -1267962325
    li x22, 818800919
    li x23, 1691107634
    li x24, -864195088
    li x25, -596184694
    li x26, -1521698716
    li x27, -1867710720
    li x28, -696227655
    li x29, -816224473
    li x30, 1368024730
    remu x23, x11, x6
    div x23, x6, x2
    srl x24, x12, x28
    xor x18, x26, x14
    remu x19, x27, x1
    slt x23, x6, x20
    sra x25, x8, x30
    srli x17, x12, 16
    xor x19, x24, x25
    li x10, -1755869090
    srli x17, x20, 9
    srli x30, x23, 5
    sw x10, 4(x31)
    slti x24, x23, 1915
    sb x3, 24(x31)
    xori x24, x20, 1
    sh x5, 0(x31)
    srai x27, x7, 8
    li x14, -281083328
    slti x2, x28, 367
    mulhu x30, x20, x28
    lhu x15, 20(x31)
    slli x10, x16, 9
    remu x27, x18, x6
    li x11, -34952348
    lb x26, 20(x31)
    li x26, 704453865
    li x10, -61481503
    li x23, 1511063978
    divu x18, x25, x9
    sh x15, 20(x31)
    srli x21, x12, 26
    li x6, 808901085
    slli x11, x17, 10
    li x12, -97758048
    sb x24, 24(x31)
    lh x25, 24(x31)
    lb x18, 16(x31)
    slti x6, x19, -568
    li x22, 938288602
    mulhu x8, x6, x2
    slt x11, x6, x16
    lhu x2, 20(x31)
    sb x3, 12(x31)
    sh x12, 20(x31)
    srai x28, x14, 7
    li x18, -853055875
    srli x18, x17, 18
    li x5, -560739241
    slti x6, x20, 1859
    xori x20, x3, -2041
    and x11, x19, x30
    lhu x5, 24(x31)
    remu x8, x16, x10
    sw x13, 8(x31)
    lh x9, 28(x31)
    remu x1, x11, x10
    srai x5, x16, 7
    lbu x15, 0(x31)
    li x13, -971574781
done: j done
    .section .data
    .align 4
scratch: .space 64
