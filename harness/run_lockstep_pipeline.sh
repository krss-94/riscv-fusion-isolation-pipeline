#!/bin/bash
set -u
export TB_TRACE=1
SPIKE=$HOME/ooo/spike-src/build/spike
SIM=${1:-${SIM:-$HOME/ooo/sim_pipeline}}
case "$SIM" in
    /*) ;;
    *) SIM="$PWD/$SIM" ;;
esac
GCC=riscv32-unknown-elf-gcc
OBJCOPY=riscv32-unknown-elf-objcopy
LD=$HOME/ooo/sw/boot/link_spike.ld
OUT=${OUT:-$HOME/ooo/harness/out_pipeline}
mkdir -p "$OUT"

TESTDIRS="$HOME/ooo/sw/test/stage2 $HOME/ooo/sw/test/stage2_random $HOME/ooo/sw/test/stage2_random_cf $HOME/ooo/sw/test/stage5_only"
# Tests that read HPM counters or CSR reset state Spike doesn't model
# (Part 10 §6 scope boundary) -- excluded from lockstep diff, checked
# standalone instead via expected register values below.
STANDALONE_ONLY="t_fusion_idiom4_neg t_fusion_idiom4_beq_nottaken t_fusion_idiom4_redirect_trap t_fusion_idiom4_pos t_fusion_idiom3_pos t_csr_basic t_hpm_isol t_fusion_idiom1_pos t_fusion_idiom2_pos t_fusion_idiom1_neg_bound t_fusion_idiom1_haz_decline t_fusion_idiom1_redirect_trap t_trap_during_muldiv_stall t_fusion_muldiv_isol_branch t_fusion_idiom5_pos"
SPIKE_REAL_INSTR_COUNT=200
SPIKE_BOOTROM_OVERHEAD=5
RTL_CYCLES=3000

PASS=0; FAIL=0; FAILED_TESTS=""

for f in $(for d in $TESTDIRS; do ls "$d"/*.s; done); do
    name=$(basename "$f" .s)
    elf="$OUT/$name.elf"
    bin="$OUT/$name.bin"

    $GCC -march=rv32im_zicsr -mabi=ilp32 -nostartfiles -nostdlib -static \
        -T "$LD" "$f" -o "$elf" 2>"$OUT/$name.gcc.log"
    if [ $? -ne 0 ]; then
        echo "BUILD FAIL: $name"; cat "$OUT/$name.gcc.log"; FAIL=$((FAIL+1)); continue
    fi
    $OBJCOPY -O binary "$elf" "$bin"

    $SPIKE --isa=rv32im_zicsr_zicclsm -m0x80000000:0x1000000 \
        --instructions=$((SPIKE_REAL_INSTR_COUNT + SPIKE_BOOTROM_OVERHEAD)) \
        -l --log-commits "$elf" 2>"$OUT/$name.spike.raw"
    "$SIM" "$bin" $RTL_CYCLES > "$OUT/$name.rtl.raw" 2>/dev/null
    sync

    python3 "$HOME/ooo/harness/spike_normalize.py" "$OUT/$name.spike.raw" | sort > "$OUT/$name.spike.norm"

    python3 "$HOME/ooo/harness/spike_normalize.py" "$OUT/$name.rtl.raw" | sort > "$OUT/$name.rtl.norm"

    if echo "$STANDALONE_ONLY" | grep -qw "$name"; then
        echo "SKIP-LOCKSTEP (standalone-only, see harness/standalone_checks.sh): $name"
        continue
    fi
    if diff -q "$OUT/$name.spike.norm" "$OUT/$name.rtl.norm" > /dev/null; then
        echo "PASS: $name"
        PASS=$((PASS+1))
    else
        echo "FAIL: $name"
        diff "$OUT/$name.spike.norm" "$OUT/$name.rtl.norm"
        FAIL=$((FAIL+1))
        FAILED_TESTS="$FAILED_TESTS $name"
    fi
done

echo "=== TOTAL PASS=$PASS FAIL=$FAIL ==="
echo "Failed:$FAILED_TESTS"
