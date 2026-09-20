// tb_core.cpp -- loads a flat binary at MEM_BASE, runs N cycles, emits a
// per-cycle commit log: "core 0: 3 0xPC (0xINSTR) xN 0xVAL" for register
// writes and "core 0: 3 0xPC (0xINSTR) mem 0xADDR 0xVAL" for stores --
// same fields Spike's --log-commits prints, intentionally omitting the
// disassembly text (not worth building a second disassembler for; the
// numeric fields are what lockstep-checking actually needs).
#include "Vcore_top.h"
#include "verilated.h"
#include "Vcore_top___024root.h"
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
    Vcore_top* top = new Vcore_top;

    std::ifstream f(argv[1], std::ios::binary);
    if (!f) { fprintf(stderr, "cannot open %s\n", argv[1]); return 1; }
    std::vector<uint8_t> image((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
    for (size_t i = 0; i < image.size(); i++)
        top->rootp->core_top__DOT__mem[i] = image[i];

    long max_cycles = atol(argv[2]);

    top->rst_n = 0; top->clk = 0;
    top->eval();
    top->clk = 1; top->eval();
    top->rst_n = 1;

    for (long cyc = 0; cyc < max_cycles; cyc++) {
        /* Settle combinational logic for the CURRENT pc/instr first, and
         * print here -- BEFORE the clk=1 edge that actually commits these
         * values. Printing after both edges (the original bug) shows each
         * line one instruction late, because dbg_pc/dbg_instr are purely
         * combinational off the pc register: by the time a post-edge print
         * runs, pc has already advanced and instr already reflects the
         * NEXT instruction's fetch, silently losing the very first commit
         * entirely. */
        top->clk = 0; top->eval();

        printf("core   0: 0x%08x (0x%08x) [decode]\n", top->dbg_pc, top->dbg_instr);
        if (top->dbg_reg_we)
            printf("core   0: 3 0x%08x (0x%08x) x%d  0x%08x\n",
                   top->dbg_pc, top->dbg_instr, top->dbg_reg_addr, top->dbg_reg_wdata);
        if (top->dbg_mem_we)
            printf("core   0: 3 0x%08x (0x%08x) mem 0x%08x 0x%08x\n",
                   top->dbg_pc, top->dbg_instr, top->dbg_mem_addr, top->dbg_mem_wdata);

        if (top->dbg_mem_we && top->dbg_mem_addr == 0x80000000u) {
            fprintf(stderr, "UART: %c", (char)(top->dbg_mem_wdata & 0xff));
        }

        top->clk = 1; top->eval();
    }

    top->final();
    delete top;
    return 0;
}
