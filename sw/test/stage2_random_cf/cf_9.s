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
    sltu x18, x22, x20
    srl x24, x19, x2
    mul x29, x8, x6
    mulh x24, x12, x28
    divu x28, x12, x4
    jal x30, blk8
blk1:
    mul x13, x7, x19
    addi x13, x26, 1503
    sltiu x4, x7, 612
    div x27, x3, x10
    add x4, x17, x26
blk2:
    and x16, x12, x23
    mulhsu x24, x3, x14
    divu x4, x25, x13
    sltu x28, x18, x12
    addi x6, x23, -1635
    la x29, blk5
    jalr x30, x29, 0
blk3:
    add x6, x4, x20
    srl x2, x2, x15
    sltiu x10, x20, -896
    sub x16, x18, x9
    mulh x24, x18, x10
blk4:
    rem x15, x5, x23
    sltu x19, x29, x26
    remu x25, x20, x29
    sltu x12, x4, x30
    mulh x17, x5, x6
    jal x30, blk6
blk5:
    sra x28, x1, x7
    rem x15, x19, x18
    ori x3, x6, 101
    and x18, x3, x21
    div x19, x29, x14
    bltu x29, x21, blk10
blk6:
    mulhsu x18, x10, x3
    sra x24, x5, x4
    mul x15, x2, x16
    slti x22, x20, 1709
    remu x8, x12, x27
    beq x20, x20, blk8
blk7:
    xori x20, x2, -1484
    mulhu x3, x7, x2
    ori x3, x3, 1804
    sub x18, x18, x16
    addi x11, x3, 1751
    jal x30, blk9
blk8:
    sub x13, x16, x27
    sra x29, x12, x22
    sub x25, x5, x7
    sub x4, x2, x4
    sra x12, x4, x24
    la x29, blk9
    jalr x30, x29, 0
blk9:
    add x28, x21, x3
    mulhsu x9, x25, x17
    mul x1, x15, x9
    addi x4, x17, 10
    mulhsu x16, x28, x11
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
