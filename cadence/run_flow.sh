#!/bin/bash
# Usage (from the cadence/ directory):
#   ./run_flow.sh D_proposed genus       # one config, one stage (start here)
#   ./run_flow.sh D_proposed innovus
#   ./run_flow.sh D_proposed tempus
#   ./run_flow.sh D_proposed             # one config, all three stages
#   ./run_flow.sh all                    # all 5 configs, all stages
#
#   MEM_HEX=0000_1000 ./run_flow.sh D_proposed genus  # 4KB memory (RECOMMENDED for first run)
#   MEM_HEX=0000_0400 ./run_flow.sh D_proposed genus  # 1KB memory (even faster)
#
# Assumes genus/innovus/tempus are already on PATH (source your lab's
# Cadence setup file first, however your lab does it).
# If a tool rejects a command-line flag (-no_gui / -nowin), paste the error.

cd "$(dirname "$0")" || exit 1
mkdir -p logs

ALL="A_baseline B_fusion_only C_isol_only D_proposed D_isol_scope_ablation"
if [ -z "$1" ] || [ "$1" = "all" ]; then cfgs="$ALL"; else cfgs="$1"; fi
stage="${2:-all}"

for c in $cfgs; do
  export CONFIG="$c"
  echo "=================== $c ($stage) ==================="

  if [ "$stage" = "all" ] || [ "$stage" = "genus" ]; then
    genus -no_gui -files 01_genus_synth.tcl -log "logs/genus_$c" || { echo "Genus failed for $c"; exit 1; }
  fi
  if [ "$stage" = "all" ] || [ "$stage" = "innovus" ]; then
    innovus -nowin -files 02_innovus_pnr.tcl -log "logs/innovus_$c" -overwrite || { echo "Innovus failed for $c"; exit 1; }
  fi
  if [ "$stage" = "all" ] || [ "$stage" = "tempus" ]; then
    tempus -no_gui -files 03_tempus_signoff.tcl -log "logs/tempus_$c" || { echo "Tempus failed for $c"; exit 1; }
  fi
done
echo "Finished: $cfgs ($stage)"
