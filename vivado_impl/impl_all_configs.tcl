# impl_all_configs.tcl
#
# Runs opt/place/route + timing/power/DRC signoff for all 5 ablation
# configs in ONE Vivado batch session, with IDENTICAL settings applied
# to every config. This replaces the earlier impl_one.tcl, which was run
# once per config by hand across separate sessions -- that's how
# D_proposed ended up built without maxThreads=1 while the other four
# had it, making the last sweep's numbers not apples-to-apples.
#
# Usage:
#   vivado -mode batch -source impl_all_configs.tcl
#
# Expects, for each config <name> in $configs below:
#   C:/Users/krss/Desktop/vivado_reports/<name>/post_synth.dcp
#
# Writes, for each config:
#   vivado_reports/<name>/timing_post_route.rpt   (report_timing_summary)
#   vivado_reports/<name>/power.rpt               (report_power, no SAIF)
#   vivado_reports/<name>/drc.rpt                 (report_drc)
#   vivado_reports/<name>/post_route.dcp
#   vivado_reports/<name>/wns_summary.txt         (just the WNS/TNS line, for easy diffing)

set_param general.maxThreads 1

set base_dir "C:/Users/krss/Desktop/vivado_reports"
set configs {A_baseline B_fusion_only C_isol_only D_proposed D_isol_scope_ablation}

foreach config_name $configs {
    set out_dir "$base_dir/$config_name"
    puts "===================================================="
    puts "STARTING CONFIG: $config_name"
    puts "===================================================="

    open_checkpoint "$out_dir/post_synth.dcp"

    # Keep the isolation gate as its own protected cell in every config
    # that has one, so it shows up consistently in critical-path reports
    # instead of being optimized away or merged differently config to config.
    set c_a [get_cells -quiet u_isol_gate_a]
    if {[llength $c_a] > 0} { set_property DONT_TOUCH TRUE $c_a }
    set c_b [get_cells -quiet u_isol_gate_b]
    if {[llength $c_b] > 0} { set_property DONT_TOUCH TRUE $c_b }

    opt_design
    place_design
    route_design

    report_timing_summary -file "$out_dir/timing_post_route.rpt"
    report_power -file "$out_dir/power.rpt"
    report_drc -file "$out_dir/drc.rpt"
    write_checkpoint -force "$out_dir/post_route.dcp"

    # Pull just the top-level WNS/TNS/WHS/THS line into its own small file
    # so you can diff all 5 configs' summaries without opening each .rpt.
    set fh [open "$out_dir/wns_summary.txt" w]
    set timing_report [open "$out_dir/timing_post_route.rpt" r]
    set found 0
    while {[gets $timing_report line] >= 0} {
        if {[string match "*WNS(ns)*" $line]} {
            set found 1
        }
        if {$found} {
            puts $fh $line
        }
        if {$found && [string trim $line] eq "" } {
            break
        }
    }
    close $timing_report
    close $fh

    puts "CONFIG DONE: $config_name"

    # Fully close this design before opening the next checkpoint, so no
    # state (DONT_TOUCH properties, timing cache, etc.) leaks between configs.
    close_design
}

puts "===================================================="
puts "ALL 5 CONFIGS COMPLETE -- SAME FLOW, SAME SETTINGS"
puts "===================================================="
puts "Compare vivado_reports/<config>/wns_summary.txt across all 5."
