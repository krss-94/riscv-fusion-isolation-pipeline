    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, -1904597345
    li x2, -1782961187
    li x3, 1440956708
    li x4, -824047624
    li x5, 455026734
    li x6, 458709969
    li x7, 1930138874
    li x8, -2029608891
    li x9, -515331985
    li x10, 110607312
    li x11, 259890040
    li x12, -1133341320
    li x13, -2045013968
    li x14, -751005387
    li x15, 43911088
    li x16, 1690376882
    li x17, 1274574148
    li x18, 1129084575
    li x19, -627980133
    li x20, 1983849424
    li x21, 1090939186
    li x22, 130376819
    li x23, -42889869
    li x24, 1824639843
    li x25, 1644332189
    li x26, -167451468
    li x27, 961097509
    li x28, 1766854345
    li x29, -817920137
    li x30, 377719670
    ori x10, x24, 955
    xor x30, x22, x20
    sub x24, x1, x30
    sltu x2, x19, x21
    or x19, x8, x22
    la x29, blk3
    jalr x30, x29, 0
blk1:
    srl x8, x27, x7
    add x29, x23, x25
    add x12, x12, x6
    add x3, x4, x3
    sltiu x24, x30, -1002
    jal x30, blk4
blk2:
    ori x17, x23, -1695
    add x26, x8, x5
    mulh x12, x20, x21
    sltu x10, x11, x16
    mul x15, x18, x25
blk3:
    sra x28, x20, x23
    divu x8, x3, x22
    slti x27, x4, 1171
    xor x16, x17, x11
    andi x9, x9, -1901
    jal x30, blk9
blk4:
    sll x22, x2, x9
    andi x6, x6, -151
    slt x17, x30, x23
    sltu x8, x23, x15
    divu x3, x19, x8
blk5:
    sll x9, x17, x25
    sub x2, x13, x14
    sub x17, x24, x3
    sub x4, x1, x6
    remu x7, x1, x17
    la x29, blk9
    jalr x30, x29, 0
blk6:
    slt x18, x21, x13
    ori x24, x26, -1874
    ori x19, x19, -564
    sltiu x30, x4, -1889
    divu x17, x30, x4
    la x29, blk9
    jalr x30, x29, 0
blk7:
    rem x10, x1, x28
    add x4, x4, x10
    andi x26, x15, 1932
    mulh x15, x7, x29
    sltiu x1, x10, -1421
blk8:
    xori x7, x4, 1746
    addi x5, x25, 34
    divu x4, x4, x3
    mulh x21, x13, x7
    addi x1, x20, 2031
    la x29, blk10
    jalr x30, x29, 0
blk9:
    sltiu x15, x5, 1918
    rem x17, x28, x16
    div x30, x16, x27
    ori x13, x8, 77
    mulh x18, x14, x23
    bltu x12, x6, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
