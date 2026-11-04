/* Illegal-instruction trap request generator. Purely combinational --
 * mepc/mcause/mtval/mtvec storage moved into csr_file.sv (single writer,
 * closes the double-writer race flagged in STAGE5_SESSION_HANDOFF_3.md
 * Part 5). This module only computes trap_taken and the write request
 * that csr_file's write port consumes; csr_file's internal priority mux
 * (trap wins over a same-cycle software CSR write) does the actual
 * register update.
 */
module trap_unit (
    input  logic        illegal_instr,
    input  logic [31:0] faulting_pc,
    input  logic [31:0] faulting_instr,
    output logic        trap_taken,
    output logic        trap_we,
    output logic [31:0] trap_mepc_wdata,
    output logic [31:0] trap_mcause_wdata,
    output logic [31:0] trap_mtval_wdata
);
    assign trap_taken        = illegal_instr;
    assign trap_we           = illegal_instr;
    assign trap_mepc_wdata   = faulting_pc;
    assign trap_mcause_wdata = 32'd2;   /* 2 = illegal instruction, priv spec */
    assign trap_mtval_wdata  = faulting_instr;
endmodule
