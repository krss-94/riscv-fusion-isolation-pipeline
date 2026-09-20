#include "Vcore_top_pipelined.h"
#include "Vcore_top_pipelined___024root.h"
#include "Vcore_top_pipelined_core_top_pipelined.h"
#include "verilated.h"
#include <cstdio>
#include <fstream>
#include <vector>
int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vcore_top_pipelined* top = new Vcore_top_pipelined;
    std::ifstream f(argv[1], std::ios::binary);
    std::vector<uint8_t> image((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
    for (size_t i = 0; i < image.size(); i++)
        top->rootp->core_top_pipelined->__PVT__mem[i] = image[i];
    top->rst_n = 0; top->clk = 0; top->eval();
    top->clk = 1; top->eval();
    top->rst_n = 1;
    for (long cyc = 0; cyc < 30; cyc++) {
        top->clk = 0; top->eval();
        printf("cyc=%2ld mcycle=%u ex_addr=0x%03x ex_is_csr=%d csr_rdata_ex=0x%08x mem_is_csr=%d mem_addr=0x%03x wb_csr_we=%d wb_addr=0x%03x dbg_wb_we=%d dbg_wb_rd=%d dbg_wb_wdata=0x%08x\n",
            cyc,
            top->rootp->core_top_pipelined->__PVT__u_csr_file__DOT__mcycle_cnt,
            top->rootp->core_top_pipelined->__PVT__ex_csr_addr,
            top->rootp->core_top_pipelined->__PVT__ex_is_csr,
            top->rootp->core_top_pipelined->__PVT__csr_rdata_ex,
            top->rootp->core_top_pipelined->__PVT__mem_is_csr_out,
            top->rootp->core_top_pipelined->__PVT__mem_csr_addr_out,
            top->rootp->core_top_pipelined->__PVT__wb_csr_we,
            top->rootp->core_top_pipelined->__PVT__wb_csr_addr_out,
            top->dbg_wb_reg_we, top->dbg_wb_reg_addr, top->dbg_wb_reg_wdata);
        top->clk = 1; top->eval();
    }
    top->final();
    delete top;
    return 0;
}
