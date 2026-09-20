    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -735725646
    li x2, 2075387982
    li x3, 1245135226
    li x4, 1610898894
    li x5, 545413835
    li x6, -1083866586
    li x7, -290385060
    li x8, 258076727
    li x9, 183717505
    li x10, 327113241
    li x11, 1405919553
    li x12, 2068228164
    li x13, 1314694657
    li x14, 1671876558
    li x15, -463552233
    li x16, 1136689898
    li x17, 103919492
    li x18, -1355213365
    li x19, -1423808129
    li x20, 2082826745
    li x21, 1632570648
    li x22, 1887988140
    li x23, 477823150
    li x24, 31059063
    li x25, -876335635
    li x26, -1138896883
    li x27, -1427917429
    li x28, -541880840
    li x29, 193051657
    li x30, 536052730
    slli x16, x6, 16
    slt x21, x15, x7
    sb x12, 8(x31)
    lh x21, 16(x31)
    srli x1, x18, 3
    srl x16, x24, x3
    sb x10, 24(x31)
    slli x11, x27, 12
    slli x15, x14, 11
    ori x15, x22, 441
    rem x2, x19, x6
    slt x21, x2, x11
    rem x8, x12, x4
    slli x5, x12, 19
    rem x20, x14, x14
    divu x29, x3, x6
    addi x22, x1, 6
    sh x22, 4(x31)
    and x16, x18, x17
    srl x1, x17, x21
    sll x14, x13, x19
    mulhsu x4, x19, x16
    sw x22, 0(x31)
    xori x1, x24, -630
    sw x30, 16(x31)
    sltiu x21, x3, 1281
    li x23, -2089482655
    lh x20, 0(x31)
    slli x5, x28, 12
    li x27, -1783951392
    addi x3, x24, -843
    sltiu x6, x24, 520
    li x11, -2111374117
    mulhu x16, x14, x25
    mul x3, x15, x18
    sb x11, 8(x31)
    mulhsu x15, x24, x28
    sw x26, 20(x31)
    ori x27, x18, -788
    lhu x19, 20(x31)
    sw x4, 24(x31)
    srai x6, x28, 16
    sltu x29, x15, x9
    lh x22, 4(x31)
    sb x30, 4(x31)
    xori x24, x22, 1941
    srli x12, x4, 18
    li x22, -1201037802
    remu x22, x2, x24
    slti x24, x6, 1320
    remu x4, x16, x22
    andi x23, x21, 307
    li x2, -655790548
    srl x26, x19, x7
    slli x25, x25, 7
    srli x3, x27, 30
    slti x16, x1, 142
    sub x8, x17, x20
    lw x6, 24(x31)
    lb x11, 20(x31)
done: j done
    .section .data
    .align 4
scratch: .space 64
