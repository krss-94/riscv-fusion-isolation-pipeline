    .section .text.init
    .global _start
_start:
    li x1, 0
    li x2, 5
    beq x1, x1, l1
    li x1, 999
l1: bne x1, x2, l2
    li x1, 999
l2: blt x1, x2, l3
    li x1, 999
l3: bge x2, x1, l4
    li x1, 999
l4: bltu x1, x2, l5
    li x1, 999
l5: bgeu x2, x1, l6
    li x1, 999
l6: li x10, 42
done: j done
