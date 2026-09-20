// tb_hpm_selfcheck.cpp -- Part 10 §6. FUSION_ACTIVE/ISOL_ACTIVE/
// MULDIV_ACTIVE have no architectural definition Spike can check, so
// they're verified by RTL-internal self-consistency instead: tap the
// actual fusion-detector-match/isolation-gate-open/muldiv-active
// signals directly, keep an independent software shadow count, and
// confirm csr_file's counter registers agree cycle-for-cycle -- not
// through the CSR read path (that only samples at explicit read
// points and wouldn't catch a one-cycle divergence that self-corrects
// before the next read).
#include "Vcore_top_pipelined.h"
#include "Vcore_top_pipelined___024root.h"
#include "Vcore_top_pipelined_core_top_pipelined.h"
#include "verilated.h"
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <vector>

int main(int argc, char** argv) {
    if (argc < 3) { fprintf(stderr, "usage: %s <flat.bin> <max_cycles>\n", argv[0]); return 1; }
    Verilated::commandArgs(argc, argv);
    Vcore_top_pipelined* top = new Vcore_top_pipelined;
    std::ifstream f(argv[1], std::ios::binary);
    if (!f) { fprintf(stderr, "cannot open %s\n", argv[1]); return 1; }
    std::vector<uint8_t> image((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
    for (size_t i = 0; i < image.size(); i++)
        top->rootp->core_top_pipelined->__PVT__mem[i] = image[i];
    long max_cycles = atol(argv[2]);
    top->rst_n = 0; top->clk = 0;
    top->eval();
    top->clk = 1; top->eval();
    top->rst_n = 1;

    uint32_t shadow_fusion = top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__fusion_active_cnt;
    uint32_t shadow_isol   = top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__isol_active_cnt;
    uint32_t shadow_muldiv = top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__muldiv_active_cnt;
    int mismatches = 0;

    for (long cyc = 0; cyc < max_cycles; cyc++) {
        top->clk = 0; top->eval();

        if (top->rootp->core_top_pipelined->fusion_active) shadow_fusion++;
        if (top->rootp->core_top_pipelined->isol_active)   shadow_isol++;
        if (top->rootp->core_top_pipelined->__PVT__muldiv_start)  shadow_muldiv++;

        uint32_t rtl_fusion = top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__fusion_active_cnt;
        uint32_t rtl_isol   = top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__isol_active_cnt;
        uint32_t rtl_muldiv = top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__muldiv_active_cnt;

        top->clk = 1; top->eval();  // commit -- counters update on this edge

        // After the edge, RTL counters reflect this cycle's pulses too;
        // compare post-edge RTL value against post-increment shadow.
        uint32_t rtl_fusion2 = top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__fusion_active_cnt;
        uint32_t rtl_isol2   = top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__isol_active_cnt;
        uint32_t rtl_muldiv2 = top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__muldiv_active_cnt;
        (void)rtl_fusion; (void)rtl_isol; (void)rtl_muldiv;

        if (rtl_fusion2 != shadow_fusion) {
            fprintf(stderr, "MISMATCH cyc=%ld FUSION_ACTIVE: shadow=%u rtl=%u\n", cyc, shadow_fusion, rtl_fusion2);
            mismatches++;
        }
        if (rtl_isol2 != shadow_isol) {
            fprintf(stderr, "MISMATCH cyc=%ld ISOL_ACTIVE: shadow=%u rtl=%u\n", cyc, shadow_isol, rtl_isol2);
            mismatches++;
        }
        if (rtl_muldiv2 != shadow_muldiv) {
            fprintf(stderr, "MISMATCH cyc=%ld MULDIV_ACTIVE: shadow=%u rtl=%u\n", cyc, shadow_muldiv, rtl_muldiv2);
            mismatches++;
        }
    }
    printf("=== HPM SELF-CONSISTENCY: cycles=%ld fusion=%u isol=%u muldiv=%u mismatches=%d ===\n",
           max_cycles, shadow_fusion, shadow_isol, shadow_muldiv, mismatches);
    top->final();
    delete top;
    return mismatches > 0 ? 1 : 0;
}
