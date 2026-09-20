    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1439031033
    li x2, 815042744
    li x3, 579820343
    li x4, 1256850712
    li x5, 53499151
    li x6, -2133822931
    li x7, 366629129
    li x8, -1849993736
    li x9, -1965654414
    li x10, 1610782485
    li x11, 497744153
    li x12, -565017372
    li x13, 1363692691
    li x14, 1838004918
    li x15, -201315442
    li x16, -674647360
    li x17, -65697356
    li x18, -1987970471
    li x19, -1138741328
    li x20, 1203704746
    li x21, 986800426
    li x22, 1404531983
    li x23, -1283854098
    li x24, 1817490355
    li x25, -388257770
    li x26, -490581113
    li x27, 2125333313
    li x28, -487078151
    li x29, -1746924104
    li x30, -17133614
    mulhsu x3, x18, x20
    lbu x20, 4(x31)
    sh x21, 20(x31)
    li x20, -1091929228
    xori x3, x30, -623
    srli x6, x22, 15
    xori x24, x19, 791
    lbu x13, 12(x31)
    lhu x3, 24(x31)
    sltu x27, x10, x2
    sb x2, 12(x31)
    mulhu x3, x28, x11
    sltiu x24, x24, -1644
    addi x21, x17, 1876
    sltiu x29, x27, -788
    lh x25, 28(x31)
    andi x18, x19, -907
    add x13, x22, x5
    srai x19, x11, 15
    mulhu x9, x22, x13
    slti x5, x4, -1279
    sll x21, x15, x26
    sltu x28, x4, x21
    xori x10, x18, 1198
    xori x20, x6, -542
    ori x23, x24, -1670
    sb x28, 0(x31)
    rem x15, x28, x3
    li x19, 908332321
    slli x23, x20, 2
    div x5, x10, x24
    li x17, 313466767
    lw x20, 20(x31)
    slli x10, x23, 12
    lb x27, 20(x31)
    srai x22, x14, 4
    sra x21, x27, x26
    lhu x20, 28(x31)
    lb x17, 24(x31)
    addi x1, x2, 1506
    andi x9, x23, 1266
    rem x15, x26, x8
    mulh x11, x16, x8
    xor x16, x6, x16
    sw x29, 28(x31)
    sb x20, 16(x31)
    div x30, x16, x13
    lbu x13, 0(x31)
    srai x7, x10, 25
    ori x3, x18, -1397
    slli x20, x13, 29
    sltiu x23, x14, 698
    sb x22, 16(x31)
    sll x11, x17, x9
    sw x7, 16(x31)
    rem x6, x13, x15
    div x15, x20, x22
    sb x22, 16(x31)
    addi x7, x2, 964
    srl x17, x19, x2
done: j done
    .section .data
    .align 4
scratch: .space 64
