# Part 10 §4.3 — hazard-interlock decline (adversarial, not random).
# addi x1,... lands in EX exactly when the fusable LUI reaches ID
# (no stall inserted) -- idiom1_hazard_clear must see ex_rd_addr==x1
# and decline fusion; execution must still be architecturally correct
# via normal unfused WAW ordering (last write wins = LUI+ADDI value).
.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter5, x0   # x10 <- fusion count before (expect 0)
    addi  x1, x0, 0x2AA           # in-flight write to x1, lands in EX as LUI enters ID
    lui   x1, 0x12345
    addi  x1, x1, 0x678           # idiom pattern matches syntactically; hazard must decline it
    csrrs x11, mhpmcounter5, x0   # x11 <- fusion count after (expect still 0: declined)
loop:
    j loop
