module regfile (
    input  logic        clk,
    input  logic [4:0]  rs1_addr,
    input  logic [4:0]  rs2_addr,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    input  logic        rd_we,
    input  logic [4:0]  rd_addr,
    input  logic [31:0] rd_data
);
    logic [31:0] regs [1:31]; /* x0 not stored; hardwired zero below */

    assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : regs[rs2_addr];

    always_ff @(posedge clk)
        if (rd_we && rd_addr != 5'd0)
            regs[rd_addr] <= rd_data;
endmodule
