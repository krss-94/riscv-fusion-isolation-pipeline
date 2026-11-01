#############################################################################
# 03_tempus_signoff.tcl -- Cadence Tempus, post-route timing on the Innovus
# netlist + extracted parasitics.
#
# Run LAST, after Innovus works:
#   CONFIG=D_proposed tempus -no_gui -files 03_tempus_signoff.tcl -log logs/tempus_D_proposed
#
# Lowest-confidence of the three scripts (Tempus setup varies most between
# versions). If Innovus's own timeDesign reports are enough for the paper,
# this can wait. Innovus writes SPEF per RC corner, so file names carry the
# corner name -- the glob below picks them up; if it finds nothing, run
# `ls out/<config>` and paste the listing back.
#############################################################################

source ./config.tcl
file mkdir $RPT logs

read_mmmc ./mmmc.tcl
read_physical -lef [list $LEF_TECH $LEF_MACRO]
read_netlist $OUT/${TOP}_postroute.v
init_design

foreach {rc} {rc_worst rc_best} {
    set spef [lindex [glob -nocomplain $OUT/*${rc}*.spef*] 0]
    if {$spef eq ""} { set spef [lindex [glob -nocomplain $OUT/*.spef*] 0] }
    if {$spef eq ""} { error "No SPEF found in $OUT for $rc" }
    read_spef -rc_corner $rc $spef
}

report_timing -max_paths 20 > $RPT/tempus_setup.rpt
report_timing -early -max_paths 20 > $RPT/tempus_hold.rpt
report_constraint -all_violators > $RPT/tempus_violators.rpt
report_analysis_coverage > $RPT/tempus_coverage.rpt

puts "Tempus done: reports in $RPT/"
exit
