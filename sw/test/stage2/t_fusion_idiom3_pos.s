# Idiom 3 positive test: AUIPC rd,imm20 + JALR ra,rd,imm12, immediately
# lookahead-adjacent (Part 8 SS2.2 idiom 3). Verifies BOTH destination
# registers survive the fusion: rd (x5, AUIPC's own value, via the
# deferred pend2 write) and ra (x1, JALR's link = its own PC+4).
.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter5, x0   # x10 <- 0 (before any fusion)
auipc_pc:
    auipc x5, 0                  # x5 <- addr(auipc_pc); idiom-3 base reg
    jalr  x1, x5, 12              # x1 <- addr(jalr_pc)+4 (own link);
                                  # target = x5+12 = auipc_pc+12 = target
    lui   x6, 0xdead              # wrong-path fall-through (skipped)
target:
    csrrs x11, mhpmcounter5, x0   # x11 <- must be 1 (exactly one fusion)
    addi  x20, x5, 0              # x20 <- x5, to check AUIPC's rd survived
    addi  x21, x1, 0              # x21 <- x1, to check JALR's ra is correct
loop:
    j loop
