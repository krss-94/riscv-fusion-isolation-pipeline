// tb_regfile.cpp -- Part 10 §2 unit test for regfile.sv. Checks x0 hardwired
// zero (read regardless of write attempts) and basic write/read-back on
// clock edges for all other registers.
#include "Vregfile.h"
#include "verilated.h"
#include <cstdio>
#include <cstdint>

static vluint64_t main_time = 0;
double sc_time_stamp() { return main_time; }

static void tick(Vregfile* dut) {
    dut->clk = 0; dut->eval(); main_time++;
    dut->clk = 1; dut->eval(); main_time++;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vregfile* dut = new Vregfile;
    int pass = 0, fail = 0;

    auto check = [&](const char* name, uint32_t got, uint32_t exp) {
        if (got == exp) { printf("PASS: %-28s -> 0x%08x\n", name, got); pass++; }
        else { printf("FAIL: %-28s -> got 0x%08x expected 0x%08x\n", name, got, exp); fail++; }
    };

    // x0 reads zero with no writes
    dut->rs1_addr = 0; dut->rs2_addr = 0; dut->rd_we = 0; dut->eval();
    check("x0_read_default", dut->rs1_data, 0);

    // attempt to write x0, confirm it stays zero
    dut->rd_we = 1; dut->rd_addr = 0; dut->rd_data = 0xDEADBEEF;
    tick(dut);
    dut->rd_we = 0; dut->rs1_addr = 0; dut->eval();
    check("x0_write_ignored", dut->rs1_data, 0);

    // write x1..x31 with distinct values, then read back
    dut->rd_we = 1;
    for (int r = 1; r <= 31; r++) {
        dut->rd_addr = r; dut->rd_data = 0x1000u * r + 7;
        tick(dut);
    }
    dut->rd_we = 0;
    for (int r = 1; r <= 31; r++) {
        char name[32]; snprintf(name, sizeof(name), "x%d_readback", r);
        dut->rs1_addr = r; dut->eval();
        check(name, dut->rs1_data, 0x1000u * r + 7);
    }

    // rs2 port independent of rs1
    dut->rs1_addr = 5; dut->rs2_addr = 10; dut->eval();
    check("rs1_port_x5", dut->rs1_data, 0x1000u*5+7);
    check("rs2_port_x10", dut->rs2_data, 0x1000u*10+7);

    // rs2 reading x0 also zero
    dut->rs2_addr = 0; dut->eval();
    check("x0_rs2_read", dut->rs2_data, 0);

    // write disabled -> no change
    dut->rd_we = 0; dut->rd_addr = 5; dut->rd_data = 0xFFFFFFFF;
    tick(dut);
    dut->rs1_addr = 5; dut->eval();
    check("write_disabled_no_change", dut->rs1_data, 0x1000u*5+7);

    printf("=== TOTAL PASS=%d FAIL=%d ===\n", pass, fail);
    dut->final();
    delete dut;
    return fail;
}
