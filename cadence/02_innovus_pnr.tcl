#############################################################################
# 02_innovus_pnr.tcl -- Cadence Innovus: floorplan -> place -> CTS -> route
#
# Run from the cadence/ directory, AFTER 01_genus_synth.tcl for the same
# CONFIG:
#   CONFIG=D_proposed innovus -nowin -files 02_innovus_pnr.tcl -log logs/innovus_D_proposed
#
# Full-size design, so expect a long run and high memory use. First time
# through, consider running only up to floorplan (comment out from
# "place_design" onward) to confirm the design loads and fits.
#
# NOT RUN BY CLAUDE. Paste any error message back.
#############################################################################

source ./config.tcl
file mkdir $OUT $RPT logs

# ---------------------------------------------------------------------
# 1. Load design (classic init flow)
# ---------------------------------------------------------------------
set init_verilog   $OUT/$TOP.v
set init_top_cell  $TOP
set init_lef_file  [list $LEF_TECH $LEF_MACRO]
set init_mmmc_file ./mmmc.tcl
set init_pwr_net   VDD
set init_gnd_net   VSS
init_design

setMultiCpuUsage -localCpu $NUM_CPUS

# ---------------------------------------------------------------------
# 2. Floorplan + power grid
# ---------------------------------------------------------------------
floorPlan -site $SITE -r 1.0 $CORE_UTIL 10 10 10 10

addRing -nets {VDD VSS} -type core_rings -follow core \
    -layer [list top $PWR_H bottom $PWR_H left $PWR_V right $PWR_V] \
    -width 2 -spacing 1 -offset 1

addStripe -nets {VDD VSS} -layer $PWR_V -direction vertical \
    -width 1 -spacing 1 -set_to_set_distance 40 -start_from left

sroute -nets {VDD VSS}

# ---------------------------------------------------------------------
# 3. Placement
# ---------------------------------------------------------------------
place_design
optDesign -preCTS

# ---------------------------------------------------------------------
# 4. Clock tree
# ---------------------------------------------------------------------
ccopt_design
optDesign -postCTS
optDesign -postCTS -hold

# ---------------------------------------------------------------------
# 5. Routing
# ---------------------------------------------------------------------
setNanoRouteMode -routeBottomRoutingLayer 1
setNanoRouteMode -routeTopRoutingLayer $ROUTE_TOP
routeDesign
setExtractRCMode -engine postRoute
optDesign -postRoute
optDesign -postRoute -hold

# fillers (cell names are PDK-specific; wrapped so a wrong name doesn't kill the run)
catch {addFiller -cell $FILLER_CELLS}

# ---------------------------------------------------------------------
# 6. Checks + reports
# ---------------------------------------------------------------------
catch {verify_drc -report $RPT/drc.rpt}
catch {verifyConnectivity -type all -report $RPT/connectivity.rpt}

timeDesign -postRoute       -outDir $RPT/timing_setup
timeDesign -postRoute -hold -outDir $RPT/timing_hold
report_power -outfile $RPT/power_vectorless.rpt   ;# NOT comparable to Vivado SAIF power
summaryReport -noHtml -outfile $RPT/summary.rpt

# ---------------------------------------------------------------------
# 7. Export (for Tempus and for the record)
# ---------------------------------------------------------------------
extractRC
rcOut -spef $OUT/${TOP}_postroute.spef
saveNetlist $OUT/${TOP}_postroute.v
defOut -floorplan -netlist -routing $OUT/${TOP}_postroute.def
catch {write_sdc $OUT/${TOP}_postroute.sdc}
saveDesign $OUT/${TOP}_postroute.enc

puts "Innovus done: results in $OUT/, reports in $RPT/"
exit
