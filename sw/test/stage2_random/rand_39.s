    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1246179410
    li x2, -492212197
    li x3, -1309705968
    li x4, 269211923
    li x5, 1351583223
    li x6, -1830881528
    li x7, -2110475304
    li x8, -327055768
    li x9, 1083523937
    li x10, 1577596626
    li x11, -859863151
    li x12, 928651474
    li x13, -171056226
    li x14, 515151656
    li x15, 573654490
    li x16, 1292250954
    li x17, 2009213444
    li x18, -639720702
    li x19, -293403990
    li x20, -1406648004
    li x21, 1088935318
    li x22, -1721590655
    li x23, -1768854998
    li x24, -2002015393
    li x25, 711620518
    li x26, -1197575819
    li x27, 179092639
    li x28, 628196754
    li x29, 935874394
    li x30, 1194258983
    srai x29, x29, 17
    li x7, 2077094743
    li x26, -1409946035
    slli x10, x6, 7
    lb x3, 0(x31)
    sw x4, 28(x31)
    mulhsu x27, x12, x9
    addi x11, x6, -1498
    mulh x3, x10, x1
    li x6, -5723869
    srli x27, x5, 13
    li x23, 1914394384
    slli x26, x2, 30
    rem x11, x1, x20
    lbu x29, 16(x31)
    li x29, 20174772
    li x1, 2084269219
    lw x16, 8(x31)
    li x23, 1294825094
    srai x19, x3, 3
    slt x5, x21, x11
    srli x11, x4, 19
    lb x16, 0(x31)
    srai x7, x21, 14
    addi x9, x13, -1915
    lbu x10, 28(x31)
    srli x26, x6, 8
    srai x7, x15, 22
    sltu x24, x16, x19
    srl x28, x1, x29
    rem x12, x28, x28
    slt x16, x15, x29
    mulhu x19, x14, x1
    sw x18, 20(x31)
    sh x3, 20(x31)
    lh x7, 20(x31)
    li x21, -1635150509
    sh x17, 12(x31)
    ori x15, x15, -865
    lhu x13, 4(x31)
    xori x12, x21, 732
    mulh x17, x27, x24
    li x13, 1658031168
    lh x26, 24(x31)
    li x21, -788365961
    sll x7, x10, x3
    slt x29, x6, x18
    li x29, 1870511210
    li x22, 272591078
    lb x10, 8(x31)
    srai x8, x28, 31
    xori x5, x29, -1691
    lh x14, 24(x31)
    div x1, x4, x14
    add x10, x22, x28
    xori x10, x18, 780
    mul x2, x1, x25
    lhu x23, 0(x31)
    lbu x18, 4(x31)
    sw x25, 16(x31)
done: j done
    .section .data
    .align 4
scratch: .space 64
