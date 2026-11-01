#############################################################################
# constraints.sdc
#
# Matches the Vivado runs exactly: one clock, nothing else
#   (create_clock -period 18.000 -name clk [get_ports clk]).
# Clock-only keeps the Cadence numbers comparable to the Vivado PPA table.
#
# CLK_PERIOD comes from config.tcl when it was sourced in the same session;
# otherwise falls back to 18.0.
#############################################################################

if {[info exists CLK_PERIOD]} { set _p $CLK_PERIOD } else { set _p 18.0 }

create_clock -name clk -period $_p [get_ports clk]

# OPTIONAL (off by default, Vivado had none): I/O budget of 20% of the clock.
# Uncomment for a more conservative, more "real chip" constraint set.
# set _io [expr {$_p * 0.2}]
# set_input_delay  $_io -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
# set_output_delay $_io -clock clk [all_outputs]
