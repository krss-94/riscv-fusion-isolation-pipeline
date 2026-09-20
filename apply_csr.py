#!/usr/bin/env python3
import sys

def replace_once(path, old, new, label):
    with open(path, 'r') as f:
        content = f.read()
    count = content.count(old)
    if count != 1:
        print(f"ABORT [{label}]: expected 1 match in {path}, found {count}")
        sys.exit(1)
    content = content.replace(old, new)
    with open(path, 'w') as f:
        f.write(content)
    print(f"OK [{label}]: {path}")

DEC = "rtl/decoder.sv"
PR  = "rtl/pipeline_regs.sv"
CT  = "rtl/core_top_pipelined.sv"

edits = []

# ---------------- decoder.sv ----------------
edits.append((DEC,
"""    output logic        is_csr,
    output logic [1:0]  csr_op        /* funct3[1:0]: 01=CSRRW 10=CSRRS 11=CSRRC */""",
"""    output logic        is_csr,
    output logic [1:0]  csr_op,       /* funct3[1:0]: 01=CSRRW 10=CSRRS 11=CSRRC */
    output logic [11:0] csr_addr      /* instr[31:20], valid whenever is_csr */""",
"decoder.sv ports"))

edits.append((DEC,
"""    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];""",
"""    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];
    assign csr_addr = instr[31:20];""",
"decoder.sv csr_addr assign"))

# ---------------- pipeline_regs.sv ----------------
edits.append((PR,
"""    input  logic        illegal_instr_in,
    input  logic        is_csr_in,

    output logic [31:0] pc_out, rs1_data_out, rs2_data_out, imm_out,""",
"""    input  logic        illegal_instr_in,
    input  logic        is_csr_in,
    input  logic [1:0]  csr_op_in,
    input  logic [11:0] csr_addr_in,

    output logic [31:0] pc_out, rs1_data_out, rs2_data_out, imm_out,""",
"id_ex_reg input ports"))

edits.append((PR,
"""    output logic        illegal_instr_out,
    output logic        is_csr_out
);""",
"""    output logic        illegal_instr_out,
    output logic        is_csr_out,
    output logic [1:0]  csr_op_out,
    output logic [11:0] csr_addr_out
);""",
"id_ex_reg output ports"))

edits.append((PR,
"""            muldiv_op_out <= 3'b0; illegal_instr_out <= 1'b0; is_csr_out <= 1'b0;""",
"""            muldiv_op_out <= 3'b0; illegal_instr_out <= 1'b0; is_csr_out <= 1'b0;
            csr_op_out <= 2'b0; csr_addr_out <= 12'b0;""",
"id_ex_reg reset block"))

edits.append((PR,
"""            is_csr_out <= is_csr_in;""",
"""            is_csr_out <= is_csr_in;
            csr_op_out <= csr_op_in; csr_addr_out <= csr_addr_in;""",
"id_ex_reg load block"))

edits.append((PR,
"""    input  logic        mem_unsigned_in, is_muldiv_in,
    output logic [31:0] alu_result_out, muldiv_result_out, rs2_data_out, pc_plus4_out, imm_out,
    output logic [4:0]  rd_addr_out,
    output logic [31:0] instr_out,
    output logic        reg_write_out, mem_read_out, mem_write_out,
    output logic [1:0]  mem_width_out, result_src_out,
    output logic        mem_unsigned_out, is_muldiv_out""",
"""    input  logic        mem_unsigned_in, is_muldiv_in,
    input  logic        is_csr_in,
    input  logic [11:0] csr_addr_in,
    output logic [31:0] alu_result_out, muldiv_result_out, rs2_data_out, pc_plus4_out, imm_out,
    output logic [4:0]  rd_addr_out,
    output logic [31:0] instr_out,
    output logic        reg_write_out, mem_read_out, mem_write_out,
    output logic [1:0]  mem_width_out, result_src_out,
    output logic        mem_unsigned_out, is_muldiv_out,
    output logic        is_csr_out,
    output logic [11:0] csr_addr_out""",
"ex_mem_reg ports"))

edits.append((PR,
"""            mem_width_out <= 2'b10; result_src_out <= 2'b00; mem_unsigned_out <= 1'b0; is_muldiv_out <= 1'b0;
        end else if (!stall) begin
            alu_result_out <= alu_result_in; muldiv_result_out <= muldiv_result_in; rs2_data_out <= rs2_data_in;
            pc_plus4_out <= pc_plus4_in; imm_out <= imm_in; rd_addr_out <= rd_addr_in; instr_out <= instr_in;
            reg_write_out <= reg_write_in; mem_read_out <= mem_read_in; mem_write_out <= mem_write_in;
            mem_width_out <= mem_width_in; result_src_out <= result_src_in;
            mem_unsigned_out <= mem_unsigned_in; is_muldiv_out <= is_muldiv_in;
        end
    end
endmodule

module mem_wb_reg (""",
"""            mem_width_out <= 2'b10; result_src_out <= 2'b00; mem_unsigned_out <= 1'b0; is_muldiv_out <= 1'b0;
            is_csr_out <= 1'b0; csr_addr_out <= 12'b0;
        end else if (!stall) begin
            alu_result_out <= alu_result_in; muldiv_result_out <= muldiv_result_in; rs2_data_out <= rs2_data_in;
            pc_plus4_out <= pc_plus4_in; imm_out <= imm_in; rd_addr_out <= rd_addr_in; instr_out <= instr_in;
            reg_write_out <= reg_write_in; mem_read_out <= mem_read_in; mem_write_out <= mem_write_in;
            mem_width_out <= mem_width_in; result_src_out <= result_src_in;
            mem_unsigned_out <= mem_unsigned_in; is_muldiv_out <= is_muldiv_in;
            is_csr_out <= is_csr_in; csr_addr_out <= csr_addr_in;
        end
    end
endmodule

module mem_wb_reg (""",
"ex_mem_reg body + module boundary"))

edits.append((PR,
"""    input  logic        reg_write_in,
    input  logic [1:0]  result_src_in,
    input  logic        is_muldiv_in,

    output logic [31:0] mem_rdata_out, alu_result_out, muldiv_result_out, pc_plus4_out, imm_out,
    output logic [4:0]  rd_addr_out,
    output logic [31:0] instr_out,
    output logic        reg_write_out,
    output logic [1:0]  result_src_out,
    output logic        is_muldiv_out
);""",
"""    input  logic        reg_write_in,
    input  logic [1:0]  result_src_in,
    input  logic        is_muldiv_in,
    input  logic        is_csr_in,
    input  logic [11:0] csr_addr_in,

    output logic [31:0] mem_rdata_out, alu_result_out, muldiv_result_out, pc_plus4_out, imm_out,
    output logic [4:0]  rd_addr_out,
    output logic [31:0] instr_out,
    output logic        reg_write_out,
    output logic [1:0]  result_src_out,
    output logic        is_muldiv_out,
    output logic        is_csr_out,
    output logic [11:0] csr_addr_out
);""",
"mem_wb_reg ports"))

edits.append((PR,
"""            reg_write_out <= 1'b0; result_src_out <= 2'b00; is_muldiv_out <= 1'b0;
        end else if (!stall) begin
            mem_rdata_out <= mem_rdata_in; alu_result_out <= alu_result_in; muldiv_result_out <= muldiv_result_in;
            pc_plus4_out <= pc_plus4_in; imm_out <= imm_in; rd_addr_out <= rd_addr_in; instr_out <= instr_in;
            reg_write_out <= reg_write_in; result_src_out <= result_src_in; is_muldiv_out <= is_muldiv_in;
        end
    end
endmodule""",
"""            reg_write_out <= 1'b0; result_src_out <= 2'b00; is_muldiv_out <= 1'b0;
            is_csr_out <= 1'b0; csr_addr_out <= 12'b0;
        end else if (!stall) begin
            mem_rdata_out <= mem_rdata_in; alu_result_out <= alu_result_in; muldiv_result_out <= muldiv_result_in;
            pc_plus4_out <= pc_plus4_in; imm_out <= imm_in; rd_addr_out <= rd_addr_in; instr_out <= instr_in;
            reg_write_out <= reg_write_in; result_src_out <= result_src_in; is_muldiv_out <= is_muldiv_in;
            is_csr_out <= is_csr_in; csr_addr_out <= csr_addr_in;
        end
    end
endmodule""",
"mem_wb_reg body"))

# ---------------- core_top_pipelined.sv ----------------
edits.append((CT,
"""    logic        id_is_csr;
    logic [1:0]  id_csr_op;""",
"""    logic        id_is_csr;
    logic [1:0]  id_csr_op;
    logic [11:0] id_csr_addr;""",
"CT id_csr_addr decl"))

edits.append((CT,
"""        .is_csr(id_is_csr), .csr_op(id_csr_op)
    );""",
"""        .is_csr(id_is_csr), .csr_op(id_csr_op), .csr_addr(id_csr_addr)
    );""",
"CT decoder instantiation"))

edits.append((CT,
"""    logic        ex_is_csr;""",
"""    logic        ex_is_csr;
    logic [1:0]  ex_csr_op;
    logic [11:0] ex_csr_addr;""",
"CT ex_csr decls"))

edits.append((CT,
"""        .muldiv_op_in(id_muldiv_op), .illegal_instr_in(id_illegal_instr), .is_csr_in(id_is_csr),""",
"""        .muldiv_op_in(id_muldiv_op), .illegal_instr_in(id_illegal_instr), .is_csr_in(id_is_csr),
        .csr_op_in(id_csr_op), .csr_addr_in(id_csr_addr),""",
"CT id_ex_reg inst inputs"))

edits.append((CT,
"""        .muldiv_op_out(ex_muldiv_op), .illegal_instr_out(ex_illegal_instr), .is_csr_out(ex_is_csr)""",
"""        .muldiv_op_out(ex_muldiv_op), .illegal_instr_out(ex_illegal_instr), .is_csr_out(ex_is_csr),
        .csr_op_out(ex_csr_op), .csr_addr_out(ex_csr_addr)""",
"CT id_ex_reg inst outputs"))

edits.append((CT,
"""    logic        trap_taken;
    logic [31:0] trap_target, mepc, mcause, mtval;
    trap_unit u_trap (
        .clk(clk), .rst_n(rst_n),
        .illegal_instr(ex_illegal_instr), .faulting_pc(ex_pc), .faulting_instr(ex_instr),
        .trap_taken(trap_taken), .trap_target(trap_target),
        .mepc(mepc), .mcause(mcause), .mtval(mtval)
    );""",
"""    logic        trap_taken, trap_we;
    logic [31:0] trap_mepc_wdata, trap_mcause_wdata, trap_mtval_wdata;
    logic [31:0] mepc, mcause, mtval, mtvec, trap_target;
    trap_unit u_trap (
        .illegal_instr(ex_illegal_instr), .faulting_pc(ex_pc), .faulting_instr(ex_instr),
        .trap_taken(trap_taken), .trap_we(trap_we),
        .trap_mepc_wdata(trap_mepc_wdata), .trap_mcause_wdata(trap_mcause_wdata),
        .trap_mtval_wdata(trap_mtval_wdata)
    );
    assign trap_target = mtvec;

    logic [31:0] csr_rdata_ex;
    logic        wb_csr_we;
    logic [11:0] wb_csr_addr;
    logic [31:0] wb_csr_wdata;
    csr_file u_csr_file (
        .clk(clk), .rst_n(rst_n),
        .csr_raddr(ex_csr_addr), .csr_rdata(csr_rdata_ex),
        .csr_we(wb_csr_we), .csr_waddr(wb_csr_addr), .csr_wdata(wb_csr_wdata),
        .trap_we(trap_we), .trap_mepc_wdata(trap_mepc_wdata),
        .trap_mcause_wdata(trap_mcause_wdata), .trap_mtval_wdata(trap_mtval_wdata),
        .mepc(mepc), .mcause(mcause), .mtval(mtval), .mtvec(mtvec)
    );

    logic [31:0] csr_wdata_ex;
    always_comb begin
        unique case (ex_csr_op)
            2'b01:   csr_wdata_ex = fwd_a_val;                  /* CSRRW */
            2'b10:   csr_wdata_ex = csr_rdata_ex | fwd_a_val;   /* CSRRS */
            2'b11:   csr_wdata_ex = csr_rdata_ex & ~fwd_a_val;  /* CSRRC */
            default: csr_wdata_ex = 32'b0;
        endcase
    end""",
"CT trap_unit rewire + csr_file inst"))

edits.append((CT,
"""    logic [31:0] mem_alu_result, mem_muldiv_result, mem_rs2_data, mem_pc_plus4, mem_imm_out, mem_instr;
    logic [4:0]  mem_rd_addr;
    logic        mem_reg_write, mem_mem_read, mem_mem_write, mem_mem_unsigned, mem_is_muldiv;
    logic [1:0]  mem_mem_width, mem_result_src;""",
"""    logic [31:0] mem_alu_result, mem_muldiv_result, mem_rs2_data, mem_pc_plus4, mem_imm_out, mem_instr;
    logic [4:0]  mem_rd_addr;
    logic        mem_reg_write, mem_mem_read, mem_mem_write, mem_mem_unsigned, mem_is_muldiv;
    logic [1:0]  mem_mem_width, mem_result_src;
    logic        mem_is_csr_out;
    logic [11:0] mem_csr_addr_out;""",
"CT mem stage decls"))

edits.append((CT,
"""    ex_mem_reg u_ex_mem (
        .clk(clk), .rst_n(rst_n), .stall(stall_exmem), .clear(1'b0),
        .alu_result_in(alu_result), .muldiv_result_in(muldiv_result_bus),
        .rs2_data_in(fwd_b_val), .pc_plus4_in(ex_pc + 32'd4), .imm_in(ex_imm),
        .rd_addr_in(ex_rd_addr), .instr_in(ex_instr),
        .reg_write_in(ex_reg_write), .mem_read_in(ex_mem_read), .mem_write_in(ex_mem_write),
        .mem_width_in(ex_mem_width), .result_src_in(ex_result_src),
        .mem_unsigned_in(ex_mem_unsigned), .is_muldiv_in(ex_is_muldiv),

        .alu_result_out(mem_alu_result), .muldiv_result_out(mem_muldiv_result),
        .rs2_data_out(mem_rs2_data), .pc_plus4_out(mem_pc_plus4), .imm_out(mem_imm_out),
        .rd_addr_out(mem_rd_addr), .instr_out(mem_instr),
        .reg_write_out(mem_reg_write), .mem_read_out(mem_mem_read), .mem_write_out(mem_mem_write),
        .mem_width_out(mem_mem_width), .result_src_out(mem_result_src),
        .mem_unsigned_out(mem_mem_unsigned), .is_muldiv_out(mem_is_muldiv)
    );""",
"""    /* CSR ops reuse alu_result (pre-write value -> rd, free via existing
     * result_src=00/is_muldiv=0 WB path + forwarding) and muldiv_result
     * (new value -> csr_file's WB write port only; ignored by regfile). */
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

        .alu_result_out(mem_alu_result), .muldiv_result_out(mem_muldiv_result),
        .rs2_data_out(mem_rs2_data), .pc_plus4_out(mem_pc_plus4), .imm_out(mem_imm_out),
        .rd_addr_out(mem_rd_addr), .instr_out(mem_instr),
        .reg_write_out(mem_reg_write), .mem_read_out(mem_mem_read), .mem_write_out(mem_mem_write),
        .mem_width_out(mem_mem_width), .result_src_out(mem_result_src),
        .mem_unsigned_out(mem_mem_unsigned), .is_muldiv_out(mem_is_muldiv),
        .is_csr_out(mem_is_csr_out), .csr_addr_out(mem_csr_addr_out)
    );""",
"CT ex_mem_reg inst + csr mux"))

edits.append((CT,
"""    logic [31:0] wb_mem_rdata, wb_alu_result, wb_muldiv_result, wb_pc_plus4, wb_imm_out, wb_instr;
    logic [4:0]  wb_rd_addr;
    logic        wb_reg_write;
    logic [1:0]  wb_result_src;
    logic        wb_is_muldiv;""",
"""    logic [31:0] wb_mem_rdata, wb_alu_result, wb_muldiv_result, wb_pc_plus4, wb_imm_out, wb_instr;
    logic [4:0]  wb_rd_addr;
    logic        wb_reg_write;
    logic [1:0]  wb_result_src;
    logic        wb_is_muldiv;
    logic        wb_is_csr;
    logic [11:0] wb_csr_addr_out;""",
"CT wb stage decls"))

edits.append((CT,
"""    mem_wb_reg u_mem_wb (
        .clk(clk), .rst_n(rst_n), .stall(stall_memwb), .clear(1'b0),
        .mem_rdata_in(mem_rdata), .alu_result_in(mem_alu_result), .muldiv_result_in(mem_muldiv_result),
        .pc_plus4_in(mem_pc_plus4), .imm_in(mem_imm_out), .rd_addr_in(mem_rd_addr), .instr_in(mem_instr),
        .reg_write_in(mem_reg_write), .result_src_in(mem_result_src), .is_muldiv_in(mem_is_muldiv),

        .mem_rdata_out(wb_mem_rdata), .alu_result_out(wb_alu_result), .muldiv_result_out(wb_muldiv_result),
        .pc_plus4_out(wb_pc_plus4), .imm_out(wb_imm_out), .rd_addr_out(wb_rd_addr), .instr_out(wb_instr),
        .reg_write_out(wb_reg_write), .result_src_out(wb_result_src), .is_muldiv_out(wb_is_muldiv)
    );""",
"""    mem_wb_reg u_mem_wb (
        .clk(clk), .rst_n(rst_n), .stall(stall_memwb), .clear(1'b0),
        .mem_rdata_in(mem_rdata), .alu_result_in(mem_alu_result), .muldiv_result_in(mem_muldiv_result),
        .pc_plus4_in(mem_pc_plus4), .imm_in(mem_imm_out), .rd_addr_in(mem_rd_addr), .instr_in(mem_instr),
        .reg_write_in(mem_reg_write), .result_src_in(mem_result_src), .is_muldiv_in(mem_is_muldiv),
        .is_csr_in(mem_is_csr_out), .csr_addr_in(mem_csr_addr_out),

        .mem_rdata_out(wb_mem_rdata), .alu_result_out(wb_alu_result), .muldiv_result_out(wb_muldiv_result),
        .pc_plus4_out(wb_pc_plus4), .imm_out(wb_imm_out), .rd_addr_out(wb_rd_addr), .instr_out(wb_instr),
        .reg_write_out(wb_reg_write), .result_src_out(wb_result_src), .is_muldiv_out(wb_is_muldiv),
        .is_csr_out(wb_is_csr), .csr_addr_out(wb_csr_addr_out)
    );""",
"CT mem_wb_reg inst"))

edits.append((CT,
"""    assign wb_reg_write_for_rf = wb_reg_write && !stall_memwb;
    assign wb_rd_data_for_rf   = wb_rd_data;""",
"""    assign wb_reg_write_for_rf = wb_reg_write && !stall_memwb;
    assign wb_rd_data_for_rf   = wb_rd_data;

    assign wb_csr_we    = wb_is_csr && !stall_memwb;
    assign wb_csr_addr  = wb_csr_addr_out;
    assign wb_csr_wdata = wb_muldiv_result;""",
"CT csr write commit"))

for path, old, new, label in edits:
    replace_once(path, old, new, label)

print("\nALL EDITS APPLIED SUCCESSFULLY")
