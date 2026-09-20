# Custom-ISA Processor Research Project
## Part 8 — Microarchitecture

*Implements the ISA defined in `03_part7_isa_definition.md` (RV32IM + `FISOL` + custom HPM events). This is the first point in the project where RTL design actually begins.*

## 1. Overview and philosophy

Two architectures are defined side by side throughout this document, because the entire research contribution is the *delta* between them:

- **Baseline** — a conventional 5-stage in-order RV32IM pipeline with standard forwarding, standard hazard handling, and synthesis-tool-inferred power optimization only (i.e., whatever Vivado's synthesis does automatically — no RTL-level isolation logic).
- **Proposed** — the identical pipeline, plus (a) a decode-stage fusion detector recognizing five fixed idiom pairs, and (b) decoder-driven operand isolation gating the multiply/divide unit's inputs directly from decoded instruction-class bits.

Both are built from the same RTL modules wherever possible (register file, ALU, memory interface, control unit) so that the only differences the experiment measures are the ones under study — this matters for the internal validity of the comparison in Part 11.

## 2. Pipeline structure (both architectures)

Five stages: **Fetch (IF) → Decode (ID) → Execute (EX) → Memory (MEM) → Writeback (WB)**, single-issue, in-order, one instruction (or one fused pair, in the proposed architecture) per cycle in steady state.

### 2.1 Fetch (IF)
- Program counter register, default increment PC+4 each cycle.
- Single-ported synchronous instruction memory (BRAM), one-cycle read latency.
- Redirect input from EX (branch resolution) or ID (unconditional jump resolution — see §2.6).
- **Proposed-architecture addition:** a one-instruction lookahead buffer — fetch delivers not just the current instruction to ID, but keeps the *next* fetched word available one cycle ahead, so the Decode-stage fusion detector can compare "this instruction" against "the next instruction" combinationally within the same cycle boundary. This costs one extra 32-bit latch; it is the only IF-stage change in the proposed architecture.
- **Flush/invalidate on redirect (design-review clarification):** the lookahead latch carries an explicit `lookahead_valid` bit, cleared on any PC redirect — branch misprediction (from EX), jump-target resolution (from ID), interrupt/exception entry, or reset — and only re-asserted once a fetch from the new (post-redirect) instruction stream has actually completed. The fusion detector treats `lookahead_valid = 0` as an automatic decline-to-fuse, independent of whether a pattern would otherwise match. This is a distinct failure mode from the register-dependency hazards the interlock in §2.2 checks — a control-flow-boundary hazard, not a data hazard — and is called out explicitly here so it is not mistakenly assumed to be covered by that interlock; it gets its own directed test in Part 10.

### 2.2 Decode (ID)
- Register file read (2 read ports, from `rs1`/`rs2` fields).
- Immediate generation unit — six parallel sign-extension paths (I/S/B/U/J), muxed by instruction format, unmodified from standard RV32I practice.
- Main control unit: combinational decode of `opcode`/`funct3`/`funct7` into ALU operation select, memory read/write enable, branch-type select, register-write enable, and (new) `FISOL` recognition.
- **Baseline:** control signals feed EX/MEM/WB directly; no fusion, no explicit isolation signals (any power optimization here is whatever Vivado infers from the netlist).
- **Proposed, addition A — fusion detector:** a small combinational pattern-match block (implemented as a priority-encoded case/lookup over `{opcode, funct3, funct7}` of the current and lookahead instruction, plus their register fields) checks the five fixed idioms from Part 7 §3.1's design intent:

  | Idiom | Pattern | Fusion effect |
  |---|---|---|
  | 1 | `LUI rd,imm20` + `ADDI rd,rd,imm12` | Collapse to single-cycle 32-bit constant materialization |
  | 2 | `AUIPC rd,imm20` + `ADDI rd,rd,imm12` | Collapse to single-cycle PC-relative address formation |
  | 3 | `AUIPC rd,imm20` + `JALR ra,rd,imm12` | Collapse to single-cycle far call/jump |
  | 4 | `SLT{,U,I} rd,rs1,rs2` + `BEQ/BNE rd,x0,off` | Collapse compare+branch: the comparator result is still architecturally written to `rd` — see the correctness note below the table — with the branch's consumption of that value forwarded directly from the comparator's combinational output rather than read back through the register file |
  | 5 | `ADD/ADDI rd,rs1,rs2` + `LW/SW rd2,0(rd)` | Shared address computation for load/store base+offset |

  **Correctness note on idiom 4 (caught during design review, in the same pass that produced §2.10's items):** the fusion detector has no visibility into whether `rd` is genuinely dead after the branch — it only checks in-flight hazards (condition iii below), not whole-program liveness, which is compiler-level information the hardware doesn't have. A design that skipped `rd`'s architectural write on the theory that it's "usually dead" would silently break any code where it isn't — a real correctness bug, not a performance-neutral shortcut, and one the baseline-equivalence gate in Part 10 §3 would eventually catch, but a spec-level fix is cheaper than relying on that. The corrected version above still performs the full RV32I-mandated write to `rd`; the only thing fusion optimizes away is the redundant register-file *read* the branch would otherwise need to consume that same value one cycle later.

  A pair only fuses if (i) the pattern matches, (ii) no `FISOL.BOUND` was decoded between them, and (iii) no other in-flight hazard would be violated by treating them as atomic (the detector includes a hazard-safety interlock — see §2.5). If any condition fails, the pair decodes normally, unfused — the fusion detector **fails safe to the baseline behavior**, never to an incorrect one.

- **Proposed, addition B — isolation control signal generation:** the same decoded `opcode`/`funct3` bits that already exist in the baseline control unit are additionally latched into two registered enable signals — `MULDIV_EN` (set only when the current instruction is one of `MUL/MULH/MULHU/MULHSU/DIV/DIVU/REM/REMU`) and, optionally, `BR_CMP_EN` for the branch comparator. These signals are generated **one pipeline stage ahead of when they're needed** (in ID, for use in EX), which is what makes the isolation "decoder-driven" rather than "netlist-inferred" — the gating decision is available before the operands even reach the functional unit, rather than being reconstructed post-hoc by the synthesis tool from switching statistics.

### 2.3 Execute (EX)
- ALU: standard RV32I operations (add/sub, shifts, compare, logical) — always active; not gated (its area/power cost is too small to matter relative to the multiply/divide unit, so isolating it isn't worth the added control complexity — a judgment call recorded here for the eventual paper's threats-to-validity section).
- Multiply/divide unit: **multi-cycle iterative** implementation (shift-add multiplier, restoring or non-restoring divider), not single-cycle-combinational. This is a deliberate choice: a multi-cycle unit has substantially larger accumulated switching activity per operation than a single-cycle one, which is what makes it a meaningful isolation target and matches "this is where a real power/area tradeoff exists" from Part 1/5. Iteration count: ~32 cycles worst case for a straightforward shift-add implementation (a known, acceptable simplicity-over-speed tradeoff for a research core — a Booth or higher-radix multiplier would reduce latency but add area/verification complexity unrelated to the research question, so it is deliberately not used).
- Branch comparator: equality/relational compare on the two ALU-path operands, resolves conditional branches.
- Forwarding muxes: standard EX/MEM→EX and MEM/WB→EX forwarding for ALU operands (see §2.5).
- **Baseline:** the multiply/divide unit's input registers are loaded from the standard operand-forwarding muxes every cycle, active or not; whatever isolation exists is whatever Vivado's synthesis infers.
- **Proposed:** `MULDIV_EN` (generated in ID, arriving at EX one cycle later, exactly when needed) directly gates the transparent latches feeding the multiply/divide unit's operand registers — when `MULDIV_EN` is low, those latches hold their previous value instead of being reloaded with new (switching) operand data, exactly the "guarded evaluation" mechanism from the classical operand-isolation literature (cited honestly in Part 13 as prior art), but driven by decode-time semantic information instead of a synthesis-inferred observability signal.

  Two implementation details here were flagged during design review and are stated explicitly to avoid ambiguity in the RTL:

  - **Gate placement relative to forwarding.** The isolation gate sits *downstream of* the EX-stage operand-forwarding mux, not upstream of it. It samples the fully-resolved operand — after EX/MEM and MEM/WB bypass selection has already happened — and only then decides, based on `MULDIV_EN`, whether to load that resolved value into the multiplier/divider's internal operand register or hold the register's previous value. Placing the gate before the forwarding mux would risk capturing a stale, pre-forwarding register-file value for a multiply that immediately follows its own operand's producer — a correctness bug, not merely a missed power optimization. Forwarding logic itself is never suppressed or gated; only the multiplier's re-sampling of a value it doesn't need this cycle is.
  - **`MULDIV_EN` during the multi-cycle stall.** `MULDIV_EN` is not re-derived combinationally from whatever ID happens to be holding during the stall. Instead, the one-cycle decode pulse from ID *triggers* an EX-local "multiply/divide busy" latch on the first cycle the operation enters EX (this is also the only cycle the operand-isolation gate actually needs to open, since the iterative multiplier/divider captures its operands once and then iterates on its own internal accumulator/shift-register state, independent of the external operand path). The busy latch — not the raw ID decode signal — holds isolation-relevant state stable for the full iteration and clears when the operation retires. This avoids the operand register either glitching open or reloading mid-iteration if ID's live decode output changes (e.g., due to how bubbles are inserted) during the stall.

### 2.4 Memory (MEM)
- Single-ported synchronous data memory (BRAM), one-cycle latency, byte/half/word access.
- Unaligned accesses handled directly in hardware (per Part 7 §5 — no trap), via byte-lane shifting logic.
- Identical in both architectures — this stage is not part of the research question and is held constant to avoid confounding the comparison.

### 2.5 Hazards, forwarding, and stalls

- **Standard forwarding:** EX/MEM→EX and MEM/WB→EX bypass paths for ALU-bound operands, unmodified from conventional 5-stage practice, present in both architectures.
- **Load-use hazard:** one-cycle stall (bubble inserted in EX) when an instruction in ID needs a register still being loaded by the instruction ahead of it in EX; resolved by forwarding from MEM/WB once available. Standard, unmodified.
- **Multiply/divide hazard:** the EX stage stalls IF/ID and freezes its own inputs for the iteration latency of an in-flight multiply/divide operation (a simple multi-cycle stall, not a fully pipelined multiplier — consistent with the small-core, small-area philosophy). Result is forwarded to a dependent instruction the cycle it becomes available.
- **Fusion hazard-safety interlock (proposed architecture only):** before committing to fuse a matched pair, the fusion detector checks that no third instruction already in flight has a conflicting dependency that atomic fusion would violate (for example, an intervening exception source or an in-flight load with the same destination register as the fusion pair). This check is deliberately conservative — the detector declines to fuse whenever the safety condition can't be verified combinationally within the cycle, favoring "fail-safe to baseline behavior" over "always fuse."
- **Fused-pair writeback (proposed architecture only):** idioms 1–4 in §2.2 all produce **one** destination register, so they retire through the existing single write port unmodified. Idiom 5 (`ADD`+`LW/SW`) can have **two** destinations (the address-computing `ADD`'s `rd` and the load's destination register). Rather than adding a second register-file write port purely to make this one idiom fully single-cycle end-to-end, the design keeps a single write port and serializes idiom 5's two writebacks across two cycles — the pair is fused for decode/isolation purposes (shared address computation, one fewer decode/fetch event) but writes back in two cycles like the unfused case. **This is a deliberate, disclosed engineering compromise**, not an oversight: it keeps the register file identical between baseline and proposed architectures (so RF area is never a confound in the comparison), at the cost of idiom 5 capturing less of the cycle-count benefit than idioms 1–4. This tradeoff should be reported explicitly in the results, not smoothed over.
- **`minstret` counting for fused pairs (correction, applies uniformly to all five idioms).** Write-port mechanics (above) and architectural retirement count are two different things and shouldn't be conflated. `minstret` is RISC-V's standards-compliant instructions-retired counter, and for it to remain comparable to any other RV32IM core's published numbers, it must count the true number of static instructions that completed — **`+2` for every fused pair, uniformly across idioms 1–5** — regardless of how many cycles or write ports the internal implementation needed to get there. Fusion is a microarchitectural optimization and is supposed to be invisible to this counter, the same way it's invisible to real fused designs' architectural "instructions retired" counts elsewhere in the literature. Idiom 5's genuine extra cost (the serialized second writeback cycle above) shows up correctly in cycle count / CPI, which is where it belongs — not in an inconsistent, idiom-dependent redefinition of what counts as a retirement. (An earlier version of Part 11 §4 described idioms 1–4 and idiom 5 as counting differently against `minstret`; that was a mistake, corrected there directly.)

### 2.6 Branch and jump handling
- Conditional branches (`BEQ/BNE/BLT/BGE/BLTU/BGEU`): resolved in EX (comparator result available after the ALU-path compare); static not-taken prediction at fetch; 2-cycle flush (IF and ID latches bubbled) on misprediction; PC redirected from EX.
- Unconditional jumps (`JAL/JALR`): target address (`PC+imm` or `rs1+imm`) is computable combinationally in ID once register operands are available, so these resolve with only a 1-cycle bubble, not 2 — a standard, well-understood asymmetry in classic 5-stage designs, unmodified from typical practice.
- No dynamic branch prediction (2-bit counters, BTB, etc.) — deliberately excluded per the Part 1 finding that branch-prediction novelty at this scale is exhausted territory; adding one would cost real design/verification effort while contributing nothing to the actual research question.

### 2.7 Clocking and reset
- Single synchronous clock domain for the entire core (no clock-domain crossing — deliberately avoided; CDC would add verification burden unrelated to the research question).
- Synchronous reset, active for a fixed number of cycles at power-up; PC resets to a fixed boot address (`0x00000000`, mapped to the start of instruction BRAM); all pipeline latches clear to a bubble (NOP-equivalent) state on reset, not to don't-care values — this matters for both simulation determinism and for keeping the fault-injection framework from Candidate 3 usable later if this line of work is extended in that direction.

### 2.8 Interrupts
- One external interrupt line plus the standard RISC-V machine-mode timer interrupt (`mtime`/`mtimecmp`), gated by `mstatus.MIE`/`mie`/`mip` per the Part 7 privileged-architecture definition.
- Precise, flush-based handling: on a taken interrupt, in-flight instructions younger than the trapping point are flushed (not drained), `mepc` is set to the PC of the not-yet-committed instruction, and fetch redirects to `mtvec`. This is the simplest correct approach for a small in-order core and avoids the added complexity of a drain-based precise-interrupt mechanism, which the research question doesn't need.
- **Interrupt arriving during a multi-cycle multiply/divide stall.** The same review that surfaced the three items in §2.10 raises this related question, so it is resolved here rather than left implicit: a pending interrupt is **not** taken mid-iteration. The in-progress multiply/divide is allowed to complete (its EX-local busy latch, §2.3, already exists and is the natural place to check this), and the interrupt is taken on the cycle immediately after it retires. This keeps worst-case interrupt latency bounded by the multiplier's maximum iteration count (~32 cycles) without requiring any additional drain logic beyond what the stall mechanism already provides.

### 2.9 Memory-mapped peripherals
Minimal, and identical in both architectures (peripherals are test/measurement infrastructure, not part of the research question):
- UART (memory-mapped transmit-data and status registers) — used for benchmark result output and debug printf from bare-metal test code.
- `mtime`/`mtimecmp` memory-mapped registers, per the standard RISC-V machine-timer convention — used both for interrupt testing and as a wall-clock reference during benchmarking.
- One memory-mapped GPIO/LED register — a simple, FPGA-visible "test passed / test running" indicator, useful during bring-up and demoing on real hardware.

## 2.10 Verification-critical items flagged during design review

Three correctness risks (plus one open performance risk) were identified reviewing this spec before RTL implementation begins. Recording them here explicitly rather than leaving them implicit in the prose above, since these are exactly the class of detail that looks fine on paper and surfaces as a real bug during verification:

1. **Isolation-gate/forwarding-mux ordering** (§2.3) — the gate must sample the post-forwarding resolved operand, never a pre-forwarding value. Resolution stated explicitly in §2.3; verify with a directed test in Part 10 that issues a multiply immediately after its own operand's producer, across all three forwarding sources (EX/MEM, MEM/WB, and the no-forwarding-needed case).
2. **`MULDIV_EN` stability across the multi-cycle stall** (§2.3) — resolved by making the gate's control signal an EX-local busy latch triggered by (but not continuously re-derived from) the ID decode pulse. Verify with a directed test that single-steps a multi-cycle multiply/divide operation and confirms the operand register neither glitches nor reloads mid-iteration.
3. **Lookahead-buffer flush on control-flow redirect** (§2.1) — resolved by an explicit `lookahead_valid` bit cleared on any redirect. This is a control-flow-boundary hazard, not a data-dependency hazard, and is a structurally different failure mode from the fusion hazard-safety interlock in §2.2 — it needs its own directed test in Part 10 (fuse-candidate pattern straddling a branch target, an interrupt boundary, and a `JALR` target), not just a general assumption that "the interlock handles it."
4. **Fusion-detector combinational depth is not yet known to fit in one cycle.** The two-instruction pattern match plus the hazard-safety interlock in §2.2 adds real logic depth to a decode stage that already carries register-file read, immediate generation, and control decode. "Fits in one cycle" is a design intent here, not a verified fact — it must be confirmed against actual post-synthesis timing (Stage 4 / Part 8's eventual synthesis pass), not assumed. If it doesn't fit, the fallback is to push fusion detection to a half-stage later (detect the pair one cycle after both instructions are already in the pipeline) rather than to quietly shrink the idiom set — but that fallback should only be adopted if synthesis timing data actually shows a problem.

*(A related interaction — an interrupt arriving mid-multiply — surfaced from applying this same scrutiny to §2.8, and is resolved there rather than left as a fifth open item.)*

## 3. Explicit baseline vs. proposed comparison

| Component | Baseline architecture | Proposed architecture | What changed |
|---|---|---|---|
| Fetch | PC, I-mem, single fetch/cycle | Same, plus a 1-instruction lookahead latch | +1 latch, enables next-cycle fusion comparison |
| Decode control unit | Standard opcode/funct decode | Same decode, plus fusion-pattern matcher and `MULDIV_EN`/`BR_CMP_EN` generation | New combinational block; no change to existing control signals |
| Register file | 32×32-bit, 2R1W | Identical | No change (register-file banking, Candidate 8, was not pursued here) |
| ALU | Standard, always active | Identical, not gated | Isolated deliberately excluded — too cheap to matter |
| Multiply/divide unit | Multi-cycle, operand latches reload every cycle | Identical datapath, but operand latches gated by `MULDIV_EN` from decode | This is the core experimental variable |
| Branch/jump handling | EX-resolved branches, ID-resolved jumps, static not-taken | Identical | No change (not part of this research question) |
| Memory stage | Single-port BRAM, unaligned-in-hardware | Identical | No change |
| Register-file writeback | Single write port | Identical (idiom 5 serializes across 2 cycles to preserve this) | No change — deliberately preserved to avoid confounding RF area |
| Exceptions/interrupts/peripherals | As specified in Part 7 | Identical | No change |
| **New instruction** | — | `FISOL.BOUND` / `FISOL.OFF` (architecturally a no-op; diagnostic only) | Enables in-binary A/B experimental control (Part 11) |
| **New CSRs** | Standard `mcycle`/`minstret` only | Adds `FUSION_ACTIVE`, `ISOL_ACTIVE`, `MULDIV_ACTIVE` HPM events | Software-visible cross-check against Vivado's post-implementation activity reports |

Everything not listed as "changed" is held identical between the two architectures by design — this is what makes the Part 11 A/B comparison internally valid rather than confounded by unrelated differences.

## 4. What is explicitly NOT implemented at this stage

Per Part 14's staging discipline, the following are deliberately deferred, not because they're unimportant but because building them now would front-load work the experimental plan doesn't need yet:

- No FPGA-specific optimization/tuning (Stage 4).
- No RTL-level verification test suite yet (Stage 6) — this microarchitecture spec is the input to that stage, not a substitute for it.
- No benchmark porting yet (Stage 7).
- No PPA measurement infrastructure yet (Stage 8) — though the `FISOL`/HPM instrumentation designed here exists specifically to make Stage 8 straightforward when it arrives.
- No ASIC-flow (OpenROAD/SkyWater) integration yet (Stage 9, optional).

---

*Next: Part 9 (software stack — confirming the standard RV32IM GCC/LLVM toolchain and Spike ISS need no modification for the baseline instruction set, plus the small assembler-level support needed for `FISOL` and the HPM CSR events) and Part 10 (verification strategy — unit tests, the fusion-detector hazard-safety interlock in particular, and the golden reference model). Say the word and I'll continue with those next.*
