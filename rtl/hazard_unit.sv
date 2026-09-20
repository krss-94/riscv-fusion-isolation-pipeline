/* Hazard detection and forwarding, Part 8 baseline 5-stage pipeline.
 *
 * Two INDEPENDENT stall mechanisms, deliberately not conflated:
 *   1. load_use_hazard: holds PC+IF/ID one cycle, inserts a bubble into
 *      ID/EX (clear, not stall) -- EX/MEM and MEM/WB are UNAFFECTED, they
 *      keep draining normally every cycle regardless.
 *   2. muldiv_busy: a GLOBAL pipeline freeze -- PC and ALL FOUR pipeline
 *      registers stall (hold current contents) until the iterative unit
 *      finishes. This must include EX/MEM and MEM/WB, not just the
 *      upstream stages: EX's own output isn't valid until muldiv
 *      completes, so if EX/MEM were allowed to advance during the stall
 *      it would push garbage into MEM; and if MEM/WB were allowed to
 *      advance independently while EX/MEM sits frozen, it would re-latch
 *      and re-execute the SAME already-completed writeback on every stall
 *      cycle -- functionally idempotent for a plain register write, but a
 *      real bug for anything with a side effect (a repeated store to a
 *      memory-mapped device would fire multiple times). Caught during
 *      design, not via a failing lockstep test -- worth being explicit
 *      that an earlier draft of this file got this wrong.
 */
module hazard_unit (
    input  logic [4:0]  ex_rs1_addr, ex_rs2_addr,
    input  logic [4:0]  mem_rd_addr,
    input  logic        mem_reg_write,
    input  logic [4:0]  wb_rd_addr,
    input  logic        wb_reg_write,

    input  logic [4:0]  id_rs1_addr, id_rs2_addr,
    input  logic [4:0]  ex_rd_addr,
    input  logic        ex_mem_read,
    input  logic [4:0]  mem_rd_addr_raw,
    input  logic        mem_mem_read,

    input  logic        pc_redirect,
    input  logic        muldiv_busy,
    input  logic        pend2_stall,

    output logic [1:0]  fwd_a_sel,
    output logic [1:0]  fwd_b_sel,

    output logic        stall_pc_ifid,   /* PC hold + if_id_reg.stall */
    output logic        stall_idex,      /* id_ex_reg.stall (muldiv freeze only) */
    output logic        stall_exmem,     /* ex_mem_reg.stall (muldiv freeze only) */
    output logic        stall_memwb,     /* mem_wb_reg.stall (muldiv freeze only) */
    output logic        flush_id,        /* if_id_reg.clear */
    output logic        flush_ex         /* id_ex_reg.clear */
);
    always_comb begin
        if (mem_reg_write && (mem_rd_addr != 5'd0) && (mem_rd_addr == ex_rs1_addr))
            fwd_a_sel = 2'b01;
        else if (wb_reg_write && (wb_rd_addr != 5'd0) && (wb_rd_addr == ex_rs1_addr))
            fwd_a_sel = 2'b10;
        else
            fwd_a_sel = 2'b00;
    end

    always_comb begin
        if (mem_reg_write && (mem_rd_addr != 5'd0) && (mem_rd_addr == ex_rs2_addr))
            fwd_b_sel = 2'b01;
        else if (wb_reg_write && (wb_rd_addr != 5'd0) && (wb_rd_addr == ex_rs2_addr))
            fwd_b_sel = 2'b10;
        else
            fwd_b_sel = 2'b00;
    end

    logic load_use_hazard;
    assign load_use_hazard = ex_mem_read && (ex_rd_addr != 5'd0) &&
                              ((ex_rd_addr == id_rs1_addr) || (ex_rd_addr == id_rs2_addr));

    logic load_use_hazard_mem;
    assign load_use_hazard_mem = mem_mem_read && (mem_rd_addr_raw != 5'd0) &&
                                  ((mem_rd_addr_raw == id_rs1_addr) || (mem_rd_addr_raw == id_rs2_addr));

    always_comb begin
        stall_pc_ifid = load_use_hazard || load_use_hazard_mem || muldiv_busy || pend2_stall;
        stall_idex    = muldiv_busy;
        stall_exmem   = muldiv_busy;
        stall_memwb   = muldiv_busy;

        flush_id = pc_redirect;
        flush_ex = pc_redirect || (!muldiv_busy && (load_use_hazard || load_use_hazard_mem || pend2_stall));
    end
endmodule
