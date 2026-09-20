/* Combinational control decoder. No CSR/SYSTEM/FENCE/custom-0 support in
 * Stage 2 (Part 7 §2's base ISA only, per Part 14) -- all of those decode
 * as safe no-ops (reg_write=0, mem_read=0, mem_write=0, PC+4) via the
 * default case, rather than anything meaningful. Fine as long as directed/
 * random RV32IM test programs don't contain them, which they won't by
 * construction at this stage. */
module decoder (
    input  logic [31:0] instr,
    output logic        reg_write,
    output logic        mem_read,
    output logic        mem_write,
    output logic [1:0]  mem_width,     /* 00=byte 01=half 10=word */
    output logic        mem_unsigned,
    output logic [3:0]  alu_op,
    output logic        alu_src_a_pc,  /* 0=rs1, 1=pc (AUIPC) */
    output logic        alu_src_b_imm, /* 0=rs2, 1=imm */
    output logic [1:0]  result_src,    /* 00=alu 01=mem 10=pc+4 11=imm */
    output logic        is_muldiv,
    output logic [2:0]  muldiv_op,     /* = funct3 */
    output logic        is_branch,
    output logic        is_jal,
    output logic        is_jalr,
    output logic        is_fisol_bound,
    output logic        is_fisol_off,
    output logic        illegal_instr,
    output logic        is_csr,
    output logic [1:0]  csr_op,       /* funct3[1:0]: 01=CSRRW 10=CSRRS 11=CSRRC */
    output logic [11:0] csr_addr      /* instr[31:20], valid whenever is_csr */
);
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];
    assign csr_addr = instr[31:20];

    localparam OP_LOAD   = 7'b0000011, OP_OPIMM = 7'b0010011, OP_AUIPC = 7'b0010111,
               OP_STORE  = 7'b0100011, OP_OP    = 7'b0110011, OP_LUI   = 7'b0110111,
               OP_BRANCH = 7'b1100011, OP_JALR  = 7'b1100111, OP_JAL   = 7'b1101111,
               OP_CUSTOM0 = 7'b0001011, OP_SYSTEM = 7'b1110011;

    always_comb begin
        /* defaults: safe no-op */
        reg_write = 1'b0; mem_read = 1'b0; mem_write = 1'b0;
        mem_width = 2'b10; mem_unsigned = 1'b0;
        alu_op = 4'h0; alu_src_a_pc = 1'b0; alu_src_b_imm = 1'b0;
        result_src = 2'b00; is_muldiv = 1'b0; muldiv_op = funct3;
        is_branch = 1'b0; is_jal = 1'b0; is_jalr = 1'b0;
        is_fisol_bound = 1'b0; is_fisol_off = 1'b0; illegal_instr = 1'b0;
        is_csr = 1'b0; csr_op = funct3[1:0];

        unique case (opcode)
            OP_OP: begin
                reg_write = 1'b1;
                if (funct7 == 7'b0000001) begin
                    is_muldiv = 1'b1;
                end else begin
                    unique case (funct3)
                        3'b000:  alu_op = funct7[5] ? 4'h1 : 4'h0; /* SUB : ADD */
                        3'b001:  alu_op = 4'h2; /* SLL */
                        3'b010:  alu_op = 4'h3; /* SLT */
                        3'b011:  alu_op = 4'h4; /* SLTU */
                        3'b100:  alu_op = 4'h5; /* XOR */
                        3'b101:  alu_op = funct7[5] ? 4'h7 : 4'h6; /* SRA : SRL */
                        3'b110:  alu_op = 4'h8; /* OR */
                        3'b111:  alu_op = 4'h9; /* AND */
                        default: alu_op = 4'h0;
                    endcase
                end
            end
            OP_OPIMM: begin
                reg_write = 1'b1; alu_src_b_imm = 1'b1;
                unique case (funct3)
                    3'b000:  alu_op = 4'h0; /* ADDI */
                    3'b001:  alu_op = 4'h2; /* SLLI */
                    3'b010:  alu_op = 4'h3; /* SLTI */
                    3'b011:  alu_op = 4'h4; /* SLTIU */
                    3'b100:  alu_op = 4'h5; /* XORI */
                    3'b101:  alu_op = instr[30] ? 4'h7 : 4'h6; /* SRAI : SRLI */
                    3'b110:  alu_op = 4'h8; /* ORI */
                    3'b111:  alu_op = 4'h9; /* ANDI */
                    default: alu_op = 4'h0;
                endcase
            end
            OP_LOAD: begin
                reg_write = 1'b1; mem_read = 1'b1; alu_src_b_imm = 1'b1;
                alu_op = 4'h0; result_src = 2'b01;
                mem_width = funct3[1:0]; mem_unsigned = funct3[2];
            end
            OP_STORE: begin
                mem_write = 1'b1; alu_src_b_imm = 1'b1; alu_op = 4'h0;
                mem_width = funct3[1:0];
            end
            OP_BRANCH: begin
                is_branch = 1'b1;
            end
            OP_JAL: begin
                reg_write = 1'b1; is_jal = 1'b1; result_src = 2'b10;
            end
            OP_JALR: begin
                reg_write = 1'b1; is_jalr = 1'b1; result_src = 2'b10;
                alu_src_b_imm = 1'b1; alu_op = 4'h0;
            end
            OP_LUI: begin
                reg_write = 1'b1; result_src = 2'b11;
            end
            OP_AUIPC: begin
                reg_write = 1'b1; alu_src_a_pc = 1'b1; alu_src_b_imm = 1'b1; alu_op = 4'h0;
            end
            OP_CUSTOM0: begin
                unique case (funct3)
                    3'b000:  is_fisol_bound = 1'b1;
                    3'b001:  is_fisol_off  = 1'b1;
                    default: illegal_instr = 1'b1; /* reserved funct3 010-111, Part 7 §3.1 */
                endcase
            end
            OP_SYSTEM: begin
                unique case (funct3)
                    3'b001:  begin reg_write = 1'b1; is_csr = 1'b1; end /* CSRRW */
                    3'b010:  begin reg_write = 1'b1; is_csr = 1'b1; end /* CSRRS */
                    3'b011:  begin reg_write = 1'b1; is_csr = 1'b1; end /* CSRRC */
                    default: illegal_instr = 1'b1; /* 000: ECALL/EBREAK/MRET/priv (not implemented); 100: reserved; 101-111: CSRRWI/CSRRSI/CSRRCI (deferred) */
                endcase
            end
            default: ; /* FENCE, anything else: no-op */
        endcase
    end
endmodule
