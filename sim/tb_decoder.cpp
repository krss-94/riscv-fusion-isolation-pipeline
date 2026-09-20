// tb_decoder.cpp -- Part 10 §2 unit test for decoder.sv. Feeds encoded
// instruction words and checks every control-signal output, per opcode.
// Includes the required reserved-FISOL-funct3 -> illegal_instr dedicated
// test (Part 10 §2, decoder bullet).
#include "Vdecoder.h"
#include "verilated.h"
#include <cstdio>
#include <cstdint>

struct Exp {
    const char* name;
    uint32_t instr;
    int reg_write, mem_read, mem_write;
    int mem_width, mem_unsigned;
    int alu_op;
    int alu_src_a_pc, alu_src_b_imm;
    int result_src;
    int is_muldiv;
    int is_branch, is_jal, is_jalr;
    int is_fisol_bound, is_fisol_off;
    int illegal_instr;
    int is_csr, csr_op;
};

static uint32_t r_type(uint32_t f7, uint32_t rs2, uint32_t rs1, uint32_t f3, uint32_t rd, uint32_t op) {
    return f7 << 25 | rs2 << 20 | rs1 << 15 | f3 << 12 | rd << 7 | op;
}
static uint32_t i_type(uint32_t imm12, uint32_t rs1, uint32_t f3, uint32_t rd, uint32_t op) {
    return (imm12 & 0xFFF) << 20 | rs1 << 15 | f3 << 12 | rd << 7 | op;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vdecoder* dut = new Vdecoder;
    int pass = 0, fail = 0;

    const uint32_t OP_LOAD=0b0000011, OP_IMM=0b0010011, OP_AUIPC=0b0010111,
                    OP_STORE=0b0100011, OP_OP=0b0110011, OP_LUI=0b0110111,
                    OP_BRANCH=0b1100011, OP_JALR=0b1100111, OP_JAL=0b1101111,
                    OP_CUSTOM0=0b0001011, OP_SYSTEM=0b1110011;

    Exp vecs[] = {
        {"OP_ADD",  r_type(0b0000000,1,2,0b000,3,OP_OP), 1,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OP_SUB",  r_type(0b0100000,1,2,0b000,3,OP_OP), 1,0,0, 2,0, 0x1, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OP_SLL",  r_type(0b0000000,1,2,0b001,3,OP_OP), 1,0,0, 2,0, 0x2, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OP_SLT",  r_type(0b0000000,1,2,0b010,3,OP_OP), 1,0,0, 2,0, 0x3, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OP_SLTU", r_type(0b0000000,1,2,0b011,3,OP_OP), 1,0,0, 2,0, 0x4, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OP_XOR",  r_type(0b0000000,1,2,0b100,3,OP_OP), 1,0,0, 2,0, 0x5, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OP_SRL",  r_type(0b0000000,1,2,0b101,3,OP_OP), 1,0,0, 2,0, 0x6, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OP_SRA",  r_type(0b0100000,1,2,0b101,3,OP_OP), 1,0,0, 2,0, 0x7, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OP_OR",   r_type(0b0000000,1,2,0b110,3,OP_OP), 1,0,0, 2,0, 0x8, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OP_AND",  r_type(0b0000000,1,2,0b111,3,OP_OP), 1,0,0, 2,0, 0x9, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OP_MULDIV", r_type(0b0000001,1,2,0b000,3,OP_OP), 1,0,0, 2,0, 0x0, 0,0, 0b00, 1, 0,0,0, 0,0, 0, 0,0},

        {"OPIMM_ADDI", i_type(5,1,0b000,3,OP_IMM), 1,0,0, 2,0, 0x0, 0,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OPIMM_SLLI", i_type(5,1,0b001,3,OP_IMM), 1,0,0, 2,0, 0x2, 0,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OPIMM_SLTI", i_type(5,1,0b010,3,OP_IMM), 1,0,0, 2,0, 0x3, 0,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OPIMM_SLTIU",i_type(5,1,0b011,3,OP_IMM), 1,0,0, 2,0, 0x4, 0,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OPIMM_XORI", i_type(5,1,0b100,3,OP_IMM), 1,0,0, 2,0, 0x5, 0,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OPIMM_SRLI", i_type(5,1,0b101,3,OP_IMM), 1,0,0, 2,0, 0x6, 0,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OPIMM_SRAI", i_type((1u<<10)|5,1,0b101,3,OP_IMM), 1,0,0, 2,0, 0x7, 0,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OPIMM_ORI",  i_type(5,1,0b110,3,OP_IMM), 1,0,0, 2,0, 0x8, 0,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
        {"OPIMM_ANDI", i_type(5,1,0b111,3,OP_IMM), 1,0,0, 2,0, 0x9, 0,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},

        {"LOAD_LB",  i_type(0,1,0b000,3,OP_LOAD), 1,1,0, 0,0, 0x0, 0,1, 0b01, 0, 0,0,0, 0,0, 0, 0,0},
        {"LOAD_LH",  i_type(0,1,0b001,3,OP_LOAD), 1,1,0, 1,0, 0x0, 0,1, 0b01, 0, 0,0,0, 0,0, 0, 0,0},
        {"LOAD_LW",  i_type(0,1,0b010,3,OP_LOAD), 1,1,0, 2,0, 0x0, 0,1, 0b01, 0, 0,0,0, 0,0, 0, 0,0},
        {"LOAD_LBU", i_type(0,1,0b100,3,OP_LOAD), 1,1,0, 0,1, 0x0, 0,1, 0b01, 0, 0,0,0, 0,0, 0, 0,0},
        {"LOAD_LHU", i_type(0,1,0b101,3,OP_LOAD), 1,1,0, 1,1, 0x0, 0,1, 0b01, 0, 0,0,0, 0,0, 0, 0,0},

        {"STORE_SW", r_type(0,1,2,0b010,0,OP_STORE), 0,0,1, 2,0, 0x0, 0,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},

        {"BRANCH_BEQ", r_type(0,1,2,0b000,0,OP_BRANCH), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 1,0,0, 0,0, 0, 0,0},

        {"JAL",  0b1101111u, 1,0,0, 2,0, 0x0, 0,0, 0b10, 0, 0,1,0, 0,0, 0, 0,0},
        {"JALR", i_type(0,1,0b000,3,OP_JALR), 1,0,0, 2,0, 0x0, 0,1, 0b10, 0, 0,0,1, 0,0, 0, 0,0},

        {"LUI",   0b0110111u, 1,0,0, 2,0, 0x0, 0,0, 0b11, 0, 0,0,0, 0,0, 0, 0,0},
        {"AUIPC", 0b0010111u, 1,0,0, 2,0, 0x0, 1,1, 0b00, 0, 0,0,0, 0,0, 0, 0,0},

        {"FISOL_BOUND", i_type(0,0,0b000,0,OP_CUSTOM0), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 1,0, 0, 0,0},
        {"FISOL_OFF",   i_type(0,0,0b001,0,OP_CUSTOM0), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,1, 0, 0,0},
        {"FISOL_RSVD_010", i_type(0,0,0b010,0,OP_CUSTOM0), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 1, 0,0},
        {"FISOL_RSVD_011", i_type(0,0,0b011,0,OP_CUSTOM0), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 1, 0,0},
        {"FISOL_RSVD_100", i_type(0,0,0b100,0,OP_CUSTOM0), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 1, 0,0},
        {"FISOL_RSVD_101", i_type(0,0,0b101,0,OP_CUSTOM0), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 1, 0,0},
        {"FISOL_RSVD_110", i_type(0,0,0b110,0,OP_CUSTOM0), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 1, 0,0},
        {"FISOL_RSVD_111", i_type(0,0,0b111,0,OP_CUSTOM0), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 1, 0,0},

        {"SYSTEM_CSRRW", i_type(0,1,0b001,3,OP_SYSTEM), 1,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 1,0b01},
        {"SYSTEM_CSRRS", i_type(0,1,0b010,3,OP_SYSTEM), 1,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 1,0b10},
        {"SYSTEM_CSRRC", i_type(0,1,0b011,3,OP_SYSTEM), 1,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 1,0b11},
        {"SYSTEM_ECALL_ETC", i_type(0,1,0b000,3,OP_SYSTEM), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 1, 0,0},
        {"SYSTEM_RSVD_100",  i_type(0,1,0b100,3,OP_SYSTEM), 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 1, 0,0},

        {"UNKNOWN_OPCODE_NOOP", 0b1111111u, 0,0,0, 2,0, 0x0, 0,0, 0b00, 0, 0,0,0, 0,0, 0, 0,0},
    };

    for (auto& v : vecs) {
        dut->instr = v.instr;
        dut->eval();
        bool ok = true;
        ok &= (dut->reg_write == v.reg_write);
        ok &= (dut->mem_read == v.mem_read);
        ok &= (dut->mem_write == v.mem_write);
        ok &= (dut->mem_width == v.mem_width);
        ok &= (dut->mem_unsigned == v.mem_unsigned);
        ok &= (dut->alu_op == v.alu_op);
        ok &= (dut->alu_src_a_pc == v.alu_src_a_pc);
        ok &= (dut->alu_src_b_imm == v.alu_src_b_imm);
        ok &= (dut->result_src == v.result_src);
        ok &= (dut->is_muldiv == v.is_muldiv);
        ok &= (dut->is_branch == v.is_branch);
        ok &= (dut->is_jal == v.is_jal);
        ok &= (dut->is_jalr == v.is_jalr);
        ok &= (dut->is_fisol_bound == v.is_fisol_bound);
        ok &= (dut->is_fisol_off == v.is_fisol_off);
        ok &= (dut->illegal_instr == v.illegal_instr);
        ok &= (dut->is_csr == v.is_csr);
        if (v.is_csr) ok &= (dut->csr_op == v.csr_op);

        if (ok) {
            printf("PASS: %-20s instr=0x%08x\n", v.name, v.instr);
            pass++;
        } else {
            printf("FAIL: %-20s instr=0x%08x  rw=%d mr=%d mw=%d width=%d uns=%d alu=%x "
                   "apc=%d bimm=%d rsrc=%d md=%d br=%d jal=%d jalr=%d fb=%d fo=%d ill=%d csr=%d csrop=%d\n",
                   v.name, v.instr, dut->reg_write, dut->mem_read, dut->mem_write,
                   dut->mem_width, dut->mem_unsigned, dut->alu_op, dut->alu_src_a_pc,
                   dut->alu_src_b_imm, dut->result_src, dut->is_muldiv, dut->is_branch,
                   dut->is_jal, dut->is_jalr, dut->is_fisol_bound, dut->is_fisol_off,
                   dut->illegal_instr, dut->is_csr, dut->csr_op);
            fail++;
        }
    }

    printf("=== TOTAL PASS=%d FAIL=%d ===\n", pass, fail);
    dut->final();
    delete dut;
    return fail;
}
