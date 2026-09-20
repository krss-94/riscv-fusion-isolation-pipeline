/*
 * regtest.s -- Stage 1's acceptance test, re-run on this VM's independently
 * built Spike. Expected end-state computed by hand in Stage 1, corrected
 * once already (100*42=0x1068, not the original 0x0A44 typo).
 */
    .section .text.init
    .global _start
    .align 2
_start:
    addi    t0, x0, 100         /* x5 = 100 */
    addi    t1, x0, 42          /* x6 = 42 */
    add     t2, t0, t1          /* x7 = 100 + 42 = 142 */
    mul     s0, t0, t1          /* x8 = 100 * 42 = 4200 = 0x1068 */

    .insn r 0x0B, 0, 0, x0, x0, x0   /* FISOL.BOUND -- must be a no-op */

    la      t3, scratch
    sw      t2, 0(t3)           /* store 142 to memory */

    .insn r 0x0B, 1, 0, x0, x0, x0   /* FISOL.OFF -- must be a no-op */

    lw      s1, 0(t3)           /* x9 = load back 142; must equal x7 */

done:
    j       done

    .section .data
    .align 2
scratch:
    .word 0xDEADBEEF
