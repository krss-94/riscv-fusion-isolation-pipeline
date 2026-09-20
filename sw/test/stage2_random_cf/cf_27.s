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
    mul x6, x16, x12
    sra x17, x8, x6
    addi x18, x3, 1172
    sltiu x11, x21, -1373
    ori x10, x15, -1087
    bne x30, x10, blk10
blk1:
    mulh x29, x25, x16
    slti x1, x19, 378
    add x23, x20, x28
    remu x18, x14, x14
    andi x24, x1, -1929
    jal x30, blk5
blk2:
    divu x13, x7, x27
    xor x27, x13, x27
    sltu x2, x6, x3
    remu x8, x5, x15
    sltiu x4, x8, -1800
    jal x30, blk10
blk3:
    srl x10, x18, x15
    or x26, x10, x22
    divu x27, x26, x5
    sub x19, x23, x2
    mulh x16, x20, x20
blk4:
    sub x11, x10, x2
    slti x13, x29, -689
    mul x25, x18, x24
    and x6, x15, x30
    ori x20, x17, -1633
    la x29, blk6
    jalr x30, x29, 0
blk5:
    or x30, x18, x7
    sltiu x20, x18, 652
    andi x21, x17, -486
    or x6, x1, x12
    xori x7, x24, 721
    jal x30, blk6
blk6:
    mul x20, x3, x19
    add x23, x26, x21
    mulh x27, x20, x16
    mulhu x15, x4, x22
    andi x10, x22, 668
    la x29, blk10
    jalr x30, x29, 0
blk7:
    sltiu x20, x30, 914
    slti x24, x16, -236
    mulhsu x17, x24, x20
    sltu x8, x24, x12
    srl x23, x10, x21
    la x29, blk9
    jalr x30, x29, 0
blk8:
    sub x14, x9, x1
    add x17, x15, x18
    addi x15, x28, -1141
    ori x5, x25, 1499
    ori x20, x30, -1714
    bgeu x25, x15, blk9
blk9:
    or x4, x3, x25
    mulhu x29, x11, x22
    slt x4, x24, x25
    xori x1, x27, 732
    mulh x24, x1, x14
    la x29, blk10
    jalr x30, x29, 0
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
