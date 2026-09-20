#!/usr/bin/env python3
import random, sys

random.seed(int(sys.argv[1]) if len(sys.argv) > 1 else 0)
N = int(sys.argv[2]) if len(sys.argv) > 2 else 60

regs = [f"x{i}" for i in range(1, 32)]
alu_reg_ops  = ["add","sub","sll","slt","sltu","xor","srl","sra","or","and"]
alu_imm_ops  = ["addi","slti","sltiu","xori","ori","andi"]
shift_imm_ops= ["slli","srli","srai"]
muldiv_ops   = ["mul","mulh","mulhu","mulhsu","div","divu","rem","remu"]

lines = ["    .section .text.init", "    .global _start", "_start:"]
lines.append("    la x31, scratch")
for i in range(1, 31):
    lines.append(f"    li x{i}, {random.randint(-(2**31), 2**31 - 1)}")

for _ in range(N):
    kind = random.choice(["alu_reg","alu_imm","shift_imm","muldiv","load","store","li"])
    rd = random.choice(regs[:-1])  # keep x31 as scratch pointer
    rs1 = random.choice(regs[:-1])
    rs2 = random.choice(regs[:-1])
    if kind == "alu_reg":
        lines.append(f"    {random.choice(alu_reg_ops)} {rd}, {rs1}, {rs2}")
    elif kind == "alu_imm":
        imm = random.randint(-2048, 2047)
        lines.append(f"    {random.choice(alu_imm_ops)} {rd}, {rs1}, {imm}")
    elif kind == "shift_imm":
        imm = random.randint(0, 31)
        lines.append(f"    {random.choice(shift_imm_ops)} {rd}, {rs1}, {imm}")
    elif kind == "muldiv":
        lines.append(f"    {random.choice(muldiv_ops)} {rd}, {rs1}, {rs2}")
    elif kind == "li":
        val = random.randint(-(2**31), 2**31 - 1)
        lines.append(f"    li {rd}, {val}")
    elif kind == "load":
        off = random.choice([0,4,8,12,16,20,24,28])
        w = random.choice(["lb","lbu","lh","lhu","lw"])
        lines.append(f"    {w} {rd}, {off}(x31)")
    elif kind == "store":
        off = random.choice([0,4,8,12,16,20,24,28])
        w = random.choice(["sb","sh","sw"])
        lines.append(f"    {w} {rs1}, {off}(x31)")

lines.append("done: j done")
lines.append("    .section .data")
lines.append("    .align 4")
lines.append("scratch: .space 64")

print("\n".join(lines))
