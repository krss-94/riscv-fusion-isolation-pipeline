# check_fusion_enabled.tcl
#
# Diagnostic: D_isol_scope_ablation's opt_design retargeting pattern (49
# cells removed, 48 inverters pulled) matches C_isol_only's (48 cells, 47
# inverters) far more closely than it matches the other fusion-enabled
# configs B_fusion_only (4 cells, 3 inverters) or D_proposed (2 cells, 2
# inverters). That's suspicious for a config that's supposed to have
# fusion ON. This script checks directly whether fusion-specific cells
# actually exist in each config's post-synthesis netlist, instead of
# inferring it indirectly from optimizer behavior.
#
# It works on the POST-SYNTHESIS checkpoint (before opt_design has a
# chance to optimize anything away), so this is checking what fusion RTL
# actually got built into each config, not what survived synthesis.
#
# Usage:
#   vivado -mode batch -source check_fusion_enabled.tcl

set base_dir "C:/Users/krss/Desktop/vivado_reports"
set configs {A_baseline B_fusion_only C_isol_only D_proposed D_isol_scope_ablation}

# Signals/cells that should ONLY exist when fusion is compiled in.
# fuse4_valid_out and pend2_valid_out are id_ex_reg pipeline fields tied
# directly to the fusion detection/pend2 mechanism described in the
# README's architecture section.
set fusion_signal_patterns {
    "*fuse4_valid*"
    "*pend2_valid*"
    "*pend2_active*"
    "*fuse_idiom*"
}

puts "===================================================="
puts "FUSION-PRESENCE CHECK (post-synthesis netlist, before opt_design)"
puts "===================================================="

foreach config_name $configs {
    set dcp "$base_dir/$config_name/post_synth.dcp"
    puts "\n--- $config_name ---"

    if {![file exists $dcp]} {
        puts "  SKIPPED: $dcp not found"
        continue
    }

    open_checkpoint -quiet $dcp

    set total_hits 0
    foreach pattern $fusion_signal_patterns {
        set hits [get_cells -quiet -hierarchical $pattern]
        set n [llength $hits]
        puts "  $pattern : $n cell(s)"
        incr total_hits $n
    }

    if {$total_hits == 0} {
        puts "  ==> NO fusion-related cells found. Fusion is NOT present in this build."
    } else {
        puts "  ==> Fusion-related cells found ($total_hits total). Fusion IS present in this build."
    }

    close_design
}

puts "\n===================================================="
puts "If D_isol_scope_ablation shows 0 fusion-related cells while"
puts "B_fusion_only and D_proposed show nonzero counts, that confirms"
puts "D_isol_scope_ablation's checkpoint was built without fusion enabled --"
puts "it needs to be rebuilt from the correct RTL parameters before its"
puts "timing/power numbers can be trusted or published."
puts "===================================================="
