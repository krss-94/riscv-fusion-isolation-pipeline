# sw/test/stage2/t_hpm_isol.s
# Standalone-verified only — Spike doesn't model FISOL/HPM counters
# (Part 9 §5 scope boundary). Verify via sim_pipeline standalone run.
#
# Corrected per the muldiv_op_en fix: FISOL.BOUND/OFF are Part 8 §3's
# "architecturally a no-op; diagnostic only" instructions — they must
# NEVER affect a computed result. A prior version of this test asserted
# a multiply issued during FISOL.BOUND produces a "stale/wrong product
# by design" — that was wrong; Part 8 §2.3 explicitly calls a
# correctness-breaking isolation gate "a correctness bug, not merely a
# missed power optimization." This version checks the opposite: results
# stay correct regardless of FISOL state.
#
# mhpmcounter3 (muldiv_active_cnt) is a per-operation event pulse —
# expect exactly 1, 2, 3 after each of the three multiplies below,
# unaffected by FISOL state.
#
# mhpmcounter4 (isol_active_cnt) now counts CYCLES the isolation gate
# holds (i.e. every cycle no multiply is in flight) — not a discrete
# "isolation fired" flag. It is expected to be large and monotonically
# increasing, not a small fixed constant; don't hardcode an exact value
# here, just confirm it strictly increases between reads.
.section .text
.globl _start
_start:
    li   x1, 6
    li   x2, 7
    mul  x3, x1, x2               # correct: x3 = 42
    csrrs x10, mhpmcounter3, x0   # x10 <- 1
    csrrs x11, mhpmcounter4, x0   # x11 <- some N (idle-cycle count so far)
    .word 0x0000000B              # fisol bound: diagnostic no-op only
    li   x4, 100
    li   x5, 200
    mul  x6, x4, x5               # must still be correct: x6 = 20000
    csrrs x12, mhpmcounter3, x0   # x12 <- 2
    csrrs x13, mhpmcounter4, x0   # x13 <- some M > N (more idle cycles elapsed)
    .word 0x0000100B              # fisol off: diagnostic no-op only
    li   x7, 3
    li   x8, 4
    mul  x9, x7, x8                # correct: x9 = 12
    csrrs x14, mhpmcounter3, x0   # x14 <- 3
    csrrs x15, mhpmcounter4, x0   # x15 <- some P > M
loop:
    j loop
