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
    Vcore_top_pipelined* top = new Vcore_top_pipelined;

    Verilated::traceEverOn(true);
    VerilatedSaifC* saif = nullptr;
    const char* saif_path = getenv("TB_SAIF_OUT");
    vluint64_t sim_time = 0;
    if (saif_path) {
        saif = new VerilatedSaifC;
        top->trace(saif, 99);
        saif->open(saif_path);
    }

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

    long max_cycles = atol(argv[2]);

    top->rst_n = 0; top->clk = 0;
    top->eval(); if (saif) saif->dump(sim_time); sim_time++;
    top->clk = 1; top->eval(); if (saif) saif->dump(sim_time); sim_time++;
    top->rst_n = 1;

    long fusion_trace_count = 0;
    long fuse_window_end = -1;
    for (long cyc = 0; cyc < max_cycles; cyc++) {
        top->clk = 0; top->eval(); if (saif) saif->dump(sim_time); sim_time++;  // settle BEFORE the committing edge
        static const bool trace_on = (getenv("TB_TRACE") != nullptr);
        if (trace_on) {

        fprintf(stderr, "cyc=%3ld pc=0x%08x ex_pc=0x%08x stall_idex=%d muldiv_busy=%d muldiv_start=%d ex_rs1=%d ex_rs2=%d ex_rs1_data=0x%08x ex_rs2_data=0x%08x fwd_a=0x%08x fwd_b=0x%08x ex_illegal=%d dbg_trap=%d\n",
            cyc,
            top->rootp->core_top_pipelined->__PVT__pc,
            top->rootp->core_top_pipelined->__PVT__ex_pc,
            top->rootp->core_top_pipelined->__PVT__stall_idex,
            top->rootp->core_top_pipelined->__PVT__muldiv_busy,
            top->rootp->core_top_pipelined->__PVT__muldiv_start,
            top->rootp->core_top_pipelined->__PVT__ex_rs1_addr,
            top->rootp->core_top_pipelined->__PVT__ex_rs2_addr,
            top->rootp->core_top_pipelined->__PVT__ex_rs1_data,
            top->rootp->core_top_pipelined->__PVT__ex_rs2_data,
            top->rootp->core_top_pipelined->__PVT__fwd_a_val,
            top->rootp->core_top_pipelined->__PVT__fwd_b_val,
            top->rootp->core_top_pipelined->__PVT__ex_illegal_instr,
            top->dbg_trap_taken);
        static uint32_t imem9_last = 0xFFFFFFFF;
        uint32_t imem9_now = top->rootp->core_top_pipelined->__PVT__imem[9];
        if (imem9_now != imem9_last) {
            fprintf(stderr, "IMEM9 CHANGED cyc=%3ld old=0x%08x new=0x%08x\n", cyc, imem9_last, imem9_now);
            imem9_last = imem9_now;
        }
        fprintf(stderr, "    fetch: pc_d=0x%08x if_instr_r=0x%08x\n",
            top->rootp->core_top_pipelined->__PVT__pc_d,
            top->rootp->core_top_pipelined->__PVT__if_instr_r);
        fprintf(stderr, "    id: id_pc=0x%08x id_instr=0x%08x ex_instr=0x%08x wb_instr=0x%08x flush_id=%d stall_pc_ifid=%d\n",
            top->rootp->core_top_pipelined->__PVT__id_pc,
            top->rootp->core_top_pipelined->__PVT__id_instr,
            top->rootp->core_top_pipelined->__PVT__ex_instr,
            top->rootp->core_top_pipelined->__PVT__wb_instr,
            top->rootp->core_top_pipelined->__PVT__flush_id,
            top->rootp->core_top_pipelined->__PVT__stall_pc_ifid);
        fprintf(stderr, "    regs: mepc=0x%08x mcause=0x%08x mtval=0x%08x\n",
            top->dbg_mepc, top->dbg_mcause, top->dbg_mtval);
        fprintf(stderr, "    csr: ex_is_csr=%d ex_csr_op=%d ex_csr_addr=0x%03x csr_rdata_ex=0x%08x wb_csr_we=%d wb_csr_addr=0x%03x wb_csr_wdata=0x%08x mtvec=0x%08x\n",
            top->rootp->core_top_pipelined->__PVT__ex_is_csr,
            top->rootp->core_top_pipelined->__PVT__ex_csr_op,
            top->rootp->core_top_pipelined->__PVT__ex_csr_addr,
            top->rootp->core_top_pipelined->__PVT__csr_rdata_ex,
            top->rootp->core_top_pipelined->__PVT__wb_csr_we,
            top->rootp->core_top_pipelined->__PVT__wb_csr_addr_out,
            top->rootp->core_top_pipelined->__PVT__wb_muldiv_result,
            top->rootp->core_top_pipelined->__PVT__mtvec);
        } // end trace_on

        if (top->dbg_wb_reg_we)
            printf("core   0: 3 0x%08x (0x%08x) x%d  0x%08x\n",
                   top->dbg_wb_pc, top->dbg_wb_instr, top->dbg_wb_reg_addr, top->dbg_wb_reg_wdata);
        if (top->dbg_pend2_fire)
            printf("core   0: 3 0x%08x (0x%08x) x%d  0x%08x\n",
                   0u, 0u, top->dbg_pend2_addr, top->dbg_pend2_data);
        if (top->dbg_mem_we)
            printf("core   0: 3 0x%08x (0x%08x) mem 0x%08x 0x%08x\n",
                   top->dbg_mem_pc, top->dbg_mem_instr, top->dbg_mem_addr, top->dbg_mem_wdata);
        if (top->dbg_mem_we && top->dbg_mem_addr == 0x80000000u)
            fprintf(stderr, "UART: %c", (char)(top->dbg_mem_wdata & 0xff));
        {
            uint32_t pcv = top->rootp->core_top_pipelined->__PVT__ex_pc;
            if (pcv >= 0x80000060u && pcv <= 0x80000078u) {
                fprintf(stderr, "T2 cyc=%3ld ex_pc=0x%08x ex_rs1=%d ex_rs1_d=0x%08x fwd_a_sel=%d fwd_a_val=0x%08x mem_rd=%d mem_we=%d wb_rd=%d wb_we=%d wb_we_rf=%d\n",
                    cyc, pcv,
                    top->rootp->core_top_pipelined->__PVT__ex_rs1_addr,
                    top->rootp->core_top_pipelined->__PVT__ex_rs1_data,
                    top->rootp->core_top_pipelined->__PVT__fwd_a_sel,
                    top->rootp->core_top_pipelined->__PVT__fwd_a_val,
                    top->rootp->core_top_pipelined->__PVT__mem_rd_addr,
                    top->rootp->core_top_pipelined->__PVT__mem_reg_write,
                    top->rootp->core_top_pipelined->__PVT__wb_rd_addr,
                    top->rootp->core_top_pipelined->__PVT__wb_reg_write,
                    top->rootp->core_top_pipelined->__PVT__wb_reg_write_for_rf);
            }
        }
        {
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

        if (cyc >= 1999999990) {
            fprintf(stderr, "cyc=%3ld start=%d ex_rd_addr=%d ex_muldiv_op=%d op_r=%d mul_a_sign=%d mul_b_sign=%d mul_acc=0x%016llx state=%d iter_cnt=%d result=0x%08x busy_reg=%d done_reg=%d\n",
                cyc,
                top->rootp->core_top_pipelined->__PVT__muldiv_start,
                top->rootp->core_top_pipelined->__PVT__ex_rd_addr,
                top->rootp->core_top_pipelined->__PVT__ex_muldiv_op,
                top->rootp->core_top_pipelined->__PVT__u_muldiv__DOT__op_r,
                top->rootp->core_top_pipelined->__PVT__u_muldiv__DOT__mul_a_sign,
                top->rootp->core_top_pipelined->__PVT__u_muldiv__DOT__mul_b_sign,
                (unsigned long long)top->rootp->core_top_pipelined->__PVT__u_muldiv__DOT__mul_acc,
                top->rootp->core_top_pipelined->__PVT__u_muldiv__DOT__state,
                top->rootp->core_top_pipelined->__PVT__u_muldiv__DOT__iter_cnt,
                top->rootp->core_top_pipelined->__PVT__muldiv_result_bus,
                top->rootp->core_top_pipelined->__PVT__muldiv_busy,
                top->rootp->core_top_pipelined->__PVT__muldiv_done);
            fprintf(stderr, "    op_a_r=0x%08x\n", top->rootp->core_top_pipelined->__PVT__u_muldiv__DOT__op_a_r);
        }

        top->clk = 1; top->eval(); if (saif) saif->dump(sim_time); sim_time++;  // commit
        if (top->rootp->core_top_pipelined->fusion_active && fusion_trace_count < 15) {
            fuse_window_end = cyc + 6;
            fusion_trace_count++;
        }
        if (cyc <= fuse_window_end) {
            fprintf(stderr, "FUSE_WIN cyc=%ld fusion_active=%d stall_pc_ifid=%d stall_idex=%d flush_ex=%d pend2_active=%d ex_pend2_valid=%d mem_pend2_valid=%d wb_pend2_valid=%d pend2_fire_valid=%d\n",
                cyc,
                (int)top->rootp->core_top_pipelined->fusion_active,
                top->rootp->core_top_pipelined->__PVT__stall_pc_ifid,
                top->rootp->core_top_pipelined->__PVT__stall_idex,
                top->rootp->core_top_pipelined->__PVT__flush_ex,
                top->rootp->core_top_pipelined->__PVT__pend2_active,
                top->rootp->core_top_pipelined->__PVT__ex_pend2_valid,
                top->rootp->core_top_pipelined->__PVT__mem_pend2_valid,
                top->rootp->core_top_pipelined->__PVT__wb_pend2_valid,
                top->rootp->core_top_pipelined->__PVT__pend2_fire_valid);
        }
    }

    fprintf(stderr, "FINAL pc=0x%08x mcause=0x%08x mepc=0x%08x\n", top->rootp->core_top_pipelined->__PVT__pc, top->dbg_mcause, top->dbg_mepc);
    fprintf(stderr, "FUSION_ACTIVE_CNT=%u\n", top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__fusion_active_cnt);
    if (saif) { saif->close(); delete saif; }
    top->final();
    delete top;
    return 0;
}
