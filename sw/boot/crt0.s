    .section .text.init
    .global _start
    .align  2

_start:
    la      sp, _stack_top

    la      t0, __bss_start
    la      t1, __bss_end
1:
    bge     t0, t1, 2f
    sw      x0, 0(t0)
    addi    t0, t0, 4
    j       1b
2:

    la      t0, trap_handler
    csrw    mtvec, t0

    call    main

halt:
    j       halt

    .section .text
    .weak trap_handler
    .align 2
trap_handler:
    j       trap_handler
