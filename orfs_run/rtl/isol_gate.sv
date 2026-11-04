/* isol_gate.sv
 *
 * Decoder-driven operand isolation gate for the multiply/divide unit,
 * per Part 8 §2.3 (lines 52-58) and §2.10 items 1-2.
 *
 * Mechanism: a gated latch that sits DOWNSTREAM of the EX-stage
 * forwarding mux. When en is high, it samples the (already-forwarded)
 * operand every cycle as normal. When en is low, it HOLDS its previous
 * value instead of re-loading -- this is the isolation: the multiplier's
 * operand register stops switching on cycles it isn't being used.
 *
 * en must be the real decode-driven MULDIV_EN signal (ID-generated,
 * arriving in EX one cycle later, held stable by the EX-local busy
 * latch during multi-cycle iteration per §2.10 item 2) -- NOT the same
 * signal used for muldiv_active/pipeline-stall timing. Conflating the
 * two was flagged explicitly as a risk to avoid.
 *
 * This file is intentionally standalone and has no dependency on
 * anything else in core_top_pipelined.sv beyond its port list, so it
 * can be deleted and the instantiation reverted without touching
 * unrelated logic if this turns out to be wrong.
 */

module isol_gate #(
    parameter int WIDTH = 32
) (
    input  logic             clk,
    input  logic             en,          // MULDIV_EN, decode-driven, EX-timed
    input  logic [WIDTH-1:0] d,           // resolved (post-forwarding) operand in
    output logic [WIDTH-1:0] q            // gated operand out -> muldiv_iter
);

    logic [WIDTH-1:0] q_hold;

    always_ff @(posedge clk) begin
        if (en) q_hold <= d;
        // else: hold q_hold at its previous value.
    end

    // Transparent pass-through while en is high (zero added latency,
    // fixes the 1-cycle stale-operand bug found via MULDIV_DBG trace
    // on t_muldiv). Only actually holds (drives q from the register,
    // freezing switching activity) on cycles en is low.
    assign q = en ? d : q_hold;

endmodule
