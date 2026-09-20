# collect_wns_table.ps1
#
# Run AFTER impl_all_configs.tcl finishes. Pulls the WNS(ns) line out of
# each config's wns_summary.txt and prints one comparison table, so you
# can paste real, same-flow numbers straight into README.md / RESULTS.md.
#
# Usage (from C:\Users\krss\Desktop):
#   .\collect_wns_table.ps1

$configs = @("A_baseline", "B_fusion_only", "C_isol_only", "D_proposed", "D_isol_scope_ablation")
$results = @()

foreach ($cfg in $configs) {
    $path = "vivado_reports\$cfg\wns_summary.txt"
    if (-not (Test-Path $path)) {
        $results += [PSCustomObject]@{ Config = $cfg; WNS = "MISSING FILE"; TNS = ""; FailingEndpoints = "" }
        continue
    }
    $lines = Get-Content $path
    # The data row is the line right after the "clk" row starts, or the
    # first line of numbers after the WNS(ns) header row -- Vivado's
    # report_timing_summary table format.
    $dataLine = $lines | Where-Object { $_ -match '^\s*clk\s' } | Select-Object -First 1
    if (-not $dataLine) {
        $results += [PSCustomObject]@{ Config = $cfg; WNS = "PARSE FAIL"; TNS = ""; FailingEndpoints = "" }
        continue
    }
    $fields = ($dataLine -replace '^\s*clk\s+', '') -split '\s+'
    $results += [PSCustomObject]@{
        Config           = $cfg
        WNS              = $fields[0]
        TNS              = $fields[1]
        FailingEndpoints = $fields[2]
    }
}

$results | Format-Table -AutoSize

Write-Host "`nPaste the WNS column above into README.md's timing table."
Write-Host "All 5 rows came from the SAME impl_all_configs.tcl run -- same maxThreads, same DONT_TOUCH treatment, same session."
