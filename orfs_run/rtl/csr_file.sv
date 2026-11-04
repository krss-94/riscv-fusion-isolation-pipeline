/* CSR register file. Sole owner and sole writer of mepc/mcause/mtval/
 * mtvec. Two write requesters feed the single write port: the hardware
 * trap path (trap_we/trap_*_wdata) and the software CSRRW/CSRRS/CSRRC
 * path (csr_we/csr_waddr/csr_wdata, driven from WB). Trap wins on a
 * same-cycle collision -- accepted edge case, not expected in-order in
 * this single-issue pipeline. Read port is combinational, address-only.
 */
module csr_file (
    input  logic        clk, rst_n,

    input  logic [11:0] csr_raddr,
    output logic [31:0] csr_rdata,

    input  logic        csr_we,
    input  logic [11:0] csr_waddr,
    input  logic [31:0] csr_wdata,

    input  logic        trap_we,
    input  logic [31:0] trap_mepc_wdata,
    input  logic [31:0] trap_mcause_wdata,
    input  logic [31:0] trap_mtval_wdata,

    input  logic        muldiv_active,
    input  logic        isol_active,
    input  logic        fusion_active,

    output logic [31:0] mepc,
    output logic [31:0] mcause,
    output logic [31:0] mtval,
    output logic [31:0] mtvec
);
    localparam CSR_MEPC   = 12'h341;
    localparam CSR_MCAUSE = 12'h342;
    localparam CSR_MTVAL  = 12'h343;
    localparam CSR_MTVEC  = 12'h305;
    localparam CSR_MULDIV_ACTIVE = 12'hB03; /* mhpmcounter3 */
    localparam CSR_ISOL_ACTIVE   = 12'hB04; /* mhpmcounter4 */
    localparam CSR_FUSION_ACTIVE = 12'hB05; /* mhpmcounter5, reserved: no fusion mechanism yet */
    localparam CSR_MCYCLE = 12'hB00; /* free-running cycle counter, read-only (writes dropped) */
    logic [31:0] mcycle_cnt;

    logic [31:0] muldiv_active_cnt;
    logic [31:0] isol_active_cnt;
    logic [31:0] fusion_active_cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mepc <= 32'b0; mcause <= 32'b0; mtval <= 32'b0;
            mtvec <= 32'h8000_1000; /* preserves old TRAP_VEC default */
            muldiv_active_cnt <= 32'b0;
            isol_active_cnt   <= 32'b0;
            fusion_active_cnt <= 32'b0;
            mcycle_cnt <= 32'b0;
        end else begin
            if (trap_we) begin
                mepc   <= trap_mepc_wdata;
                mcause <= trap_mcause_wdata;
                mtval  <= trap_mtval_wdata;
            end else if (csr_we) begin
                unique case (csr_waddr)
                    CSR_MEPC:   mepc   <= csr_wdata;
                    CSR_MCAUSE: mcause <= csr_wdata;
                    CSR_MTVAL:  mtval  <= csr_wdata;
                    CSR_MTVEC:  mtvec  <= csr_wdata;
                    default: ; /* unimplemented CSR address: dropped */
                endcase
            end
            /* free-running HPM counters, independent of csr_we/trap_we -- software
             * can only read mhpmcounter3/4/5, no write case arm added.
             * Nested under the reset else (Stage 8 fix): previously these
             * sat as unconditional top-level statements alongside the
             * reset if-block with no else, which (a) let a same-cycle
             * assertion of muldiv_active/isol_active/fusion_active during
             * reset silently override the reset value for that counter
             * with mcycle_cnt's unconditional +1 doing so on EVERY cycle,
             * unconditionally defeating its own reset -- a real bug -- and
             * (b) triggers a Vivado 2026.1 synth-8-91 "ambiguous clock"
             * misdiagnosis on this exact two-top-level-if-no-else shape,
             * confirmed by minimal isolation during Stage 8 bring-up. */
            if (muldiv_active) muldiv_active_cnt <= muldiv_active_cnt + 32'b1;
            if (isol_active)   isol_active_cnt   <= isol_active_cnt + 32'b1;
            /* fusion_active must already be gated to pulse exactly once per
             * real fusion event (never once per stall cycle) at the call
             * site -- same level-vs-pulse care as the muldiv_active_cnt bug
             * fixed in Handoff #7. */
            if (fusion_active) fusion_active_cnt <= fusion_active_cnt + 32'b1;
            mcycle_cnt <= mcycle_cnt + 32'b1; /* increments every cycle outside reset */
        end
    end

    always_comb begin
        unique case (csr_raddr)
            CSR_MEPC:   csr_rdata = mepc;
            CSR_MCAUSE: csr_rdata = mcause;
            CSR_MTVAL:  csr_rdata = mtval;
            CSR_MTVEC:  csr_rdata = mtvec;
            CSR_MULDIV_ACTIVE: csr_rdata = muldiv_active_cnt;
            CSR_ISOL_ACTIVE:   csr_rdata = isol_active_cnt;
            CSR_FUSION_ACTIVE: csr_rdata = fusion_active_cnt;
            CSR_MCYCLE:        csr_rdata = mcycle_cnt;
            default:    csr_rdata = 32'b0;
        endcase
    end
endmodule
