    .section .text.init
    .global _start
_start:
    jal x1, target
    li x5, 999
target:
    li x6, 111
    la x2, ret_target
    jalr x3, x2, 0
    li x7, 999
ret_target:
    li x8, 222
done: j done
