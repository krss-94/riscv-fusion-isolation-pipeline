# Results

Full data behind the summary in `README.md`. All numbers below came from
actual runs on the RTL (`sim_pipeline_*`) or actual Vivado synthesis/xsim
reports -- none are estimated or backfilled. **Every PPA figure is a single
run per config** (one place-and-route, one SAIF capture); differences of a
few percent in power or a few tenths of a ns in slack are within what a
multi-seed run could move, and are not claimed as effects below.

## Power (SAIF-based, post-synthesis)

Captured via Vivado xsim SAIF switching-activity dumps, `report_power` per
config per benchmark, Artix-7 (`xc7a100tcsg324-1`). `D_isol_scope_ablation`'s
original power capture used a `post_synth.dcp` that had been silently
rebuilt with `FUSION_EN=0` (see the Timing section below for how this was
found and fixed) -- the row below is the corrected recapture on the fixed
checkpoint.

| Config | crc32 (W) | huffbench (W) | matmult-int (W) | nettle-aes (W) |
|---|---|---|---|---|
| A_baseline | 0.157 | 0.210 | 0.142 | 0.200 |
| C_isol_only | 0.166 | 0.211 | 0.148 | 0.206 |
| B_fusion_only | 0.192 | 0.243 | 0.176 | 0.235 |
| D_proposed | 0.192 | 0.244 | 0.175 | 0.241 |
| D_isol_scope_ablation | 0.192 | 0.245 | 0.175 | 0.242 |

**Fusion overhead (B vs A):** crc32 +22.3%, huffbench +15.7%,
matmult-int +23.9%, nettle-aes +17.5% -- a tight 16-24% band across every
benchmark tested.

**Isolation overhead alone (C vs A):** crc32 +5.7%, huffbench +0.5%,
matmult-int +4.2%, nettle-aes +3% -- small and consistently positive,
unlike fusion.

**Isolation on top of fusion (D_proposed and D_isol_scope_ablation vs
B_fusion_only):** both land within 0-3% of `B_fusion_only` across all 4
benchmarks. Isolation barely moves power once fusion is already on.

**About the two D configs:** they differ only in `BR_CMP_EN`, which in the
RTL feeds only the `isol_active_cnt` HPM counter (`core_top_pipelined.sv`
lines 382-383) and does not change the isolation gates. So
`D_isol_scope_ablation` is not a real "wide vs narrow isolation scope"
experiment, and no scope effect is claimed. The two D rows agree to within
0-2%, as expected for near-identical hardware.

> **Caveat, refined 2026-09-28:** The blanket "27-39% nets matched" figure
> masks a large spread by hierarchy block, confirmed via targeted
> `report_switching_activity` sampling on `D_proposed`/crc32: isolation
> gates `u_isol_gate_a`/`u_isol_gate_b` (the actual mechanism this paper's
> isolation-overhead claim rests on) are **97.98% SAIF-verified**; pipeline
> stage registers (`u_id_ex`/`u_ex_mem`/`u_mem_wb`) range **58-93%**; the
> muldiv unit's internal control FSM is only **18.9%** verified. That gap
> was isolated to a synthesis netlist-matching failure in the FSM's
> re-encoded next-state logic (`FSM_sequential_state[*]_i_*_n_0` nodes
> report an identical flat 0.5 default regardless of workload -- confirmed
> by comparing a mul-free benchmark, crc32, against a mul-heavy one,
> matmult-int, and finding byte-identical values), not a workload-dependent
> measurement gap or evidence the unit was idle. **Isolation-overhead power
> numbers above are high-confidence. Any claim about the muldiv unit's own
> internal switching specifically should not be treated as SAIF-verified.**

## Timing (post-route, Artix-7)

Several sweeps were run before landing on a trustworthy number. The first
two used `impl_one.tcl`, run once per config by hand across separate
sessions -- this left `D_proposed` built without `maxThreads=1` while the
other four configs had it, and without a `DONT_TOUCH` on the isolation gate
cells, so its numbers weren't apples-to-apples with the rest. The later
sweep (`vivado_impl/impl_all_configs.tcl`) runs all 5 configs back-to-back
in one Vivado batch session with identical settings.

**14ns -- failed for fusion-enabled configs (superseded, kept for history):**

| Config | WNS (ns) | Result |
|---|---|---|
| A_baseline | positive | PASS |
| C_isol_only | +0.691 | PASS |
| B_fusion_only | -2.449 | FAIL |
| D_proposed | -2.449 | FAIL |
| D_isol_scope_ablation | -1.935 | FAIL |

**18ns, inconsistent-flow sweep (superseded -- `D_proposed` built separately from the other 4):**

| Config | WNS (ns) | Failing endpoints |
|---|---|---|
| A_baseline | +2.683 | 0 |
| B_fusion_only | +0.522 | 0 |
| C_isol_only | +2.212 | 0 |
| D_proposed | +0.464 | 0 |
| D_isol_scope_ablation | +0.471 | 0 |

**18ns, consistent-flow sweep -- superseded.** `D_isol_scope_ablation`'s
`+2.791ns` result in this sweep turned out to be built from a
`post_synth.dcp` that had been silently rebuilt with `FUSION_EN=0` (found
via `check_fusion_enabled.tcl`, which showed zero fusion-related cells in
that checkpoint vs. nonzero counts for `B_fusion_only`/`D_proposed`). Every
number attributed to that config in this sweep -- and the "no confirmed root
cause" discussion that followed it -- was actually isolation-only, not
fusion+isolation. Kept for history; see the corrected result underneath.

| Config | WNS (ns) | Est. Fmax | Failing endpoints |
|---|---|---|---|
| A_baseline | +1.551 | 60.8 MHz | 0 |
| B_fusion_only | +0.222 | 56.3 MHz | 0 |
| C_isol_only | +1.493 | 60.6 MHz | 0 |
| D_proposed | +0.543 | 57.3 MHz | 0 |
| D_isol_scope_ablation | +2.791 | 65.8 MHz | 0 |

**18ns, final -- `D_isol_scope_ablation` checkpoint rebuilt with correct
parameters (`synth_one.tcl D_isol_scope_ablation 1 1 1`) and reverified.
Single run per config:**

| Config | WNS (ns) | Est. Fmax | Failing endpoints |
|---|---|---|---|
| A_baseline | +1.551 | 60.8 MHz | 0 |
| C_isol_only | +1.493 | 60.6 MHz | 0 |
| D_proposed | +0.543 | 57.3 MHz | 0 |
| D_isol_scope_ablation | +0.295 | 56.5 MHz | 0 |
| B_fusion_only | +0.222 | 56.3 MHz | 0 |

**What this says:** fusion alone (A->B) costs ~1.33ns of slack -- the
dominant timing effect, consistent with the power-side conclusion.
Isolation alone (A->C) costs ~0.06ns, which is within what one run can
distinguish from noise, so the honest reading is "no measurable timing cost
from isolation alone".

**What it does not say:** the three fusion configs (B +0.222, D_isol_scope
+0.295, D_proposed +0.543) sit within about 0.3ns of each other, from one
place-and-route run each. `D_proposed` has slightly *more* slack than
`B_fusion_only`, so there is no evidence that isolation adds timing cost on
top of fusion. The 0.25ns gap between `D_proposed` and
`D_isol_scope_ablation` is **not** a scope effect: those two configs differ
only in `BR_CMP_EN`, which does not change the isolation gates (see the
Power section). Treat it as place-and-route variation, and do not rank B,
D_proposed and D_isol_scope_ablation against each other. A multi-seed run
would put a real spread on this.

### DRC (from an earlier single-config deep-dive session)

0 errors, 3 benign warnings — structural, not placement-dependent, so this
carries over to the consistent-flow configs:
- **REQP-1839** — async reset on `alu_result_out_reg` feeding `dmem`'s
  address pins. Harmless unless `rst_n` fires mid-operation; not fixed,
  documented as a known warning.
- **CFGBVS-1** — cosmetic, config-bank voltage properties unset. Only
  matters for a real board bitstream.
- **RTSTAT-10** — 103 debug-only nets (`dbg_mem_pc[*]` etc.) with no
  routable loads. Expected, not an issue.

### Critical path (from `report_timing_summary`'s worst-path breakdown)

All 10 worst paths share one shape: `dmem_reg_0_0_7` (a data-memory BRAM)
read, through 15 logic levels, to `imem_reg_0_*`'s `ENBWREN` (fanout 51) /
`RSTRAMARSTRAM`/`RSTRAMB` (fanout 96) control pins. 75% of the ~17.3ns path
is net delay, not logic delay — the path is routing-bound. Cheapest lever,
not yet applied: `phys_opt_design -directive AggressiveFanoutOpt`, or
hand-replicating the stall/flush driver feeding those imem control pins.

## Cross-check: relative area in open-source flows (synthesis only)

An independent check of the area deltas, using open-source flows. Relative
numbers only: these are different libraries and nodes from Artix-7, with
the memory shrunk to keep runtimes sane (same size in every config, 4 KB for
the yosys runs, 1 KB for ORFS). Not timing and not power.

| Flow | Stage | Fusion (B vs A) | Isolation (C vs A) | D_proposed vs A | D_isol_scope vs D_proposed |
|---|---|---|---|---|---|
| yosys + sky130_fd_sc_hd, 4 KB | synthesis | +2.10% | +0.26% | +2.29% | +0.06% |
| yosys + Nangate45, 4 KB | synthesis | +2.01% | +0.27% | +2.27% | +0.03% |
| OpenROAD-flow-scripts sky130hd, 1 KB | post-route | +5.01% | +0.87% | +5.38% | +0.80% |

Fusion costs a few percent of area, isolation under 1%, and the two D
configs are essentially the same hardware, consistent with the Vivado
conclusions. The percentages grow as the memory shrinks because the fusion
logic is a fixed cost against less memory area. The ORFS slack and
vectorless power from the same runs are not reported: slack differences
there were within run-to-run noise and power is not SAIF-based.

## Benchmarks

Representative single-run results (functional correctness across all 5
configs; cycle counts vary by config where fusion is active):

| Benchmark | Metric | Result |
|---|---|---|
| Dhrystone (NUMBER_OF_RUNS=500) | throughput | 1414 µs/run, 707 Dhrystones/sec (~0.40 DMIPS/MHz) |
| CoreMark (ITERATIONS=20) | ticks | 14,011,383 total (~14s), all 4 CRCs matched, correct operation validated (~1.43 CoreMark/MHz) |
| Embench-IoT crc32 | cycles | 10,969,806, correct=1 |

Full Embench-IoT suite (~19 programs) runs `correct=1` on all 5 ablation
configs.

### Fusion-path cycle-count deltas vs A_baseline (selected benchmarks)

| Benchmark | Δ cycles (B_fusion_only vs A_baseline) | Fusion activations | Cost per activation |
|---|---|---|---|
| ud | +178,500 | 44,629 | ~4.00 cycles/activation (flat) |
| huffbench | +44 | 92 | ~0.48 cycles/activation |
| nettle-aes | +228 | 992 | ~0.23 cycles/activation |
| slre | +464 | 1,513 | ~0.31 cycles/activation |
| sglib-combined | -2,573 | 21,210 | -0.12 cycles/activation (net faster) |

`ud`'s near-exact flat 4-cycles-per-activation cost is the structural
`pend2_stall` cost described in the README — its hot loop reuses the fused
register almost every iteration, so it pays the full front-end freeze nearly
every time fusion fires. The other benchmarks mostly don't hit that reuse
window, so their average per-activation cost is much smaller or, in
sglib-combined's case, net positive (correctness was independently confirmed
via its own internal check, not just cycle count).

## Verification

| Suite | Configs | Result |
|---|---|---|
| Lockstep vs Spike (directed + control-flow + randomized) | all 5 | 92/92 PASS |
| Standalone invariant checks | all 5 | 15/15 PASS |
| HPM self-check (fusion/isolation counters vs RTL, 3000+ cycles) | 2 test binaries | 0 mismatches |
