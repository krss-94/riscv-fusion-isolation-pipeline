    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 64500649
    li x2, -561653581
    li x3, 785763968
    li x4, 1014177238
    li x5, -241044521
    li x6, 1453256336
    li x7, -1756523514
    li x8, 880265970
    li x9, 268969520
    li x10, -356641884
    li x11, -2109756462
    li x12, 1761895032
    li x13, 343884032
    li x14, -2046633258
    li x15, 1548687704
    li x16, 979367558
    li x17, 940166198
    li x18, 856833215
    li x19, 1787538827
    li x20, 536554131
    li x21, -932832049
    li x22, 932406584
    li x23, -80587240
    li x24, -1232515914
    li x25, -1940095435
    li x26, -218757343
    li x27, -2136582243
    li x28, 638103369
    li x29, -1768681676
    li x30, 643147076
    slli x12, x1, 9
    lw x6, 12(x31)
    srai x16, x1, 11
    srli x5, x7, 10
    lh x17, 0(x31)
    slli x3, x19, 3
    li x6, -788681896
    slti x3, x10, -268
    sh x29, 28(x31)
    li x18, 422655939
    li x28, 1320760598
    sh x10, 0(x31)
    lw x17, 16(x31)
    divu x8, x11, x25
    addi x28, x21, 912
    li x12, 1785243505
    lh x20, 4(x31)
    sb x2, 8(x31)
    sh x11, 4(x31)
    sw x5, 20(x31)
    addi x6, x6, 566
    sltiu x27, x20, -1178
    mulh x8, x4, x1
    srli x18, x1, 10
    sw x26, 4(x31)
    lbu x3, 24(x31)
    lhu x22, 24(x31)
    li x9, -2018128380
    li x18, -1873305010
    slti x16, x15, 988
    li x6, -2112463489
    sb x11, 8(x31)
    sb x28, 28(x31)
    sll x1, x17, x24
    and x17, x21, x8
    slli x24, x30, 15
    rem x26, x10, x12
    remu x27, x29, x20
    sw x20, 4(x31)
    li x23, -1185492614
    mulh x28, x12, x21
    lhu x14, 28(x31)
    li x21, -905652635
    mulhsu x28, x28, x8
    li x14, -1539992032
    add x13, x17, x24
    andi x28, x4, 477
    slt x2, x19, x9
    li x2, 1609059646
    mulhu x12, x2, x21
    sb x21, 24(x31)
    li x11, -667847725
    srai x20, x24, 16
    xori x26, x18, 1870
    li x12, -617764789
    sw x5, 24(x31)
    lbu x29, 4(x31)
    lb x21, 8(x31)
    sltiu x7, x16, -1425
    andi x15, x16, -2037
done: j done
    .section .data
    .align 4
scratch: .space 64
