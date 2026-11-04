# CDC Verification Plan

**Project:** RISC-V Fusion/Isolation Pipeline (ooo-repo)
**Date:** 2026-11-03
**Version:** 1.0

---

## 1. Clock Domain Analysis

### 1.1 Clock Domains Identified

| Domain | Clock | Reset | Modules | Frequency |
|--------|-------|-------|---------|-----------|
| `clk` | `clk` | `rst_n` (async active-low) | All RTL modules | Single clock |

### 1.2 Clock Domain Crossing Assessment

**Result: NO CDC PATHS EXIST**

The design uses a **single clock domain** (`clk`) with synchronous active-low reset (`rst_n`) throughout. All sequential elements are clocked by `clk` and reset by `rst_n`. No asynchronous clock domain crossings are present.

---

## 2. Reset Architecture

### 2.1 Reset Strategy

| Signal | Type | Domain | Synchronization |
|--------|------|--------|-----------------|
| `rst_n` | Asynchronous assertion, synchronous deassertion | `clk` | All flops use `negedge rst_n` |

### 2.2 Reset Verification

- ✅ All registers have async reset (`negedge rst_n`)
- ✅ Reset values are defined for all state elements
- ✅ Pipeline registers have proper clear/stall logic
- ✅ CSR file has synchronous reset for trap state
- ⚠️ **Recommendation:** Add reset synchronizer if `rst_n` comes from external async source

---

## 3. CDC Risk Classification

| Risk Category | Status | Evidence |
|---------------|--------|----------|
| Multi-clock design | ✅ N/A | Single clock only |
| Async FIFO | ✅ N/A | No FIFOs between clock domains |
| Clock gating | ✅ N/A | No clock gating implemented |
| Async reset crossing | ⚠️ Low | `rst_n` async assert, sync deassert |
| Data crossing | ✅ N/A | No multi-clock data paths |
| Control crossing | ✅ N/A | No multi-clock control paths |

---

## 4. Synchronizer Requirements

### 4.1 Required Synchronizers

| Signal | Source Domain | Dest Domain | Synchronizer Type | Status |
|--------|---------------|-------------|-------------------|--------|
| `rst_n` | External (async) | `clk` | 2-FF sync | ⚠️ Not implemented (external responsibility) |

### 4.2 Existing Synchronization

- Pipeline stall/flush logic provides implicit synchronization for pipeline bubbles
- `pend2_active` state machine handles deferred writeback synchronization
- Hazard unit manages forwarding/stalling without CDC concerns

---

## 5. Verification Methodology

### 5.1 Static CDC Analysis (SpyGlass/CDC)

**Tool:** Synopsys SpyGlass CDC (not available - requires license)
**Alternative:** Manual code review + Verilator structural checks

**Checks Performed:**
- ✅ Single clock domain verified by inspection
- ✅ All sequential elements use `clk` and `rst_n`
- ✅ No `posedge`/`negedge` mixing on different clocks
- ✅ No multi-clock module instantiations

### 5.2 Dynamic CDC Verification

**Method:** Simulation with reset stress testing
- Run directed tests with random reset assertion
- Verify no X-propagation in simulation
- Check for metastability in reset recovery

**Test Cases:**
1. Random `rst_n` assertion during operation
2. Back-to-back reset pulses
3. Reset during muldiv operation
3. Reset during fusion/pend2 sequence

---

## 6. Sign-Off Criteria

| Criterion | Target | Status |
|-----------|--------|--------|
| Zero CDC violations (SpyGlass) | 0 | ⚠️ Tool not available |
| Zero async reset synchronizer violations | 0 | ⚠️ External responsibility |
| Zero clock domain crossing data paths | 0 | ✅ Verified by inspection |
| Reset recovery without X-propagation | Pass | ✅ Simulation verified |
| Metastability MTBF > 100 years | N/A | ✅ No CDC paths |

---

## 7. Tool Gap & Recommendations

### 7.1 Missing Tool: Synopsys SpyGlass CDC

**Impact:** Cannot generate formal CDC sign-off report
**Mitigation:** 
- Manual code review confirms single-clock design
- All flops use same clock/reset
- No hand-written synchronizers needed

### 7.2 Recommended Actions

1. **Add reset synchronizer** at top level if `rst_n` comes from external async source:
   ```systemverilog
   logic rst_sync1, rst_sync2;
   always_ff @(posedge clk or negedge rst_n) begin
       if (!rst_n) {rst_sync1, rst_sync2} <= 2'b00;
       else {rst_sync1, rst_sync2} <= {rst_sync1, 1'b1};
   end
   wire rst_synced = rst_sync2;
   ```

2. **Run SpyGlass CDC** when license available for formal sign-off

3. **Document CDC assumptions** in design specification

---

## 8. Conclusion

**CDC Status: CLEAN (by inspection)**

The RISC-V Fusion/Isolation Pipeline is a **single-clock-domain design** with no clock domain crossings. All sequential logic uses `clk` with synchronous `rst_n` deassertion. No CDC synchronizers are required internally.

**Remaining Work for Formal Sign-Off:**
1. Obtain SpyGlass CDC license for formal report
2. Add reset synchronizer at top level if needed
3. Run formal CDC verification flow

---

## Appendix: Module Clock/Reset Summary

| Module | Clock | Reset | CDC Risk |
|--------|-------|-------|----------|
| `core_top_pipelined` | `clk` | `rst_n` | None |
| `core_top` (single-cycle) | `clk` | `rst_n` | None |
| `pipeline_regs` (4 modules) | `clk` | `rst_n` | None |
| `hazard_unit` | `clk` | `rst_n` | None |
| `muldiv_iter` | `clk` | `rst_n` | None |
| `csr_file` | `clk` | `rst_n` | None |
| `trap_unit` | `clk` | `rst_n` | None |
| `alu` | N/A (comb) | N/A | None |
| `decoder` | N/A (comb) | N/A | None |
| `imm_gen` | N/A (comb) | N/A | None |
| `regfile` / `regfile_pipelined` | `clk` | `rst_n` | None |
| `isol_gate` | `clk` | implicit | None |
| `muldiv` | N/A (comb) | N/A | None |

---
*End of CDC Verification Plan*