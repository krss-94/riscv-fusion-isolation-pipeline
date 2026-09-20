# RISC-V Fusion/Isolation Pipeline

![ISA](https://img.shields.io/badge/ISA-RV32IM-blue)
![Language](https://img.shields.io/badge/RTL-SystemVerilog-informational)
![Verification](https://img.shields.io/badge/Lockstep-92%2F92%20PASS-success)
![Standalone](https://img.shields.io/badge/Standalone-15%2F15%20PASS-success)
![Configs](https://img.shields.io/badge/Ablation%20Configs-5-orange)
![Timing](https://img.shields.io/badge/Post--Route%20Timing-CLOSED-success)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

A 5-stage in-order RV32IM pipeline in SystemVerilog, extended with two
hardware research features on top of a standard IF→ID→EX→MEM→WB core:
**macro-op instruction fusion** and a **hardware isolation-gating scheme**
for the multiply/divide unit. Built to answer one concrete research
question — *does fusion, isolation, or both, actually save power, and at
what cost?* — and answered with real post-synthesis silicon-target
measurement, not simulation estimates.

> Legacy note: earlier notes/commit history call this "ooo" (out-of-order).
> It isn't — no ROB, no reservation stations, no OOO issue/retirement. It's
> an in-order 5-stage pipeline with fusion + isolation. Naming kept for
> history's sake, not corrected retroactively.

---

## Table of contents

- [Scale of this project](#scale-of-this-project)
- [Research question and answer](#research-question-and-answer)
- [Architecture](#architecture)
- [Verification](#verification)
- [Benchmarks](#benchmarks)
- [Results (Power + Timing)](#results)
- [Bugs found & fixed](#bugs-found--fixed)
- [Known structural tradeoff](#known-structural-tradeoff-documented-not-a-bug)
- [Build & run](#build--run)
- [Repo layout](#repo-layout)
- [Status](#status)

---

## Scale of this project

This isn't a class-assignment single-cycle core. What's actually in this repo:

| | |
|---|---|
| **RTL** | 14 SystemVerilog modules, ~1000 lines, full 5-stage pipeline + fusion detector + isolation gate + CSR/HPM file + iterative muldiv unit |
| **Ablation configs** | 5 independently built and verified configurations (baseline / fusion-only / isolation-only / proposed / isolation-scope-ablation) |
| **Verification** | 92/92 cycle-accurate lockstep tests vs. a Spike golden model + 15/15 standalone invariant checks + HPM self-check — **all 5 configs, every suite, zero failures** |
| **ISA compliance** | Full official `rv32ui` / `rv32um` / `rv32mi` compliance suite (68 official RISC-V test binaries) |
| **Benchmarks** | Dhrystone, CoreMark, and the full ~19-program Embench-IoT suite — every program runs correct across all 5 configs |
| **PPA characterization** | Full SAIF-based power sweep (5 configs × 4 benchmarks = 20 synthesis+xsim runs) and post-route timing closure on Artix-7, iterated through 3 clock-constraint attempts (100ns → 14ns → 18ns) until every config genuinely passed |
| **Real bugs found & fixed** | 2 functional correctness bugs (traced via cycle-level signal analysis to exact root cause, not guessed), plus 1 structural performance anomaly fully explained and disclosed |
| **Custom toolchain work** | Bare-metal C runtime built from scratch (no libc on this toolchain) — hand-rolled `printf`/`string` libs, linker scripts, board-support layers for 3 separate benchmark suites |

Every number above is backed by an actual logged run — see [`RESULTS.md`](RESULTS.md) for the raw data.

---

## Research question and answer

**Question:** does instruction fusion, muldiv isolation, or the combination
of both, reduce power — and what does each cost?

**Answer, from real post-synthesis measurement:**

| Effect | Finding |
|---|---|
| **Fusion power cost** | +16% to +24% over baseline, consistent across all 4 benchmarks tested |
| **Fusion timing cost** | Post-route slack drops from +2.2/+2.7ns (no fusion) to +0.46/+0.52ns (fusion) at the same clock target — a real, measured ~2ns critical-path cost |
| **Isolation power cost** | Within ±6% of baseline, inconsistent in sign (sometimes negative) |
| **Isolation + fusion combined vs. fusion alone** | No measurable extra cost |

**Conclusion:** fusion is the microarchitectural feature that actually costs
power and timing. Isolation gating — for its security/measurement-boundary
value — comes essentially for free.

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
  `hazard_unit.sv`, single unified 128KB memory region.
- Fusion detected in decode (`decoder.sv`); a fused pair occupies one
  pipeline slot and defers its second register write through a `pend2`
  state machine in `core_top_pipelined.sv`, draining EX→MEM→WB over the
  following cycles instead of requiring a second regfile write port.
- Isolation gating (`isol_gate.sv`) wraps the muldiv unit
  (`muldiv.sv`/`muldiv_iter.sv`) with a hardware execution boundary,
  exposed via CSR-mapped HPM counters in `csr_file.sv`.

**Ablation configs:**

| Config | Fusion | Isolation | Branch-cmp scope |
|---|:---:|:---:|:---:|
| `A_baseline` | ✗ | ✗ | — |
| `B_fusion_only` | ✓ | ✗ | — |
| `C_isol_only` | ✗ | ✓ | — |
| `D_proposed` | ✓ | ✓ | narrow |
| `D_isol_scope_ablation` | ✓ | ✓ | wide |

---

## Verification

| Suite | Configs | Result |
|---|---|---|
| Lockstep vs. Spike (directed + control-flow + randomized) | all 5 | **92/92 PASS** |
| Standalone invariant checks | all 5 | **15/15 PASS** |
| Official RISC-V compliance (`rv32ui`/`rv32um`/`rv32mi`) | — | **68/68 PASS** |
| HPM self-check (fusion/isolation counters vs. RTL, 3000+ cycles) | 2 binaries | **0 mismatches** |

---

## Benchmarks

| Benchmark | Result |
|---|---|
| Dhrystone (500 runs) | 707 Dhrystones/sec, ~0.40 DMIPS/MHz |
| CoreMark (20 iterations) | ~1.43 CoreMark/MHz, all 4 CRCs matched |
| Embench-IoT (19 programs) | `correct=1` across all 5 configs |

Full per-benchmark, per-config cycle counts (including the fusion-cost
breakdown per benchmark) are in [`RESULTS.md`](RESULTS.md).

---

## Results

**Power** (SAIF-based, post-synthesis) — fusion adds **~16-24%** over
baseline; isolation-scope alone moves power by **less than 6%**,
inconsistently signed. *(Caveat: SAIF net-matching was 27-39% per report —
relative trends are trustworthy, absolute wattage should be read as a
comparative estimate. Full detail in RESULTS.md.)*

**Timing** (post-route, Artix-7, 18ns clock) — all 5 configs pass, 0 failing
endpoints. Non-fusion configs carry +2.2 to +2.7ns slack; fusion-enabled
configs sit at +0.46 to +0.52ns.

Full power matrix and both timing-closure attempts (14ns fail → 18ns pass)
are in [`RESULTS.md`](RESULTS.md).

---

## Bugs found & fixed

**1. Idiom5 commit-suppression bug** — `core_top_pipelined.sv`'s `if_id_reg`
`.clear()` OR-chain suppressed the first half of a fused pair for idioms
1-4, but idiom5 was never added. Its ADD/ADDI half kept committing
separately *in addition to* the correct deferred `pend2` write — one
spurious extra commit per idiom5 activation, 44,646 extra commits on the
`ud` benchmark. Root-caused via phantom-commit counting against the
`pend2`-drain trace, fixed by adding `fuse_idiom5` to the clear condition,
verified zero regression across all 5 configs.

**2. Isolation control policy bug** — `muldiv_op_en` was wired to `!isol_en`
(toggled only by diagnostic `FISOL.BOUND`/`FISOL.OFF` instructions,
architecturally a no-op measurement marker, never a functional gate). Any
multiply issued during a `FISOL.BOUND` region got the wrong result. Fixed by
rewiring to the correct existing gate (`muldiv_active`); the old test had
wrongly codified the buggy behavior as expected — rewritten to check
invariants instead of pinning stale values.

## Known structural tradeoff (documented, not a bug)

Any pend2-based fusion (idioms 3, 5) incurs a flat ~4-cycle front-end freeze
any time a new instruction is ready while a deferred write drains through
the shared WB port — regardless of whether that instruction depends on the
pending register. Traced through two wrong hypotheses (flush-interaction,
then simple RAW hazard) before confirming the real cause: no WB-port
arbitration exists for independent instructions to bypass a draining
`pend2` write. This is why `ud` (reuses the fused register almost every
loop iteration) pays it hard while `huffbench`/`slre` mostly don't. Left
unoptimized deliberately rather than adding real WB-port arbitration under
time pressure — disclosed here rather than silently absorbed into the
fusion overhead numbers.

---

## Build & run

```bash
# Build one ablation config (FUSION_EN ISOL_EN BR_CMP_EN <name>)
./sim/build_pipeline.sh 1 1 0 sim_pipeline_D_proposed

# Run the Spike lockstep + standalone verification harness
SIM=./sim_pipeline_D_proposed bash harness/run_lockstep_pipeline.sh
SIM=./sim_pipeline_D_proposed bash harness/standalone_checks.sh
```

## Repo layout

```
rtl/          RTL sources (14 SystemVerilog files, ~1000 lines total)
              core_top_pipelined.sv is the top module
sim/          Verilator testbenches + build script
harness/      Spike lockstep verification harness, test generators
sw/           Test programs (directed .s, randomized .s/.c) + benchmark suite
              (Dhrystone, CoreMark, Embench-IoT ports)
docs/         Design notes, microarchitecture spec, raw verification logs
compliance/   Official RISC-V compliance test binaries (68 tests)
vivado_saif/  Vivado xsim testbench + Tcl scripts for SAIF power capture
RESULTS.md    Full PPA (power + timing) and benchmark data tables
```

## Status

- RTL, verification, benchmarking, and PPA characterization: **complete**
  across all 5 ablation configs.
- Open for future work: WB-port arbitration to remove the `pend2_stall`
  structural cost; multi-seed place-and-route variance check on the power
  numbers.

## License

MIT — see [LICENSE](LICENSE).

