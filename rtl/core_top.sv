/* Stage 2 single-cycle RV32IM core (Part 14 Stage 2). Single unified sim
 * memory (byte array), matching Part 7 §7's "architecturally unified
 * address space" -- the dual-port split for throughput is explicitly a
 * Stage 5/Part 8 concern, not this stage's. No CSR, no traps, no
 * FISOL/HPM, no pipeline/hazards -- see decoder.sv's note on the default
 * no-op case. Debug ports exist purely for the Verilator testbench's
 * commit-log generation; they are not part of the architectural design.
 */
module core_top #(
    parameter MEM_BASE  = 32'h8000_0000,
    parameter MEM_BYTES = 32'h0002_0000  /* covers link_spike.ld's IMEM+DMEM span */
) (
    input  logic clk,
    input  logic rst_n,
    /* debug/commit-log outputs, testbench-only */
    output logic [31:0] dbg_pc,
    output logic [31:0] dbg_instr,
    output logic        dbg_reg_we,
    output logic [4:0]  dbg_reg_addr,
    output logic [31:0] dbg_reg_wdata,
    output logic        dbg_mem_we,
    output logic [31:0] dbg_mem_addr,
    output logic [31:0] dbg_mem_wdata, /* truncated to actual store width, see always_comb below */
    output logic [1:0]  dbg_mem_width
);
    logic [7:0] mem [0:MEM_BYTES-1];

    logic [31:0] pc, pc_next;
    logic [31:0] instr;
    logic [4:0]  rs1_addr, rs2_addr, rd_addr;
    logic [31:0] rs1_data, rs2_data, rd_data;
    logic [31:0] imm;
    logic [31:0] alu_a, alu_b, alu_result, muldiv_result;
    logic [31:0] mem_rdata_raw, mem_rdata;
    logic [31:0] dbg_mem_wdata_r;
    logic        reg_write, mem_read, mem_write, mem_unsigned, is_muldiv;
    logic        alu_src_a_pc, alu_src_b_imm, is_branch, is_jal, is_jalr;
    logic        is_fisol_bound, is_fisol_off, illegal_instr, is_csr;
    logic [1:0]  csr_op;
    logic [11:0] csr_addr;
    logic [1:0]  mem_width, result_src;
    logic [3:0]  alu_op;
    logic [2:0]  muldiv_op;
    logic        branch_taken;

    /* ---- Fetch (combinational instruction read, sim-only) ---- */
    wire [31:0] imem_off = pc - MEM_BASE;
    assign instr = {mem[imem_off+3], mem[imem_off+2], mem[imem_off+1], mem[imem_off+0]};

    /* ---- Decode ---- */
    assign rs1_addr = instr[19:15];
    assign rs2_addr = instr[24:20];
    assign rd_addr  = instr[11:7];

    decoder u_decoder (
        .instr(instr), .reg_write(reg_write), .mem_read(mem_read), .mem_write(mem_write),
        .mem_width(mem_width), .mem_unsigned(mem_unsigned), .alu_op(alu_op),
        .alu_src_a_pc(alu_src_a_pc), .alu_src_b_imm(alu_src_b_imm), .result_src(result_src),
        .is_muldiv(is_muldiv), .muldiv_op(muldiv_op),
        .is_branch(is_branch), .is_jal(is_jal), .is_jalr(is_jalr),
        .is_fisol_bound(is_fisol_bound), .is_fisol_off(is_fisol_off),
        .illegal_instr(illegal_instr),
        .is_csr(is_csr), .csr_op(csr_op), .csr_addr(csr_addr)
    );
    imm_gen u_imm_gen (.instr(instr), .imm(imm));

    regfile u_regfile (
        .clk(clk), .rs1_addr(rs1_addr), .rs2_addr(rs2_addr),
        .rs1_data(rs1_data), .rs2_data(rs2_data),
        .rd_we(reg_write), .rd_addr(rd_addr), .rd_data(rd_data)
    );

    /* ---- Execute ---- */
    assign alu_a = alu_src_a_pc ? pc : rs1_data;
    assign alu_b = alu_src_b_imm ? imm : rs2_data;
    alu u_alu (.a(alu_a), .b(alu_b), .alu_op(alu_op), .result(alu_result));
    muldiv u_muldiv (.a(rs1_data), .b(rs2_data), .op(muldiv_op), .result(muldiv_result));

    always_comb begin
        unique case (muldiv_op[2:0]) /* only used for branch compare width, see below */
            default: ;
        endcase
    end

    /* Branch condition (dedicated, not routed through the shared ALU). */
    always_comb begin
        unique case (instr[14:12])
            3'b000:  branch_taken = (rs1_data == rs2_data);                       /* BEQ  */
            3'b001:  branch_taken = (rs1_data != rs2_data);                       /* BNE  */
            3'b100:  branch_taken = ($signed(rs1_data) <  $signed(rs2_data));     /* BLT  */
            3'b101:  branch_taken = ($signed(rs1_data) >= $signed(rs2_data));     /* BGE  */
            3'b110:  branch_taken = (rs1_data <  rs2_data);                       /* BLTU */
            3'b111:  branch_taken = (rs1_data >= rs2_data);                       /* BGEU */
            default: branch_taken = 1'b0;
        endcase
    end

    /* ---- Memory (combinational read; write applied synchronously below) ---- */
    wire [31:0] dmem_off = alu_result - MEM_BASE;
    assign mem_rdata_raw = {mem[dmem_off+3], mem[dmem_off+2], mem[dmem_off+1], mem[dmem_off+0]};

    always_comb begin
        unique case (mem_width)
            2'b00:   mem_rdata = mem_unsigned ? {24'b0, mem_rdata_raw[7:0]}
                                               : {{24{mem_rdata_raw[7]}}, mem_rdata_raw[7:0]};
            2'b01:   mem_rdata = mem_unsigned ? {16'b0, mem_rdata_raw[15:0]}
                                               : {{16{mem_rdata_raw[15]}}, mem_rdata_raw[15:0]};
            default: mem_rdata = mem_rdata_raw;
        endcase
    end

    always_ff @(posedge clk) begin
        if (mem_write) begin
            unique case (mem_width)
                2'b00: mem[dmem_off] <= rs2_data[7:0];
                2'b01: begin mem[dmem_off] <= rs2_data[7:0]; mem[dmem_off+1] <= rs2_data[15:8]; end
                default: begin
                    mem[dmem_off]   <= rs2_data[7:0];   mem[dmem_off+1] <= rs2_data[15:8];
                    mem[dmem_off+2] <= rs2_data[23:16]; mem[dmem_off+3] <= rs2_data[31:24];
                end
            endcase
        end
    end

    /* ---- Writeback mux ---- */
    always_comb begin
        unique case (result_src)
            2'b00:   rd_data = is_muldiv ? muldiv_result : alu_result;
            2'b01:   rd_data = mem_rdata;
            2'b10:   rd_data = pc + 32'd4;
            2'b11:   rd_data = imm;
            default: rd_data = 32'hDEADBEEF;
        endcase
    end

    /* ---- Next PC ---- */
    always_comb begin
        if (is_jal)          pc_next = pc + imm;
        else if (is_jalr)    pc_next = (rs1_data + imm) & ~32'd1;
        else if (is_branch && branch_taken) pc_next = pc + imm;
        else                 pc_next = pc + 32'd4;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) pc <= MEM_BASE;
        else        pc <= pc_next;
    end

    /* ---- Debug/commit-log outputs ---- */
    assign dbg_pc         = pc;
    assign dbg_instr      = instr;
    assign dbg_reg_we     = reg_write && (rd_addr != 5'd0);
    assign dbg_reg_addr   = rd_addr;
    assign dbg_reg_wdata  = rd_data;
    assign dbg_mem_we     = mem_write;
    assign dbg_mem_addr   = alu_result;
    always_comb begin
        unique case (mem_width)
            2'b00:   dbg_mem_wdata = {24'b0, rs2_data[7:0]};
            2'b01:   dbg_mem_wdata = {16'b0, rs2_data[15:0]};
            default: dbg_mem_wdata = rs2_data;
        endcase
    end
    assign dbg_mem_width  = mem_width;

    /* memory preload hook for the testbench (Verilator DPI-free: testbench
     * pokes core_top.mem[] directly via hierarchical reference). */
endmodule
