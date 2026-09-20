    csrrs x10, mhpmcounter5, x0   # x10 <- fusion count before (expect 0)
    auipc x1, 0x100
    addi  x1, x1, 0x678           # idiom 2: AUIPC+ADDI same rd -> must fuse
    csrrs x11, mhpmcounter5, x0   # x11 <- fusion count after 1st (expect 1)
    auipc x2, 0x5
    addi  x2, x2, 0x321           # 2nd occurrence, back-to-back
    csrrs x12, mhpmcounter5, x0   # x12 <- fusion count after 2nd (expect 2)
loop:
    j loop
