    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -2094748989
    li x2, -460260022
    li x3, 789691057
    li x4, 1106351323
    li x5, 1033606238
    li x6, 696500488
    li x7, -1560883353
    li x8, -375508609
    li x9, -1747573256
    li x10, -416844557
    li x11, -1294942797
    li x12, -728815531
    li x13, 1954694792
    li x14, -1215793434
    li x15, 203501846
    li x16, 1948811642
    li x17, 1454631754
    li x18, -620605105
    li x19, -1271921019
    li x20, 2100143908
    li x21, -2017046692
    li x22, 1582075426
    li x23, -1209638678
    li x24, 1273862689
    li x25, 987061916
    li x26, -1315067957
    li x27, -1206098841
    li x28, -1969614281
    li x29, -704331492
    li x30, -445963453
    sw x27, 12(x31)
    sll x26, x25, x10
    lb x20, 16(x31)
    andi x7, x1, 1021
    sltu x22, x13, x10
    sh x29, 4(x31)
    addi x26, x11, 1252
    lb x23, 4(x31)
    xori x7, x11, -804
    or x16, x20, x26
    srai x28, x12, 31
    lbu x2, 28(x31)
    li x24, -2041902887
    divu x25, x26, x16
    xori x1, x4, 266
    ori x2, x5, -1639
    andi x26, x7, 399
    slti x18, x15, 1240
    lh x7, 28(x31)
    sh x15, 8(x31)
    slt x17, x26, x12
    slli x23, x13, 10
    li x22, -322665642
    slti x8, x13, 468
    mulhsu x29, x23, x10
    li x9, -1985139987
    div x20, x27, x29
    slli x18, x7, 23
    rem x2, x27, x15
    sh x8, 20(x31)
    slli x23, x12, 13
    xori x29, x20, 1880
    mulhu x30, x21, x9
    mulhu x2, x3, x16
    slli x26, x16, 0
    srli x13, x9, 18
    slti x19, x10, -138
    lb x5, 20(x31)
    sh x23, 0(x31)
    lw x16, 28(x31)
    li x9, -482569652
    sh x18, 12(x31)
    slt x27, x19, x8
    xor x28, x14, x22
    srli x4, x26, 3
    slti x24, x16, 1454
    li x2, 1283356173
    remu x8, x18, x28
    lhu x5, 28(x31)
    remu x9, x16, x25
    sb x1, 20(x31)
    addi x3, x15, 892
    lw x13, 20(x31)
    mul x7, x14, x8
    sw x27, 0(x31)
    mulhu x15, x25, x13
    li x24, -779040678
    xori x18, x9, -1304
    sltu x5, x28, x19
    li x23, -510747731
done: j done
    .section .data
    .align 4
scratch: .space 64
