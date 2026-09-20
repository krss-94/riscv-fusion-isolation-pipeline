    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -147531839
    li x2, 375314994
    li x3, 51147202
    li x4, 1258326099
    li x5, -1743226477
    li x6, -844385151
    li x7, 2071004980
    li x8, 1996119480
    li x9, 121896630
    li x10, -1891713581
    li x11, -154900306
    li x12, 1470713325
    li x13, 82137440
    li x14, 602548301
    li x15, -974295
    li x16, 697715439
    li x17, -952783076
    li x18, 1461214682
    li x19, 892535548
    li x20, -906066512
    li x21, 1143697776
    li x22, -427779567
    li x23, 1488565340
    li x24, -487420646
    li x25, 1967277085
    li x26, -2145143166
    li x27, 1762104543
    li x28, -128903672
    li x29, -440558901
    li x30, 556004609
    li x22, -1773202157
    slli x1, x14, 7
    xori x23, x4, -1558
    li x16, 254670688
    mulhu x17, x7, x24
    rem x21, x13, x4
    div x7, x1, x9
    and x7, x6, x13
    sb x4, 8(x31)
    divu x9, x1, x25
    li x10, -1828449198
    ori x19, x21, -1921
    srai x12, x20, 8
    rem x27, x19, x5
    ori x21, x5, -178
    andi x24, x7, -438
    mulh x29, x16, x20
    mul x2, x4, x4
    lh x9, 24(x31)
    remu x27, x29, x20
    slli x17, x6, 4
    sltiu x16, x18, -1441
    addi x30, x30, -1913
    slli x14, x15, 3
    addi x10, x12, -971
    srai x5, x29, 21
    sw x17, 8(x31)
    xor x30, x1, x16
    sh x2, 4(x31)
    sll x24, x10, x11
    xor x3, x15, x18
    sh x29, 8(x31)
    srli x3, x22, 4
    li x1, 312705832
    lw x22, 0(x31)
    sub x3, x3, x21
    srli x29, x14, 21
    sh x19, 28(x31)
    li x18, -2019537308
    lb x3, 12(x31)
    remu x25, x20, x22
    slli x29, x1, 19
    sh x7, 8(x31)
    sh x15, 12(x31)
    rem x22, x9, x7
    li x26, -1227547649
    slti x19, x30, -329
    andi x16, x12, -1716
    sub x9, x27, x6
    mulhsu x16, x9, x30
    li x14, 85793331
    sh x23, 28(x31)
    and x27, x2, x9
    and x22, x23, x9
    srai x10, x21, 1
    sltiu x13, x15, -1846
    andi x25, x5, -1664
    or x15, x4, x21
    sw x26, 4(x31)
    slti x7, x27, 49
done: j done
    .section .data
    .align 4
scratch: .space 64
