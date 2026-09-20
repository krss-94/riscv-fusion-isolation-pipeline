    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 206669761
    li x2, -907967073
    li x3, -670812570
    li x4, -362950793
    li x5, 2035208040
    li x6, -646106684
    li x7, 2142072459
    li x8, 989790753
    li x9, -1415467504
    li x10, 746659503
    li x11, -865971008
    li x12, 1228846564
    li x13, 67447445
    li x14, 1083718509
    li x15, 1102687951
    li x16, 623458907
    li x17, -1550002817
    li x18, -438687685
    li x19, 667208129
    li x20, -143504298
    li x21, 684509902
    li x22, -951937928
    li x23, -2053524869
    li x24, 1820016310
    li x25, -1563795238
    li x26, -1499912464
    li x27, 1786488527
    li x28, 1587652541
    li x29, 964243961
    li x30, -825267343
    add x21, x17, x29
    sll x17, x25, x1
    addi x23, x15, -159
    sra x24, x7, x9
    sll x5, x7, x4
    li x2, -1188214985
    sltiu x21, x28, -53
    ori x29, x27, -2040
    sltu x26, x23, x19
    srli x8, x22, 3
    mulhu x10, x19, x29
    slli x14, x22, 27
    mul x14, x16, x26
    sb x13, 8(x31)
    srli x20, x16, 5
    slti x16, x30, 1580
    lbu x8, 28(x31)
    li x21, -687975082
    andi x2, x21, -1615
    lb x30, 16(x31)
    xor x30, x10, x8
    andi x4, x7, -700
    sltiu x4, x26, 556
    slt x5, x12, x7
    div x8, x30, x21
    srli x18, x11, 25
    srai x7, x22, 10
    lb x3, 4(x31)
    li x29, -1596287074
    srai x29, x27, 23
    srai x24, x3, 6
    li x27, 1042578565
    srli x4, x21, 23
    li x4, 160977234
    ori x30, x17, -615
    slt x15, x8, x11
    li x14, -1235844260
    mul x13, x18, x17
    sltiu x27, x8, 873
    lh x10, 12(x31)
    lbu x24, 12(x31)
    andi x8, x21, 1830
    srli x25, x2, 6
    li x5, -691237375
    lb x19, 12(x31)
    sb x2, 16(x31)
    slti x13, x26, 546
    lbu x15, 20(x31)
    sll x2, x17, x13
    rem x1, x3, x17
    sb x25, 20(x31)
    sltu x24, x9, x24
    sh x21, 4(x31)
    sw x3, 0(x31)
    srli x18, x18, 8
    sw x7, 20(x31)
    li x8, -761338898
    slli x20, x8, 13
    mulh x6, x12, x9
    slli x19, x24, 1
done: j done
    .section .data
    .align 4
scratch: .space 64
