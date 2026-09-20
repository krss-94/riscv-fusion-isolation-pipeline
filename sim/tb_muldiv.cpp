// tb_muldiv.cpp -- Part 10 §2 unit test for muldiv.sv. Reference model uses
// 64-bit arithmetic per RV32M spec, including defined div-by-zero and
// INT_MIN/-1 signed-overflow behavior.
#include "Vmuldiv.h"
#include "verilated.h"
#include <cstdio>
#include <cstdint>

struct Vec { const char* name; uint32_t a, b; int op; uint32_t expect; };

static uint32_t ref(uint32_t au, uint32_t bu, int op) {
    int32_t a = (int32_t)au, b = (int32_t)bu;
    switch (op) {
        case 0: return (uint32_t)((int64_t)a * (int64_t)b);
        case 1: return (uint32_t)(((int64_t)a * (int64_t)b) >> 32);
        case 2: return (uint32_t)(((int64_t)a * (uint64_t)bu) >> 32);
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
    return 0xDEADBEEFu;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vmuldiv* dut = new Vmuldiv;
    int pass = 0, fail = 0;

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
            dut->a = p.a; dut->b = p.b; dut->op = op;
            dut->eval();
            uint32_t exp = ref(p.a, p.b, op);
            char name[64]; snprintf(name, sizeof(name), "%s_%s", opnames[op], p.n);
            if (dut->result == exp) {
                printf("PASS: %-24s a=0x%08x b=0x%08x -> 0x%08x\n", name, p.a, p.b, dut->result);
                pass++;
            } else {
                printf("FAIL: %-24s a=0x%08x b=0x%08x -> got 0x%08x expected 0x%08x\n",
                       name, p.a, p.b, dut->result, exp);
                fail++;
            }
        }
    }

    printf("=== TOTAL PASS=%d FAIL=%d ===\n", pass, fail);
    dut->final();
    delete dut;
    return fail;
}
