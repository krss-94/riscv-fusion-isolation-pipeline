// tb_muldiv_iter.cpp -- unit test for the ACTUAL multi-cycle iterative
// multiply/divide unit used by the proposed pipelined core (Part 10 §2
// gap fix: the prior tb_muldiv.cpp only covered Stage 2's combinational
// reference unit, muldiv.sv, never muldiv_iter.sv). Same golden vector
// table (INT_MIN/-1, div-by-zero, boundary values) as tb_muldiv.cpp,
// driven through the start/op_en/busy/done handshake instead of purely
// combinationally.
#include "Vmuldiv_iter.h"
#include "verilated.h"
#include <cstdio>
#include <cstdint>

static uint32_t ref(uint32_t au, uint32_t bu, int op) {
    int32_t a = (int32_t)au, b = (int32_t)bu;
    switch (op) {
        case 0: return (uint32_t)(a * b);
        case 1: return (uint32_t)(((int64_t)a * (int64_t)b) >> 32);
        case 2: return (uint32_t)(((int64_t)a * (int64_t)bu) >> 32);
        case 3: return (uint32_t)(((uint64_t)au * (uint64_t)bu) >> 32);
        case 4:
            if (bu == 0) return 0xFFFFFFFFu;
            if (au == 0x80000000u && bu == 0xFFFFFFFFu) return 0x80000000u;
            return (uint32_t)(a / b);
        case 5:
            if (bu == 0) return 0xFFFFFFFFu;
            return au / bu;
        case 6:
            if (bu == 0) return au;
            if (au == 0x80000000u && bu == 0xFFFFFFFFu) return 0;
            return (uint32_t)(a % b);
        case 7:
            if (bu == 0) return au;
            return au % bu;
    }
    return 0;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vmuldiv_iter* dut = new Vmuldiv_iter;
    int pass = 0, fail = 0;

    dut->rst_n = 0; dut->clk = 0; dut->start = 0; dut->op_en = 1;
    dut->eval(); dut->clk = 1; dut->eval(); dut->rst_n = 1;

    const uint32_t Z=0, ONE=1, NEG1=0xFFFFFFFFu, SMIN=0x80000000u, SMAX=0x7FFFFFFFu, UMAX=0xFFFFFFFFu;
    struct { const char* n; uint32_t a, b; } ab[] = {
        {"zero_zero", Z, Z}, {"one_one", ONE, ONE}, {"neg1_neg1", NEG1, NEG1},
        {"smin_smin", SMIN, SMIN}, {"smax_smax", SMAX, SMAX},
        {"smin_neg1", SMIN, NEG1}, {"smin_one", SMIN, ONE}, {"smax_neg1", SMAX, NEG1},
        {"a_bZero", 0x12345678u, Z}, {"smin_bZero", SMIN, Z},
        {"umax_umax", UMAX, UMAX}, {"umax_one", UMAX, ONE},
        {"mixed1", 0x00000005u, 0xFFFFFFFDu}, {"mixed2", SMIN, 0x00000002u},
    };
    const char* opnames[8] = {"MUL","MULH","MULHSU","MULHU","DIV","DIVU","REM","REMU"};

    for (auto& p : ab) {
        for (int op = 0; op < 8; op++) {
            // Pulse start for one cycle with operands/op presented.
            dut->a = p.a; dut->b = p.b; dut->op = op; dut->op_en = 1;
            dut->start = 1;
            dut->clk = 0; dut->eval();
            dut->clk = 1; dut->eval();
            dut->start = 0;
            // Run until done, bounded (32-iter unit, generous margin).
            uint32_t result = 0; bool got_done = false;
            for (int cyc = 0; cyc < 60; cyc++) {
                dut->clk = 0; dut->eval();
                if (dut->done) { result = dut->result; got_done = true; }
                dut->clk = 1; dut->eval();
                if (got_done) break;
            }
            uint32_t exp = ref(p.a, p.b, op);
            char name[64]; snprintf(name, sizeof(name), "%s_%s", opnames[op], p.n);
            if (got_done && result == exp) {
                printf("PASS: %-24s a=0x%08x b=0x%08x -> 0x%08x\n", name, p.a, p.b, result);
                pass++;
            } else {
                printf("FAIL: %-24s a=0x%08x b=0x%08x -> got 0x%08x (done=%d) expected 0x%08x\n",
                       name, p.a, p.b, result, got_done, exp);
                fail++;
            }
        }
    }
    printf("=== TOTAL PASS=%d FAIL=%d ===\n", pass, fail);
    dut->final();
    delete dut;
    return fail;
}
