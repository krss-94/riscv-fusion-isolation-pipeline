# RISC-V Fusion/Isolation Pipeline

A 5-stage in-order RV32IM pipeline in SystemVerilog, extended with two
hardware research features layered on top of a standard IF→ID→EX→MEM→WB
core: **macro-op fusion** of common compiler-generated instruction idioms,
and a **hardware isolation-gating scheme** for the multiply/divide unit.
Built to answer one question: *does fusing instruction pairs, isolating the
idle muldiv unit, or combining both, actually save power — and at what
cost?*

Verified via cycle-accurate lockstep against a Spike golden model, benchmarked
on Dhrystone / CoreMark / Embench-IoT, and PPA-characterized on an Artix-7
target (Vivado synthesis, SAIF-based power, post-route timing).

> Earlier notes/commit history in this repo refer to this as an "ooo" (out-of-order)
> project. It is not out-of-order — no ROB, no reservation stations, no
> out-of-order issue/retirement. It's an in-order 5-stage pipeline with
> instruction fusion and isolation gating. The naming is legacy and left
> uncorrected in old paths/module names for history's sake.

---

## Research question and answer

**Question:** does instruction fusion, muldiv isolation, or the combination
of both, reduce power — and what does each cost?

**Answer, backed by post-synthesis measurement (see [Results](#results) below):**

- **Fusion is the dominant power and timing cost.** ~16-24% power overhead
  over baseline, and post-route critical-path slack drops from +2.2/+2.7ns
  (non-fusion configs) to +0.46/+0.52ns (fusion-enabled configs) at the same
  clock target — a real, measured ~2ns critical-path cost, not an estimate.
- **Isolation-domain scope is nearly free.** Power delta between isolation-scope
  configs is within ±6% and inconsistent in direction (sometimes negative),
  and combining isolation with fusion adds no measurable power or timing cost
  beyond fusion alone.
- **Conclusion:** fusion, not isolation, is the microarchitectural feature
  that actually costs something. Isolation gating can be added for its
  security/measurement-boundary properties essentially for free.

---

## Highlights

- **5 fusion idioms** — pattern-matches instruction pairs commonly emitted by
  real compiler output (e.g. compare+branch, load+use, ADD/ADDI+LW
  zero-offset) and fuses them into a single pipeline slot
- **`pend2` dual-writeback mechanism** — lets a fused pair commit two register
  writes without adding a second write port to the register file, by
  deferring the second write through EX→MEM→WB over the following cycles
- **Isolation gating** (`isol_gate.sv`) — a hardware-enforced execution
  boundary around the muldiv unit, with its own HPM counters
  (`fusion_active_cnt`, `isol_active`) for measurement
- **Verified correct**: 92/92 cycle-accurate lockstep tests against Spike,
  plus 15/15 standalone invariant checks, clean across **all 5 ablation
  configs** (baseline / fusion-only / isolation-only / proposed /
  isolation-scope-ablation)
- **Benchmarked**: Dhrystone, CoreMark, and the full ~19-program Embench-IoT
  suite all run correct and complete on the real RTL, across all 5 configs
- **PPA-characterized**: full SAIF power sweep (5 configs × 4 benchmarks) and
  post-route timing closure (5 configs, all passing) on Artix-7
  (`xc7a100tcsg324-1`)
- **Every anomaly explained, not hand-waved**: two real correctness bugs
  found and fixed with evidence (not guessed), and one performance anomaly
  root-caused to a specific structural tradeoff rather than left as "weird
  behavior we didn't look into" — see [Bugs Found & Fixed](#bugs-found--fixed)

---

## Repo layout

```
rtl/          RTL sources (14 SystemVerilog files, ~1000 lines total)
              core_top_pipelined.sv is the top module
sim/          Verilator testbenches + build script
harness/      Spike lockstep verification harness, test generators
sw/           Test programs (directed .s, randomized .s/.c) + benchmark suite
              (Dhrystone, CoreMark, Embench-IoT ports)
docs/         Design notes, microarchitecture spec
compliance/   RISC-V compliance test binaries
vivado_saif/  Vivado xsim testbench + Tcl scripts for SAIF power capture
RESULTS.md    Full PPA (power + timing) and benchmark data tables
```

## Build & run

```bash
# Build one ablation config (FUSION_EN ISOL_EN BR_CMP_EN <name>)
./sim/build_pipeline.sh 1 1 0 sim_pipeline_D_proposed

# Run the Spike lockstep + standalone verification harness
SIM=./sim_pipeline_D_proposed bash harness/run_lockstep_pipeline.sh
SIM=./sim_pipeline_D_proposed bash harness/standalone_checks.sh
```

**Ablation configs:**

| Config | Fusion | Isolation | Branch-cmp scope |
|---|---|---|---|
| `A_baseline` | off | off | — |
| `B_fusion_only` | on | off | — |
| `C_isol_only` | off | on | — |
| `D_proposed` | on | on | narrow |
| `D_isol_scope_ablation` | on | on | wide |

---

## Architecture

```
        IF          ID          EX          MEM         WB
     +-------+   +-------+   +-------+   +-------+   +-------+
PC-->| fetch |-->| decode|-->|  ALU  |-->|  dmem |-->|  RF   |
     |       |   | fuse  |   | muldiv|   | isol  |   | write |
     +-------+   +-------+   +-------+   +-------+   +-------+
         ^  if_id      id_ex      ex_mem     mem_wb      |
         |__reg________reg________reg________reg_________|
              stall/forward/clear on every stage boundary
```

- Standard 5-stage in-order pipeline with hazard/forward/stall logic in
  `hazard_unit.sv` and a single unified 128KB data/instruction memory
  region.
- Fusion detection happens in decode (`decoder.sv`); a fused pair occupies
  one pipeline slot for its first half and defers its second register write
  through `pend2_active`/`pend2_fire_valid` state machine logic in
  `core_top_pipelined.sv`, draining EX→MEM→WB over the following cycles.
- Isolation gating (`isol_gate.sv`) sits around the muldiv unit
  (`muldiv.sv`/`muldiv_iter.sv`), enforcing a hardware execution boundary and
  exposing `isol_active`/`fusion_active_cnt` via CSR-mapped HPM counters
  (`csr_file.sv`).

---

## Verification

Cycle-accurate lockstep against a Spike (riscv-isa-sim) golden model, plus a
standalone invariant-checking suite, run identically across all 5 ablation
configs:

| Suite | Result |
|---|---|
| Lockstep (directed + control-flow + randomized) | **92/92 PASS** |
| Standalone invariant checks | **15/15 PASS** |
| HPM self-check (fusion/isolation counters vs RTL, 3000+ cycles) | **0 mismatches** |

Every config — `A_baseline`, `B_fusion_only`, `C_isol_only`, `D_proposed`,
`D_isol_scope_ablation` — passes both suites cleanly.

## Benchmarks

All benchmarks run to completion with correct output on the real RTL
(`sim_pipeline_*`), across all 5 configs. Representative single-run figures:

| Benchmark | Result |
|---|---|
| Dhrystone (500 runs) | 707 Dhrystones/sec, ~0.40 DMIPS/MHz |
| CoreMark (20 iterations) | ~1.43 CoreMark/MHz, all 4 CRCs matched |
| Embench-IoT (19 programs) | all `correct=1` across all 5 configs |

Full per-benchmark, per-config cycle counts are in
[`RESULTS.md`](RESULTS.md).

## Results

Full data (power matrix, post-route timing, per-benchmark cycle deltas) is
in [`RESULTS.md`](RESULTS.md). Summary:

**Power** (SAIF-based, post-synthesis, relative estimates — see caveat in
RESULTS.md): fusion adds **~16-24%** over baseline across all 4 benchmarks
tested; isolation-scope alone moves power by **less than 6%**, inconsistently
signed.

**Timing** (post-route, Artix-7, 18ns clock): all 5 configs meet timing with
0 failing endpoints. Non-fusion configs (`A_baseline`, `C_isol_only`) carry
+2.2 to +2.7ns of slack; fusion-enabled configs (`B_fusion_only`,
`D_proposed`, `D_isol_scope_ablation`) sit much closer to the edge at
+0.46 to +0.52ns — fusion is the real critical-path driver.

## Bugs found & fixed

Two real correctness bugs, found via lockstep mismatch and traced to root
cause with cycle-level signal tracing rather than guessed at:

1. **Idiom5 commit-suppression bug** — `core_top_pipelined.sv`'s `if_id_reg`
   `.clear()` OR-chain suppressed the first half of a fused pair for idioms
   1-4, but idiom5 was never added to that list. Its ADD/ADDI half kept
   committing separately (with a corrupted value) *in addition to* the
   correct deferred `pend2` write — one spurious extra commit per idiom5
   activation. On the `ud` benchmark this produced 44,646 extra commits
   versus baseline. Root-caused by counting phantom commits against the
   `pend2`-drain trace, confirmed by exact count match, fixed by adding
   `fuse_idiom5` to the clear condition. Verified zero regression across all
   5 configs after the fix.

2. **Isolation control policy bug** — `muldiv_op_en` was wired to `!isol_en`
   (a flag toggled only by the `FISOL.BOUND`/`FISOL.OFF` diagnostic
   instructions), but those instructions are architecturally specified as a
   no-op measurement-window marker, never a functional gate. Any multiply
   issued during a `FISOL.BOUND` region got the wrong result. Fixed by
   rewiring to the existing EX-local busy latch (`muldiv_active`), the
   actually-correct functional gate per spec. The old test's expected values
   had wrongly codified the buggy behavior as correct — rewritten to check
   invariants (multiply results stay correct regardless of FISOL state)
   instead of pinning stale numbers.

## Known structural tradeoff (documented, not a bug)

Any pend2-based fusion (idioms 3, 5) incurs a flat front-end freeze
(`pend2_stall`, typically 4 cycles) any time a new instruction is ready
while a deferred write is still draining through the shared WB port —
**regardless of whether that instruction actually depends on the pending
register.** This was initially suspected to be a flush-interaction bug, then
a simple RAW hazard; cycle-level tracing showed it's neither — it's a
structural consequence of serializing the deferred write through a single
WB port with no arbitration logic for independent instructions to pass it.

This is why the `ud` benchmark pays this cost heavily (its loop reuses the
fused register almost every iteration) while `huffbench`/`slre` mostly don't
(their fusion instances don't hit the reuse window as often). Adding real
WB-port arbitration to let independent instructions bypass a draining pend2
write would eliminate this cost, but was deliberately left unoptimized as
out-of-scope engineering work rather than an under-pressure bugfix. Disclosed
here rather than silently absorbed into the fusion overhead numbers above.

## Status

- RTL, verification, benchmarking, and PPA characterization: **complete**
  across all 5 ablation configs.
- Open for future work: WB-port arbitration to remove the `pend2_stall`
  structural cost; multi-seed place-and-route variance check on the power
  numbers specifically (current numbers are single-run per config).

## License

MIT — see [LICENSE](LICENSE).
