#!/bin/bash
set -u
cd "$HOME/ooo"

declare -A CONFIGS=(
  [A_baseline]="0 0 0"
  [B_fusion_only]="1 0 0"
  [C_isol_only]="0 1 0"
  [D_proposed]="1 1 0"
  [D_isol_scope_ablation]="0 1 1"
)

SUMMARY=""

for cfg in "${!CONFIGS[@]}"; do
    read -r fusion isol brcmp <<< "${CONFIGS[$cfg]}"
    echo "=================================================="
    echo "=== Config: $cfg (FUSION_EN=$fusion ISOL_EN=$isol BR_CMP_EN=$brcmp) ==="
    echo "=================================================="

    if ! ./sim/build_pipeline.sh "$fusion" "$isol" "$brcmp" "sim_pipeline_${cfg}" \
        > "harness/build_${cfg}.log" 2>&1; then
        echo "BUILD FAILED for $cfg, see harness/build_${cfg}.log"
        SUMMARY="${SUMMARY}
$cfg: BUILD FAILED"
        continue
    fi

    SIM="$HOME/ooo/sim_pipeline_${cfg}" OUT="$HOME/ooo/harness/out_pipeline_${cfg}" \
        ./harness/run_lockstep_pipeline.sh > "harness/lockstep_${cfg}.log" 2>&1
    LOCKSTEP_RESULT=$(tail -2 "harness/lockstep_${cfg}.log")

    SIM="$HOME/ooo/sim_pipeline_${cfg}" OUT="$HOME/ooo/harness/out_pipeline_${cfg}" \
        ./harness/standalone_checks.sh > "harness/standalone_${cfg}.log" 2>&1
    MISMATCHES=$(grep -c "MISMATCH" "harness/standalone_${cfg}.log" || true)

    SUMMARY="${SUMMARY}
$cfg:
  $LOCKSTEP_RESULT
  standalone mismatches: $MISMATCHES"
done

echo ""
echo "======= FINAL SUMMARY ======="
echo "$SUMMARY"
