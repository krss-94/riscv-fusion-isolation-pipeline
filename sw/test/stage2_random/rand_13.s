    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1035050629
    li x2, 1005123725
    li x3, -1588222948
    li x4, -881942512
    li x5, -293860246
    li x6, -1517367605
    li x7, 1314461158
    li x8, 1401728461
    li x9, 1051193913
    li x10, 1929829377
    li x11, -1044931275
    li x12, 1502976610
    li x13, -1643426075
    li x14, 2085984805
    li x15, 820006544
    li x16, -1568291153
    li x17, -1388847487
    li x18, -1277208876
    li x19, 97466987
    li x20, -1059517922
    li x21, -174122173
    li x22, 453113804
    li x23, -573636195
    li x24, -1832766565
    li x25, 1948480806
    li x26, -473783153
    li x27, 940090999
    li x28, -1961904356
    li x29, -1538691101
    li x30, 1452323356
    sw x6, 24(x31)
    li x9, 1302114362
    ori x23, x28, 1022
    sw x5, 12(x31)
    mul x7, x28, x20
    lw x23, 20(x31)
    sb x11, 16(x31)
    slti x26, x22, -1129
    xori x3, x14, -1730
    li x11, 114184637
    sltiu x10, x4, 421
    lw x20, 28(x31)
    srli x28, x27, 0
    slli x5, x16, 30
    sh x10, 0(x31)
    lh x23, 8(x31)
    mulhsu x22, x27, x28
    slli x14, x19, 22
    lhu x10, 20(x31)
    sub x11, x13, x15
    add x25, x2, x20
    sh x10, 28(x31)
    lw x13, 16(x31)
    mul x5, x5, x28
    slt x12, x27, x6
    slli x10, x20, 18
    srli x5, x4, 31
    lh x29, 0(x31)
    lh x10, 0(x31)
    addi x29, x29, -1019
    addi x30, x28, -822
    divu x30, x12, x3
    srai x26, x27, 3
    ori x22, x27, -93
    li x30, -1924376405
    lw x5, 20(x31)
    div x10, x5, x18
    slli x3, x12, 1
    sb x4, 16(x31)
    srai x26, x21, 10
    li x22, 1125310528
    srl x4, x10, x13
    mulhu x13, x9, x5
    mul x10, x1, x17
    lbu x9, 12(x31)
    li x28, 1292494965
    remu x9, x5, x15
    slti x25, x13, 1852
    sra x19, x29, x2
    li x17, -1705626912
    lw x5, 28(x31)
    lhu x24, 12(x31)
    sll x18, x1, x25
    srai x27, x20, 3
    lbu x14, 16(x31)
    mulhsu x1, x20, x4
    srli x17, x17, 28
    sb x20, 24(x31)
    lbu x24, 20(x31)
    mulhu x27, x12, x27
done: j done
    .section .data
    .align 4
scratch: .space 64
