    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1981904747
    li x2, -160922745
    li x3, 1258216143
    li x4, -283175183
    li x5, -1390761494
    li x6, 1506997741
    li x7, 1375334394
    li x8, -533184608
    li x9, -1736270099
    li x10, -17277605
    li x11, 1169523862
    li x12, 28673259
    li x13, 322805121
    li x14, -528602298
    li x15, -1884585787
    li x16, 1897961579
    li x17, 1456415680
    li x18, -875487052
    li x19, 1669678323
    li x20, 769880109
    li x21, 527197205
    li x22, -724668393
    li x23, 863954772
    li x24, -1431004447
    li x25, 1496193574
    li x26, 1206307185
    li x27, 392595814
    li x28, 448739768
    li x29, -1660855811
    li x30, 1955192971
    sw x2, 24(x31)
    li x3, 622619946
    li x22, -826681943
    sb x14, 0(x31)
    sub x4, x29, x26
    addi x24, x1, 717
    sh x16, 28(x31)
    li x13, -2003992780
    sb x28, 24(x31)
    sw x19, 16(x31)
    lhu x14, 20(x31)
    slli x2, x6, 11
    sh x2, 12(x31)
    xori x12, x7, -275
    li x13, -1884542152
    and x1, x18, x28
    li x17, -663335949
    slti x5, x15, 1155
    addi x1, x4, -250
    lhu x20, 24(x31)
    sub x1, x6, x13
    srai x11, x9, 8
    lbu x5, 12(x31)
    sltu x3, x9, x16
    li x21, -688691962
    srli x8, x1, 13
    sh x10, 28(x31)
    sw x15, 28(x31)
    lbu x14, 4(x31)
    lw x30, 8(x31)
    sw x21, 4(x31)
    sltiu x7, x7, -1554
    addi x16, x15, 386
    srli x15, x15, 17
    sltiu x4, x26, 886
    srli x4, x26, 28
    srli x27, x26, 15
    ori x12, x10, -83
    srli x17, x21, 11
    slti x26, x5, -901
    sh x19, 12(x31)
    mulhu x13, x30, x17
    slli x27, x29, 23
    or x27, x14, x10
    li x9, 77064953
    sra x13, x19, x15
    lb x16, 4(x31)
    sh x16, 4(x31)
    sra x22, x24, x7
    sh x22, 24(x31)
    sltiu x6, x12, -1374
    slli x30, x2, 20
    xor x21, x12, x7
    li x4, -1893941610
    sb x3, 4(x31)
    lb x7, 24(x31)
    sub x4, x10, x1
    lh x28, 12(x31)
    srai x13, x20, 10
    sw x16, 24(x31)
done: j done
    .section .data
    .align 4
scratch: .space 64
