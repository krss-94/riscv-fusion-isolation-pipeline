# RISC-V Fusion/Isolation Pipeline

A 5-stage in-order RV32IM pipeline in SystemVerilog, extended with two
microarchitectural research features on top of a standard IF→ID→EX→MEM→WB
core: macro-op instruction fusion, and a hardware isolation-gating scheme
for the multiply/divide unit. Verified via cycle-accurate lockstep against
a Spike golden model, benchmarked on Dhrystone/CoreMark/Embench-IoT, and
characterized for power and timing via Vivado synthesis and post-route
implementation targeting an Artix-7 device.

> Note: earlier commit history and some internal paths refer to this as
> "ooo" (out-of-order). It is not out-of-order — no ROB, no reservation
> stations, no OOO issue/retirement. It is an in-order 5-stage pipeline
> with instruction fusion and isolation gating. Naming kept for history,
> not corrected retroactively.

---

## Research question

Does instruction fusion, muldiv isolation, or the combination of both,
reduce power — and what does each cost in return? Answered below with
post-synthesis power and post-route timing measurement, not simulation
estimates.

## Ablation configurations

| Config | Fusion | Isolation | Branch-cmp scope |
|---|:---:|:---:|:---:|
| `A_baseline` | off | off | — |
| `B_fusion_only` | on | off | — |
| `C_isol_only` | off | on | — |
| `D_proposed` | on | on | narrow |
| `D_isol_scope_ablation` | on | on | wide |

All five configs are independently built, verified, benchmarked, and
synthesized — the comparisons below are apples-to-apples across all five,
not just the "proposed" config in isolation.

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

- Standard 5-stage in-order pipeline; hazard/forward/stall logic in
  `hazard_unit.sv`; single unified 128KB memory region.
- Fusion is detected in decode (`decoder.sv`). A fused pair occupies one
  pipeline slot; its second register write is deferred through a `pend2`
  state machine in `core_top_pipelined.sv` and drains EX→MEM→WB over the
  following cycles instead of requiring a second regfile write port.
- Isolation gating (`isol_gate.sv`) wraps the muldiv unit
  (`muldiv.sv`/`muldiv_iter.sv`) with a hardware execution boundary,
  exposed via CSR-mapped HPM counters in `csr_file.sv`.

---

## Verification

Cycle-accurate lockstep against Spike (riscv-isa-sim), plus a standalone
invariant-checking suite and the official RISC-V compliance suite, run
identically across all 5 configs:

| Suite | Result |
|---|---|
| Lockstep vs. Spike (directed + control-flow + randomized) | 92/92 PASS |
| Standalone invariant checks | 15/15 PASS |
| Official RISC-V compliance (`rv32ui`/`rv32um`/`rv32mi`) | 68/68 PASS |
| HPM self-check (fusion/isolation counters vs. RTL, 3000+ cycles) | 0 mismatches |

## Benchmarks

Dhrystone, CoreMark, and the full ~19-program Embench-IoT suite, all
running to completion with correct output on the real RTL across all 5
configs:

| Benchmark | Result |
|---|---|
| Dhrystone (500 runs) | 707 Dhrystones/sec, ~0.40 DMIPS/MHz |
| CoreMark (20 iterations) | ~1.43 CoreMark/MHz, all 4 CRCs matched |
| Embench-IoT (19 programs) | `correct=1`, all 5 configs |

---

## Power (SAIF-based, post-synthesis, Artix-7 `xc7a100tcsg324-1`)

`D_isol_scope_ablation`'s original power capture used a `post_synth.dcp`
that had been silently rebuilt with fusion disabled (see the Timing
section for how this was caught and fixed) — the row below is the
corrected recapture on the fixed checkpoint.

| Config | crc32 (W) | huffbench (W) | matmult-int (W) | nettle-aes (W) |
|---|---|---|---|---|
| A_baseline | 0.157 | 0.210 | 0.142 | 0.200 |
| C_isol_only | 0.166 | 0.211 | 0.148 | 0.206 |
| B_fusion_only | 0.192 | 0.243 | 0.176 | 0.235 |
| D_proposed | 0.192 | 0.244 | 0.175 | 0.241 |
| D_isol_scope_ablation | 0.188 | 0.245 | 0.175 | 0.242 |

- **Fusion overhead (B vs. A):** +22.3% (crc32), +15.7% (huffbench), +23.9% (matmult-int), +17.5% (nettle-aes)
- **Isolation overhead alone (C vs. A):** +5.7%, +0.5%, +4.2%, +3% — small and consistently positive
- **Isolation on top of fusion, narrow vs. wide scope (D_proposed and D_isol_scope_ablation vs. B_fusion_only):** both within 0-3% of fusion-only, and the two scope variants within 0-2% of each other — isolation choice barely moves power once fusion is on

> Caveat: Design Nets Matched (fraction of nets with real SAIF switching
> data) was 27-39% across all reports. Relative trends above are reliable
> since the same partial-matching methodology applies uniformly across all
> 5 configs; absolute wattage should be read as a comparative estimate
> under partial SAIF annotation, not silicon-accurate absolute power.

## Timing (post-route, Artix-7)

Two earlier sweeps at 18ns are superseded and kept below for history. The
final sweep also caught and fixed a real bug: `D_isol_scope_ablation`'s
`post_synth.dcp` had been silently rebuilt at some point with `FUSION_EN=0`
instead of `1` (confirmed via `check_fusion_enabled.tcl`, which found zero
fusion-related cells in that checkpoint while `B_fusion_only`/`D_proposed`
showed nonzero counts). Every number attributed to that config in every
earlier sweep — including the SAIF power table above — was actually
isolation-only with a different scope setting, not fusion+isolation. The
checkpoint was rebuilt with the correct parameters
(`synth_one.tcl D_isol_scope_ablation 1 1 1`) and reverified before the
final numbers below were captured.

**First 18ns sweep (superseded — `D_proposed` built in a separate session from the other 4):**

| Config | WNS (ns) | Failing endpoints |
|---|---|---|
| A_baseline | +2.683 | 0 |
| B_fusion_only | +0.522 | 0 |
| C_isol_only | +2.212 | 0 |
| D_proposed | +0.464 | 0 |
| D_isol_scope_ablation | +0.471 | 0 |

**Second 18ns sweep (superseded — consistent flow, but `D_isol_scope_ablation`'s checkpoint was silently built without fusion):**

| Config | WNS (ns) | Failing endpoints |
|---|---|---|
| A_baseline | +1.551 | 0 |
| B_fusion_only | +0.222 | 0 |
| C_isol_only | +1.493 | 0 |
| D_proposed | +0.543 | 0 |
| D_isol_scope_ablation | +2.791 | 0 |

**18ns, final — consistent flow, `D_isol_scope_ablation` checkpoint fixed and reverified. This is the trusted result:**

| Config | WNS (ns) | Est. Fmax | Failing endpoints |
|---|---|---|---|
| A_baseline | +1.551 | 60.8 MHz | 0 |
| C_isol_only | +1.493 | 60.6 MHz | 0 |
| D_proposed | +0.543 | 57.3 MHz | 0 |
| D_isol_scope_ablation | +0.295 | 56.5 MHz | 0 |
| B_fusion_only | +0.222 | 56.3 MHz | 0 |

All 5 configs meet timing at 18ns (~55.6MHz), 0 failing endpoints. The
ordering is now monotonic and makes sense: baseline and isolation-only sit
close together at the top — isolation alone costs almost nothing
(~0.06ns, A→C). The two fusion+isolation combined configs sit in the
middle. Fusion-only sits at the bottom, confirming fusion is the dominant
timing cost (~1.33ns, A→B). Narrow isolation scope (`D_proposed`) costs
less than wide scope (`D_isol_scope_ablation`) on top of fusion, which is
the expected direction — a wider isolation boundary constrains more of the
design.

Full per-benchmark critical-path breakdown and DRC results are in
[`RESULTS.md`](RESULTS.md).

**Conclusion:** fusion is the microarchitectural feature that costs power
and timing. Isolation gating, for its security/measurement-boundary value,
is close to free on both axes.

Full per-benchmark cycle-count deltas and fusion-activation counts are in
[`RESULTS.md`](RESULTS.md).

---

## Bugs found & fixed

**1. Idiom5 commit-suppression bug.** `core_top_pipelined.sv`'s `if_id_reg`
`.clear()` OR-chain suppressed the first half of a fused pair for idioms
1-4, but idiom5 was never added to that list. Its ADD/ADDI half kept
committing separately — with a corrupted value — in addition to the correct
deferred `pend2` write, producing one spurious extra commit per idiom5
activation. On the `ud` benchmark this produced 44,646 extra commits versus
baseline. Root-caused by counting phantom commits against the `pend2`-drain
trace and confirming an exact count match; fixed by adding `fuse_idiom5` to
the clear condition. Verified zero regression across all 5 configs.

**2. Isolation control policy bug.** `muldiv_op_en` was wired to `!isol_en`
— a flag toggled only by the `FISOL.BOUND`/`FISOL.OFF` diagnostic
instructions, which are architecturally specified as a no-op
measurement-window marker, never a functional gate. Any multiply issued
during a `FISOL.BOUND` region produced the wrong result. Fixed by rewiring
to the existing EX-local busy latch (`muldiv_active`), the correct
functional gate per spec. The prior test had wrongly codified the buggy
behavior as expected output; rewritten to check invariants instead of
pinning stale values.

## Known structural tradeoff (documented, not a bug)

Any pend2-based fusion (idioms 3, 5) incurs a flat ~4-cycle front-end
freeze any time a new instruction is ready while a deferred write is still
draining through the shared WB port, regardless of whether that
instruction depends on the pending register. Two incorrect hypotheses were
ruled out before finding the real cause — first suspected as a
flush-interaction, then as a simple RAW hazard — before cycle-level tracing
showed the actual mechanism: there is no WB-port arbitration for
independent instructions to bypass a draining `pend2` write, so the freeze
is structural, not a hazard check. This is why the `ud` benchmark (whose
loop reuses the fused register almost every iteration) pays this cost
heavily while `huffbench`/`slre` mostly don't. Adding WB-port arbitration
would remove this cost but was deliberately left as future work rather than
an under-pressure redesign; disclosed here rather than silently absorbed
into the fusion overhead numbers above.

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
compliance/   Official RISC-V compliance test binaries
vivado_saif/  Vivado xsim testbench + Tcl scripts for SAIF power capture
RESULTS.md    Full per-benchmark cycle-count and fusion-activation data
```

## Status

RTL, verification, benchmarking, and PPA characterization are complete
across all 5 ablation configs. Open for future work: WB-port arbitration to
remove the `pend2_stall` structural cost described above, and a multi-seed
place-and-route variance check on the power numbers specifically (current
figures are single-run per config).

## License

MIT — see [LICENSE](LICENSE).
