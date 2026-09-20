# Stage 5 Notes — Pipelined Core (Baseline)

## Status
Baseline pipeline is lockstep-verified against Spike: 87/87 PASS
(directed + random + control-flow), confirmed from a from-scratch rebuild
(rm -rf obj_dir_* ../sim_* before build, zero %Error/%Warning).

FISOL, HPM counters, fusion detection, and isolation control (the actual
research mechanism) are not yet implemented -- this stage only closes
out the baseline pipeline the research logic will be bolted onto.

## Bugs found and fixed

### Multiply carry-truncation (muldiv_iter.sv)
mulhu with large unsigned operands dropped the upper byte
(0x00000003FFFFFD44 instead of 0x00000063FFFFFD44 for a=100,
b=0xFFFFFFF9). The shift-add multiplier's accumulate step hardcoded the
carry-out to 1'b0 instead of capturing it. Fixed with explicit 33-bit
width casts on the accumulate sum. The original unit test only used small
operands and never forced a carry, so it passed clean while masking the
bug -- regression case added to tb_muldiv.cpp.

### REMU sign-misclassification (muldiv_iter.sv)
remu x10, x1, x2 with a=100, b=-7 (0xFFFFFFF9) gave x10=0x2 instead of
0x64. div_a_sign_c/div_b_sign_c used op[1:0] != 2'b01, which excludes
DIVU but not REMU from the "treat as signed" path, so REMU's divisor was
wrongly negated. Fixed by switching to op[0] == 1'b0 (0 = signed
DIV/REM, 1 = unsigned DIVU/REMU). This single fix cleared all 24 of 87
initial lockstep failures -- REMU appears constantly across the random
suites, so it was one bug, not 24.

### Regfile same-cycle write/read hazard -- already correct
regfile_pipelined.sv (separate file from Stage 2's regfile.sv) already
had the write-then-read same-cycle bypass in place by the time this
session checked it, and core_top_pipelined.sv already instantiated it
correctly. No action needed; confirmed by reading the files directly.

## False-confidence traps caught this session

1. A Verilator %Error did not stop make from linking. Stale objects in
   obj_dir_pipeline meant an early "87/87 PASS" was almost certainly
   re-testing the old buggy multiplier. Always rm -rf obj_dir_* ../sim_*
   before a rebuild you intend to trust, and check for zero
   errors/warnings first.
2. run_lockstep.sh has SIM=$HOME/ooo/sim_core hardcoded -- it only ever
   verifies the Stage 2 single-cycle core, despite the generic name.
   Several early "PASS" results this session silently never touched the
   pipeline. Use run_lockstep_pipeline.sh (new this session,
   SIM=$HOME/ooo/sim_pipeline) for pipeline verification, and grep any
   harness script's SIM= line before trusting its output.

## Structural risk noted, not yet resolved

In core_top_pipelined.sv, wb_reg_write_for_rf (feeds the regfile and its
bypass) is gated by !stall_memwb; wb_reg_write_fwd (feeds hazard_unit's
EX-stage forwarding select) is not. Not currently causing an observed
failure -- t_muldiv.s never exercises EX-stage forwarding -- but not
proven safe either. Resolution: gate both from one shared
wb_reg_write_valid = wb_reg_write && !stall_memwb signal, rebuild clean,
confirm 87/87 still holds.

## New/modified files this session
- rtl/muldiv_iter.sv -- both bugs fixed
- sim/tb_muldiv.cpp -- added mulhu overflow regression case
- sim/tb_pipeline.cpp -- widened per-cycle debug prints (cycles 0-400);
  verbose, consider gating behind a compile-time flag or removing once
  Stage 6's verification infra exists
- harness/run_lockstep_pipeline.sh -- new, correct pipeline lockstep
  harness; use this, not run_lockstep.sh

## Next steps (Stage 5 not yet closed)
1. Resolve the wb_reg_write_for_rf/wb_reg_write_fwd asymmetry above.
2. Implement FISOL in the pipeline decoder (no-op hint instruction).
3. Implement HPM events per spec Part 7 sec 3.
4. Implement the four primary configurations + isolation-scope ablation
   per spec Part 11 sec 1.1-1.2 -- the actual fusion detector + isolation
   control logic.
5. Hold new FISOL/HPM/fusion logic to at least the same bar as the
   baseline (full lockstep, not just smoke tests) before calling Stage 5
   closed.
