    .section .text.init
    .global _start
_start:
    la x31, scratch
    li x1, 1891299130
    li x2, -1048936187
    li x3, 1005277327
    li x4, 680537650
    li x5, -846160206
    li x6, -443783326
    li x7, -1638961366
    li x8, 1724270823
    li x9, -1029064159
    li x10, -1504511745
    li x11, 704370583
    li x12, -1439036296
    li x13, 651539210
    li x14, -699795223
    li x15, -1790107984
    li x16, 2052992355
    li x17, 461843062
    li x18, 574363288
    li x19, 1609727647
    li x20, -1314952733
    li x21, -1210373758
    li x22, 1280939216
    li x23, 2062125
    li x24, -1707558617
    li x25, -1762932721
    li x26, -942020491
    li x27, -2027235701
    li x28, 1032257771
    li x29, -1748121702
    li x30, 796167253
    xori x18, x13, 1718
    sltu x14, x14, x20
    ori x16, x13, 1958
    andi x3, x19, 137
    rem x19, x15, x1
    bltu x12, x23, blk7
blk1:
    sltiu x12, x16, -503
    sltiu x2, x21, -1267
    sltu x13, x4, x2
    div x1, x1, x19
    sltiu x17, x30, -1116
    jal x30, blk2
blk2:
    sltu x25, x7, x1
    slt x28, x17, x9
    sltiu x7, x20, 972
    mulhu x2, x18, x30
    xor x17, x21, x27
blk3:
    divu x8, x13, x18
    slt x16, x30, x20
    sltiu x21, x30, -1314
    slt x9, x26, x4
    slt x2, x23, x30
blk4:
    addi x15, x5, -1177
    rem x9, x23, x12
    sub x14, x5, x15
    sll x5, x26, x24
    xor x1, x22, x30
    bge x19, x14, blk9
blk5:
    xor x9, x16, x11
    mulh x2, x22, x21
    addi x30, x28, -1627
    sub x27, x21, x30
    addi x1, x26, -941
    jal x30, blk9
blk6:
    xori x1, x29, -1885
    sltu x10, x3, x9
    mul x22, x19, x21
    mul x18, x26, x8
    sub x30, x12, x29
blk7:
    divu x15, x10, x12
    ori x1, x9, 498
    addi x7, x17, -1478
    ori x15, x11, 1413
    slti x9, x22, -1800
blk8:
    mulh x8, x13, x27
    slt x25, x8, x27
    slt x9, x28, x28
    mul x26, x3, x15
    div x1, x7, x22
blk9:
    sub x8, x29, x24
    divu x23, x23, x6
    addi x15, x23, 932
    divu x16, x7, x25
    addi x11, x16, -609
    jal x30, blk10
blk10:
done: j done
    .section .data
    .align 4
scratch: .space 64
