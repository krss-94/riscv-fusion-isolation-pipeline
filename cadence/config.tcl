#############################################################################
# config.tcl -- shared settings, sourced by every stage script.
# This is the ONLY file you should need to edit at the lab.
#
# Everything marked  <<< CHECK  is a guess at GPDK045's usual file/layer
# names. Run 00_discover_gpdk.sh at the lab, paste its output to Claude,
# and these get filled in exactly.
#############################################################################

# ---- which ablation config (override from shell: CONFIG=D_proposed) ------
if {[info exists ::env(CONFIG)]} { set CONFIG $::env(CONFIG) } else { set CONFIG "D_proposed" }

# FUSION_EN / ISOL_EN / BR_CMP_EN per config (same mapping as the README /
# Vivado flow: D_proposed = 1 1 0, D_isol_scope_ablation = 1 1 1)
array set CFG_FUSION {A_baseline 0 B_fusion_only 1 C_isol_only 0 D_proposed 1 D_isol_scope_ablation 1}
array set CFG_ISOL   {A_baseline 0 B_fusion_only 0 C_isol_only 1 D_proposed 1 D_isol_scope_ablation 1}
array set CFG_BRCMP  {A_baseline 0 B_fusion_only 0 C_isol_only 0 D_proposed 0 D_isol_scope_ablation 1}
if {![info exists CFG_FUSION($CONFIG)]} { error "Unknown CONFIG '$CONFIG'" }

set TOP       "core_top_pipelined"
set RTL_DIR   "../rtl"               ;# scripts are run from the cadence/ dir
set OUT       "out/$CONFIG"
set RPT       "reports/$CONFIG"

# ---- design targets ------------------------------------------------------
set CLK_PERIOD 18.0      ;# ns. Same as the Vivado runs, so results compare.
                         ;# 45nm cells are far faster than FPGA LUT fabric --
                         ;# once a clean 18ns pass works, sweep this down.
set CORE_UTIL  0.50      ;# floorplan utilization; lower = easier routing
set NUM_CPUS   8

# ---- GPDK045 locations ---------------------------------------------------
set PDK_ROOT    "/CHANGE/ME"                         ;# <<< CHECK (from discover output)
set STDCELL_DIR "$PDK_ROOT/gsclib045"                ;# <<< CHECK

# Liberty: slow corner for setup / synthesis, fast corner for hold
set LIB_SLOW    "$STDCELL_DIR/timing/slow_vdd1v0_basicCells.lib"   ;# <<< CHECK
set LIB_FAST    "$STDCELL_DIR/timing/fast_vdd1v2_basicCells.lib"   ;# <<< CHECK

set LEF_TECH    "$STDCELL_DIR/lef/gsclib045_tech.lef"              ;# <<< CHECK
set LEF_MACRO   "$STDCELL_DIR/lef/gsclib045_macro.lef"             ;# <<< CHECK

# Parasitic extraction tech files (QRC). If your PDK ships a .CapTbl file
# instead of qrcTechFile, tell Claude -- mmmc.tcl needs a 3-line change.
set QRC_WORST   "$PDK_ROOT/qrc/rcworst/qrcTechFile"                ;# <<< CHECK
set QRC_BEST    "$PDK_ROOT/qrc/rcbest/qrcTechFile"                 ;# <<< CHECK

# ---- physical-design details (from the tech LEF) -------------------------
set SITE        "CoreSite"                                         ;# <<< CHECK
set PWR_H       "Metal10"    ;# horizontal power ring / stripe layer  <<< CHECK
set PWR_V       "Metal11"    ;# vertical power ring / stripe layer    <<< CHECK
set ROUTE_TOP   11           ;# top routing layer number              <<< CHECK
set FILLER_CELLS "FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"    ;# <<< CHECK
