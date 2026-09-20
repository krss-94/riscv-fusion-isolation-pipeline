# Part 10 §4.4 — isolation-gate/forwarding ordering into a multiply's
# operand, all three forwarding sources.
.section .text
.globl _start
_start:
    li   x2, 7
    # Case A: EX/MEM forward (producer immediately precedes multiply)
    addi x1, x0, 6
    mul  x3, x1, x2        # expect 42; rs1 must come via MEM-stage forward
    # Case B: MEM/WB forward (one independent instr between)
    addi x4, x0, 6
    addi x5, x0, 1
    mul  x6, x4, x2        # expect 42; rs1 must come via WB-stage forward
    # Case C: no forwarding needed (producer already retired)
    addi x7, x0, 6
    addi x8, x0, 1
    addi x9, x0, 1
    mul  x10, x7, x2       # expect 42; rs1 read directly from regfile
loop:
    j loop
