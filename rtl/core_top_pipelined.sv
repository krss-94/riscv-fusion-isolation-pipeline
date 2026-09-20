module core_top_pipelined #(
    parameter MEM_BASE  = 32'h8000_0000,
    parameter MEM_BYTES = 32'h0002_0000,
    parameter bit FUSION_EN  = 1'b1,
    parameter bit ISOL_EN    = 1'b1,
    /* verilator lint_off UNUSEDPARAM */
    parameter bit BR_CMP_EN  = 1'b0
    /* verilator lint_on UNUSEDPARAM */
) (
    input  logic clk,
    input  logic rst_n,

    output logic [31:0] dbg_wb_pc,
    output logic [31:0] dbg_wb_instr,
    output logic        dbg_wb_reg_we,
    output logic [4:0]  dbg_wb_reg_addr,
    output logic [31:0] dbg_wb_reg_wdata,

    output logic        dbg_pend2_fire,
    output logic [4:0]  dbg_pend2_addr,
    output logic [31:0] dbg_pend2_data,

    output logic [31:0] dbg_mem_pc,
    output logic [31:0] dbg_mem_instr,
    output logic        dbg_mem_we,
    output logic [31:0] dbg_mem_addr,
    output logic [31:0] dbg_mem_wdata,
    output logic [1:0]  dbg_mem_width,

    output logic        dbg_trap_taken,
    output logic [31:0] dbg_mepc,
    output logic [31:0] dbg_mcause,
    output logic [31:0] dbg_mtval
);
    localparam int MEM_WORDS = MEM_BYTES/4;
    /* verilator lint_off UNDRIVEN */
    (* ram_style = "block" *) logic [31:0] imem [0:MEM_WORDS-1];
`ifndef VERILATOR
    initial $readmemh("imem_init.hex", imem);
`endif
    /* verilator lint_on UNDRIVEN */
    (* ram_style = "block" *) logic [31:0] dmem [0:MEM_WORDS-1];
`ifndef VERILATOR
    initial $readmemh("imem_init.hex", dmem);
`endif

    logic [31:0] pc, pc_next;
    wire  [31:0] imem_off      = pc - MEM_BASE;
    wire  [31:0] imem_off_next = (pc + 32'd4) - MEM_BASE;

    logic [31:0] pc_d, if_instr_r, if_instr_next_r;
    logic        flush_id;
    logic        stall_pc_ifid;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush_id) begin
            pc_d <= MEM_BASE; if_instr_r <= 32'h00000013; if_instr_next_r <= 32'h00000013;
        end else if (!stall_pc_ifid) begin
            pc_d <= pc;
            if_instr_r      <= imem[imem_off[16:2]];
            if_instr_next_r <= imem[imem_off_next[16:2]];
        end
    end

    logic [31:0] id_pc, id_instr, id_instr_next;
    logic        id_lookahead_valid;

    logic        fuse_idiom1, fuse_idiom2, fuse_idiom3, fuse_idiom4, fuse_idiom5;
    logic [4:0]  mem_rd_addr;
    logic        mem_mem_read;

    if_id_reg u_if_id (
        .clk(clk), .rst_n(rst_n), .stall(stall_pc_ifid),
        .clear(flush_id || ((fuse_idiom1 || fuse_idiom2 || fuse_idiom3 || fuse_idiom4 || fuse_idiom5) && !stall_pc_ifid)),
        .pc_in(pc_d), .instr_in(if_instr_r), .instr_next_in(if_instr_next_r),
        .lookahead_valid_in(!flush_id),
        .pc_out(id_pc), .instr_out(id_instr), .instr_next_out(id_instr_next),
        .lookahead_valid_out(id_lookahead_valid)
    );

    logic        pc_redirect;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) pc <= MEM_BASE;
        else if (pc_redirect || !stall_pc_ifid) pc <= pc_next;
    end

    logic [4:0]  id_rs1_addr, id_rs2_addr, id_rd_addr;
    logic [31:0] id_rs1_data, id_rs2_data, id_imm;
    logic        id_reg_write, id_mem_read, id_mem_write, id_mem_unsigned;
    logic [1:0]  id_mem_width, id_result_src;
    logic [3:0]  id_alu_op;
    logic        id_alu_src_a_pc, id_alu_src_b_imm;
    logic        id_is_muldiv, id_is_branch, id_is_jal, id_is_jalr;
    logic        id_is_fisol_bound, id_is_fisol_off, id_illegal_instr;
    logic [2:0]  id_muldiv_op;
    logic        id_is_csr;
    logic [1:0]  id_csr_op;
    logic [11:0] id_csr_addr;

    assign id_rs1_addr = id_instr[19:15];
    assign id_rs2_addr = id_instr[24:20];
    assign id_rd_addr  = id_instr[11:7];

    decoder u_decoder (
        .instr(id_instr), .reg_write(id_reg_write), .mem_read(id_mem_read), .mem_write(id_mem_write),
        .mem_width(id_mem_width), .mem_unsigned(id_mem_unsigned), .alu_op(id_alu_op),
        .alu_src_a_pc(id_alu_src_a_pc), .alu_src_b_imm(id_alu_src_b_imm), .result_src(id_result_src),
        .is_muldiv(id_is_muldiv), .muldiv_op(id_muldiv_op),
        .is_branch(id_is_branch), .is_jal(id_is_jal), .is_jalr(id_is_jalr),
        .is_fisol_bound(id_is_fisol_bound), .is_fisol_off(id_is_fisol_off), .illegal_instr(id_illegal_instr),
        .is_csr(id_is_csr), .csr_op(id_csr_op), .csr_addr(id_csr_addr)
    );
    imm_gen u_imm_gen (.instr(id_instr), .imm(id_imm));

    wire [6:0] id_opcode      = id_instr[6:0];
    wire [2:0] id_funct3      = id_instr[14:12];
    wire [6:0] id_next_opcode = id_instr_next[6:0];
    wire [2:0] id_next_funct3 = id_instr_next[14:12];
    wire [4:0] id_branch_rs2  = id_instr_next[24:20];
    wire [4:0] id_lui_rd      = id_instr[11:7];
    wire [4:0] id_addi_rd     = id_instr_next[11:7];
    wire [4:0] id_addi_rs1    = id_instr_next[19:15];
    wire [4:0] id_auipc_rd    = id_instr[11:7];

    wire idiom1_pattern_match = id_lookahead_valid
        && (id_opcode == 7'b0110111)
        && (id_next_opcode == 7'b0010011)
        && (id_next_funct3 == 3'b000)
        && (id_lui_rd != 5'd0)
        && (id_addi_rd == id_lui_rd)
        && (id_addi_rs1 == id_lui_rd);

    wire idiom2_pattern_match = id_lookahead_valid
        && (id_opcode == 7'b0010111)
        && (id_next_opcode == 7'b0010011)
        && (id_next_funct3 == 3'b000)
        && (id_auipc_rd != 5'd0)
        && (id_addi_rd == id_auipc_rd)
        && (id_addi_rs1 == id_auipc_rd);

    wire idiom3_pattern_match = id_lookahead_valid
        && (id_opcode == 7'b0010111)
        && (id_next_opcode == 7'b1100111)
        && (id_next_funct3 == 3'b000)
        && (id_auipc_rd != 5'd0)
        && (id_addi_rs1 == id_auipc_rd);

    wire idiom4_pattern_match = id_lookahead_valid
        && (((id_opcode == 7'b0110011) && (id_funct3 == 3'b010 || id_funct3 == 3'b011))
            || ((id_opcode == 7'b0010011) && (id_funct3 == 3'b010 || id_funct3 == 3'b011)))
        && (id_next_opcode == 7'b1100011)
        && (id_next_funct3 == 3'b000 || id_next_funct3 == 3'b001)
        && (id_addi_rs1 == id_rd_addr)
        && (id_branch_rs2 == 5'd0);

    logic [4:0]  ex_rd_addr;
    logic        ex_reg_write;
    logic [4:0]  mem_rd_addr_fwd;
    logic        mem_reg_write_fwd;
    logic [4:0]  wb_rd_addr_fwd;
    logic        wb_reg_write_fwd;

    wire idiom1_hazard_clear = !(ex_reg_write  && ex_rd_addr  == id_lui_rd) &&
                               !(mem_reg_write_fwd && mem_rd_addr_fwd == id_lui_rd) &&
                               !(wb_reg_write_fwd  && wb_rd_addr_fwd  == id_lui_rd);

    wire idiom2_hazard_clear = !(ex_reg_write  && ex_rd_addr  == id_auipc_rd) &&
                               !(mem_reg_write_fwd && mem_rd_addr_fwd == id_auipc_rd) &&
                               !(wb_reg_write_fwd  && wb_rd_addr_fwd  == id_auipc_rd);

    wire idiom3_hazard_clear = !(ex_reg_write  && ex_rd_addr  == id_auipc_rd) &&
                               !(mem_reg_write_fwd && mem_rd_addr_fwd == id_auipc_rd) &&
                               !(wb_reg_write_fwd  && wb_rd_addr_fwd  == id_auipc_rd);

    wire idiom4_hazard_clear = 1'b1;

    logic id_bound_active;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) id_bound_active <= 1'b0;
        else if (!stall_pc_ifid) begin
            if (id_is_fisol_bound) id_bound_active <= 1'b1;
            else if (id_is_fisol_off) id_bound_active <= 1'b0;
        end
    end
    wire [6:0] id_funct7 = id_instr[31:25];
    wire [31:0] id_imm_next = {{20{id_instr_next[31]}}, id_instr_next[31:20]};

    wire idiom5_pattern_match = id_lookahead_valid
        && (((id_opcode == 7'b0110011) && (id_funct3 == 3'b000) && (id_funct7 == 7'b0000000))
            || ((id_opcode == 7'b0010011) && (id_funct3 == 3'b000)))
        && (id_next_opcode == 7'b0000011)
        && (id_next_funct3 == 3'b010)
        && (id_rd_addr != 5'd0)
        && (id_addi_rs1 == id_rd_addr)
        && (id_imm_next == 32'd0);

    wire idiom5_hazard_clear = !(ex_reg_write      && ex_rd_addr      == id_rs1_addr) &&
                               !(mem_reg_write_fwd && mem_rd_addr_fwd == id_rs1_addr) &&
                               !(wb_reg_write_fwd  && wb_rd_addr_fwd  == id_rs1_addr) &&
                               !((id_opcode == 7'b0110011) &&
                                 (   (ex_reg_write      && ex_rd_addr      == id_rs2_addr)
                                  || (mem_reg_write_fwd && mem_rd_addr_fwd == id_rs2_addr)
                                  || (wb_reg_write_fwd  && wb_rd_addr_fwd  == id_rs2_addr)));

    assign fuse_idiom1 = FUSION_EN && idiom1_pattern_match && idiom1_hazard_clear && !id_bound_active;
    assign fuse_idiom2 = FUSION_EN && idiom2_pattern_match && idiom2_hazard_clear && !id_bound_active;
    assign fuse_idiom3 = FUSION_EN && idiom3_pattern_match && idiom3_hazard_clear && !id_bound_active;
    assign fuse_idiom4 = FUSION_EN && idiom4_pattern_match && idiom4_hazard_clear && !id_bound_active;
    assign fuse_idiom5 = FUSION_EN && idiom5_pattern_match && idiom5_hazard_clear && !id_bound_active;

    wire [31:0] fusion_add_result = (id_opcode == 7'b0110011) ? (id_rs1_data + id_rs2_data)
                                                                : (id_rs1_data + id_imm);

    wire [31:0] fusion_imm20 = {id_instr[31:12], 12'b0};
    wire [31:0] fusion_imm12 = {{20{id_instr_next[31]}}, id_instr_next[31:20]};
    wire [31:0] fusion_result_imm = fusion_imm20 + fusion_imm12;
    wire any_fuse_imm = fuse_idiom1 || fuse_idiom2;
    wire [31:0] id_imm_final = any_fuse_imm ? fusion_result_imm : id_imm;

    logic        stall_idex, flush_ex;

    wire fusion_active /*verilator public*/ = (fuse_idiom1 || fuse_idiom2 || fuse_idiom3 || fuse_idiom4 || fuse_idiom5) && !stall_idex && !flush_ex;

    logic        ex_pend2_valid, mem_pend2_valid, wb_pend2_valid;
    logic [4:0]  ex_pend2_addr, mem_pend2_addr, wb_pend2_addr;
    logic [31:0] ex_pend2_data, mem_pend2_data, wb_pend2_data;
    logic        ex_fuse4_valid, ex_fuse4_bne;
    logic [31:0] ex_fuse4_target;
    wire  [31:0] fused_jalr_base = id_pc + fusion_imm20;

    wire [31:0] fusion_branch_imm =
        {{19{id_instr_next[31]}}, id_instr_next[31], id_instr_next[7],
         id_instr_next[30:25], id_instr_next[11:8], 1'b0};
    wire [31:0] fusion_branch_target = (id_pc + 32'd4) + fusion_branch_imm;
    wire fuse4_is_bne = id_next_funct3[0];

    logic        pend2_fire_valid;
    logic        stall_memwb;

    logic        pend2_active;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) pend2_active <= 1'b0;
        else if ((fuse_idiom3 || fuse_idiom5) && !stall_pc_ifid && !flush_ex) pend2_active <= 1'b1;
        else if (pend2_fire_valid) pend2_active <= 1'b0;
    end

    logic [4:0]  pend2_fire_addr;
    logic [31:0] pend2_fire_data;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) pend2_fire_valid <= 1'b0;
        else if (!stall_memwb) begin
            pend2_fire_valid <= wb_pend2_valid;
            pend2_fire_addr  <= wb_pend2_addr;
            pend2_fire_data  <= wb_pend2_data;
        end
    end

    logic [4:0]  wb_rd_addr_for_rf;
    logic        wb_reg_write_for_rf;
    logic [31:0] wb_rd_data_for_rf;

    regfile_pipelined u_regfile (
        .clk(clk), .rs1_addr(id_rs1_addr), .rs2_addr(id_rs2_addr),
        .rs1_data(id_rs1_data), .rs2_data(id_rs2_data),
        .rd_we(wb_reg_write_for_rf), .rd_addr(wb_rd_addr_for_rf), .rd_data(wb_rd_data_for_rf)
    );

    logic [31:0] ex_pc, ex_rs1_data, ex_rs2_data, ex_imm, ex_instr;
    logic [4:0]  ex_rs1_addr, ex_rs2_addr;
    logic        ex_mem_read, ex_mem_write, ex_mem_unsigned;
    logic [1:0]  ex_mem_width, ex_result_src;
    logic [3:0]  ex_alu_op;
    logic        ex_alu_src_a_pc, ex_alu_src_b_imm;
    logic        ex_is_muldiv, ex_is_branch, ex_is_jal, ex_is_jalr;
    logic [2:0]  ex_muldiv_op;
    logic        ex_illegal_instr;
    logic        ex_is_csr;
    logic [1:0]  ex_csr_op;
    logic [11:0] ex_csr_addr;
    logic        ex_is_fisol_bound, ex_is_fisol_off;

    id_ex_reg u_id_ex (
        .clk(clk), .rst_n(rst_n), .stall(stall_idex), .clear(flush_ex),
        .pc_in(fuse_idiom3 ? (id_pc + 32'd4) : id_pc),
        .rs1_data_in(fuse_idiom3 ? fused_jalr_base : id_rs1_data),
        .rs2_data_in(id_rs2_data),
        .imm_in(fuse_idiom3 ? fusion_imm12 : id_imm_final),
        .rs1_addr_in(fuse_idiom3 ? id_auipc_rd : id_rs1_addr), .rs2_addr_in(id_rs2_addr),
        .rd_addr_in((fuse_idiom3 || fuse_idiom5) ? id_addi_rd : id_rd_addr),
        .instr_in(id_instr),
        .reg_write_in(fuse_idiom3 ? 1'b1 : id_reg_write),
        .mem_read_in(fuse_idiom5 ? 1'b1 : id_mem_read), .mem_write_in(id_mem_write),
        .mem_width_in(fuse_idiom5 ? 2'b10 : id_mem_width),
        .result_src_in(fuse_idiom3 ? 2'b10 : fuse_idiom5 ? 2'b01 : id_result_src), .mem_unsigned_in(id_mem_unsigned),
        .alu_op_in(id_alu_op), .alu_src_a_pc_in(id_alu_src_a_pc), .alu_src_b_imm_in(id_alu_src_b_imm),
        .is_muldiv_in(id_is_muldiv), .is_branch_in(id_is_branch), .is_jal_in(id_is_jal),
        .is_jalr_in(fuse_idiom3 ? 1'b1 : id_is_jalr),
        .muldiv_op_in(id_muldiv_op), .illegal_instr_in(id_illegal_instr), .is_csr_in(id_is_csr),
        .csr_op_in(id_csr_op), .csr_addr_in(id_csr_addr),
        .is_fisol_bound_in(id_is_fisol_bound), .is_fisol_off_in(id_is_fisol_off),
        .pend2_valid_in(fuse_idiom3 || fuse_idiom5),
        .pend2_addr_in(fuse_idiom3 ? id_auipc_rd : id_rd_addr),
        .pend2_data_in(fuse_idiom3 ? fused_jalr_base : fusion_add_result),
        .fuse4_valid_in(fuse_idiom4), .fuse4_bne_in(fuse4_is_bne), .fuse4_target_in(fusion_branch_target),

        .pc_out(ex_pc), .rs1_data_out(ex_rs1_data), .rs2_data_out(ex_rs2_data), .imm_out(ex_imm),
        .rs1_addr_out(ex_rs1_addr), .rs2_addr_out(ex_rs2_addr), .rd_addr_out(ex_rd_addr),
        .instr_out(ex_instr),
        .reg_write_out(ex_reg_write), .mem_read_out(ex_mem_read), .mem_write_out(ex_mem_write),
        .mem_width_out(ex_mem_width), .result_src_out(ex_result_src), .mem_unsigned_out(ex_mem_unsigned),
        .alu_op_out(ex_alu_op), .alu_src_a_pc_out(ex_alu_src_a_pc), .alu_src_b_imm_out(ex_alu_src_b_imm),
        .is_muldiv_out(ex_is_muldiv), .is_branch_out(ex_is_branch), .is_jal_out(ex_is_jal), .is_jalr_out(ex_is_jalr),
        .muldiv_op_out(ex_muldiv_op), .illegal_instr_out(ex_illegal_instr), .is_csr_out(ex_is_csr),
        .csr_op_out(ex_csr_op), .csr_addr_out(ex_csr_addr),
        .is_fisol_bound_out(ex_is_fisol_bound), .is_fisol_off_out(ex_is_fisol_off),
        .pend2_valid_out(ex_pend2_valid), .pend2_addr_out(ex_pend2_addr), .pend2_data_out(ex_pend2_data),
        .fuse4_valid_out(ex_fuse4_valid), .fuse4_bne_out(ex_fuse4_bne), .fuse4_target_out(ex_fuse4_target)
    );

    logic [1:0]  fwd_a_sel, fwd_b_sel;
    logic        muldiv_busy, muldiv_done;
    logic [31:0] muldiv_result_bus;
    logic        stall_exmem;
    logic        muldiv_active;

    hazard_unit u_hazard (
        .ex_rs1_addr(ex_rs1_addr), .ex_rs2_addr(ex_rs2_addr),
        .mem_rd_addr(mem_rd_addr_fwd), .mem_reg_write(mem_reg_write_fwd),
        .wb_rd_addr(wb_rd_addr_fwd), .wb_reg_write(wb_reg_write_fwd),
        .id_rs1_addr(id_rs1_addr), .id_rs2_addr(id_rs2_addr),
        .ex_rd_addr(ex_rd_addr), .ex_mem_read(ex_mem_read),
        .mem_rd_addr_raw(mem_rd_addr), .mem_mem_read(mem_mem_read),
        .pc_redirect(pc_redirect),
        .muldiv_busy(muldiv_active),
        .pend2_stall(pend2_active),
        .fwd_a_sel(fwd_a_sel), .fwd_b_sel(fwd_b_sel),
        .stall_pc_ifid(stall_pc_ifid), .stall_idex(stall_idex),
        .stall_exmem(stall_exmem), .stall_memwb(stall_memwb),
        .flush_id(flush_id), .flush_ex(flush_ex)
    );

    logic [31:0] mem_alu_result_fwd, wb_data_fwd;
    logic [31:0] fwd_a_val, fwd_b_val;
    always_comb begin
        unique case (fwd_a_sel)
            2'b01:   fwd_a_val = mem_alu_result_fwd;
            2'b10:   fwd_a_val = wb_data_fwd;
            default: fwd_a_val = ex_rs1_data;
        endcase
        unique case (fwd_b_sel)
            2'b01:   fwd_b_val = mem_alu_result_fwd;
            2'b10:   fwd_b_val = wb_data_fwd;
            default: fwd_b_val = ex_rs2_data;
        endcase
    end

    logic [31:0] alu_a, alu_b, alu_result;
    assign alu_a = ex_alu_src_a_pc ? ex_pc : fwd_a_val;
    assign alu_b = ex_alu_src_b_imm ? ex_imm : fwd_b_val;
    alu u_alu (.a(alu_a), .b(alu_b), .alu_op(ex_alu_op), .result(alu_result));

    wire fuse4_branch_taken = ex_fuse4_bne ? (alu_result != 32'b0) : (alu_result == 32'b0);

    logic muldiv_start;
    logic        wb_is_fisol_bound, wb_is_fisol_off;

    logic isol_en;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            isol_en <= 1'b0;
        else if (wb_is_fisol_bound)
            isol_en <= 1'b1;
        else if (wb_is_fisol_off)
            isol_en <= 1'b0;
    end

    assign muldiv_start = ex_is_muldiv && !muldiv_busy && !muldiv_done;

    wire muldiv_op_en = muldiv_active;

    wire br_cmp_op_en = BR_CMP_EN && ex_is_branch;
    wire isol_active /*verilator public*/ = ISOL_EN && !muldiv_op_en && !br_cmp_op_en;

    logic [31:0] muldiv_a_gated, muldiv_b_gated;
    isol_gate u_isol_gate_a (.clk(clk), .en(!ISOL_EN || muldiv_op_en), .d(fwd_a_val), .q(muldiv_a_gated));
    isol_gate u_isol_gate_b (.clk(clk), .en(!ISOL_EN || muldiv_op_en), .d(fwd_b_val), .q(muldiv_b_gated));

    muldiv_iter u_muldiv (
        .clk(clk), .rst_n(rst_n), .start(muldiv_start), .op_en(muldiv_op_en),
        .a(muldiv_a_gated), .b(muldiv_b_gated), .op(ex_muldiv_op),
        .busy(muldiv_busy), .done(muldiv_done), .result(muldiv_result_bus)
    );

    assign muldiv_active = muldiv_busy || muldiv_start;

    logic branch_taken;
    always_comb begin
        unique case (ex_instr[14:12])
            3'b000:  branch_taken = (fwd_a_val == fwd_b_val);
            3'b001:  branch_taken = (fwd_a_val != fwd_b_val);
            3'b100:  branch_taken = ($signed(fwd_a_val) <  $signed(fwd_b_val));
            3'b101:  branch_taken = ($signed(fwd_a_val) >= $signed(fwd_b_val));
            3'b110:  branch_taken = (fwd_a_val <  fwd_b_val);
            3'b111:  branch_taken = (fwd_a_val >= fwd_b_val);
            default: branch_taken = 1'b0;
        endcase
    end

    logic        trap_taken, trap_we;
    logic [31:0] trap_mepc_wdata, trap_mcause_wdata, trap_mtval_wdata;
    logic [31:0] mepc, mcause, mtval, mtvec, trap_target;
    trap_unit u_trap (
        .illegal_instr(ex_illegal_instr), .faulting_pc(ex_pc), .faulting_instr(ex_instr),
        .trap_taken(trap_taken), .trap_we(trap_we),
        .trap_mepc_wdata(trap_mepc_wdata), .trap_mcause_wdata(trap_mcause_wdata),
        .trap_mtval_wdata(trap_mtval_wdata)
    );
    assign trap_target = mtvec;

    logic [31:0] csr_rdata_raw, csr_rdata_ex;
    logic        wb_csr_we;
    logic [11:0] wb_csr_addr;
    logic [31:0] wb_csr_wdata;
    csr_file u_csr_file (
        .clk(clk), .rst_n(rst_n),
        .csr_raddr(ex_csr_addr), .csr_rdata(csr_rdata_raw),
        .csr_we(wb_csr_we), .csr_waddr(wb_csr_addr), .csr_wdata(wb_csr_wdata),
        .trap_we(trap_we), .trap_mepc_wdata(trap_mepc_wdata),
        .trap_mcause_wdata(trap_mcause_wdata), .trap_mtval_wdata(trap_mtval_wdata),
        .mepc(mepc), .mcause(mcause), .mtval(mtval), .mtvec(mtvec),
        .muldiv_active(muldiv_start), .isol_active(isol_active),
        .fusion_active(fusion_active)
    );

    logic        mem_is_csr_out;
    logic [11:0] mem_csr_addr_out;
    logic [31:0] mem_muldiv_result;
    logic        wb_is_csr;
    logic [11:0] wb_csr_addr_out;
    logic [31:0] wb_muldiv_result;

    always_comb begin
        if (mem_is_csr_out && mem_csr_addr_out == ex_csr_addr)
            csr_rdata_ex = mem_muldiv_result;
        else if (wb_is_csr && wb_csr_addr_out == ex_csr_addr)
            csr_rdata_ex = wb_muldiv_result;
        else
            csr_rdata_ex = csr_rdata_raw;
    end

    logic [31:0] csr_wdata_ex;
    always_comb begin
        unique case (ex_csr_op)
            2'b01:   csr_wdata_ex = fwd_a_val;
            2'b10:   csr_wdata_ex = csr_rdata_ex | fwd_a_val;
            2'b11:   csr_wdata_ex = csr_rdata_ex & ~fwd_a_val;
            default: csr_wdata_ex = 32'b0;
        endcase
    end

    logic [31:0] redirect_target;
    assign pc_redirect = (ex_is_branch && branch_taken) || (ex_fuse4_valid && fuse4_branch_taken) || ex_is_jal || ex_is_jalr || trap_taken;
    always_comb begin
        if (trap_taken)          redirect_target = trap_target;
        else if (ex_is_jalr)     redirect_target = (fwd_a_val + ex_imm) & ~32'd1;
        else if (ex_fuse4_valid) redirect_target = ex_fuse4_target;
        else                     redirect_target = ex_pc + ex_imm;
    end
    assign pc_next = pc_redirect ? redirect_target : (stall_pc_ifid ? pc : pc + 32'd4);

    assign dbg_trap_taken = trap_taken;
    assign dbg_mepc   = mepc;
    assign dbg_mcause = mcause;
    assign dbg_mtval  = mtval;

    logic [31:0] mem_alu_result, mem_rs2_data, mem_pc_plus4, mem_imm_out, mem_instr;
    logic        mem_reg_write, mem_mem_write, mem_mem_unsigned, mem_is_muldiv;
    logic [1:0]  mem_mem_width, mem_result_src;
    logic        mem_is_fisol_bound, mem_is_fisol_off;

    logic [31:0] ex_alu_result_final, ex_muldiv_result_final;
    assign ex_alu_result_final    = ex_is_csr ? csr_rdata_ex : alu_result;
    assign ex_muldiv_result_final = ex_is_csr ? csr_wdata_ex : muldiv_result_bus;

    ex_mem_reg u_ex_mem (
        .clk(clk), .rst_n(rst_n), .stall(stall_exmem), .clear(1'b0),
        .alu_result_in(ex_alu_result_final), .muldiv_result_in(ex_muldiv_result_final),
        .rs2_data_in(fwd_b_val), .pc_plus4_in(ex_pc + 32'd4), .imm_in(ex_imm),
        .rd_addr_in(ex_rd_addr), .instr_in(ex_instr),
        .reg_write_in(ex_reg_write), .mem_read_in(ex_mem_read), .mem_write_in(ex_mem_write),
        .mem_width_in(ex_mem_width), .result_src_in(ex_result_src),
        .mem_unsigned_in(ex_mem_unsigned), .is_muldiv_in(ex_is_muldiv),
        .is_csr_in(ex_is_csr), .csr_addr_in(ex_csr_addr),
        .is_fisol_bound_in(ex_is_fisol_bound), .is_fisol_off_in(ex_is_fisol_off),
        .pend2_valid_in(ex_pend2_valid), .pend2_addr_in(ex_pend2_addr), .pend2_data_in(ex_pend2_data),

        .alu_result_out(mem_alu_result), .muldiv_result_out(mem_muldiv_result),
        .rs2_data_out(mem_rs2_data), .pc_plus4_out(mem_pc_plus4), .imm_out(mem_imm_out),
        .rd_addr_out(mem_rd_addr), .instr_out(mem_instr),
        .reg_write_out(mem_reg_write), .mem_read_out(mem_mem_read), .mem_write_out(mem_mem_write),
        .mem_width_out(mem_mem_width), .result_src_out(mem_result_src),
        .mem_unsigned_out(mem_mem_unsigned), .is_muldiv_out(mem_is_muldiv),
        .is_csr_out(mem_is_csr_out), .csr_addr_out(mem_csr_addr_out),
        .is_fisol_bound_out(mem_is_fisol_bound), .is_fisol_off_out(mem_is_fisol_off),
        .pend2_valid_out(mem_pend2_valid), .pend2_addr_out(mem_pend2_addr), .pend2_data_out(mem_pend2_data)
    );
    assign mem_rd_addr_fwd = mem_rd_addr;
    assign mem_reg_write_fwd = mem_reg_write;
    always_comb begin
        unique case (mem_result_src)
            2'b00:   mem_alu_result_fwd = mem_is_muldiv ? mem_muldiv_result : mem_alu_result;
            2'b01:   mem_alu_result_fwd = 32'hDEADBEEF;
            2'b10:   mem_alu_result_fwd = mem_pc_plus4;
            2'b11:   mem_alu_result_fwd = mem_imm_out;
            default: mem_alu_result_fwd = 32'hDEADBEEF;
        endcase
    end

    logic [31:0] mem_rdata_raw;
    logic [31:0] mem_rdata_raw_d;
    localparam logic [31:0] UART_TXDATA_ADDR = 32'h8000_0000;
    wire  [31:0] dmem_off = mem_alu_result - MEM_BASE;
    wire  is_uart_txdata = (mem_alu_result == UART_TXDATA_ADDR);
    logic [1:0] dmem_byte_sel_d;
    always_ff @(posedge clk) begin
        if (!stall_memwb) begin
            mem_rdata_raw_d <= dmem[dmem_off[16:2]];
            dmem_byte_sel_d <= dmem_off[1:0];
        end
    end
    assign mem_rdata_raw = mem_rdata_raw_d >> (8*dmem_byte_sel_d);


    logic [31:0] mem_wdata_trunc;
    always_comb begin
        unique case (mem_mem_width)
            2'b00:   mem_wdata_trunc = {24'b0, mem_rs2_data[7:0]};
            2'b01:   mem_wdata_trunc = {16'b0, mem_rs2_data[15:0]};
            default: mem_wdata_trunc = mem_rs2_data;
        endcase
    end

    logic [3:0]  dmem_byte_we;
    logic [31:0] dmem_wdata_shifted;
    always_comb begin
        dmem_byte_we = 4'b0000;
        dmem_wdata_shifted = 32'b0;
        if (mem_mem_write && !is_uart_txdata) begin
            unique case (mem_mem_width)
                2'b00: begin
                    dmem_byte_we = 4'b0001 << dmem_off[1:0];
                    dmem_wdata_shifted = {24'b0, mem_rs2_data[7:0]} << (8*dmem_off[1:0]);
                end
                2'b01: begin
                    dmem_byte_we = 4'b0011 << dmem_off[1:0];
                    dmem_wdata_shifted = {16'b0, mem_rs2_data[15:0]} << (8*dmem_off[1:0]);
                end
                default: begin
                    dmem_byte_we = 4'b1111;
                    dmem_wdata_shifted = mem_rs2_data;
                end
            endcase
        end
    end
    always_ff @(posedge clk) begin
        if (!stall_exmem) begin
            if (dmem_byte_we[0]) dmem[dmem_off[16:2]][7:0]   <= dmem_wdata_shifted[7:0];
            if (dmem_byte_we[1]) dmem[dmem_off[16:2]][15:8]  <= dmem_wdata_shifted[15:8];
            if (dmem_byte_we[2]) dmem[dmem_off[16:2]][23:16] <= dmem_wdata_shifted[23:16];
            if (dmem_byte_we[3]) dmem[dmem_off[16:2]][31:24] <= dmem_wdata_shifted[31:24];
        end
    end

    assign dbg_mem_pc     = mem_pc_plus4 - 32'd4;
    assign dbg_mem_instr  = mem_instr;
    assign dbg_mem_we     = mem_mem_write && !stall_exmem;
    assign dbg_mem_addr   = mem_alu_result;
    assign dbg_mem_wdata  = mem_wdata_trunc;
    assign dbg_mem_width  = mem_mem_width;

    logic [31:0] wb_mem_rdata;
    logic [31:0] wb_alu_result, wb_pc_plus4, wb_imm_out, wb_instr;
    logic [4:0]  wb_rd_addr;
    logic        wb_reg_write;
    logic [1:0]  wb_result_src;
    logic        wb_is_muldiv;

    logic [1:0] wb_mem_width;
    logic       wb_mem_unsigned;
    mem_wb_reg u_mem_wb (
        .clk(clk), .rst_n(rst_n), .stall(stall_memwb), .clear(1'b0),
        .alu_result_in(mem_alu_result), .muldiv_result_in(mem_muldiv_result),
        .pc_plus4_in(mem_pc_plus4), .imm_in(mem_imm_out), .rd_addr_in(mem_rd_addr), .instr_in(mem_instr),
        .reg_write_in(mem_reg_write), .result_src_in(mem_result_src), .is_muldiv_in(mem_is_muldiv),
        .is_csr_in(mem_is_csr_out), .csr_addr_in(mem_csr_addr_out),
        .is_fisol_bound_in(mem_is_fisol_bound), .is_fisol_off_in(mem_is_fisol_off),
        .mem_width_in(mem_mem_width), .mem_unsigned_in(mem_mem_unsigned),
        .pend2_valid_in(mem_pend2_valid), .pend2_addr_in(mem_pend2_addr), .pend2_data_in(mem_pend2_data),

        .alu_result_out(wb_alu_result), .muldiv_result_out(wb_muldiv_result),
        .pc_plus4_out(wb_pc_plus4), .imm_out(wb_imm_out), .rd_addr_out(wb_rd_addr), .instr_out(wb_instr),
        .reg_write_out(wb_reg_write), .result_src_out(wb_result_src), .is_muldiv_out(wb_is_muldiv),
        .is_csr_out(wb_is_csr), .csr_addr_out(wb_csr_addr_out),
        .is_fisol_bound_out(wb_is_fisol_bound), .is_fisol_off_out(wb_is_fisol_off),
        .mem_width_out(wb_mem_width), .mem_unsigned_out(wb_mem_unsigned),
        .pend2_valid_out(wb_pend2_valid), .pend2_addr_out(wb_pend2_addr), .pend2_data_out(wb_pend2_data)
    );
    always_comb begin
        unique case (wb_mem_width)
            2'b00:   wb_mem_rdata = wb_mem_unsigned ? {24'b0, mem_rdata_raw[7:0]}
                                                     : {{24{mem_rdata_raw[7]}}, mem_rdata_raw[7:0]};
            2'b01:   wb_mem_rdata = wb_mem_unsigned ? {16'b0, mem_rdata_raw[15:0]}
                                                     : {{16{mem_rdata_raw[15]}}, mem_rdata_raw[15:0]};
            default: wb_mem_rdata = mem_rdata_raw_d;
        endcase
    end
    assign wb_rd_addr_fwd = wb_rd_addr;
    assign wb_reg_write_fwd = wb_reg_write;

    logic [31:0] wb_rd_data;
    always_comb begin
        unique case (wb_result_src)
            2'b00:   wb_rd_data = wb_is_muldiv ? wb_muldiv_result : wb_alu_result;
            2'b01:   wb_rd_data = wb_mem_rdata;
            2'b10:   wb_rd_data = wb_pc_plus4;
            2'b11:   wb_rd_data = wb_imm_out;
            default: wb_rd_data = 32'hDEADBEEF;
        endcase
    end
    assign wb_data_fwd = wb_rd_data;
    assign wb_rd_addr_for_rf   = pend2_fire_valid ? pend2_fire_addr : wb_rd_addr;
    assign wb_reg_write_for_rf = pend2_fire_valid ? 1'b1 : (wb_reg_write && !stall_memwb);
    assign wb_rd_data_for_rf   = pend2_fire_valid ? pend2_fire_data : wb_rd_data;

    assign wb_csr_we    = wb_is_csr && !stall_memwb;
    assign wb_csr_addr  = wb_csr_addr_out;
    assign wb_csr_wdata = wb_muldiv_result;

    assign dbg_wb_pc        = wb_pc_plus4 - 32'd4;
    assign dbg_wb_instr     = wb_instr;
    assign dbg_wb_reg_we    = wb_reg_write && (wb_rd_addr != 5'd0) && !stall_memwb;
    assign dbg_wb_reg_addr  = wb_rd_addr;
    assign dbg_wb_reg_wdata = wb_rd_data;

    assign dbg_pend2_fire = pend2_fire_valid;
    assign dbg_pend2_addr = pend2_fire_addr;
    assign dbg_pend2_data = pend2_fire_data;
endmodule
