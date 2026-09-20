# sw/test/stage2/t_csr_basic.s
# Standalone-verified (not lockstep-meaningful — Spike's own CSR state
# for these addresses is not independently confirmed correct by this
# project, same caveat as t_fisol_illegal.s). Verify via sim_pipeline
# standalone run + trace inspection instead.
.section .text
.globl _start
_start:
    li   x1, 0x12345678
    csrrw x2, mepc, x1       # mepc <- x1 (0x12345678); x2 <- old mepc (0x0 at reset)
    csrrs x3, mepc, x0       # x3 <- mepc (read-only op, csrrs with x0 never writes)
    li   x4, 0x0000000F
    csrrs x5, mcause, x4     # mcause |= x4; x5 <- old mcause (0x0)
    li   x6, 0x00000005
    csrrc x7, mcause, x6     # mcause &= ~x6; x7 <- mcause before clear (0xF)
    li   x8, 0x80002000
    csrrw x9, mtvec, x8      # mtvec <- x8; x9 <- old mtvec (0x80001000 reset default)
loop:
    j loop
