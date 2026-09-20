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
    mulhsu x16, x3, x18
    mulh x19, x20, x11
    divu x6, x22, x6
    ori x27, x30, 463
    sll x8, x4, x6
    la x29, blk7
    jalr x30, x29, 0
blk1:
    mulhsu x6, x22, x2
    mul x14, x30, x6
    rem x29, x12, x16
    sll x22, x8, x30
    andi x18, x3, 1910
    la x29, blk2
    jalr x30, x29, 0
blk2:
    div x2, x28, x9
    srl x2, x14, x8
    mulhu x3, x28, x11
    addi x5, x24, 18
    remu x5, x21, x17
    jal x30, blk3
blk3:
    xor x29, x27, x12
    ori x20, x25, 1858
    div x10, x5, x18
    srl x5, x25, x24
    sltu x22, x5, x23
    la x29, blk8
    jalr x30, x29, 0
blk4:
    rem x21, x8, x28
    sll x9, x22, x13
    sll x5, x4, x13
    sub x1, x21, x15
    slti x28, x4, 442
    la x29, blk9
    jalr x30, x29, 0
blk5:
    and x13, x16, x29
    slti x6, x6, -1670
    mul x20, x23, x17
    xori x26, x30, -1528
    slt x13, x25, x19
    la x29, blk8
    jalr x30, x29, 0
blk6:
    slti x24, x2, 486
    remu x24, x29, x10
    mul x19, x4, x18
    ori x17, x20, 492
    mulhsu x10, x23, x20
    la x29, blk7
    jalr x30, x29, 0
blk7:
    andi x7, x12, 1394
    mulh x4, x28, x3
    ori x21, x27, -1886
    xori x22, x21, 1141
    add x29, x13, x3
blk8:
    rem x2, x8, x9
    srl x24, x14, x15
    sub x13, x11, x16
    sltiu x2, x16, -280
    div x25, x15, x21
blk9:
    ori x30, x16, 1080
    sll x27, x17, x23
    andi x11, x7, -857
    or x3, x18, x6
    remu x10, x20, x13
    jal x30, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
