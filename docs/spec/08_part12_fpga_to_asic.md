# Custom-ISA Processor Research Project
## Part 12 — FPGA-to-ASIC Discussion

*Builds on Parts 7–11. This section exists to keep one promise made at the very start of this project: never present FPGA results as if they were ASIC — let alone advanced-node — silicon data.*

## 1. What Parts 7–11 actually prove

The methodology in Part 11 produces: relative LUT/FF/BRAM/DSP area differences between architectural configurations, on one specific FPGA fabric; relative achievable-frequency differences, on that same fabric's routing and logic structure; and relative dynamic-power differences, estimated from real switching activity but still computed through Vivado's FPGA-specific power model, not measured from silicon. These are legitimate, meaningful results — they directly answer the research question ("does decoder-driven isolation, combined with fusion, produce a measurable power/area effect") on the platform where they were measured.

## 2. What Parts 7–11 do not prove

They do not establish how large the same effect would be in a standard-cell ASIC implementation, at any node. FPGA LUTs, routing fabric, and BRAM primitives have area/power/delay characteristics structurally different from standard cells — a technique that saves switching activity in an FPGA's routing-heavy datapath is not guaranteed to save a proportionally similar amount in a standard-cell datapath with different wire-to-gate capacitance ratios. **No claim in this project's results should ever be phrased as being about 7 nm, 5 nm, or any advanced node**, because no advanced-node data of any kind — real or predictive — has been generated. This is worth restating explicitly rather than assuming it's obvious, since it is exactly the kind of claim that's easy to overstate by accident in a results section under deadline pressure.

## 3. Is an open-source ASIC track realistically possible for this project?

Yes, as an **optional, secondary** track — this reuses the Cluster 8 findings from Part 1's literature review directly. OpenROAD/OpenLane is a mature, actively-maintained open RTL-to-GDSII flow, with two viable technology targets:

- **SkyWater130 (SKY130)** — a real, fabricated, open PDK. Using it produces results traceable to an actual manufacturable process, just an old one (130 nm) far from "advanced node" in the sense your original brief cares about. Its value here isn't node-relevance; it's that it's the most credible "this is standard-cell, not FPGA-fabric" data point available without an NDA.
- **ASAP7** — a predictive, academic 7 nm PDK, integrated with OpenROAD specifically to let academic groups explore advanced-node-scale designs without foundry access. It is **not** real 7 nm silicon data — it's a modeled, non-manufacturable technology used for *relative* comparisons between architectural variants, not for absolute claims about real 7 nm power/area/frequency. This distinction must be stated every single time ASAP7 numbers appear, not just once in a caveats section.

Both are realistically usable within an undergraduate/masters-scale timeline **if scoped narrowly** — full timing closure at aggressive targets is measurably weaker with the fully open flow than with commercial tools (Part 1's Cluster 8 finding, from the DVCon RISC-V-core comparison), so this track should not attempt to match commercial-flow timing quality, only to check *directional* PPA agreement with the FPGA results.

## 4. Optional Track 3: RTL → open-source ASIC flow, run in parallel with Parts 7–11

If pursued, this reuses exactly the four configurations (A–D) and the isolation-scope ablation already defined in Part 11 — no new architectural variants need to be designed, which keeps the added cost bounded to tooling/flow work rather than new RTL:

```
RTL (Parts 7–8)
 ├─→ Vivado FPGA synthesis → Track 1 (fixed clock) / Track 2 (Fmax sweep) — Part 11
 └─→ OpenLane/OpenROAD → SKY130 (and, time permitting, ASAP7) → Track 3
```

**Track 3's own fixed-clock discipline.** The same confound Part 11 §1.3 identified for FPGA (comparing power/area at different frequencies conflates the architectural effect with frequency itself) applies identically here. Track 3 therefore follows the same two-part structure as Track 1/Track 2: a primary standard-cell PPA comparison at one fixed, comfortably-met clock period across all configurations, plus a separate achievable-Fmax characterization if there's time for it — not one number that quietly mixes both questions.

**What Track 3 would actually add, if it agrees with Parts 7–11:** evidence that the isolation/fusion effect isn't an FPGA-fabric artifact — i.e., that the *direction* of the result (proposed architecture uses less switching-activity-derived power than baseline, at comparable area) holds in a standard-cell context too, even though the *magnitude* will differ and should never be claimed to transfer numerically.

**What Track 3 would show if it disagrees:** an equally valuable, honestly-reportable result — that the technique's benefit is FPGA-fabric-specific (plausible, since FPGA routing/LUT structures have different parasitic characteristics than standard cells) — which would itself be a real, interesting finding worth discussing rather than a failure to hide.

## 5. Recommendation on whether to pursue Track 3

Consistent with Part 14's staging (Stage 9 was already labeled optional), Track 3 should be attempted **only after** the FPGA track (Parts 7–11) is fully complete, verified, and has produced a result worth cross-checking — not in parallel with it, and not as a way to pad the project if the FPGA results turn out to be a null result. Running an ASIC flow to cross-validate a real finding is a strong addition to the eventual paper (Part 13); running one on a project that hasn't yet produced a finding to validate is wasted effort.

## 6. Explicit ground rules for reporting Track 3 results, if pursued

- Every SKY130 number is labeled "SKY130, 130 nm, real fabricatable PDK" — never implied to represent a modern node.
- Every ASAP7 number is labeled "ASAP7, predictive academic 7 nm PDK — not measured silicon" in the same sentence or table cell it appears in, not only in a methods section the reader might skip.
- Timing-closure quality is reported honestly (e.g., final worst-negative-slack, not just "met timing") given the known open-flow-vs-commercial gap at aggressive constraints — a marginally-closed open-flow result claimed as clean is a more serious credibility risk than an honestly-reported one with visible slack.
- Any place the FPGA (Part 11) and ASIC-flow (this section) results disagree in direction is reported as a finding, not smoothed over or omitted.

---

*Next: Part 13 — the paper-level contribution statement, built from what Parts 7–12 actually establish. Say the word.*
