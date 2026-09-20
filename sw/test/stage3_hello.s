    .section .text.init
    .global _start
_start:
    la    sp, _stack_top
    la    t0, __bss_start
    la    t1, __bss_end
bss_loop:
    bge   t0, t1, bss_done
    sw    x0, 0(t0)
    addi  t0, t0, 4
    j     bss_loop
bss_done:
    la    a0, msg
puts_loop:
    lb    t2, 0(a0)
    beqz  t2, halt
    li    t3, 0x80000000     /* UART_TXDATA, testbench-only virtual UART */
    sw    t2, 0(t3)
    addi  a0, a0, 1
    j     puts_loop
halt:
    j     halt

    .section .data
    .align 4
msg: .asciz "hello\n"
    .align 4
bss_var: .word 0
