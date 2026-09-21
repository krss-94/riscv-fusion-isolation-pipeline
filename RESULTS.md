# Results

Full data behind the summary in `README.md`. All numbers below came from
actual runs on the RTL (`sim_pipeline_*`) or actual Vivado synthesis/xsim
reports — none are estimated or backfilled.

## Power (SAIF-based, post-synthesis)

Captured via Vivado xsim SAIF switching-activity dumps, `report_power` per
config per benchmark, Artix-7 (`xc7a100tcsg324-1`). `D_isol_scope_ablation`'s
original power capture used a `post_synth.dcp` that had been silently
rebuilt with `FUSION_EN=0` (see the Timing section above for how this was
found and fixed) — the row below is the corrected recapture on the fixed
checkpoint.

| Config | crc32 (W) | huffbench (W) | matmult-int (W) | nettle-aes (W) |
|---|---|---|---|---|
| A_baseline | 0.157 | 0.210 | 0.142 | 0.200 |
| C_isol_only | 0.166 | 0.211 | 0.148 | 0.206 |
| B_fusion_only | 0.192 | 0.243 | 0.176 | 0.235 |
| D_proposed | 0.192 | 0.244 | 0.175 | 0.241 |
| D_isol_scope_ablation | 0.192 | 0.245 | 0.175 | 0.242 |

**Fusion overhead (B vs A):** crc32 +22.3%, huffbench +15.7%,
matmult-int +23.9%, nettle-aes +17.5% — a tight 16-24% band across every
benchmark tested.

**Isolation overhead alone (C vs A):** crc32 +5.7%, huffbench +0.5%,
matmult-int +4.2%, nettle-aes +3% — small and consistently positive,
unlike fusion.

**Isolation on top of fusion, narrow vs wide scope (D_proposed and
D_isol_scope_ablation vs B_fusion_only):** both land within 0-3% of
`B_fusion_only` across all 4 benchmarks, and the two scope variants are
within 0-2% of each other. Isolation choice barely moves power once fusion
is already on — consistent with the timing result above, where isolation
alone costs almost nothing (~0.06ns) and the narrow/wide scope difference
on top of fusion is small but in the expected direction (wider scope costs
slightly more).

> **Caveat:** Design Nets Matched (fraction of nets with real SAIF switching
> data vs. vectorless/default estimation) ranged 27-39% across all reports.
> The *relative* trends above are trustworthy since the same partial-matching
> methodology applies uniformly across all 5 configs, but the absolute
> wattage figures should be presented as comparative power estimates under
> partial SAIF annotation, not silicon-accurate absolute power.

## Timing (post-route, Artix-7)

Three sweeps were run before landing on a trustworthy number. The first two
used `impl_one.tcl`, run once per config by hand across separate sessions —
this left `D_proposed` built without `maxThreads=1` while the other four
configs had it, and without a `DONT_TOUCH` on the isolation gate cells,
so its numbers weren't apples-to-apples with the rest. The final sweep
(`vivado_impl/impl_all_configs.tcl`) runs all 5 configs back-to-back in one
Vivado batch session with identical settings — that one is the number to
trust.

**14ns — failed for fusion-enabled configs (superseded, kept for history):**

| Config | WNS (ns) | Result |
|---|---|---|
| A_baseline | positive | PASS |
| C_isol_only | +0.691 | PASS |
| B_fusion_only | -2.449 | FAIL |
| D_proposed | -2.449 | FAIL |
| D_isol_scope_ablation | -1.935 | FAIL |

**18ns, inconsistent-flow sweep (superseded — `D_proposed` built separately from the other 4):**

| Config | WNS (ns) | Failing endpoints |
|---|---|---|
| A_baseline | +2.683 | 0 |
| B_fusion_only | +0.522 | 0 |
| C_isol_only | +2.212 | 0 |
| D_proposed | +0.464 | 0 |
| D_isol_scope_ablation | +0.471 | 0 |

**18ns, consistent-flow sweep — final, trusted result.** All 5 configs run
in one session, same `maxThreads=1`, same `DONT_TOUCH` on
`u_isol_gate_a`/`u_isol_gate_b` in every config that has them, full
`report_timing_summary` signoff (not router-estimated numbers):

| Config | WNS (ns) | Est. Fmax | Failing endpoints |
|---|---|---|---|
| A_baseline | +1.551 | 60.8 MHz | 0 |
| B_fusion_only | +0.222 | 56.3 MHz | 0 |
| C_isol_only | +1.493 | 60.6 MHz | 0 |
| D_proposed | +0.543 | 57.3 MHz | 0 |
| D_isol_scope_ablation | +2.791 | 65.8 MHz | 0 |

**What this says:** fusion alone (A→B) costs ~1.33ns of slack — the
dominant timing effect, consistent with the power-side conclusion.
Isolation alone (A→C) costs only ~0.06ns — negligible by itself.

**What it does NOT say, stated plainly:** the combined configs don't show
isolation adding a further cost on top of fusion. `D_proposed`
(fusion+isolation, narrow scope) has *more* slack than `B_fusion_only`
(fusion alone) — +0.543ns vs +0.222ns. `D_isol_scope_ablation`
(fusion+isolation, wide scope) has the *best* slack of all 5 configs,
better than baseline, despite fusion being enabled. This is a real,
reproducible result from the consistent-flow run, not placer noise — the
noise question is specifically what the consistent-flow rerun was meant to
resolve. No confirmed root cause exists yet for why the combined configs
land here; a plausible but unverified guess is that `DONT_TOUCH` on the
isolation gate cells happens to give the placer a better starting point in
these two configs specifically. Reported as an open question rather than
forced into a clean story the earlier, inconsistent-flow data seemed to
suggest.

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
