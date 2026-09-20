# Part 10 §4.6b — LUI+ADDI idiom straddling a JALR redirect.
.section .text
.globl _start
_start:
    csrrs x10, mhpmcounter5, x0   # x10 <- 0 (before)
    auipc x1, 0                  # x1 <- addr(this auipc); no following ADDI,
                                  # so idiom 2 (AUIPC+ADDI) cannot match here
    addi  x0, x0, 0               # idiom-3 adjacency breaker: AUIPC+JALR must be
                                  # immediate lookahead-adjacent to fuse (Part 8
                                  # SS2.2 idiom 3) -- this test predates idiom 3
                                  # and is about wrong-path idiom-1 suppression,
                                  # not idiom-3 correctness, so decouple them
    jalr  x0, x1, 20              # unconditional redirect: target = x1+20 (was +16;
                                  # +4 for the idiom-3 adjacency breaker inserted above)
    lui   x5, 0x12345             # wrong-path fall-through
    addi  x5, x5, 0x678           # wrong-path, syntactically matches idiom1
target:
    csrrs x11, mhpmcounter5, x0   # x11 <- must still be 0
loop:
    j loop
