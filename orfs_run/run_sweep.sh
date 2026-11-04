#!/usr/bin/env bash
# Multi-run ORFS/nangate45 sweep over the 5 ablation configs.
# Usage (inside LibreLane nix-shell, after `source env.sh` in all_free_pdks):
#   RTL_DIR=/path/to/rtl HEX=/path/to/imem_init.hex PERIOD=5.0 JOBS=4 ./run_sweep.sh
# Result: sweep_out/results.csv  (summarize with summarize.py)
set -euo pipefail

RTL_DIR=${RTL_DIR:?dir with the .sv files + core_top_synth_wrapper_sv.tmpl}
HEX=${HEX:?path to imem_init.hex}
PERIOD=${PERIOD:-5.0}          # ns (nangate45 is ns). Pick near your closing period.
MEM_BYTES=${MEM_BYTES:-1024}   # shrunk memory, same in every config
JOBS=${JOBS:-2}
: "${ORFS_FLOW:?run: source all_free_pdks/env.sh}"
export LEC_CHECK=0 QT_QPA_PLATFORM=offscreen SYNTH_HDL_FRONTEND=

OUT=$(pwd)/sweep_out; mkdir -p "$OUT"/cfg
MEMHEX=$(printf '%X' "$MEM_BYTES")

# name F I B   (D_isol_scope = "1 1 1" per synth_one.tcl in RESULTS.md)
if [ -n "${CONFIGS:-}" ]; then
  IFS=',' read -ra CONFIGS <<< "$CONFIGS"
else
  CONFIGS=("A_baseline 0 0 0" "B_fusion_only 1 0 0" "C_isol_only 0 1 0"
           "D_proposed 1 1 0" "D_isol_scope_ablation 1 1 1")
fi
# NOT true seeds: OpenROAD placement is deterministic. These perturb the
# physical flow (utilization, placement density addon) to sample P&R variation.
if [ -n "${PERTURBS:-}" ]; then
  IFS=',' read -ra PERTURBS <<< "$PERTURBS"
else
  PERTURBS=("40 0.00" "40 0.05" "42 0.00" "42 0.05" "44 0.00" "44 0.05"
            "46 0.00" "46 0.05" "38 0.00" "38 0.05")
fi

prep() {  # one source tree per config
  local name=$1 f=$2 i=$3 b=$4 d=$OUT/cfg/$1
  mkdir -p "$d"
  cp "$RTL_DIR"/*.sv "$d"/
  sed -e "s/@MEMHEX@/$MEMHEX/" -e "s/@F@/$f/" -e "s/@I@/$i/" -e "s/@B@/$b/" \
      "$RTL_DIR/core_top_synth_wrapper_sv.tmpl" > "$d/core_top_synth_wrapper.sv"
  # truncate hex to the shrunk memory and make the path absolute for yosys
  head -n $((MEM_BYTES/4)) "$HEX" > "$d/imem_init.hex"
  sed -i "s#\"imem_init.hex\"#\"$d/imem_init.hex\"#g" "$d/core_top_pipelined.sv"
  cat > "$d/constraint.sdc" <<SDC
create_clock -name clk -period $PERIOD [get_ports clk]
set_input_delay  [expr $PERIOD*0.2] -clock clk [get_ports rst_n]
set_output_delay [expr $PERIOD*0.2] -clock clk [all_outputs]
SDC
}

run_one() {
  local name=$1 util=$2 pd=$3 d=$OUT/cfg/$1 tag="u${2}_pd${3}"
  cat > "$d/config_$tag.mk" <<MK
export DESIGN_NAME        = core_top_synth_wrapper
export DESIGN_NICKNAME    = $name
export PLATFORM           = nangate45
export VERILOG_FILES      = $(ls $d/*.sv | tr '\n' ' ')
export SDC_FILE           = $d/constraint.sdc
export CORE_UTILIZATION   = $util
export PLACE_DENSITY_LB_ADDON = $pd
export SYNTH_MEMORY_MAX_BITS  = 65536
MK
  ( cd "$ORFS_FLOW" && make DESIGN_CONFIG="$d/config_$tag.mk" FLOW_VARIANT="$tag" \
      > "$d/run_$tag.log" 2>&1 ) && echo "ok   $name $tag" || echo "FAIL $name $tag"
}
export -f run_one; export OUT PERIOD ORFS_FLOW LEC_CHECK QT_QPA_PLATFORM

for c in "${CONFIGS[@]}"; do read -r n f i b <<<"$c"; prep "$n" "$f" "$i" "$b"; done

for c in "${CONFIGS[@]}"; do read -r n _ <<<"$c"
  for p in "${PERTURBS[@]}"; do read -r u pd <<<"$p"; echo "$n $u $pd"; done
done | xargs -P "$JOBS" -L1 bash -c 'run_one "$0" "$1" "$2"'

python3 "$(dirname "$0")/summarize.py" "$ORFS_FLOW" "$OUT/results.csv"
