// tb_alu.cpp -- Part 10 §2 unit test for alu.sv. Directed cases for
// ADD/SUB sign-overflow boundaries and SLT/SLTU signed-vs-unsigned
// disagreement points, plus bitwise sanity checks, plus an exhaustive
// 0..31 shift-amount sweep for SLL/SRL/SRA (SRA against both a negative
// and a positive operand to hit the sign-extension boundary), plus
// explicit b>31 cases confirming the RTL's `b[4:0]` truncation (b=32
// behaves like b=0, b=63 like b=31).
#include "Valu.h"
#include "verilated.h"
#include <cstdio>
#include <cstdint>

enum { ALU_ADD=0, ALU_SUB=1, ALU_SLL=2, ALU_SLT=3, ALU_SLTU=4,
       ALU_XOR=5, ALU_SRL=6, ALU_SRA=7, ALU_OR=8, ALU_AND=9 };

struct Vec { const char* name; uint32_t op, a, b, expect; };

static Vec vecs[] = {
    // ADD: overflow/wrap boundaries
    {"add_zero",       ALU_ADD, 0x00000000u, 0x00000000u, 0x00000000u},
    {"add_smax_p1",    ALU_ADD, 0x7FFFFFFFu, 0x00000001u, 0x80000000u},
    {"add_neg1_p1",    ALU_ADD, 0xFFFFFFFFu, 0x00000001u, 0x00000000u},
    {"add_smin_smin",  ALU_ADD, 0x80000000u, 0x80000000u, 0x00000000u},
    {"add_5_neg3",     ALU_ADD, 0x00000005u, 0xFFFFFFFDu, 0x00000002u},

    // SUB: underflow/overflow boundaries
    {"sub_0_1",        ALU_SUB, 0x00000000u, 0x00000001u, 0xFFFFFFFFu},
    {"sub_smin_1",     ALU_SUB, 0x80000000u, 0x00000001u, 0x7FFFFFFFu},
    {"sub_smax_neg1",  ALU_SUB, 0x7FFFFFFFu, 0xFFFFFFFFu, 0x80000000u},
    {"sub_eq",         ALU_SUB, 0x00000005u, 0x00000005u, 0x00000000u},

    // SLT (signed): the classic signed/unsigned disagreement points
    {"slt_smin_smax",  ALU_SLT, 0x80000000u, 0x7FFFFFFFu, 0x00000001u},
    {"slt_smax_smin",  ALU_SLT, 0x7FFFFFFFu, 0x80000000u, 0x00000000u},
    {"slt_neg1_0",     ALU_SLT, 0xFFFFFFFFu, 0x00000000u, 0x00000001u},
    {"slt_eq",         ALU_SLT, 0x00000005u, 0x00000005u, 0x00000000u},

    // SLTU (unsigned): same bit patterns, opposite verdicts
    {"sltu_smin_smax", ALU_SLTU, 0x80000000u, 0x7FFFFFFFu, 0x00000000u},
    {"sltu_smax_smin", ALU_SLTU, 0x7FFFFFFFu, 0x80000000u, 0x00000001u},
    {"sltu_0_ffff",    ALU_SLTU, 0x00000000u, 0xFFFFFFFFu, 0x00000001u},
    {"sltu_ffff_0",    ALU_SLTU, 0xFFFFFFFFu, 0x00000000u, 0x00000000u},

    // Bitwise sanity
    {"xor_complement", ALU_XOR, 0xF0F0F0F0u, 0x0F0F0F0Fu, 0xFFFFFFFFu},
    {"xor_self",       ALU_XOR, 0x12345678u, 0x12345678u, 0x00000000u},
    {"and_zero",       ALU_AND, 0xFFFFFFFFu, 0x00000000u, 0x00000000u},
    {"and_self",       ALU_AND, 0xFFFFFFFFu, 0xFFFFFFFFu, 0xFFFFFFFFu},
    {"or_complement",  ALU_OR,  0xAAAAAAAAu, 0x55555555u, 0xFFFFFFFFu},

    // b[4:0] truncation, explicit b>31 cases (b=32 ~ shamt 0, b=63 ~ shamt 31)
    {"sll_b32_eq_b0",  ALU_SLL, 0xFFFFFFFFu, 32, 0xFFFFFFFFu},
    {"sll_b63_eq_b31", ALU_SLL, 0xFFFFFFFFu, 63, 0x80000000u},
    {"srl_b32_eq_b0",  ALU_SRL, 0xFFFFFFFFu, 32, 0xFFFFFFFFu},
    {"srl_b63_eq_b31", ALU_SRL, 0xFFFFFFFFu, 63, 0x00000001u},
    {"sra_b32_eq_b0",  ALU_SRA, 0x80000000u, 32, 0x80000000u},
    {"sra_b63_eq_b31", ALU_SRA, 0x80000000u, 63, 0xFFFFFFFFu},
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Valu* dut = new Valu;
    int pass = 0, fail = 0;

    auto check = [&](const char* name, uint32_t op, uint32_t a, uint32_t b, uint32_t expect) {
        dut->a = a; dut->b = b; dut->alu_op = op;
        dut->eval();
        if (dut->result == expect) {
            printf("PASS: %-16s op=%u a=0x%08x b=0x%08x -> 0x%08x\n", name, op, a, b, dut->result);
            pass++;
        } else {
            printf("FAIL: %-16s op=%u a=0x%08x b=0x%08x -> got 0x%08x expected 0x%08x\n",
                   name, op, a, b, dut->result, expect);
            fail++;
        }
    };

    for (auto& v : vecs) check(v.name, v.op, v.a, v.b, v.expect);

    // Exhaustive shift-amount sweep, 0..31, two operand patterns each
    char nbuf[48];
    for (int amt = 0; amt < 32; amt++) {
        uint32_t sll_expect = 0xFFFFFFFFu << amt;                 // all-ones operand
        snprintf(nbuf, sizeof nbuf, "sll_amt%d", amt);
        check(nbuf, ALU_SLL, 0xFFFFFFFFu, (uint32_t)amt, sll_expect);

        uint32_t srl_expect = 0xFFFFFFFFu >> amt;                 // all-ones operand
        snprintf(nbuf, sizeof nbuf, "srl_amt%d", amt);
        check(nbuf, ALU_SRL, 0xFFFFFFFFu, (uint32_t)amt, srl_expect);

        int32_t sra_neg_expect = (int32_t)0x80000000u >> amt;     // INT_MIN, sign must extend
        snprintf(nbuf, sizeof nbuf, "sra_negop_amt%d", amt);
        check(nbuf, ALU_SRA, 0x80000000u, (uint32_t)amt, (uint32_t)sra_neg_expect);

        int32_t sra_pos_expect = (int32_t)0x7FFFFFFFu >> amt;     // INT_MAX, no sign bit to extend
        snprintf(nbuf, sizeof nbuf, "sra_posop_amt%d", amt);
        check(nbuf, ALU_SRA, 0x7FFFFFFFu, (uint32_t)amt, (uint32_t)sra_pos_expect);
    }

    printf("=== TOTAL PASS=%d FAIL=%d ===\n", pass, fail);
    dut->final();
    delete dut;
    return fail;
}
