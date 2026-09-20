/* Pipeline stage registers for the Part 8 baseline 5-stage core (IF/ID,
 * ID/EX, EX/MEM, MEM/WB). Each has a synchronous clear (bubble insertion,
 * for stalls/flushes) that takes priority over the normal load, and a
 * stall input that holds the current contents instead of advancing
 * (for load-use hazard and muldiv-busy stalls). clear and stall together
 * is treated as clear-wins (inserting a bubble is always safe even if a
 * stall was also requested that cycle).
 */

module if_id_reg (
    input  logic        clk, rst_n, stall, clear,
    input  logic [31:0] pc_in, instr_in, instr_next_in,
    input  logic        lookahead_valid_in,
    output logic [31:0] pc_out, instr_out, instr_next_out,
    output logic        lookahead_valid_out
);
    /* lookahead_valid: Part 8 SS2.1 -- cleared on any redirect (clear),
     * re-asserted the very next cycle once a fetch from the new stream
     * has completed (lookahead_valid_in = !flush_id at the call site,
     * already true starting the first real post-redirect fetch). A
     * control-flow-boundary hazard, distinct from the register-
     * dependency interlock in SS2.2/SS2.5. */
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n || clear) begin
            pc_out <= 32'b0; instr_out <= 32'h00000013;
            instr_next_out <= 32'h00000013; lookahead_valid_out <= 1'b0;
        end else if (!stall) begin
            pc_out <= pc_in; instr_out <= instr_in;
            instr_next_out <= instr_next_in; lookahead_valid_out <= lookahead_valid_in;
        end
    end
endmodule

module id_ex_reg (
    input  logic        clk, rst_n, stall, clear,
    input  logic [31:0] pc_in, rs1_data_in, rs2_data_in, imm_in,
    input  logic [4:0]  rs1_addr_in, rs2_addr_in, rd_addr_in,
    input  logic [31:0] instr_in,
    input  logic        reg_write_in, mem_read_in, mem_write_in,
    input  logic [1:0]  mem_width_in, result_src_in,
    input  logic        mem_unsigned_in,
    input  logic [3:0]  alu_op_in,
    input  logic        alu_src_a_pc_in, alu_src_b_imm_in,
    input  logic        is_muldiv_in, is_branch_in, is_jal_in, is_jalr_in,
    input  logic [2:0]  muldiv_op_in,
    input  logic        illegal_instr_in,
    input  logic        is_csr_in,
    input  logic [1:0]  csr_op_in,
    input  logic [11:0] csr_addr_in,
    input  logic        is_fisol_bound_in, is_fisol_off_in,
    input  logic        pend2_valid_in,
    input  logic [4:0]  pend2_addr_in,
    input  logic [31:0] pend2_data_in,
    input  logic        fuse4_valid_in,
    input  logic        fuse4_bne_in,
    input  logic [31:0] fuse4_target_in,

    output logic [31:0] pc_out, rs1_data_out, rs2_data_out, imm_out,
    output logic [4:0]  rs1_addr_out, rs2_addr_out, rd_addr_out,
    output logic [31:0] instr_out,
    output logic        reg_write_out, mem_read_out, mem_write_out,
    output logic [1:0]  mem_width_out, result_src_out,
    output logic        mem_unsigned_out,
    output logic [3:0]  alu_op_out,
    output logic        alu_src_a_pc_out, alu_src_b_imm_out,
    output logic        is_muldiv_out, is_branch_out, is_jal_out, is_jalr_out,
    output logic [2:0]  muldiv_op_out,
    output logic        illegal_instr_out,
    output logic        is_csr_out,
    output logic [1:0]  csr_op_out,
    output logic [11:0] csr_addr_out,
    output logic        is_fisol_bound_out, is_fisol_off_out,
    output logic        pend2_valid_out,
    output logic [4:0]  pend2_addr_out,
    output logic [31:0] pend2_data_out,
    output logic        fuse4_valid_out,
    output logic        fuse4_bne_out,
    output logic [31:0] fuse4_target_out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n || clear) begin
            pc_out <= 32'b0; rs1_data_out <= 32'b0; rs2_data_out <= 32'b0; imm_out <= 32'b0;
            rs1_addr_out <= 5'b0; rs2_addr_out <= 5'b0; rd_addr_out <= 5'b0;
            instr_out <= 32'h00000013;
            reg_write_out <= 1'b0; mem_read_out <= 1'b0; mem_write_out <= 1'b0;
            mem_width_out <= 2'b10; result_src_out <= 2'b00; mem_unsigned_out <= 1'b0;
            alu_op_out <= 4'b0; alu_src_a_pc_out <= 1'b0; alu_src_b_imm_out <= 1'b0;
            is_muldiv_out <= 1'b0; is_branch_out <= 1'b0; is_jal_out <= 1'b0; is_jalr_out <= 1'b0;
            muldiv_op_out <= 3'b0; illegal_instr_out <= 1'b0; is_csr_out <= 1'b0;
            csr_op_out <= 2'b0; csr_addr_out <= 12'b0;
            is_fisol_bound_out <= 1'b0; is_fisol_off_out <= 1'b0;
            pend2_valid_out <= 1'b0; pend2_addr_out <= 5'b0; pend2_data_out <= 32'b0;
            fuse4_valid_out <= 1'b0; fuse4_bne_out <= 1'b0; fuse4_target_out <= 32'b0;
        end else if (!stall) begin
            pc_out <= pc_in; rs1_data_out <= rs1_data_in; rs2_data_out <= rs2_data_in; imm_out <= imm_in;
            rs1_addr_out <= rs1_addr_in; rs2_addr_out <= rs2_addr_in; rd_addr_out <= rd_addr_in;
            instr_out <= instr_in;
            reg_write_out <= reg_write_in; mem_read_out <= mem_read_in; mem_write_out <= mem_write_in;
            mem_width_out <= mem_width_in; result_src_out <= result_src_in; mem_unsigned_out <= mem_unsigned_in;
            alu_op_out <= alu_op_in; alu_src_a_pc_out <= alu_src_a_pc_in; alu_src_b_imm_out <= alu_src_b_imm_in;
            is_muldiv_out <= is_muldiv_in; is_branch_out <= is_branch_in; is_jal_out <= is_jal_in; is_jalr_out <= is_jalr_in;
            muldiv_op_out <= muldiv_op_in; illegal_instr_out <= illegal_instr_in;
            is_csr_out <= is_csr_in;
            csr_op_out <= csr_op_in; csr_addr_out <= csr_addr_in;
            is_fisol_bound_out <= is_fisol_bound_in; is_fisol_off_out <= is_fisol_off_in;
            pend2_valid_out <= pend2_valid_in; pend2_addr_out <= pend2_addr_in; pend2_data_out <= pend2_data_in;
            fuse4_valid_out <= fuse4_valid_in; fuse4_bne_out <= fuse4_bne_in; fuse4_target_out <= fuse4_target_in;
        end
    end
endmodule

module ex_mem_reg (
    input  logic        clk, rst_n, stall, clear,
    input  logic [31:0] alu_result_in, muldiv_result_in, rs2_data_in, pc_plus4_in, imm_in,
    input  logic [4:0]  rd_addr_in,
    input  logic [31:0] instr_in,
    input  logic        reg_write_in, mem_read_in, mem_write_in,
    input  logic [1:0]  mem_width_in, result_src_in,
    input  logic        mem_unsigned_in, is_muldiv_in,
    input  logic        is_csr_in,
    input  logic [11:0] csr_addr_in,
    input  logic        is_fisol_bound_in, is_fisol_off_in,
    input  logic        pend2_valid_in,
    input  logic [4:0]  pend2_addr_in,
    input  logic [31:0] pend2_data_in,

    output logic [31:0] alu_result_out, muldiv_result_out, rs2_data_out, pc_plus4_out, imm_out,
    output logic [4:0]  rd_addr_out,
    output logic [31:0] instr_out,
    output logic        reg_write_out, mem_read_out, mem_write_out,
    output logic [1:0]  mem_width_out, result_src_out,
    output logic        mem_unsigned_out, is_muldiv_out,
    output logic        is_csr_out,
    output logic [11:0] csr_addr_out,
    output logic        is_fisol_bound_out, is_fisol_off_out,
    output logic        pend2_valid_out,
    output logic [4:0]  pend2_addr_out,
    output logic [31:0] pend2_data_out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n || clear) begin
            alu_result_out <= 32'b0; muldiv_result_out <= 32'b0; rs2_data_out <= 32'b0;
            pc_plus4_out <= 32'b0; imm_out <= 32'b0; rd_addr_out <= 5'b0; instr_out <= 32'h00000013;
            reg_write_out <= 1'b0; mem_read_out <= 1'b0; mem_write_out <= 1'b0;
            mem_width_out <= 2'b10; result_src_out <= 2'b00; mem_unsigned_out <= 1'b0; is_muldiv_out <= 1'b0;
            is_csr_out <= 1'b0; csr_addr_out <= 12'b0;
            is_fisol_bound_out <= 1'b0; is_fisol_off_out <= 1'b0;
            pend2_valid_out <= 1'b0; pend2_addr_out <= 5'b0; pend2_data_out <= 32'b0;
        end else if (!stall) begin
            alu_result_out <= alu_result_in; muldiv_result_out <= muldiv_result_in; rs2_data_out <= rs2_data_in;
            pc_plus4_out <= pc_plus4_in; imm_out <= imm_in; rd_addr_out <= rd_addr_in; instr_out <= instr_in;
            reg_write_out <= reg_write_in; mem_read_out <= mem_read_in; mem_write_out <= mem_write_in;
            mem_width_out <= mem_width_in; result_src_out <= result_src_in;
            mem_unsigned_out <= mem_unsigned_in; is_muldiv_out <= is_muldiv_in;
            is_csr_out <= is_csr_in; csr_addr_out <= csr_addr_in;
            is_fisol_bound_out <= is_fisol_bound_in; is_fisol_off_out <= is_fisol_off_in;
            pend2_valid_out <= pend2_valid_in; pend2_addr_out <= pend2_addr_in; pend2_data_out <= pend2_data_in;
        end
    end
endmodule

module mem_wb_reg (
    input  logic        clk, rst_n, stall, clear,
    input  logic [31:0] alu_result_in, muldiv_result_in, pc_plus4_in, imm_in,
    input  logic [4:0]  rd_addr_in,
    input  logic [31:0] instr_in,
    input  logic        reg_write_in,
    input  logic [1:0]  result_src_in,
    input  logic        is_muldiv_in,
    input  logic        is_csr_in,
    input  logic [11:0] csr_addr_in,
    input  logic        is_fisol_bound_in, is_fisol_off_in,
    input  logic        pend2_valid_in,
    input  logic [4:0]  pend2_addr_in,
    input  logic [31:0] pend2_data_in,
    /* BRAM-read realignment fix: mem_rdata is NOT latched here anymore.
     * The registered memory read (mem_rdata_raw_d) already lands in the
     * correct WB-timed cycle on its own; latching it again through this
     * register would delay it by one more cycle than every other WB
     * field, returning the previous load's data (found via ra getting
     * corrupted -- see lockstep re-verification after the BRAM patch).
     * Only the width/unsigned control bits need to ride along so WB can
     * do the sign/zero-extension itself once mem_rdata_raw_d is valid. */
    input  logic [1:0]  mem_width_in,
    input  logic         mem_unsigned_in,

    output logic [31:0] alu_result_out, muldiv_result_out, pc_plus4_out, imm_out,
    output logic [4:0]  rd_addr_out,
    output logic [31:0] instr_out,
    output logic        reg_write_out,
    output logic [1:0]  result_src_out,
    output logic        is_muldiv_out,
    output logic        is_csr_out,
    output logic [11:0] csr_addr_out,
    output logic        is_fisol_bound_out, is_fisol_off_out,
    output logic [1:0]  mem_width_out,
    output logic         mem_unsigned_out,
    output logic        pend2_valid_out,
    output logic [4:0]  pend2_addr_out,
    output logic [31:0] pend2_data_out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n || clear) begin
            alu_result_out <= 32'b0; muldiv_result_out <= 32'b0;
            pc_plus4_out <= 32'b0; imm_out <= 32'b0; rd_addr_out <= 5'b0; instr_out <= 32'h00000013;
            reg_write_out <= 1'b0; result_src_out <= 2'b00; is_muldiv_out <= 1'b0;
            is_csr_out <= 1'b0; csr_addr_out <= 12'b0;
            is_fisol_bound_out <= 1'b0; is_fisol_off_out <= 1'b0;
            mem_width_out <= 2'b00; mem_unsigned_out <= 1'b0;
            pend2_valid_out <= 1'b0; pend2_addr_out <= 5'b0; pend2_data_out <= 32'b0;
        end else if (!stall) begin
            alu_result_out <= alu_result_in; muldiv_result_out <= muldiv_result_in;
            pc_plus4_out <= pc_plus4_in; imm_out <= imm_in; rd_addr_out <= rd_addr_in; instr_out <= instr_in;
            reg_write_out <= reg_write_in; result_src_out <= result_src_in; is_muldiv_out <= is_muldiv_in;
            is_csr_out <= is_csr_in; csr_addr_out <= csr_addr_in;
            is_fisol_bound_out <= is_fisol_bound_in; is_fisol_off_out <= is_fisol_off_in;
            mem_width_out <= mem_width_in; mem_unsigned_out <= mem_unsigned_in;
            pend2_valid_out <= pend2_valid_in; pend2_addr_out <= pend2_addr_in; pend2_data_out <= pend2_data_in;
        end
    end
endmodule
