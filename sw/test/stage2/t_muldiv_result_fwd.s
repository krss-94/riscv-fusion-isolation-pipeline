# Part 10 §4.8 — multiply RESULT forwarding on retirement (distinct
# from §4.4's operand-side forwarding into the multiplier). Each
# consumer type x2, once immediately following MUL (EX/MEM forward)
# and once with one independent instr between (MEM/WB forward).
.section .text
.globl _start
_start:
    li   x1, 6
    li   x2, 7
    # 1: ALU consumer, EX/MEM forward
    mul  x3, x1, x2          # x3 = 42
    add  x10, x3, x0         # x10 = 42, via EX/MEM fwd
    # 2: ALU consumer, MEM/WB forward
    mul  x3, x1, x2
    addi x0, x0, 0           # independent bubble
    add  x11, x3, x0         # x11 = 42, via MEM/WB fwd
    # 3: branch-compare consumer, EX/MEM forward
    li   x7, 42
    mul  x3, x1, x2
    beq  x3, x7, br1_taken
    addi x12, x0, 0x99       # must NOT execute if fwd correct
    j    br1_done
br1_taken:
    addi x12, x0, 1          # x12 = 1 if branch correctly taken
br1_done:
    # 4: branch-compare consumer, MEM/WB forward
    mul  x3, x1, x2
    addi x0, x0, 0
    beq  x3, x7, br2_taken
    addi x13, x0, 0x99
    j    br2_done
br2_taken:
    addi x13, x0, 1
br2_done:
    # 5: store-address consumer, EX/MEM forward
    lui  x8, 0x80010
    ori  x8, x8, 0x040       # x8 = 0x80010040
    li   x9, 1
    mul  x3, x8, x9          # x3 = 0x80010040 (product = address itself)
    li   x14, 0xAB
    sw   x14, 0(x3)          # address computed from forwarded mul result
    lw   x15, 0(x3)          # x15 = 0xAB if store landed correctly
    # 6: store-address consumer, MEM/WB forward
    mul  x3, x8, x9
    addi x0, x0, 0
    li   x16, 0xCD
    sw   x16, 0(x3)
    lw   x17, 0(x3)          # x17 = 0xCD
    # 7: another-MUL consumer, EX/MEM forward
    li   x19, 1
    mul  x3, x1, x2          # x3 = 42
    mul  x18, x3, x19        # x18 = 42*1 = 42, EX/MEM fwd into 2nd MUL's operand
    # 8: another-MUL consumer, MEM/WB forward
    mul  x3, x1, x2
    addi x0, x0, 0
    mul  x20, x3, x19        # x20 = 42
loop:
    j loop
