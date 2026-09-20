/* Multi-cycle iterative multiply/divide unit (Part 8 §2.3). Shift-add
 * multiplier, restoring divider, ~32 cycle worst case. Replaces Stage 2's
 * combinational muldiv.sv -- deliberately slower, since accumulated
 * switching activity across iterations is what makes this a meaningful
 * isolation target (Part 8 §2.3's own stated rationale).
 *
 * Interface: start pulses for one cycle to begin; busy stays high until
 * done pulses for one cycle with the result valid. op_en gates operand
 * latching (Part 8 §2.3's isolation hook) -- when low, internal operand
 * registers hold their previous value instead of reloading. This signal
 * is driven externally (MULDIV_EN, decode-stage-generated) per §2.2B;
 * this module doesn't generate it, only consumes it.
 */
module muldiv_iter (
    input  logic        clk,
    input  logic        rst_n,
    input  logic         start,
    input  logic         op_en,      /* isolation gate input, Part 8 §2.3 */
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [2:0]  op,          /* funct3: mul/mulh/mulhsu/mulhu/div/divu/rem/remu */
    output logic         busy,
    output logic         done,
    output logic [31:0] result
);
    typedef enum logic [1:0] {IDLE, MUL_RUN, DIV_RUN, FINISH} state_t;
    state_t state;

    logic [31:0] op_a_r;
    logic [2:0]  op_r;
    logic [5:0]  iter_cnt;

    /* ---- Sign bits: pure combinational from stable inputs (a/b/op),
     * used same-cycle for operand negation AND registered below for use
     * many cycles later at FINISH -- this split is what avoids the
     * blocking-assignment-in-always_ff pattern lint flagged. */
    logic mul_a_sign_c, mul_b_sign_c;
    assign mul_a_sign_c = (op[1:0] != 2'b11) && a[31];
    assign mul_b_sign_c = (op[1:0] == 2'b01) && b[31];

    logic div_a_sign_c, div_b_sign_c;
    assign div_a_sign_c = (op[0] == 1'b0) && a[31];   /* signed only for DIV/REM, not DIVU/REMU */
    assign div_b_sign_c = (op[0] == 1'b0) && b[31];

    logic mul_a_sign, mul_b_sign;   /* registered copies, held for FINISH */
    logic div_a_sign, div_b_sign;

    /* ---- Multiplier state: 64-bit accumulator, shift-add ---- */
    logic [63:0] mul_acc;
    logic [31:0] mul_mcand;

    /* ---- Divider state: restoring, 32-bit quotient/remainder ---- */
    logic [63:0] div_rem;   /* {remainder[31:0], quotient[31:0]}, shifted */
    logic [31:0] div_divisor;
    logic        div_by_zero;
    /* RISC-V spec special case: INT_MIN / -1 overflows 32 bits and must
     * return INT_MIN (DIV) / 0 (REM) directly, not the naive computed
     * result -- no general division logic can produce this correctly. */
    logic        is_div_overflow;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE; busy <= 1'b0; done <= 1'b0;
            op_a_r <= 32'b0; op_r <= 3'b0; iter_cnt <= 6'b0;
            mul_acc <= 64'b0; mul_mcand <= 32'b0;
            mul_a_sign <= 1'b0; mul_b_sign <= 1'b0;
            div_a_sign <= 1'b0; div_b_sign <= 1'b0;
            div_rem <= 64'b0; div_divisor <= 32'b0; div_by_zero <= 1'b0; is_div_overflow <= 1'b0;
        end else begin
            done <= 1'b0;
            unique case (state)
                IDLE: begin
                    if (start) begin
                        /* Operand isolation gate: only latch new operands
                         * when op_en is high, per Part 8 §2.3's placement
                         * rule (downstream of forwarding -- the caller is
                         * responsible for presenting already-forwarded a/b
                         * here; this module just gates the latch). */
                        if (op_en) begin
                            op_a_r <= a; op_r <= op;
                        end
                        busy <= 1'b1;
                        iter_cnt <= 6'd0;

                        if (op[2] == 1'b0) begin
                            /* MUL/MULH/MULHSU/MULHU */
                            mul_a_sign <= mul_a_sign_c;
                            mul_b_sign <= mul_b_sign_c;
                            mul_mcand  <= mul_b_sign_c ? (~b + 32'd1) : b;
                            mul_acc    <= {32'b0, (mul_a_sign_c ? (~a + 32'd1) : a)};
                            state <= MUL_RUN;
                        end else begin
                            /* DIV/DIVU/REM/REMU */
                            div_a_sign  <= div_a_sign_c;
                            div_b_sign  <= div_b_sign_c;
                            div_by_zero <= (b == 32'b0);
                            div_divisor <= div_b_sign_c ? (~b + 32'd1) : b;
                            is_div_overflow <= (a == 32'h80000000) && div_b_sign_c && (b == 32'hFFFFFFFF);
                            div_rem     <= {32'b0, (div_a_sign_c ? (~a + 32'd1) : a)};
                            state <= DIV_RUN;
                        end
                    end
                end

                MUL_RUN: begin
                    /* 32-cycle shift-add: add mcand into upper half if
                     * current LSB set, then shift whole 64-bit acc right. */
                    if (mul_acc[0])
                        mul_acc <= {33'(mul_acc[63:32]) + 33'(mul_mcand), mul_acc[31:1]};
                    else
                        mul_acc <= {1'b0, mul_acc[63:32], mul_acc[31:1]};
                    iter_cnt <= iter_cnt + 6'd1;
                    if (iter_cnt == 6'd31) state <= FINISH;
                end

                DIV_RUN: begin
                    /* 32-cycle restoring divide on {remainder,quotient}. */
                    automatic logic [63:0] shifted;
                    automatic logic [31:0] trial_rem;
                    shifted   = div_rem << 1;
                    trial_rem = shifted[63:32];
                    if (trial_rem >= div_divisor) begin
                        div_rem <= {(trial_rem - div_divisor), shifted[31:1], 1'b1};
                    end else begin
                        div_rem <= shifted;
                    end
                    iter_cnt <= iter_cnt + 6'd1;
                    if (iter_cnt == 6'd31) state <= FINISH;
                end

                FINISH: begin
                    busy  <= 1'b0;
                    done  <= 1'b1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    always_comb begin
        /* Full 64-bit two's-complement negation is required (not just the
         * upper 32 bits) because borrow propagates from the lower half
         * during negation; the lower 32 bits of `full` are then correctly
         * discarded after that propagation is accounted for -- this is
         * intentional, not wasted logic. */
        /* verilator lint_off UNUSEDSIGNAL */
        automatic logic [63:0] full;
        /* verilator lint_on UNUSEDSIGNAL */
        unique case (op_r)
            3'b000:  result = mul_a_sign ^ mul_b_sign ? (~mul_acc[31:0] + 32'd1) : mul_acc[31:0]; /* MUL */
            3'b001:  begin /* MULH */
                full = mul_a_sign ^ mul_b_sign ? (~mul_acc + 64'd1) : mul_acc;
                result = full[63:32];
            end
            3'b010:  begin /* MULHSU: a signed, b already unsigned in mcand */
                full = mul_a_sign ? (~mul_acc + 64'd1) : mul_acc;
                result = full[63:32];
            end
            3'b011:  result = mul_acc[63:32]; /* MULHU */
            3'b100:  result = div_by_zero ? 32'hFFFFFFFF
                              : is_div_overflow ? 32'h80000000
                              : (div_a_sign ^ div_b_sign) ? (~div_rem[31:0] + 32'd1) : div_rem[31:0]; /* DIV */
            3'b101:  result = div_by_zero ? 32'hFFFFFFFF : div_rem[31:0]; /* DIVU */
            3'b110:  result = div_by_zero ? op_a_r : is_div_overflow ? 32'h00000000 : (div_a_sign ? (~div_rem[63:32] + 32'd1) : div_rem[63:32]); /* REM */
            3'b111:  result = div_by_zero ? op_a_r : div_rem[63:32]; /* REMU */
            default: result = 32'hDEADBEEF;
        endcase
    end
endmodule
