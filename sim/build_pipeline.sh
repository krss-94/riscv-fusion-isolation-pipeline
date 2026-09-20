#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

FUSION_EN="${1:-1}"
ISOL_EN="${2:-1}"
BR_CMP_EN="${3:-0}"
CFG_NAME="${4:-sim_pipeline}"

SIM_BIN="$(cd .. && pwd)/${CFG_NAME}"
SIM_BAK="$(cd .. && pwd)/${CFG_NAME}.bak"
OBJ_DIR="obj_dir_pipeline_${CFG_NAME}"
MK="Vcore_top_pipelined.mk"

echo "==> Config: FUSION_EN=$FUSION_EN ISOL_EN=$ISOL_EN BR_CMP_EN=$BR_CMP_EN -> $SIM_BIN"

echo "==> [1/5] Backing up existing binary (if present)"
if [[ -x "$SIM_BIN" ]]; then
    cp "$SIM_BIN" "$SIM_BAK"
    chmod +x "$SIM_BAK"
else
    echo "    no existing $SIM_BIN, skipping backup"
fi

echo "==> [2/5] Verilating RTL"
verilator --cc ../rtl/alu.sv ../rtl/imm_gen.sv ../rtl/regfile.sv \
    ../rtl/regfile_pipelined.sv ../rtl/decoder.sv ../rtl/muldiv_iter.sv \
    ../rtl/pipeline_regs.sv ../rtl/hazard_unit.sv ../rtl/trap_unit.sv \
    ../rtl/csr_file.sv ../rtl/isol_gate.sv ../rtl/core_top_pipelined.sv \
    --top-module core_top_pipelined -Wall -Wno-UNUSEDSIGNAL \
    -Wno-DECLFILENAME --exe tb_pipeline.cpp -CFLAGS "-std=c++14" \
    -GFUSION_EN="$FUSION_EN" -GISOL_EN="$ISOL_EN" -GBR_CMP_EN="$BR_CMP_EN" \
    --trace-saif --trace-structs \
    --Mdir "$OBJ_DIR" -o "$SIM_BIN"

echo "==> [3/5] Confirming the real link target exists in the generated Makefile"
if ! grep -q "^$(printf %s "$SIM_BIN" | sed 's/[.[\*^$]/\\&/g'):" "$OBJ_DIR/$MK"; then
    echo "!! ERROR: $OBJ_DIR/$MK has no '$SIM_BIN:' target." >&2
    exit 1
fi

echo "==> [4/5] Building with corrected target + lld linker"
CCACHE_DISABLE=1 make -C "$OBJ_DIR" -f "$MK" "$SIM_BIN" LINK="g++ -fuse-ld=lld"

echo "==> [5/5] Sanity-checking the built binary"
chmod +x "$SIM_BIN"
FILE_OUT="$(file "$SIM_BIN")"
echo "    file: $FILE_OUT"
if [[ "$FILE_OUT" != *"ELF"* || "$FILE_OUT" != *"executable"* ]]; then
    echo "!! ERROR: $SIM_BIN not a working ELF." >&2
    exit 1
fi
echo "==> Build OK: $SIM_BIN"
