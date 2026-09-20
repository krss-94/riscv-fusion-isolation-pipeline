    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 94420161
    li x2, 1317226848
    li x3, 1977810007
    li x4, -903552102
    li x5, 693134957
    li x6, -2031791066
    li x7, 1058259313
    li x8, -422663686
    li x9, -1880367624
    li x10, 1611972096
    li x11, -1245497532
    li x12, 171641309
    li x13, 596026272
    li x14, -819481764
    li x15, 1340907052
    li x16, 1803778984
    li x17, -2070885850
    li x18, -624308978
    li x19, 1973559882
    li x20, 1178431337
    li x21, 1579640331
    li x22, -1121215946
    li x23, 244025538
    li x24, 1964484469
    li x25, -602550319
    li x26, -999866845
    li x27, 1230377967
    li x28, -1591345782
    li x29, 681032079
    li x30, 1788979395
    and x11, x6, x11
    addi x19, x26, -1634
    andi x25, x12, 184
    mulhsu x16, x21, x2
    remu x10, x9, x3
    jal x30, blk1
blk1:
    rem x13, x16, x24
    sub x6, x7, x9
    div x30, x7, x2
    sltiu x26, x29, -1643
    sltu x6, x30, x14
blk2:
    or x16, x3, x18
    div x21, x8, x8
    addi x19, x6, 1939
    slti x19, x13, 1293
    sra x17, x21, x15
    jal x30, blk6
blk3:
    xor x16, x11, x27
    rem x20, x1, x24
    ori x2, x29, -663
    divu x30, x18, x8
    sltu x12, x6, x25
    la x29, blk7
    jalr x30, x29, 0
blk4:
    mulh x15, x19, x3
    mulhu x17, x1, x7
    mulhu x15, x15, x15
    addi x18, x18, 362
    sltiu x9, x6, 645
    bltu x9, x4, blk6
blk5:
    sub x22, x23, x1
    ori x16, x23, -377
    sra x25, x4, x25
    add x18, x27, x25
    srl x28, x13, x26
    blt x7, x18, blk6
blk6:
    rem x9, x12, x12
    divu x13, x30, x1
    sltu x3, x25, x24
    slti x11, x11, -56
    xori x30, x16, -1027
    jal x30, blk9
blk7:
    andi x3, x22, -408
    or x16, x12, x5
    addi x26, x19, 1522
    ori x15, x17, -786
    and x22, x18, x5
    la x29, blk10
    jalr x30, x29, 0
blk8:
    xori x16, x26, -1509
    mulhu x20, x8, x6
    divu x25, x8, x14
    mulhu x18, x25, x15
    ori x10, x8, -484
    blt x21, x4, blk10
blk9:
    or x16, x3, x14
    sltu x13, x8, x6
    sltiu x3, x10, -832
    xori x5, x24, 618
    mulhu x30, x19, x17
    bgeu x27, x25, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
