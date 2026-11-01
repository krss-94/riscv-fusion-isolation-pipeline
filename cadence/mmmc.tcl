#############################################################################
# mmmc.tcl -- multi-mode multi-corner view definition, read by Innovus
# (init_design) and Tempus (read_mmmc).
#   setup: slow library + worst RC      hold: fast library + best RC
# Uses the SDC that Genus wrote for this config.
#############################################################################

source ./config.tcl

create_library_set -name lib_slow -timing [list $LIB_SLOW]
create_library_set -name lib_fast -timing [list $LIB_FAST]

create_rc_corner -name rc_worst -qx_tech_file $QRC_WORST
create_rc_corner -name rc_best  -qx_tech_file $QRC_BEST

create_delay_corner -name dc_slow -library_set lib_slow -rc_corner rc_worst
create_delay_corner -name dc_fast -library_set lib_fast -rc_corner rc_best

create_constraint_mode -name func -sdc_files [list $OUT/$TOP.sdc]

create_analysis_view -name view_setup -constraint_mode func -delay_corner dc_slow
create_analysis_view -name view_hold  -constraint_mode func -delay_corner dc_fast

set_analysis_view -setup [list view_setup] -hold [list view_hold]
