    csrrs x10, mhpmcounter5, x0   # x10 <- fusion count before (expect 0)
    .word 0x0000000B              # fisol bound: must suppress fusion detector
    lui   x1, 0x12345
    addi  x1, x1, 0x678           # idiom pattern present, but BOUND active -> no fuse
    csrrs x11, mhpmcounter5, x0   # x11 <- fusion count after (expect still 0)
    .word 0x0000100B              # fisol off
    lui   x2, 0xabcde
    addi  x2, x2, 0x321           # idiom resumes -> fuse normally
    csrrs x12, mhpmcounter5, x0   # x12 <- fusion count after (expect 1)
loop:
    j loop
