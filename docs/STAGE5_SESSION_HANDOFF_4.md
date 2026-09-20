# Stage 5 Session Handoff #4 — CSR Infra Implemented and Verified, RAW Hazard Found+Fixed

Continuation of Handoff #3. Read #3, #2, #1 in that order, then
`10_part14_roadmap.md`, if more context is needed.

**Location, unchanged:** `~/ooo/` on the user's Ubuntu VM.

## Part 0 — Where Handoff #3 left off

CSR infra entirely absent. Handoff #3 Part 5 scoped it: CSRRW/CSRRS/CSRRC
only, mepc/mcause/mtval/mtvec addresses, mtvec becomes a real register.

## Part 1 — CSR RTL implemented (7 files)

- `rtl/decoder.sv`: added `csr_addr` output (`instr[31:20]`).
- `rtl/pipeline_regs.sv`: `is_csr`/`csr_op`/`csr_addr` propagated through
  id_ex_reg, ex_mem_reg, mem_wb_reg.
- `rtl/trap_unit.sv`: rewritten, now purely combinational (trap detect +
  write-data compute only). mepc/mcause/mtval/mtvec storage moved out.
- `rtl/csr_file.sv`: new file. Sole owner/writer of the four CSRs.
  Single write port shared by hardware trap path and software CSR path;
  trap wins on same-cycle collision (documented edge case).
- `rtl/core_top_pipelined.sv`: csr_file + trap_unit instantiated, EX-stage
  CSR write-data mux (CSRRW/CSRRS/CSRRC), WB-stage csr_file write commit.
  CSR ops reuse `alu_result` (old value -> rd) and `muldiv_result` (new
  value -> csr_file write port) fields rather than adding new pipeline
  fields — result_src=00/is_muldiv=0 stays unchanged for CSR ops, so the
  existing WB mux and GPR forwarding cover CSR-result-to-GPR-consumer for
  free.

All edits applied via exact-match Python `str_replace`-style scripts,
each `old_str` count-verified ==1 before writing. Several early attempts
aborted on match-count mismatches because `old_str` blocks were built
from chat-pasted RTL rather than `cat -A` output of the real file —
chat rendering silently drops blank lines. **Standing lesson: always
build edit anchors from `cat -A` output taken directly from the target
file, never from a re-typed/re-pasted copy of previously-seen text.**

**Verilator gotcha:** two DOT-path debug signals
(`core_top_pipelined__DOT__wb_csr_addr`, `...wb_csr_wdata`) did not
exist in the generated header — Verilator optimizes away pure `assign`
aliases and keeps only the underlying source signal
(`wb_csr_addr_out`, `wb_muldiv_result`). Confirmed via grep on
`obj_dir_pipeline/Vcore_top_pipelined___024root.h`. Not a bug, just a
naming gotcha for future debug-port work.

## Part 2 — Bug found: CSR RAW hazard, no forwarding on csr_addr

Directed test `sw/test/stage2/t_csr_basic.s` (csrrw/csrrs/csrrc against
mepc/mcause/mtvec in sequence) showed 2 of 5 expected register values
wrong on first run:
- `csrrs x3, mepc, x0` right after `csrrw x2, mepc, x1`: got 0x0,
  expected 0x12345678 (the just-written mepc value).
- `csrrc x7, mcause, x6` reading mcause the same cycle an earlier
  csrrs's write to mcause was committing at WB: got 0x0, expected 0xf.

**Root cause:** `csr_rdata_ex` reads `csr_file`'s registered output
directly at EX with zero forwarding. The existing GPR forwarding network
(`mem_alu_result_fwd`/`wb_data_fwd`) only forwards CSR *results* to
later GPR-consuming instructions via `rd_addr` match — it does nothing
for a second CSR instruction reading the *same CSR address* before the
first one's write has committed. This is a hazard class distinct from
what Handoff #3's original CSR design assumed was "automatically
covered."

**Fix:** added a priority-mux forwarding path directly on `csr_rdata_ex`
in `core_top_pipelined.sv`: MEM-stage pending CSR write (if
`mem_is_csr_out && mem_csr_addr_out == ex_csr_addr`) takes priority over
WB-stage pending write, else falls through to `csr_file`'s raw read.
Mirrors the existing GPR forward-mux pattern, keyed on `csr_addr`
instead of `rd_addr`.

**Verified correct after fix** — standalone run of `t_csr_basic`:
```
x2=0x00000000 x3=0x12345678 x5=0x00000000 x7=0x0000000f x9=0x80001000
```
All five match hand-derived expected values.

## Part 3 — Verification status

- Full lockstep suite: `88/88` unchanged (CSR RTL is purely additive to
  non-CSR paths, confirmed no regression, both before and after the
  hazard fix).
- `t_csr_basic` itself shows as a lockstep FAIL — **not meaningful**,
  same class of false signal as `t_fisol_illegal` in Handoff #3 Part
  2.1. Diff is exactly one line: Spike's Zicsr model assumes mtvec
  resets to 0x0; this project's `csr_file.sv` resets mtvec to
  0x8000_1000 by design (preserves old `TRAP_VEC` behavior). Confirmed
  via `diff t_csr_basic.spike.norm t_csr_basic.rtl.norm` — the only
  discrepancy is `x9`, consistent with the known reset-value difference,
  not a real bug. No exclusion mechanism exists in
  `run_lockstep_pipeline.sh` for non-meaningful tests (checked — none
  was ever added for `t_fisol_illegal` either); left as-is, documented
  here instead, consistent with existing practice.
- `t_csr_basic.s` is standalone-verified via hand-derivation + trace
  inspection, the same rigor tier as the trap verification in Handoff
  #3 Part 3 — this is the real evidence, not the lockstep PASS/FAIL.

## Part 4 — Current file state

- `rtl/decoder.sv`, `rtl/pipeline_regs.sv`, `rtl/trap_unit.sv`,
  `rtl/csr_file.sv`, `rtl/core_top_pipelined.sv` — all modified/created
  this session, all confirmed correct via Part 2/3 above.
- `sim/tb_pipeline.cpp` — one additive CSR trace line added (stderr
  only, `csr: ex_is_csr=... ex_csr_addr=... csr_rdata_ex=... wb_csr_we=...
  wb_csr_addr=... wb_csr_wdata=... mtvec=...`), no existing print logic
  touched.
- `sw/test/stage2/t_csr_basic.s` — new, verified correct.
- Latest confirmed-clean full lockstep result: `PASS=88` (of 88
  meaningful tests; `t_csr_basic` present but non-meaningful per Part 3).

## Part 5 — What's next

Per Handoff #3 Part 5's original ordering, CSR infra (this session)
unblocks:
1. Software-readable mepc/mcause/mtval — done, this session.
2. Software-programmable mtvec — done, this session.
3. **HPM event counters** (FUSION_ACTIVE/ISOL_ACTIVE/MULDIV_ACTIVE) —
   next substantial chunk, the actual research-relevant instrumentation
   for the fusion/isolation project. Needs: new CSR addresses allocated
   for the counters, counter-increment logic tied to the relevant
   pipeline signals (muldiv_active already exists as a wire and is the
   obvious source for MULDIV_ACTIVE; FUSION_ACTIVE/ISOL_ACTIVE depend on
   mechanisms not yet implemented in this RTL — check Part 7 §3.2 before
   scoping).

After HPM counters: four primary configs + isolation-scope ablation
(Part 11 §1.1-1.2), then smoke tests across all configs — the remaining
Stage 5 deliverables per `10_part14_roadmap.md`.

**Open item carried forward:** the CSR forwarding fix only checks
MEM/WB stages one level deep (matches the pipeline's existing 2-stage
forwarding depth). If HPM counter reads ever need to observe a value
written by an instruction more than 2 stages ahead, this will need
re-examination — not currently a problem since nothing in this pipeline
has more depth than MEM/WB forwarding already covers.

## Part 6 — Standing methodology (reinforced again this session)

Handoff #1 Part 6, #2 Part 7, #3 Part 6 all still apply. New
reinforcement: **RTL edit anchors must come from `cat -A` output of the
live file, not from any previously-pasted/re-typed copy of that text**
— chat rendering silently normalizes whitespace (dropped blank lines,
in this session's case), producing `old_str` blocks that look identical
to a human but fail exact-match. Every edit in this session that
aborted did so for this reason; every edit that succeeded was built
from freshly-`cat -A`'d text taken in the same message as the edit.
