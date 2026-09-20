/* Combinational M-extension unit -- Stage 2 simplification, see chat notes.
 * Not representative of Part 8's eventual multi-cycle design; validates
 * decode/datapath correctness only, per Part 14 Stage 2's "simplest
 * possible way" instruction. */
module muldiv (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [2:0]  op, /* matches funct3: MUL/MULH/MULHSU/MULHU/DIV/DIVU/REM/REMU */
    output logic [31:0] result
);
    wire signed [32:0] a_s = {a[31], a};
    wire signed [32:0] b_s = {b[31], b};
    wire        [32:0] a_u = {1'b0, a};
    wire        [32:0] b_u = {1'b0, b};

    wire signed [65:0] prod_ss = a_s * b_s;
    wire signed [65:0] prod_su = a_s * $signed({1'b0, b});
    wire        [65:0] prod_uu = a_u * b_u;

    logic signed [31:0] div_s, rem_s;
    logic        [31:0] div_u, rem_u;

    /* RV32M-defined behavior for div-by-zero / signed overflow (Part 10 §2). */
    always_comb begin
        if (b == 32'b0) div_s = -32'sd1;
        else if (a == 32'h80000000 && b == 32'hFFFFFFFF) div_s = 32'h80000000;
        else div_s = $signed(a) / $signed(b);

        if (b == 32'b0) rem_s = $signed(a);
        else if (a == 32'h80000000 && b == 32'hFFFFFFFF) rem_s = 32'sd0;
        else rem_s = $signed(a) % $signed(b);

        div_u = (b == 32'b0) ? 32'hFFFFFFFF : (a / b);
        rem_u = (b == 32'b0) ? a            : (a % b);
    end

    always_comb begin
        case (op)
            3'b000: result = prod_ss[31:0];
            3'b001: result = prod_ss[63:32];
            3'b010: result = prod_su[63:32];
            3'b011: result = prod_uu[63:32];
            3'b100: result = div_s;
            3'b101: result = div_u;
            3'b110: result = rem_s;
            3'b111: result = rem_u;
            default: result = 32'hDEADBEEF;
        endcase
    end
endmodule
