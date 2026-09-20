    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 124276532
    li x2, 368279939
    li x3, 1474574846
    li x4, 1712165703
    li x5, 1641478645
    li x6, 1927755037
    li x7, -832434376
    li x8, -1482522420
    li x9, -969676635
    li x10, 474960469
    li x11, 1187032178
    li x12, -1884488887
    li x13, 1455322544
    li x14, 1290487987
    li x15, 1862942145
    li x16, 587077433
    li x17, -893536822
    li x18, -799499063
    li x19, -1262705997
    li x20, 151519393
    li x21, 460659702
    li x22, -326852522
    li x23, 1353722928
    li x24, 1068142444
    li x25, 1338449711
    li x26, -941291537
    li x27, 1748953904
    li x28, 1252638005
    li x29, -678741483
    li x30, 2063235648
    mulhu x28, x15, x12
    mulhu x9, x5, x8
    srai x10, x3, 19
    srl x19, x17, x10
    andi x14, x28, 853
    lb x27, 4(x31)
    sb x11, 20(x31)
    li x6, -679032584
    srai x22, x9, 16
    lb x26, 16(x31)
    lbu x9, 28(x31)
    srli x21, x23, 9
    slti x21, x12, 1039
    sll x15, x11, x20
    li x5, 1081543077
    sb x28, 28(x31)
    remu x27, x15, x20
    sh x6, 4(x31)
    mulhu x17, x10, x29
    li x17, -1211566011
    lw x23, 16(x31)
    lbu x25, 12(x31)
    sh x21, 4(x31)
    sra x29, x4, x25
    div x16, x28, x18
    addi x18, x30, 862
    srli x11, x28, 19
    sb x2, 16(x31)
    mul x17, x15, x2
    and x24, x4, x19
    lhu x13, 16(x31)
    li x20, 1129778775
    div x4, x21, x15
    sh x2, 24(x31)
    li x7, -175522101
    addi x30, x8, -429
    sb x22, 12(x31)
    sb x1, 20(x31)
    slli x17, x10, 28
    lh x28, 28(x31)
    lh x23, 20(x31)
    mulhu x8, x3, x2
    addi x12, x12, 1397
    sb x7, 28(x31)
    li x26, -1576587475
    li x16, 1566841316
    lh x11, 8(x31)
    remu x4, x12, x16
    sh x17, 4(x31)
    li x7, 1942749304
    sh x19, 4(x31)
    lh x10, 0(x31)
    slli x27, x28, 3
    mulhsu x6, x5, x18
    lhu x5, 8(x31)
    sw x11, 12(x31)
    srai x3, x23, 19
    sb x26, 4(x31)
    or x10, x5, x16
    mul x28, x1, x29
done: j done
    .section .data
    .align 4
scratch: .space 64
