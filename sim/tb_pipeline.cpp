// tb_pipeline.cpp -- Verilator testbench for core_top_pipelined. Same
// commit-log line format as tb_core.cpp (Stage 2) so run_lockstep.sh works
// unchanged. Two real lessons baked in from the start, not rediscovered:
//   1. Sample/print BEFORE the committing clk=1 edge (Stage 2's own
//      off-by-one bug: printing after both edges shows values one
//      instruction late and drops the very first commit).
//   2. Print WB-stage events before MEM-stage events within the same
//      cycle -- WB's instruction is always older in program order than
//      whatever's simultaneously in MEM, and Spike's log is strict
//      program order.
#include "Vcore_top_pipelined.h"
#include "Vcore_top_pipelined___024root.h"
#include "Vcore_top_pipelined_core_top_pipelined.h"
#include "verilated.h"
#include "verilated_saif_c.h"
#include <memory>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <vector>

int main(int argc, char** argv) {
    if (argc < 3) {
        fprintf(stderr, "usage: %s <flat.bin> <max_cycles>\n", argv[0]);
        return 1;
    }
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    Vcore_top_pipelined* top = new Vcore_top_pipelined;

    std::ifstream f(argv[1], std::ios::binary);
    if (!f) { fprintf(stderr, "cannot open %s\n", argv[1]); return 1; }
    std::vector<uint8_t> image((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
    /* mem[] is now a 32-bit word array (BRAM-inference fix), not a byte
     * array -- pack 4 bytes/word, little-endian, matching the RTL layout. */
    for (size_t i = 0; i < image.size(); i += 4) {
        uint32_t w = 0;
        for (int b = 0; b < 4 && i + b < image.size(); b++)
            w |= (uint32_t)image[i + b] << (8 * b);
        top->rootp->core_top_pipelined->__PVT__imem[i / 4] = w;
        top->rootp->core_top_pipelined->__PVT__dmem[i / 4] = w;
    }

    std::unique_ptr<VerilatedSaifC> tfp;
    const char* saif_path = getenv("SAIF_OUT");
    if (saif_path) {
        tfp = std::make_unique<VerilatedSaifC>();
        top->trace(tfp.get(), 99);
        tfp->open(saif_path);
    }
    long saif_start = getenv("SAIF_START") ? atol(getenv("SAIF_START")) : 0;
    long saif_end   = getenv("SAIF_END")   ? atol(getenv("SAIF_END"))   : -1;
    long main_time  = 0;

    long max_cycles = atol(argv[2]);

    top->rst_n = 0; top->clk = 0;
    top->eval();
    top->clk = 1; top->eval();
    top->rst_n = 1;

    long fusion_trace_count = 0;
    long fuse_window_end = -1;
    for (long cyc = 0; cyc < max_cycles; cyc++) {
        top->clk = 0; top->eval();  // settle BEFORE the committing edge
        main_time += 5;
        if (tfp && cyc >= saif_start && (saif_end < 0 || cyc <= saif_end)) tfp->dump(static_cast<uint64_t>(main_time));

        static const bool tb_trace = (getenv("TB_TRACE") != nullptr);
        if (tb_trace) {
            if (top->dbg_wb_reg_we)
                printf("core   0: 3 0x%08x (0x%08x) x%d  0x%08x\n",
                       top->dbg_wb_pc, top->dbg_wb_instr, top->dbg_wb_reg_addr, top->dbg_wb_reg_wdata);
            if (top->dbg_pend2_fire)
                printf("core   0: 3 0x%08x (0x%08x) x%d  0x%08x\n",
                       0u, 0u, top->dbg_pend2_addr, top->dbg_pend2_data);
            if (top->dbg_mem_we)
                printf("core   0: 3 0x%08x (0x%08x) mem 0x%08x 0x%08x\n",
                       top->dbg_mem_pc, top->dbg_mem_instr, top->dbg_mem_addr, top->dbg_mem_wdata);
        }
        if (top->dbg_mem_we && top->dbg_mem_addr == 0x80000000u)
            fprintf(stderr, "UART: %c", (char)(top->dbg_mem_wdata & 0xff));
        if (tb_trace) {
            uint32_t mar = top->rootp->core_top_pipelined->__PVT__mem_alu_result;
            if (mar >= 0x80010030u && mar <= 0x80010050u) {
                fprintf(stderr, "T3 cyc=%3ld mem_alu_result=0x%08x dmem_off=0x%08x mem_we=%d byte_we=%d result_src=%d rdata_raw_d=0x%08x\n",
                    cyc, mar, mar - 0x80000000u,
                    top->rootp->core_top_pipelined->__PVT__mem_mem_write,
                    top->rootp->core_top_pipelined->__PVT__dmem_byte_we,
                    top->rootp->core_top_pipelined->__PVT__mem_result_src,
                    top->rootp->core_top_pipelined->__PVT__mem_rdata_raw_d);
            }
        }
        if (top->dbg_trap_taken)
            fprintf(stderr, "TRAP cyc=%3ld mepc=0x%08x mcause=0x%08x mtval=0x%08x\n",
                    cyc, top->dbg_mepc, top->dbg_mcause, top->dbg_mtval);


        top->clk = 1; top->eval();  // commit
        main_time += 5;
        if (tfp && cyc >= saif_start && (saif_end < 0 || cyc <= saif_end)) tfp->dump(static_cast<uint64_t>(main_time));
        if (top->rootp->core_top_pipelined->fusion_active && fusion_trace_count < 15) {
            fuse_window_end = cyc + 6;
            fusion_trace_count++;
        }
    }

    fprintf(stderr, "FINAL pc=0x%08x mcause=0x%08x mepc=0x%08x\n", top->rootp->core_top_pipelined->__PVT__pc, top->dbg_mcause, top->dbg_mepc);
    fprintf(stderr, "FUSION_ACTIVE_CNT=%u\n", top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__fusion_active_cnt);
    if (tfp) tfp->close();
    top->final();
    delete top;
    return 0;
}
