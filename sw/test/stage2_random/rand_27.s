    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 637790689
    li x2, 864875610
    li x3, 1963001921
    li x4, -1303938719
    li x5, -1866724923
    li x6, -716973269
    li x7, 1352338417
    li x8, -1360066802
    li x9, 1759568439
    li x10, 1454187623
    li x11, 1180321675
    li x12, 1031519239
    li x13, 676578491
    li x14, 2116152840
    li x15, 613098340
    li x16, -1061119073
    li x17, 645594958
    li x18, 104082762
    li x19, 1852105180
    li x20, 130928076
    li x21, -1416556456
    li x22, 891374524
    li x23, 2135870935
    li x24, -2082848986
    li x25, 1201349223
    li x26, -361584838
    li x27, 1356354365
    li x28, -632621914
    li x29, -597287419
    li x30, 1208752872
    ori x16, x12, -1545
    ori x6, x7, 1959
    add x11, x11, x25
    div x11, x21, x4
    srli x26, x18, 5
    mulh x15, x10, x17
    lhu x1, 12(x31)
    lb x18, 4(x31)
    lh x2, 12(x31)
    sw x28, 0(x31)
    mul x14, x24, x15
    ori x29, x28, -1929
    xori x8, x13, 650
    li x29, -1965100639
    slt x28, x3, x10
    addi x15, x20, 1863
    addi x20, x12, 248
    sb x6, 28(x31)
    li x14, 731467479
    lw x27, 20(x31)
    sh x29, 4(x31)
    lbu x20, 4(x31)
    mulhu x11, x10, x2
    xor x13, x29, x3
    slti x6, x25, -1882
    remu x30, x2, x19
    lb x2, 12(x31)
    lh x20, 28(x31)
    srai x21, x17, 25
    ori x6, x1, -77
    xori x24, x11, 1064
    srai x3, x8, 4
    li x24, 566758608
    or x27, x20, x16
    sll x15, x4, x22
    srai x22, x19, 31
    srli x23, x17, 24
    lh x30, 20(x31)
    sb x10, 28(x31)
    lbu x26, 12(x31)
    sw x4, 16(x31)
    xori x25, x13, 134
    srai x1, x27, 7
    mul x18, x2, x25
    div x28, x8, x26
    slt x4, x5, x25
    srai x18, x26, 27
    srai x9, x18, 11
    sub x25, x15, x24
    or x25, x8, x26
    srai x22, x21, 7
    li x1, 140019931
    rem x11, x24, x1
    sh x18, 20(x31)
    sb x4, 8(x31)
    add x18, x10, x16
    srai x23, x19, 31
    andi x11, x15, 251
    sb x19, 16(x31)
    li x14, 151524931
done: j done
    .section .data
    .align 4
scratch: .space 64
