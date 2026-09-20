    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1132903364
    li x2, -1051970500
    li x3, -216934237
    li x4, 651086875
    li x5, 1240057366
    li x6, -1744359796
    li x7, 1442100146
    li x8, -234560211
    li x9, 1912423074
    li x10, 1724117817
    li x11, -2016100644
    li x12, 177865246
    li x13, -1146393543
    li x14, -2055186059
    li x15, 611149651
    li x16, 1545958589
    li x17, 731456842
    li x18, -844525795
    li x19, 1642734788
    li x20, 22693829
    li x21, -1999196329
    li x22, 1277341528
    li x23, -1404422504
    li x24, -538146417
    li x25, 36191509
    li x26, 1195901923
    li x27, -458465863
    li x28, -2020460154
    li x29, -1960707156
    li x30, -1415839410
    lw x8, 12(x31)
    li x18, 59148841
    li x19, 1759884385
    sh x20, 0(x31)
    li x28, -1264931184
    and x16, x28, x12
    lh x7, 28(x31)
    divu x12, x1, x18
    mulhsu x20, x1, x26
    sb x18, 8(x31)
    li x18, -1051004095
    li x22, 1580883381
    div x1, x25, x25
    sltiu x9, x4, -536
    srai x3, x6, 16
    xori x22, x9, 364
    sb x16, 4(x31)
    srli x13, x11, 12
    or x9, x29, x24
    slti x20, x14, -1878
    sll x13, x5, x2
    rem x23, x17, x22
    lbu x27, 28(x31)
    lhu x21, 20(x31)
    slt x24, x10, x5
    sub x10, x3, x28
    srli x30, x10, 10
    lw x9, 0(x31)
    li x7, -168137256
    li x28, 38112456
    mulhsu x7, x12, x4
    lhu x22, 12(x31)
    or x22, x13, x10
    rem x1, x11, x20
    srai x1, x6, 20
    li x5, -1232527637
    sw x27, 20(x31)
    lb x16, 12(x31)
    sb x3, 8(x31)
    lw x7, 20(x31)
    lh x27, 20(x31)
    and x10, x8, x28
    li x23, -1699625937
    sll x14, x3, x13
    li x5, -523815788
    lh x18, 4(x31)
    srli x29, x10, 7
    slli x4, x26, 18
    lb x22, 24(x31)
    li x29, -1340364408
    li x19, -1651165029
    xori x22, x8, -1206
    div x26, x18, x30
    lb x9, 20(x31)
    addi x21, x11, -1825
    li x30, 414767775
    mulh x13, x11, x13
    sra x30, x11, x20
    and x9, x7, x26
    li x29, 808269060
done: j done
    .section .data
    .align 4
scratch: .space 64
