    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -544121104
    li x2, -1552461398
    li x3, -2119845296
    li x4, 11948934
    li x5, -1800387369
    li x6, -519606845
    li x7, 966648405
    li x8, -1472498778
    li x9, -1125229012
    li x10, -1670967639
    li x11, 388387290
    li x12, -896883309
    li x13, 748337932
    li x14, -1246012399
    li x15, -939805772
    li x16, 1329338341
    li x17, 1659574216
    li x18, 1629395451
    li x19, -35597816
    li x20, -2046624244
    li x21, 415948867
    li x22, 338015202
    li x23, -1275376817
    li x24, -1788838407
    li x25, 1807864786
    li x26, -343135987
    li x27, -437507592
    li x28, 342739040
    li x29, 1968494786
    li x30, -1914811500
    lh x22, 8(x31)
    sb x2, 24(x31)
    andi x20, x17, 949
    lh x19, 4(x31)
    xor x28, x29, x19
    mul x7, x13, x7
    mul x26, x20, x11
    remu x4, x7, x8
    srai x11, x27, 19
    slli x4, x17, 3
    rem x25, x18, x26
    mulhsu x12, x23, x25
    lb x24, 12(x31)
    li x13, 259689520
    addi x22, x10, 73
    sll x26, x6, x9
    add x20, x5, x1
    srl x15, x7, x26
    srli x20, x1, 22
    addi x16, x18, -924
    sb x10, 4(x31)
    rem x15, x5, x23
    lw x29, 16(x31)
    lh x16, 0(x31)
    lbu x5, 4(x31)
    li x26, -2091588032
    addi x16, x15, 1132
    ori x18, x16, 101
    and x21, x1, x19
    mulh x18, x10, x17
    sw x18, 4(x31)
    andi x24, x5, -1232
    mul x15, x2, x16
    sh x1, 12(x31)
    slti x12, x27, 2014
    and x20, x20, x3
    and x22, x14, x14
    and x3, x7, x2
    li x6, -2019223230
    lb x16, 28(x31)
    sh x3, 4(x31)
    sll x15, x15, x19
    mulh x16, x27, x5
    slli x22, x8, 8
    addi x4, x4, -1065
    sh x12, 0(x31)
    sb x7, 4(x31)
    slt x9, x25, x17
    add x15, x9, x20
    add x17, x26, x14
    srai x16, x28, 14
    sltu x22, x9, x5
    srl x26, x6, x12
    sub x29, x30, x10
    srl x11, x15, x8
    lhu x11, 20(x31)
    div x7, x3, x9
    remu x15, x20, x30
    rem x13, x6, x11
    xor x11, x3, x6
done: j done
    .section .data
    .align 4
scratch: .space 64
