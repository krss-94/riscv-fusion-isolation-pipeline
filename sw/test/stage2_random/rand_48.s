    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 206836289
    li x2, 1125217044
    li x3, -1436058613
    li x4, -1685690633
    li x5, 641309301
    li x6, -1482126285
    li x7, -1215026922
    li x8, -1832583395
    li x9, -1874731082
    li x10, -1594128517
    li x11, -696853348
    li x12, 1467256414
    li x13, -979617052
    li x14, 635899422
    li x15, -1553987290
    li x16, 656235898
    li x17, -1393216248
    li x18, -956684856
    li x19, -574029931
    li x20, -1653128102
    li x21, -730293556
    li x22, -298992448
    li x23, 1175981449
    li x24, 1209384851
    li x25, -333701790
    li x26, 1659720776
    li x27, -406001499
    li x28, -1036154525
    li x29, 1143205137
    li x30, -1319546913
    lbu x30, 8(x31)
    ori x6, x9, 1513
    lb x18, 24(x31)
    mulh x17, x10, x2
    xor x1, x24, x1
    srai x29, x3, 28
    li x27, 1835681080
    lb x3, 12(x31)
    li x29, 894391422
    li x8, 164311998
    xor x9, x20, x1
    mulhsu x22, x14, x3
    mulh x11, x28, x25
    sb x3, 8(x31)
    lh x4, 16(x31)
    addi x27, x5, 1408
    srl x19, x19, x3
    li x17, 501526048
    li x30, 1397696077
    or x25, x13, x18
    remu x19, x22, x11
    div x22, x10, x26
    remu x7, x5, x1
    mulh x8, x19, x10
    sltiu x2, x6, -1270
    li x30, -1441429782
    li x22, -1972194992
    divu x5, x20, x16
    sub x2, x8, x1
    srl x25, x5, x8
    sll x2, x15, x16
    li x4, -841181178
    sh x18, 12(x31)
    srai x29, x30, 4
    li x18, 1662131363
    sh x14, 20(x31)
    li x12, 496162040
    li x16, 1280787729
    sh x6, 16(x31)
    li x29, 1225470423
    lhu x29, 16(x31)
    sltu x29, x13, x4
    lhu x9, 20(x31)
    andi x9, x27, 577
    sb x6, 24(x31)
    sb x18, 0(x31)
    sb x11, 8(x31)
    srai x10, x14, 18
    li x6, -104722999
    mul x2, x20, x8
    div x30, x11, x18
    sb x24, 20(x31)
    lhu x2, 12(x31)
    sll x2, x15, x30
    li x10, -2038932811
    srai x28, x14, 31
    sb x1, 20(x31)
    ori x6, x25, -1228
    and x27, x12, x4
    xori x16, x29, -1225
done: j done
    .section .data
    .align 4
scratch: .space 64
