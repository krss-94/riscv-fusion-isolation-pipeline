# Idiom 4 redirect-trap test (mirrors idiom1_redirect_trap): SLT+BNE idiom
# straddling an interrupt/trap-entry boundary. Illegal instruction resolves
# in EX same cycle SLT (its fall-through successor) sits in ID -- same
# redirect-timing hazard idiom1 exercises, now for idiom4's fused
# compare+branch entry in the redirect_target mux.
.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter5, x0   # x10 <- 0 (before)
    .word 0b00000000000000000010000000001011   # reserved FISOL funct3=010 -> illegal, traps to mtvec (0x80001000)
    slt   x5, x0, x0              # wrong-path fall-through, syntactically matches idiom4
    bne   x5, x0, wrong_target    # wrong-path (rs1==rd of slt, rs2=x0) -- must never fire
wrong_target:
    lui   x6, 0xdead              # would only execute on wrong path
.org 0x1000
handler:
    csrrs x11, mhpmcounter5, x0   # x11 <- must still be 0 (wrong-path pair never fused/executed)
loop:
    j loop
