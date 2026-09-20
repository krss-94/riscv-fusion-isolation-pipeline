// tb_imm_gen.cpp -- Part 10 §2 unit test for imm_gen.sv. Encodes a known
// immediate into each format's bit layout (matching imm_gen.sv's decode
// case exactly), feeds the encoded instruction word in, and checks the
// RTL's sign-extended imm output against the value encoded. Boundary
// values per format: most-negative, most-positive representable, zero,
// and -1/-2 to exercise the sign-extension path. I/LOAD/JALR share one
// decode arm and are all three exercised since imm_gen switches on them
// together.
#include "Vimm_gen.h"
#include "verilated.h"
#include <cstdio>
#include <cstdint>

static uint32_t enc_I(int32_t imm, uint32_t opcode) {
    return ((uint32_t)imm & 0xFFFu) << 20 | opcode;
}
static uint32_t enc_S(int32_t imm, uint32_t opcode) {
    uint32_t u = (uint32_t)imm & 0xFFFu;
    return ((u >> 5) & 0x7Fu) << 25 | (u & 0x1Fu) << 7 | opcode;
}
static uint32_t enc_B(int32_t imm, uint32_t opcode) {
    uint32_t u = (uint32_t)imm; // 13-bit signed value, bit0 implicit 0
    uint32_t b31 = (u >> 12) & 1u, b7 = (u >> 11) & 1u;
    uint32_t b30_25 = (u >> 5) & 0x3Fu, b11_8 = (u >> 1) & 0xFu;
    return b31 << 31 | b30_25 << 25 | b11_8 << 8 | b7 << 7 | opcode;
}
static uint32_t enc_U(uint32_t imm_upper20_shifted, uint32_t opcode) {
    return (imm_upper20_shifted & 0xFFFFF000u) | opcode;
}
static uint32_t enc_J(int32_t imm, uint32_t opcode) {
    uint32_t u = (uint32_t)imm; // 21-bit signed value, bit0 implicit 0
    uint32_t b31 = (u >> 20) & 1u, b19_12 = (u >> 12) & 0xFFu;
    uint32_t b20 = (u >> 11) & 1u, b30_21 = (u >> 1) & 0x3FFu;
    return b31 << 31 | b19_12 << 12 | b20 << 20 | b30_21 << 21 | opcode;
}

struct Vec { const char* name; uint32_t instr; int32_t expect; };

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vimm_gen* dut = new Vimm_gen;
    int pass = 0, fail = 0;

    const uint32_t OP_LOAD = 0b0000011, OP_IMM = 0b0010011, OP_JALR = 0b1100111;
    const uint32_t OP_STORE = 0b0100011, OP_BRANCH = 0b1100011;
    const uint32_t OP_LUI = 0b0110111, OP_AUIPC = 0b0010111, OP_JAL = 0b1101111;

    Vec vecs[] = {
        {"I_OP_IMM_max",  enc_I(2047, OP_IMM),   2047},
        {"I_OP_IMM_min",  enc_I(-2048, OP_IMM), -2048},
        {"I_OP_IMM_zero", enc_I(0, OP_IMM),         0},
        {"I_OP_IMM_neg1", enc_I(-1, OP_IMM),       -1},
        {"I_LOAD_max",    enc_I(2047, OP_LOAD),  2047},
        {"I_LOAD_min",    enc_I(-2048, OP_LOAD),-2048},
        {"I_JALR_max",    enc_I(2047, OP_JALR),  2047},
        {"I_JALR_min",    enc_I(-2048, OP_JALR),-2048},

        {"S_max",  enc_S(2047, OP_STORE),  2047},
        {"S_min",  enc_S(-2048, OP_STORE),-2048},
        {"S_zero", enc_S(0, OP_STORE),        0},
        {"S_neg1", enc_S(-1, OP_STORE),      -1},

        {"B_max",  enc_B(4094, OP_BRANCH),  4094},
        {"B_min",  enc_B(-4096, OP_BRANCH),-4096},
        {"B_zero", enc_B(0, OP_BRANCH),         0},
        {"B_neg2", enc_B(-2, OP_BRANCH),       -2},

        {"U_LUI_max",   enc_U(0xFFFFF000u, OP_LUI),   (int32_t)0xFFFFF000u},
        {"U_LUI_min",   enc_U(0x00000000u, OP_LUI),                     0},
        {"U_LUI_mid",   enc_U(0x12345000u, OP_LUI),   (int32_t)0x12345000u},
        {"U_AUIPC_mid", enc_U(0xABCDE000u, OP_AUIPC), (int32_t)0xABCDE000u},

        {"J_max",  enc_J(1048574, OP_JAL),  1048574},
        {"J_min",  enc_J(-1048576, OP_JAL),-1048576},
        {"J_zero", enc_J(0, OP_JAL),             0},
        {"J_neg2", enc_J(-2, OP_JAL),           -2},

        // unrecognized opcode -> default case must be 0, not garbage
        {"default_unknown_opcode", 0b1111111u, 0},
    };

    for (auto& v : vecs) {
        dut->instr = v.instr;
        dut->eval();
        int32_t got = (int32_t)dut->imm;
        if (got == v.expect) {
            printf("PASS: %-24s instr=0x%08x -> %d\n", v.name, v.instr, got);
            pass++;
        } else {
            printf("FAIL: %-24s instr=0x%08x -> got %d expected %d\n",
                   v.name, v.instr, got, v.expect);
            fail++;
        }
    }

    printf("=== TOTAL PASS=%d FAIL=%d ===\n", pass, fail);
    dut->final();
    delete dut;
    return fail;
}
