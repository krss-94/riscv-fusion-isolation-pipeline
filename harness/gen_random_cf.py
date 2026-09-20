#!/usr/bin/env python3
import random, sys

random.seed(int(sys.argv[1]) if len(sys.argv) > 1 else 0)
NBLOCKS = int(sys.argv[2]) if len(sys.argv) > 2 else 10
BLOCK_LEN = 5

regs = [f"x{i}" for i in range(1, 31)]
alu_reg_ops  = ["add","sub","sll","slt","sltu","xor","srl","sra","or","and"]
alu_imm_ops  = ["addi","slti","sltiu","xori","ori","andi"]
muldiv_ops   = ["mul","mulh","mulhu","mulhsu","div","divu","rem","remu"]
branch_ops   = ["beq","bne","blt","bge","bltu","bgeu"]

lines = ["    .section .text.init", "    .global _start", "_start:"]
lines.append("    la x31, scratch")
for i in range(1, 31):
    lines.append(f"    li x{i}, {random.randint(-(2**31), 2**31 - 1)}")

def gen_block():
    out = []
    for _ in range(BLOCK_LEN):
        rd, rs1, rs2 = random.choice(regs), random.choice(regs), random.choice(regs)
        kind = random.choice(["alu_reg","alu_imm","muldiv"])
        if kind == "alu_reg":
            out.append(f"    {random.choice(alu_reg_ops)} {rd}, {rs1}, {rs2}")
        elif kind == "alu_imm":
            out.append(f"    {random.choice(alu_imm_ops)} {rd}, {rs1}, {random.randint(-2048,2047)}")
        else:
            out.append(f"    {random.choice(muldiv_ops)} {rd}, {rs1}, {rs2}")
    return out

# NBLOCKS straight-line blocks, each followed by a FORWARD-only branch or
# jump (never backward -- guarantees termination, no infinite loops beyond
# the final trailing self-loop).
for b in range(NBLOCKS):
    lines += gen_block()
    target = f"blk{random.randint(b+1, NBLOCKS)}"
    cf = random.choice(["branch", "jal", "jalr", "none"])
    if cf == "branch":
        rs1, rs2 = random.choice(regs), random.choice(regs)
        lines.append(f"    {random.choice(branch_ops)} {rs1}, {rs2}, {target}")
    elif cf == "jal":
        lines.append(f"    jal x30, {target}")
    elif cf == "jalr":
        lines.append(f"    la x29, {target}")
        lines.append(f"    jalr x30, x29, 0")
    lines.append(f"blk{b+1}:")

lines.append("done: j done")
lines.append("    .section .data")
lines.append("    .align 4")
lines.append("scratch: .space 64")
print("\n".join(lines))
