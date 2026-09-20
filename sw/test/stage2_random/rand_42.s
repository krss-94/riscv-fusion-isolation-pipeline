    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 598833565
    li x2, -966241705
    li x3, -1188800802
    li x4, 1015636137
    li x5, -335343207
    li x6, -2019505554
    li x7, -1208440693
    li x8, 193022198
    li x9, -1200698400
    li x10, 383393196
    li x11, 1313483709
    li x12, 851002234
    li x13, -686118794
    li x14, -1479704272
    li x15, -701821063
    li x16, -1749143279
    li x17, -1732089961
    li x18, 1492476947
    li x19, 445499907
    li x20, 1319105919
    li x21, 986690512
    li x22, 155598469
    li x23, -521690861
    li x24, 223512817
    li x25, 1553519297
    li x26, 332224959
    li x27, 878629360
    li x28, -1713685808
    li x29, -953596103
    li x30, -580541375
    srai x12, x7, 17
    sw x3, 8(x31)
    sh x6, 24(x31)
    sb x18, 20(x31)
    xori x27, x2, 536
    slli x3, x7, 20
    sb x13, 28(x31)
    srai x5, x8, 16
    lh x14, 24(x31)
    addi x5, x17, -1304
    li x4, 775160916
    lw x3, 28(x31)
    srai x18, x28, 7
    lb x25, 20(x31)
    srai x14, x6, 0
    sw x17, 8(x31)
    or x28, x21, x10
    lw x7, 8(x31)
    li x30, -755243973
    sltu x4, x30, x12
    addi x2, x8, -1403
    sb x27, 8(x31)
    sw x18, 16(x31)
    li x20, 815475292
    sh x13, 20(x31)
    lb x15, 12(x31)
    srai x1, x19, 14
    slti x1, x3, -1566
    xor x29, x2, x28
    sra x17, x8, x9
    slti x18, x5, 1824
    li x16, -1329679265
    srl x22, x14, x12
    mul x15, x28, x24
    sh x21, 0(x31)
    sb x26, 4(x31)
    xori x7, x18, -900
    xori x9, x15, -1431
    li x28, -1726968859
    sb x27, 4(x31)
    xori x14, x16, -297
    srl x6, x13, x1
    srli x30, x26, 29
    remu x23, x24, x26
    ori x7, x10, -1569
    sb x2, 20(x31)
    or x19, x16, x17
    addi x2, x17, -526
    lhu x3, 12(x31)
    and x29, x19, x8
    lw x2, 24(x31)
    lbu x17, 16(x31)
    sh x11, 16(x31)
    sltiu x22, x21, 1697
    li x30, 2130718029
    sltu x18, x7, x17
    slti x30, x12, -1485
    srai x10, x6, 19
    li x21, 234515030
    sb x29, 16(x31)
done: j done
    .section .data
    .align 4
scratch: .space 64
