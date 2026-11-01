#!/bin/bash
# Run this at the lab (Linux shell, same place you'll launch the tools).
#   bash 00_discover_gpdk.sh 2>&1 | tee discover.txt
# Then paste discover.txt back to Claude -- it fills in config.tcl exactly.

echo "=== tools on PATH ==="
which genus innovus tempus 2>&1
echo
echo "=== cadence/pdk related env vars ==="
env | grep -i -E "cds|cadence|pdk|gpdk|gsclib" | head -30
echo

# likely install roots -- only search the ones that exist (keeps it fast)
roots=""
for r in /cadence /opt /usr/local /apps /tools /eda /pdk /mnt /net /home /data /software; do
  [ -d "$r" ] && roots="$roots $r"
done
echo "=== searching:$roots ==="

echo
echo "=== gsclib045 / gpdk045 directories ==="
timeout 180 find $roots -maxdepth 8 -type d \( -iname "gsclib045*" -o -iname "gpdk045*" \) 2>/dev/null | head -40

echo
echo "=== liberty timing files (gsclib045) ==="
timeout 180 find $roots -maxdepth 9 -type f -iname "*.lib" -path "*045*" 2>/dev/null | head -40

echo
echo "=== LEF files (gsclib045) ==="
timeout 180 find $roots -maxdepth 9 -type f -iname "*.lef" -path "*045*" 2>/dev/null | head -40

echo
echo "=== QRC tech files / cap tables (045) ==="
timeout 180 find $roots -maxdepth 9 -type f \( -iname "qrcTechFile*" -o -iname "*.captbl" \) -path "*045*" 2>/dev/null | head -40

# pull site + layer names straight out of the tech LEF
techlef=$(timeout 180 find $roots -maxdepth 9 -type f -iname "*tech*.lef" -path "*045*" 2>/dev/null | head -1)
if [ -n "$techlef" ]; then
  echo
  echo "=== SITE / LAYER names in $techlef ==="
  grep -E "^\s*SITE |^\s*LAYER " "$techlef" | sort -u | head -60
fi

# filler cell names from the macro LEF
macrolef=$(timeout 180 find $roots -maxdepth 9 -type f -iname "*macro*.lef" -path "*045*" 2>/dev/null | head -1)
if [ -n "$macrolef" ]; then
  echo
  echo "=== FILL cells in $macrolef ==="
  grep -E "^\s*MACRO\s+FILL" "$macrolef" | sort -u
fi
echo
echo "=== done -- paste everything above back to Claude ==="
