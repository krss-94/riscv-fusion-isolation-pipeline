#!/bin/bash
set -u
SPIKE=$HOME/ooo/spike-src/build/spike
SIM=$HOME/ooo/sim_core
GCC=riscv32-unknown-elf-gcc
OBJCOPY=riscv32-unknown-elf-objcopy
LD=$HOME/ooo/sw/boot/link_spike.ld
TESTDIRS="$HOME/ooo/sw/test/stage2 $HOME/ooo/sw/test/stage2_random $HOME/ooo/sw/test/stage2_random_cf"
OUT=$HOME/ooo/harness/out
mkdir -p "$OUT"

INSTR_COUNT=200
SPIKE_BOOTROM_OVERHEAD=5
PASS=0; FAIL=0

for f in $(for d in $TESTDIRS; do ls "$d"/*.s; done); do
    name=$(basename "$f" .s)
    elf="$OUT/$name.elf"
    bin="$OUT/$name.bin"
    $GCC -march=rv32im_zicsr -mabi=ilp32 -nostartfiles -nostdlib -static -T "$LD" "$f" -o "$elf" 2>"$OUT/$name.gcc.log"
    if [ $? -ne 0 ]; then echo "BUILD FAIL: $name"; cat "$OUT/$name.gcc.log"; FAIL=$((FAIL+1)); continue; fi
    $OBJCOPY -O binary "$elf" "$bin"

    $SPIKE --isa=rv32im_zicsr -m0x80000000:0x1000000 --instructions=$((INSTR_COUNT + SPIKE_BOOTROM_OVERHEAD)) -l --log-commits "$elf" 2>"$OUT/$name.spike.raw"
    "$SIM" "$bin" $INSTR_COUNT > "$OUT/$name.rtl.raw" 2>&1

    awk '/^core   0: 0x80000000 \(/{f=1} f' "$OUT/$name.spike.raw" | \
        awk '{if ($0==prev) exit; print; prev=$0}' | \
        grep -oE '(x[0-9]+ +0x[0-9a-f]+|mem 0x[0-9a-f]+ 0x[0-9a-f]+)' | tr -s ' ' | \
        awk '{ if ($1=="mem") printf "mem %s 0x%x\n", $2, strtonum($3); else printf "%s 0x%x\n", $1, strtonum($2) }' > "$OUT/$name.spike.norm"
    awk '{if ($0==prev) exit; print; prev=$0}' "$OUT/$name.rtl.raw" | \
        grep -oE '(x[0-9]+ +0x[0-9a-f]+|mem 0x[0-9a-f]+ 0x[0-9a-f]+)' | tr -s ' ' | \
        awk '{ if ($1=="mem") printf "mem %s 0x%x\n", $2, strtonum($3); else printf "%s 0x%x\n", $1, strtonum($2) }' > "$OUT/$name.rtl.norm"

    if diff -q "$OUT/$name.spike.norm" "$OUT/$name.rtl.norm" > /dev/null; then
        echo "PASS: $name"
        PASS=$((PASS+1))
    else
        echo "FAIL: $name"
        diff "$OUT/$name.spike.norm" "$OUT/$name.rtl.norm"
        FAIL=$((FAIL+1))
    fi
done

echo "=== TOTAL PASS=$PASS FAIL=$FAIL ==="
