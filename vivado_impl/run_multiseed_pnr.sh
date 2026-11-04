#!/usr/bin/env bash
# Multi-seed PnR variance analysis for RISC-V Fusion/Isolation Pipeline
# Runs place-and-route with multiple seeds to characterize timing/power variance

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
VIVADO="${VIVADO:-vivado}"

# Configurations to test (same as ablation study)
CONFIGS=(
    "0 0 0 A_baseline"
    "1 0 0 B_fusion_only"
    "0 1 0 C_isol_only"
    "1 1 0 D_proposed"
    "1 1 1 D_isol_scope_ablation"
)

# Number of seeds per config
N_SEEDS="${N_SEEDS:-10}"

# Base seed (will increment for each run)
BASE_SEED="${BASE_SEED:-42}"

# Output directory
OUT_DIR="${OUT_DIR:-${REPO_ROOT}/vivado_impl/multiseed_results}"
mkdir -p "${OUT_DIR}"

echo "=========================================="
echo "Multi-Seed PnR Variance Analysis"
echo "=========================================="
echo "Configs: ${#CONFIGS[@]}"
echo "Seeds per config: ${N_SEEDS}"
echo "Output: ${OUT_DIR}"
echo ""

# Function to run single PnR
run_pnr() {
    local fusion_en=$1
    local isol_en=$2
    local br_cmp_en=$3
    local config_name=$4
    local seed=$5
    local run_dir="${OUT_DIR}/${config_name}_seed${seed}"
    
    mkdir -p "${run_dir}"
    
    echo "  [${config_name}] Seed ${seed}..."
    
    # Generate TCL script with seed
    cat > "${run_dir}/run_pnr.tcl" <<EOF
set_param general.maxThreads 8
set_param place.enableMultiThreading 1
set_param route.enableMultiThreading 1

open_project ${run_dir}/${config_name}.xpr

# Synthesis
read_verilog -sv \\
    ${REPO_ROOT}/rtl/alu.sv \\
    ${REPO_ROOT}/rtl/imm_gen.sv \\
    ${REPO_ROOT}/rtl/regfile.sv \\
    ${REPO_ROOT}/rtl/regfile_pipelined.sv \\
    ${REPO_ROOT}/rtl/decoder.sv \\
    ${REPO_ROOT}/rtl/muldiv_iter.sv \\
    ${REPO_ROOT}/rtl/pipeline_regs.sv \\
    ${REPO_ROOT}/rtl/hazard_unit.sv \\
    ${REPO_ROOT}/rtl/trap_unit.sv \\
    ${REPO_ROOT}/rtl/csr_file.sv \\
    ${REPO_ROOT}/rtl/isol_gate.sv \\
    ${REPO_ROOT}/rtl/muldiv.sv \\
    ${REPO_ROOT}/rtl/core_top_pipelined.sv

synth_design -top core_top_pipelined -part xc7a100tcsg324-1 \
    -generic "FUSION_EN=${fusion_en}" \
    -generic "ISOL_EN=${isol_en}" \
    -generic "BR_CMP_EN=${br_cmp_en}"

# Place & Route with specific seed
place_design -seed ${seed}
route_design -seed ${seed}

# Timing analysis
report_timing_summary -file ${run_dir}/timing_summary.rpt
report_clock_utilization -file ${run_dir}/clock_util.rpt
report_utilization -file ${run_dir}/utilization.rpt

# Power analysis (requires SAIF)
# report_power -file ${run_dir}/power.rpt

# Save checkpoint
write_checkpoint -force ${run_dir}/${config_name}_seed${seed}.dcp

close_project
EOF
    
    cd "${run_dir}"
    if ${VIVADO} -mode batch -source run_pnr.tcl -log "${run_dir}/vivado.log" -jou "${run_dir}/vivado.jou" 2>&1 | tail -20; then
        # Extract WNS from timing summary
        wns=$(grep -A2 "Worst Negative Slack" "${run_dir}/timing_summary.rpt" 2>/dev/null | tail -1 | awk '{print $NF}' || echo "N/A")
        echo "    WNS: ${wns}"
        echo "${config_name},${seed},${wns}" >> "${OUT_DIR}/wns_summary.csv"
        return 0
    else
        echo "    FAILED"
        echo "${config_name},${seed},FAIL" >> "${OUT_DIR}/wns_summary.csv"
        return 1
    fi
}

# Initialize summary CSV
echo "config,seed,wns_ns" > "${OUT_DIR}/wns_summary.csv"

# Run all configs with all seeds
seed=${BASE_SEED}
for config in "${CONFIGS[@]}"; do
    read -r fusion_en isol_en br_cmp_en config_name <<< "${config}"
    
    echo "Config: ${config_name} (FUSION_EN=${fusion_en} ISOL_EN=${isol_en} BR_CMP_EN=${br_cmp_en})"
    
    for i in $(seq 1 ${N_SEEDS}); do
        run_pnr ${fusion_en} ${isol_en} ${br_cmp_en} ${config_name} ${seed}
        seed=$((seed + 1))
    done
    echo ""
done

# Generate summary statistics
echo "=========================================="
echo "Summary Statistics"
echo "=========================================="

python3 <<EOF
import pandas as pd
import numpy as np

df = pd.read_csv("${OUT_DIR}/wns_summary.csv")
df['wns_ns'] = pd.to_numeric(df['wns_ns'], errors='coerce')

print("\nWNS Statistics by Config (ns):")
print(df.groupby('config')['wns_ns'].agg(['count', 'mean', 'std', 'min', 'max']).round(3))

print("\nVariance Analysis:")
for config in df['config'].unique():
    subset = df[df['config'] == config]['wns_ns'].dropna()
    if len(subset) > 1:
        cv = subset.std() / subset.mean() * 100
        print(f"  {config}: mean={subset.mean():.3f}ns, std={subset.std():.3f}ns, CV={cv:.1f}%")

# Save detailed stats
df.groupby('config')['wns_ns'].agg(['count', 'mean', 'std', 'min', 'max']).round(3).to_csv("${OUT_DIR}/wns_stats.csv")
print(f"\nDetailed stats saved to ${OUT_DIR}/wns_stats.csv")
EOF

echo ""
echo "=========================================="
echo "Multi-seed PnR complete!"
echo "Results: ${OUT_DIR}"
echo "=========================================="