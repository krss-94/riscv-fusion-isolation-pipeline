# Directed test: reserved FISOL funct3 (010) must trap to the fixed
# vector 0x8000_1000, per Part 7 sec 3.1. This instruction has no
# assembler mnemonic (custom-0, not in binutils), so it's raw-encoded:
# opcode=0001011, funct3=010, rd=rs1=rs2=0 -> 0b0000000_00000_00000_010_00000_0001011
.section .text
.globl _start
_start:
    addi x1, x0, 0x11        # sentinel: prove normal execution reaches here
    .word 0b00000000000000000010000000001011   # reserved FISOL funct3=010 -> illegal
    addi x2, x0, 0x22        # must NOT execute if trap redirects correctly
loop: j loop
