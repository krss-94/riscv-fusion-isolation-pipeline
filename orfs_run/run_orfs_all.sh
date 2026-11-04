#!/bin/bash
# Run INSIDE the orfs container, started from ~/Downloads/ooo-repo/orfs_run (or wherever this folder is):
#   docker run --rm -it -v "$PWD":/work openroad/orfs:latest bash
#   bash /work/run_orfs_all.sh            # all 5 configs
#   bash /work/run_orfs_all.sh D_proposed # one config
# Env knobs:  MEM=0000_1000 (4 KB, default)  PERIOD=10.0 (ns)
set -e
FLOW=/OpenROAD-flow-scripts/flow
HERE=/work
MEM=${MEM:-0000_1000}
PERIOD=${PERIOD:-10.0}
source /OpenROAD-flow-scripts/env.sh >/dev/null 2>&1 || true
export PATH=/OpenROAD-flow-scripts/tools/install/OpenROAD/bin:/OpenROAD-flow-scripts/tools/install/yosys/bin:$PATH

# name fusion isol brcmp
CFGS="A_baseline:0:0:0 B_fusion_only:1:0:0 C_isol_only:0:1:0 D_proposed:1:1:0 D_isol_scope_ablation:1:1:1"
[ -n "$1" ] && CFGS=$(for c in $CFGS; do case $c in $1:*) echo $c;; esac; done)

for c in $CFGS; do
  IFS=: read name F I B <<<"$c"
  nick=core_$name
  SRC=$FLOW/designs/src/$nick
  DDIR=$FLOW/designs/sky130hd/$nick
  rm -rf $SRC $DDIR; mkdir -p $SRC $DDIR
  cp $HERE/rtl/*.sv $SRC/
  cp $HERE/rtl/imem_init.hex $SRC/
  # absolute hex path so yosys finds it no matter its working dir
  sed -i "s#\"imem_init.hex\"#\"$SRC/imem_init.hex\"#g" $SRC/core_top_pipelined.sv
  sed "s/@MEMHEX@/$MEM/;s/@F@/$F/;s/@I@/$I/;s/@B@/$B/" $HERE/rtl/core_top_synth_wrapper.sv.tmpl > $SRC/core_top_synth_wrapper.sv
  rm -f $SRC/core_top_synth_wrapper.sv.tmpl
  cat > $DDIR/config.mk <<EOF
export DESIGN_NICKNAME = $nick
export DESIGN_NAME     = core_top_synth_wrapper
export PLATFORM        = sky130hd
export VERILOG_FILES   = \$(sort \$(wildcard \$(DESIGN_HOME)/src/\$(DESIGN_NICKNAME)/*.sv))
export SDC_FILE        = \$(DESIGN_HOME)/\$(PLATFORM)/\$(DESIGN_NICKNAME)/constraint.sdc
export CORE_UTILIZATION = 35
export PLACE_DENSITY_LB_ADDON = 0.2
export REMOVE_ABC_BUFFERS = 1
export SYNTH_MEMORY_MAX_BITS = 1100000
EOF
  cat > $DDIR/constraint.sdc <<EOF
set clk_name clk
set clk_port_name clk
set clk_period $PERIOD
set clk_io_pct 0.2
set clk_port [get_ports \$clk_port_name]
create_clock -name \$clk_name -period \$clk_period \$clk_port
set clk_io_name vclk_\$clk_name
create_clock -name \$clk_io_name -period \$clk_period
set_clock_latency 0.775 [get_clocks \$clk_name]
set_clock_latency 0.775 [get_clocks \$clk_io_name]
set non_clock_inputs [list]
foreach input [all_inputs] { if { \$clk_port != \$input } { lappend non_clock_inputs \$input } }
set_input_delay  [expr \$clk_period * \$clk_io_pct] -clock \$clk_io_name \$non_clock_inputs
set_output_delay [expr \$clk_period * \$clk_io_pct] -clock \$clk_io_name [all_outputs]
EOF
  echo "=========== $name (F=$F I=$I B=$B MEM=$MEM period=$PERIOD) ==========="
  ( cd $FLOW && make DESIGN_CONFIG=./designs/sky130hd/$nick/config.mk 2>&1 | tee $HERE/log_$name.txt | tail -3 )
  # results -> shared folder
  R=$FLOW/results/sky130hd/$nick/base
  mkdir -p $HERE/results/$name
  cp $R/6_final.odb $R/6_final.sdc $R/6_final.spef $R/6_final.v $HERE/results/$name/ 2>/dev/null || echo "  (no final results for $name)"
  cp $FLOW/reports/sky130hd/$nick/base/*.rpt $FLOW/reports/sky130hd/$nick/base/synth_stat.txt $HERE/results/$name/ 2>/dev/null || true
done

echo; echo "################ SUMMARY ################"
for c in $CFGS; do name=${c%%:*}
  echo "== $name"
  grep -E "Chip area|Number of cells" $HERE/results/$name/synth_stat.txt 2>/dev/null | tail -2
  grep -E "design__instance__area |timing__setup__ws |power__total " $FLOW/logs/sky130hd/core_$name/base/6_report.json 2>/dev/null | head -3
done
