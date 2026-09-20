# run_saif.tcl - log SAIF for the DUT under whatever the top scope is called, always exit
set saif_out [file normalize $::env(SAIF_OUT_PATH)]
open_saif $saif_out
set objs {}
set pats [list "/*/dut/*"]
foreach r [get_scopes /*] { lappend pats "[string map [list "\\" "\\\\"] $r]/dut/*" }
lappend pats "/tb_saif/dut/*"
foreach p $pats {
  if {[llength $objs] == 0} { catch { set objs [get_objects -r $p] } }
}
if {[llength $objs] == 0} {
  puts "SAIF_FAIL: no DUT objects; roots=[get_scopes /*]"
  catch { close_saif }
  exit 1
}
puts "SAIF_LOGGING: [llength $objs] objects"
log_saif $objs
run -all
close_saif
puts "SAIF written: $saif_out"
exit
