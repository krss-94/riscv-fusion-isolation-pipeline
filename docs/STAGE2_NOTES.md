# Stage 2 — Single-Cycle RTL: Status

## Result
87/87 lockstep pass: 7 directed tests (ALU-reg, ALU-imm, branches, jal/jalr,
lui/auipc, load/store all widths, full M-extension incl. div-by-zero and
INT_MIN/-1) + 50 constrained-random straight-line RV32IM programs (60
instructions each, seeds 1-50) + 30 forward-branch/jump control-flow
programs (10 blocks each, seeds 1-30), all compared
built Spike (same commit as Stage 1: c09c0cce9869...).

## Real bugs found and fixed during bring-up (not just harness friction)
1. **Testbench print-timing bug**: dbg_pc/dbg_instr/dbg_reg_wdata are
   combinational off the `pc` register. Printing after the committing clock
   edge showed every line one instruction late and silently dropped the
   first commit entirely. Fixed by sampling/printing before the edge, not
   after.
2. **dbg_mem_wdata truncation**: was echoing raw rs2_data (32-bit) instead
   of the actual truncated bytes a byte/half store writes to memory.
   Display-only bug (the real store logic in core_top.sv was always
   correct), but a real fix, not cosmetic-only, since it made byte/half
   stores unverifiable via commit-log diff.
3. **Harness instruction-budget mismatch**: --instructions=N applied
   identically to Spike (which burns ~5 on its own boot-ROM) and RTL (no
   boot-ROM) caused budget drift, not caught until random tests were long
   enough to expose it.
4. **Uninitialized-register test-generation bug** (the real root cause of
   8/17 initial random-test failures, misdiagnosed once before landing on
   this): gen_random.py picked source registers without tracking whether
   they'd been written within the same program. Spike's regfile carries
   over residual values from its own boot-ROM execution (e.g. x5=0x80000000,
   x11=0x1020 -- same values seen in Stage 1's own boot trace); RTL starts
   clean at zero. Reading an unwritten register is undefined by
   construction and diverges between the two for reasons unrelated to
   either simulator's correctness. Fixed by explicitly initializing all 30
   usable registers via `li` before any random instruction can read them.

## Known scope limits, by design (not gaps)
- No CSR/SYSTEM/FENCE/FISOL support in this core at all -- Part 7 §2's base
  ISA only, per Part 14 Stage 2. FISOL instructions happen to execute
  correctly as no-ops, but only because they fall through the decoder's
  generic default case along with everything else undecoded -- not because
  this RTL knows FISOL exists.
- M-extension is purely combinational (single block, no multi-cycle
  iteration) -- intentional Stage 2 simplification per Part 14 ("simplest
  possible way"), not representative of Part 8's eventual design.
- Random control-flow coverage (gen_random_cf.py) is forward-branch/jump
  only -- no backward branches, so no randomly-generated loops. Guarantees
  termination but doesn't stress a loop-heavy fusion-idiom-adjacent pattern
  the way Part 8's eventual fusion detector will care about; adequate for
  Stage 2's own decode/datapath scope, not a substitute for Part 10 §5's
  full random suite once pipeline/hazards exist.
- riscv-tests' own ECALL-based pass/fail harness is NOT usable against this
  core (no SYSTEM instruction support yet) -- lockstep-vs-Spike via a
  custom harness is the verification method for this stage, not
  riscv-tests' own scoring convention.

## Files
- rtl/{alu,imm_gen,regfile,muldiv,decoder,core_top}.sv
- sim/tb_core.cpp, sim/Makefile
- sw/test/stage2/*.s (directed), sw/test/stage2_random/*.s (generated,
  regeneratable via harness/gen_random.py with the same seeds)
- harness/run_lockstep.sh, harness/gen_random.py
- docs/raw_logs/stage2_lockstep_full.log (full 57-test run)
