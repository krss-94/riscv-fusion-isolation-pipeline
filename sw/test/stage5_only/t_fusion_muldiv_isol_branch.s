# Part 10 §4.x (new) — branch instruction issued while a multiply-driven
# isolation window is open. Purpose: exercise BR_CMP_EN, the ablation
# knob that (per Part 11 §1.2) widens isolation scope to branch-compare
# ops. Without this test, D_isol_scope_ablation (BR_CMP_EN=1) is
# structurally indistinguishable from D_proposed (BR_CMP_EN=0) in the
# suite -- Part 10 currently has no config-discriminating test for it.
#
# mhpmcounter4 = isolation-active count (CSR_ISOL_ACTIVE, matches
# t_hpm_isol.s convention). Expect: BR_CMP_EN=0 -> branch resolves
# outside the counted isolation window (count unaffected by the branch
# itself); BR_CMP_EN=1 -> branch is pulled inside the isolation window
# (count reflects the widened scope). Standalone-verified only: this
# reads a custom HPM CSR Spike cannot model, same class as t_hpm_isol.s.
.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter4, x0    # x10 <- isol count before (expect 0)
    li    x1, 6
    li    x2, 7
    mul   x3, x1, x2               # opens isolation window (multi-cycle)
    beq   x1, x1, target           # branch issued WHILE mul is in flight
    li    x3, 999                  # wrong-path if branch mis-scoped
target:
    csrrs x11, mhpmcounter4, x0    # x11 <- isol count during/just-after window
    addi  x4, x3, 0                # x4 <- 42 if mul result forwarded correctly
    csrrs x12, mhpmcounter4, x0    # x12 <- isol count after window fully closed
loop:
    j loop
