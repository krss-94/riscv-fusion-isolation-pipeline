    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -636315487
    li x2, -672292332
    li x3, 53448145
    li x4, -1707439122
    li x5, 200522475
    li x6, 1712568201
    li x7, 290203250
    li x8, -1159439504
    li x9, -605237725
    li x10, 1966079745
    li x11, 805741695
    li x12, 433686925
    li x13, 1124844734
    li x14, -1995961798
    li x15, -713273534
    li x16, -1061567647
    li x17, 1636862255
    li x18, 1484450596
    li x19, -1208801752
    li x20, 1048740742
    li x21, 1172846865
    li x22, 449490531
    li x23, -1023964507
    li x24, -1975213360
    li x25, 1201149141
    li x26, 1286835081
    li x27, 456747621
    li x28, -1258054824
    li x29, -62711700
    li x30, 249293012
    mulh x1, x6, x18
    and x9, x17, x27
    lh x16, 24(x31)
    li x2, 1758766113
    sw x26, 0(x31)
    slti x7, x12, -541
    mulh x30, x7, x5
    ori x24, x26, 770
    mul x4, x9, x15
    sb x14, 20(x31)
    slli x2, x5, 31
    li x25, 121439705
    lbu x19, 4(x31)
    li x5, 1576638227
    lb x8, 24(x31)
    or x3, x10, x2
    srai x8, x20, 9
    lw x25, 4(x31)
    mulh x11, x18, x2
    div x14, x12, x30
    lb x28, 8(x31)
    lb x4, 28(x31)
    mulh x26, x19, x17
    li x26, 879422219
    lh x4, 20(x31)
    andi x15, x1, -1244
    mul x15, x9, x21
    lb x7, 16(x31)
    li x9, -499490129
    sw x4, 28(x31)
    sh x12, 16(x31)
    li x22, 569159537
    srl x17, x26, x10
    slli x18, x27, 6
    li x20, -599022171
    srai x19, x28, 25
    li x9, -903120925
    div x28, x22, x27
    divu x30, x25, x15
    li x22, 344828077
    sra x1, x14, x28
    lh x15, 16(x31)
    sll x10, x4, x30
    mulhsu x11, x16, x14
    lw x19, 20(x31)
    srl x30, x20, x22
    li x30, 1793114596
    lb x18, 24(x31)
    xori x20, x30, -1410
    mulhu x2, x8, x15
    lb x13, 8(x31)
    lhu x13, 28(x31)
    sb x24, 24(x31)
    or x26, x14, x14
    sra x28, x20, x6
    mulh x15, x20, x27
    rem x17, x17, x11
    sb x7, 24(x31)
    sltiu x23, x16, -1190
    mul x26, x3, x12
done: j done
    .section .data
    .align 4
scratch: .space 64
