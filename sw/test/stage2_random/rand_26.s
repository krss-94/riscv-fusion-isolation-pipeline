    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1266333950
    li x2, -1903712941
    li x3, 1135637217
    li x4, 11757332
    li x5, 581726284
    li x6, 1948766907
    li x7, 1478084879
    li x8, -1192791013
    li x9, -1591666061
    li x10, 418578386
    li x11, 1961399074
    li x12, -582918362
    li x13, -2015238744
    li x14, -2114456118
    li x15, 262522399
    li x16, 1356976144
    li x17, -328766475
    li x18, -1285348019
    li x19, -1071407693
    li x20, 78684101
    li x21, -1894437775
    li x22, -1825829795
    li x23, -1955289138
    li x24, -400500964
    li x25, 187638363
    li x26, -1700011677
    li x27, 1218654826
    li x28, 1899307744
    li x29, 886804084
    li x30, 350218100
    slt x12, x4, x22
    li x3, 1972736739
    srli x29, x30, 27
    lb x16, 0(x31)
    ori x19, x1, -1135
    li x23, 352252117
    li x20, -302272641
    slli x14, x6, 18
    add x3, x20, x28
    srl x28, x22, x30
    lh x1, 28(x31)
    sb x18, 24(x31)
    slt x4, x7, x15
    srli x8, x5, 24
    lw x26, 4(x31)
    sb x24, 0(x31)
    slti x13, x8, -1497
    srai x11, x14, 13
    mulh x8, x1, x17
    sub x1, x7, x7
    ori x18, x24, -1739
    sw x18, 8(x31)
    or x2, x13, x16
    slt x14, x24, x24
    srli x6, x8, 0
    srai x14, x7, 28
    sw x11, 16(x31)
    slli x27, x19, 30
    li x9, -826165626
    lw x10, 16(x31)
    sw x23, 0(x31)
    sh x25, 28(x31)
    or x27, x1, x25
    add x27, x1, x28
    sb x22, 4(x31)
    mulh x22, x21, x23
    li x23, -1639354237
    mulhsu x16, x25, x21
    li x14, 1337427830
    sb x12, 28(x31)
    srai x5, x23, 19
    slti x30, x24, 830
    li x16, -140652232
    remu x16, x10, x8
    sb x16, 8(x31)
    slli x3, x20, 12
    slt x9, x25, x22
    lh x15, 8(x31)
    lw x14, 24(x31)
    andi x9, x7, -1225
    lh x25, 24(x31)
    mul x21, x3, x15
    srai x5, x20, 23
    divu x17, x12, x19
    li x21, 1538203692
    slli x6, x24, 23
    lhu x5, 20(x31)
    lbu x3, 0(x31)
    lhu x23, 28(x31)
    xori x26, x5, -1185
done: j done
    .section .data
    .align 4
scratch: .space 64
