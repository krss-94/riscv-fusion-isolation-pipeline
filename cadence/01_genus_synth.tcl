#############################################################################
# 01_genus_synth.tcl -- Cadence Genus, RTL -> gate-level netlist (GPDK045)
#
# Run from the cadence/ directory:
#   CONFIG=D_proposed genus -no_gui -files 01_genus_synth.tcl -log logs/genus_D_proposed
#
# Full-size design: MEM_BYTES stays at the RTL default (128KB). Nothing is
# shrunk. Your original rtl/ files are never modified: the per-config
# parameter values (FUSION_EN / ISOL_EN / BR_CMP_EN) are applied to a COPY
# of core_top_pipelined.sv written into out/<config>/.
#
# NOT RUN BY CLAUDE (no Cadence tools available to it). If any command
# errors, paste the exact message back -- that's the expected loop.
#############################################################################

source ./config.tcl
file mkdir $OUT $RPT logs

# ---------------------------------------------------------------------
# 1. Libraries. Slow corner for synthesis (conservative setup timing).
# ---------------------------------------------------------------------
set_db library $LIB_SLOW
catch {set_db lef_library [list $LEF_TECH $LEF_MACRO]}
catch {set_db hdl_language sv}
catch {set_db max_cpus_per_server $NUM_CPUS}
# 32768-word memories sit right at Genus's default array-size limit;
# raise it so elaboration doesn't stop on them. (Wrapped in catch: if this
# Genus version has no such attribute, the run continues.)
catch {set_db hdl_max_memory_address_range 65536}

# ---------------------------------------------------------------------
# 2. imem_init.hex. core_top_pipelined.sv does $readmemh("imem_init.hex").
#    Put a REAL benchmark hex here before running (the same one your
#    Vivado SAIF runs loaded). An all-NOP dummy is created only so
#    elaboration can't fail on a missing file -- see README: with an
#    all-NOP program, synthesis can fold most of the design away and the
#    PPA numbers would be meaningless.
# ---------------------------------------------------------------------
if {![file exists imem_init.hex]} {
    puts "WARNING: imem_init.hex missing -- writing an all-NOP placeholder. DO NOT trust PPA from this run."
    set fh [open imem_init.hex w]
    for {set i 0} {$i < 32768} {incr i} { puts $fh "00000013" }
    close $fh
}

# ---------------------------------------------------------------------
# 3. Apply this config's parameters to a copy of the top-level file
# ---------------------------------------------------------------------
proc set_param {txt name val} {
    # group 1 = everything up to the value; group 2 = "1'b0"/"1'b1"
    set pat "(parameter\\s+bit\\s+${name}\\s*=\\s*)1'b\[01\]"
    # replacement: \1 (group 1) followed by the literal text 1'b<val>
    if {![regsub $pat $txt "\\11'b${val}" new]} {
        error "Could not find 'parameter bit $name = 1'bX' in core_top_pipelined.sv"
    }
    if {![regexp "parameter\\s+bit\\s+${name}\\s*=\\s*1'b${val}" $new]} {
        error "Parameter $name did not end up as $val"
    }
    return $new
}

proc set_mem_size {txt mem_hex} {
    # Replace MEM_BYTES = 32'h0002_0000 with the specified value
    set pat "(parameter\\s+MEM_BYTES\\s*=\\s*)32'h\[0-9a-fA-F_\]+"
    if {![regsub $pat $txt "\\132'h${mem_hex}" new]} {
        error "Could not find 'parameter MEM_BYTES = 32'hXXXX' in core_top_pipelined.sv"
    }
    if {![regexp "MEM_BYTES\\s*=\\s*32'h${mem_hex}" $new]} {
        error "MEM_BYTES did not end up as 32'h${mem_hex}"
    }
    return $new
}

set fh [open $RTL_DIR/core_top_pipelined.sv r]
set txt [read $fh]
close $fh

# Apply memory size shrink if MEM_HEX env var is set (e.g., MEM_HEX=0000_1000 for 4KB)
if {[info exists ::env(MEM_HEX)]} {
    set mem_hex $::env(MEM_HEX)
    puts "Shrinking memory to MEM_BYTES = 32'h${mem_hex}"
    set txt [set_mem_size $txt $mem_hex]
}

set txt [set_param $txt FUSION_EN $CFG_FUSION($CONFIG)]
set txt [set_param $txt ISOL_EN   $CFG_ISOL($CONFIG)]
set txt [set_param $txt BR_CMP_EN $CFG_BRCMP($CONFIG)]
set cfg_top $OUT/core_top_pipelined.sv
set fh [open $cfg_top w]
puts -nonewline $fh $txt
close $fh
puts "Config $CONFIG -> FUSION_EN=$CFG_FUSION($CONFIG) ISOL_EN=$CFG_ISOL($CONFIG) BR_CMP_EN=$CFG_BRCMP($CONFIG)"

# ---------------------------------------------------------------------
# 4. Read RTL: every rtl/*.sv except the original top, plus the config copy
# ---------------------------------------------------------------------
set files {}
foreach f [lsort [glob $RTL_DIR/*.sv]] {
    if {[file tail $f] ne "core_top_pipelined.sv"} { lappend files $f }
}
lappend files $cfg_top
read_hdl -sv $files
elaborate $TOP
check_design -unresolved

# ---------------------------------------------------------------------
# 5. Constraints + synthesis
# ---------------------------------------------------------------------
read_sdc ./constraints.sdc

set_db syn_generic_effort medium
set_db syn_map_effort     medium
set_db syn_opt_effort     medium

syn_generic
syn_map
syn_opt

# ---------------------------------------------------------------------
# 6. Reports (these are your Cadence PPA numbers for this config)
# ---------------------------------------------------------------------
report_qor    > $RPT/qor.rpt
report_area   > $RPT/area.rpt
report_timing > $RPT/timing.rpt
report_gates  > $RPT/gates.rpt
report_power  > $RPT/power_vectorless.rpt   ;# NOT comparable to Vivado's SAIF power, see README

# ---------------------------------------------------------------------
# 7. Handoff to Innovus
# ---------------------------------------------------------------------
write_hdl > $OUT/$TOP.v
write_sdc > $OUT/$TOP.sdc

puts "Genus done: $OUT/$TOP.v, $OUT/$TOP.sdc, reports in $RPT/"
exit
