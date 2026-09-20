#!/bin/bash
set -u
SIM=${SIM:-$HOME/ooo/sim_pipeline}
OUT=${OUT:-$HOME/ooo/harness/out_pipeline}
PASS=0; FAIL=0

getreg() {
    # $1=name $2=regnum, returns last committed value for that reg
    "$SIM" "$OUT/$1.bin" 3000 2>/dev/null | grep "^core" | awk -v r="$2" '$6==r{v=$7} END{print v}'
}

check_eq() {
    local name=$1 reg=$2 exp=$3
    got=$(getreg "$name" "$reg")
    if [ "$got" == "$exp" ]; then echo "  OK $name.$reg = $got"; else
        echo "  MISMATCH $name.$reg expected $exp got $got"; FAILFLAG=1; fi
}

check_unwritten() {
    # Asserts register $2 has no commit-log write for test $1 at all --
    # distinct from check_eq's 0x0 case, since getreg returns empty (not
    # "0x00000000") for a register that was never written.
    local name=$1 reg=$2
    got=$(getreg "$name" "$reg")
    if [ -z "$got" ]; then echo "  OK $name.$reg never written (expected)"; else
        echo "  MISMATCH $name.$reg expected no write but got $got"; FAILFLAG=1; fi
}

echo "-- t_fusion_idiom1_pos --"
FAILFLAG=0
check_eq t_fusion_idiom1_pos x10 0x00000000
check_eq t_fusion_idiom1_pos x11 0x00000001
check_eq t_fusion_idiom1_pos x12 0x00000002
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_idiom2_pos --"
FAILFLAG=0
check_eq t_fusion_idiom2_pos x10 0x00000000
check_eq t_fusion_idiom2_pos x11 0x00000001
check_eq t_fusion_idiom2_pos x12 0x00000002
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_idiom4_pos --"
FAILFLAG=0
check_eq t_fusion_idiom4_pos x10 0x00000000
check_eq t_fusion_idiom4_pos x11 0x00000001
check_eq t_fusion_idiom4_pos x5  0x00000001
check_eq t_fusion_idiom4_pos x20 0x00000001
check_unwritten t_fusion_idiom4_pos x8
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_idiom4_neg --"
FAILFLAG=0
check_eq t_fusion_idiom4_neg x10 0x00000000
check_eq t_fusion_idiom4_neg x11 0x00000000
check_eq t_fusion_idiom4_neg x5  0x00000001
check_eq t_fusion_idiom4_neg x22 0x000000aa
check_unwritten t_fusion_idiom4_neg x8
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_idiom4_beq_nottaken --"
FAILFLAG=0
check_eq t_fusion_idiom4_beq_nottaken x10 0x00000000
check_eq t_fusion_idiom4_beq_nottaken x11 0x00000001
check_eq t_fusion_idiom4_beq_nottaken x5  0x00000001
check_eq t_fusion_idiom4_beq_nottaken x22 0x000000bb
check_unwritten t_fusion_idiom4_beq_nottaken x8
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_idiom4_redirect_trap --"
FAILFLAG=0
check_eq t_fusion_idiom4_redirect_trap x10 0x00000000
check_eq t_fusion_idiom4_redirect_trap x11 0x00000000
check_unwritten t_fusion_idiom4_redirect_trap x5
check_unwritten t_fusion_idiom4_redirect_trap x6
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_idiom5_pos --"
FAILFLAG=0
check_eq t_fusion_idiom5_pos x10 0x00000000
check_eq t_fusion_idiom5_pos x11 0x00000002
check_eq t_fusion_idiom5_pos x5 0x80010000
check_eq t_fusion_idiom5_pos x7 0xcafebabe
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_idiom3_pos --"
FAILFLAG=0
check_eq t_fusion_idiom3_pos x10 0x00000000
check_eq t_fusion_idiom3_pos x11 0x00000001
check_eq t_fusion_idiom3_pos x5 0x80000004
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_idiom1_neg_bound --"
FAILFLAG=0
check_eq t_fusion_idiom1_neg_bound x10 0x00000000
check_eq t_fusion_idiom1_neg_bound x11 0x00000000
check_eq t_fusion_idiom1_neg_bound x12 0x00000001
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_hpm_isol --"
FAILFLAG=0
check_eq t_hpm_isol x3 0x0000002a   # 6*7=42
check_eq t_hpm_isol x6 0x00004e20   # 100*200=20000
check_eq t_hpm_isol x9 0x0000000c   # 3*4=12
check_eq t_hpm_isol x10 0x00000001
check_eq t_hpm_isol x12 0x00000002
check_eq t_hpm_isol x14 0x00000003
N=$(getreg t_hpm_isol x11); M=$(getreg t_hpm_isol x13); P=$(getreg t_hpm_isol x15)
Nd=$((16#${N#0x})); Md=$((16#${M#0x})); Pd=$((16#${P#0x}))
if [ "$Nd" -lt "$Md" ] && [ "$Md" -lt "$Pd" ]; then
    echo "  OK t_hpm_isol idle-cycle count strictly increasing: $N < $M < $P"
else
    echo "  MISMATCH t_hpm_isol idle-cycle count not strictly increasing: $N $M $P"; FAILFLAG=1
fi
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_idiom1_haz_decline --"
FAILFLAG=0
check_eq t_fusion_idiom1_haz_decline x10 0x00000000
check_eq t_fusion_idiom1_haz_decline x1 0x12345678
check_eq t_fusion_idiom1_haz_decline x11 0x00000000
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_idiom1_redirect_trap --"
FAILFLAG=0
check_eq t_fusion_idiom1_redirect_trap x10 0x00000000
check_eq t_fusion_idiom1_redirect_trap x11 0x00000000
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_trap_during_muldiv_stall --"
FAILFLAG=0
check_eq t_trap_during_muldiv_stall x20 0x8000000c
check_eq t_trap_during_muldiv_stall x21 0x00000002
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_csr_basic --"
FAILFLAG=0
check_eq t_csr_basic x2 0x00000000
check_eq t_csr_basic x3 0x12345678
check_eq t_csr_basic x5 0x00000000
check_eq t_csr_basic x7 0x0000000f
check_eq t_csr_basic x9 0x80001000
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "-- t_fusion_muldiv_isol_branch --"
FAILFLAG=0
check_eq t_fusion_muldiv_isol_branch x4  0x0000002a
N=$(getreg t_fusion_muldiv_isol_branch x10)
M=$(getreg t_fusion_muldiv_isol_branch x11)
P=$(getreg t_fusion_muldiv_isol_branch x12)
Nd=$((16#${N#0x})); Md=$((16#${M#0x})); Pd=$((16#${P#0x}))
if [ "$Nd" -le "$Md" ] && [ "$Md" -le "$Pd" ]; then
    echo "  OK t_fusion_muldiv_isol_branch isol count non-decreasing across window: $N <= $M <= $P"
else
    echo "  MISMATCH t_fusion_muldiv_isol_branch isol count not monotonic: $N $M $P"; FAILFLAG=1
fi
[ $FAILFLAG -eq 0 ] && PASS=$((PASS+1)) || FAIL=$((FAIL+1))

echo "=== STANDALONE PASS=$PASS FAIL=$FAIL ==="
