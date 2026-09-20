// tb_saif.sv — SAIF-logging testbench for Vivado xsim (Verilator can't emit SAIF).
// Separate from tb_pipeline.cpp on purpose: this exists only to generate real
// switching-activity data for report_power, not to re-run correctness checks
// (those are already closed via the 92/92 lockstep + 15/15 standalone suite).
//
// IMPORTANT — confirm before running: this assumes core_top_pipelined's imem/dmem
// $readmemh calls read a filename you can override per-run. If your RTL hardcodes
// "imem_init.hex" directly (per your Harvard-split fix), you have two options:
//   (a) copy the benchmark's .hex file to imem_init.hex before each xelab run, or
//   (b) parameterize the filename in core_top_pipelined.sv (e.g. a string parameter
//       IMEM_HEX_FILE, defaulting to "imem_init.hex" so nothing else breaks).
// Option (a) is zero RTL changes — recommended given how much this session has
// already touched that file. This testbench assumes (a): it expects
// imem_init.hex (and dmem's mirror) to already be swapped to the target
// benchmark's image *before* xelab runs, by the driver script.

`timescale 1ns/1ps

module tb_saif;
  parameter FUSION_EN  = 0;
  parameter ISOL_EN    = 0;
  parameter BR_CMP_EN  = 0;
  parameter int MAX_CYCLES = 1000000; // generous ceiling; real benchmarks should
                                      // finish and can end sim early via a UART/
                                      // exit-code tap if your core_top exposes one

  logic clk = 0;
  logic rst_n = 0;

  always #5 clk = ~clk; // sim-only clock period, unrelated to the synthesis
                         // period under test — SAIF timing comes from real
                         // clock edges during this run, not from this constant

  core_top_pipelined #(.FUSION_EN(FUSION_EN), .ISOL_EN(ISOL_EN), .BR_CMP_EN(BR_CMP_EN)) dut (
    .clk(clk),
    .rst_n(rst_n)
    // NOTE: confirm core_top_pipelined's actual port list matches — this
    // testbench only wires clk/rst_n since that's all tb_pipeline.cpp's
    // harness needed per your earlier sessions; add any other top-level
    // ports here if core_top_pipelined declares more.
  );

  initial begin
    rst_n = 0;
    repeat (5) @(posedge clk);
    rst_n = 1;

    repeat (MAX_CYCLES) @(posedge clk);

    $display("SAIF_TB: reached MAX_CYCLES (%0d) without explicit finish — check if this benchmark actually completed, or raise MAX_CYCLES", MAX_CYCLES);
    $finish;
  end

endmodule





