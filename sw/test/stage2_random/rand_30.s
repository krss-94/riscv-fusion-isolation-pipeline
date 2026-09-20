    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1042487425
    li x2, -441530102
    li x3, 608073536
    li x4, 2099428162
    li x5, -165214454
    li x6, -1105200157
    li x7, 1792988484
    li x8, 663245278
    li x9, -1857010582
    li x10, -2046508694
    li x11, 738604298
    li x12, 1129626827
    li x13, 281975230
    li x14, 746868006
    li x15, -819505297
    li x16, 1414525666
    li x17, 1619533334
    li x18, -1802415316
    li x19, -796222469
    li x20, 1158073657
    li x21, -854893078
    li x22, -1347036246
    li x23, 624420858
    li x24, 56284997
    li x25, 1926133204
    li x26, 85978544
    li x27, -1854328103
    li x28, 1910589727
    li x29, -61630277
    li x30, 1857724029
    srai x19, x9, 10
    xori x27, x6, 285
    sh x30, 28(x31)
    div x29, x24, x27
    lh x13, 24(x31)
    li x26, 836308869
    srli x10, x17, 10
    lb x30, 12(x31)
    li x11, 1805005410
    li x13, 136129251
    sw x22, 8(x31)
    div x20, x28, x12
    mulhu x27, x17, x5
    li x30, 1782952191
    li x1, -101989839
    sltiu x14, x3, -6
    li x10, 482078816
    srai x11, x1, 28
    sra x12, x16, x25
    lh x24, 12(x31)
    mulhsu x13, x4, x7
    rem x24, x4, x4
    or x6, x6, x23
    srai x1, x29, 10
    srai x17, x18, 12
    srai x5, x19, 12
    lhu x20, 8(x31)
    xor x20, x30, x8
    sh x5, 8(x31)
    rem x7, x10, x1
    sh x1, 24(x31)
    li x23, -1726148340
    sh x15, 4(x31)
    sra x8, x2, x18
    lbu x28, 0(x31)
    sltu x16, x20, x25
    xor x18, x25, x3
    andi x17, x15, 1913
    mulh x14, x3, x7
    addi x1, x20, -2007
    sltu x11, x21, x6
    xor x20, x15, x23
    sw x13, 0(x31)
    li x17, 2068421769
    lb x26, 16(x31)
    mulh x6, x9, x3
    sw x14, 8(x31)
    lb x12, 24(x31)
    sll x20, x27, x20
    remu x1, x12, x6
    sw x25, 8(x31)
    sw x28, 20(x31)
    andi x11, x9, -1878
    sw x5, 20(x31)
    sb x21, 8(x31)
    lb x5, 4(x31)
    slli x18, x2, 14
    lb x2, 24(x31)
    lb x8, 16(x31)
    li x29, -1255176428
done: j done
    .section .data
    .align 4
scratch: .space 64
