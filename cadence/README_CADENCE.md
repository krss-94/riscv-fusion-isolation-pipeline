# Cadence flow (Genus / Innovus / Tempus) -- GPDK045, full-size design

Status: **written but never run.** No Cadence tools were available where
these were written, so expect a few rounds of "paste the error, get a fix".
Original `rtl/` files are never modified by any script here.

## What's in this folder

| File | Purpose |
|---|---|
| `config.tcl` | Every path/setting. The only file to edit. |
| `00_discover_gpdk.sh` | Finds the real GPDK045 file names at the lab. |
| `constraints.sdc` | Clock-only, 18 ns -- same as the Vivado runs. |
| `01_genus_synth.tcl` | RTL -> netlist (per config). |
| `mmmc.tcl` | Setup (slow) / hold (fast) corner definitions. |
| `02_innovus_pnr.tcl` | Floorplan, place, CTS, route, DRC check, export. |
| `03_tempus_signoff.tcl` | Post-route timing. Do last; optional at first. |
| `run_flow.sh` | Runs stages for one config or all 5. |

## Order of operations at the lab

1. Clone/pull the repo (this folder is `cadence/`). Source your lab's
   Cadence setup so `genus`, `innovus`, `tempus` are on PATH.
2. **Put a real program in `cadence/imem_init.hex`** -- the same benchmark
   hex your Vivado SAIF runs loaded (see below for why).
3. `bash 00_discover_gpdk.sh 2>&1 | tee discover.txt`, paste it to Claude,
   and fix the `<<< CHECK` lines in `config.tcl`.
4. Smoke test with **4KB memory** (128KB is too big for first run):
   `MEM_HEX=0000_1000 ./run_flow.sh D_proposed genus`
   Read `logs/genus_D_proposed*` for warnings before going further.
5. `MEM_HEX=0000_1000 ./run_flow.sh D_proposed innovus`, then `... tempus`.
6. Once D_proposed works end to end at 4KB, try A_baseline at 4KB.
7. Only attempt full 128KB if you have time and 4KB worked perfectly.

Bring back for each config: `reports/<cfg>/qor.rpt`, `area.rpt`,
`timing.rpt`, Innovus `summary.rpt` and `timing_setup/`, and the log tails
if anything failed.

## Things I could not verify (most likely places for a first error)

- **`$readmemh` in Genus.** Not sure whether Genus honors it or ignores it.
  Check the Genus log for warnings mentioning `readmemh`, `initial` or
  undriven `imem`.
- **`imem` is a read-only array (a ROM) in the RTL.** Its ASIC cost depends
  on the program in `imem_init.hex`. An all-NOP or empty program lets
  synthesis fold it (and much of the design behind it) away. `imem` is
  identical across all 5 configs, so the fusion/isolation comparison holds
  either way -- same argument as in the Vivado analysis -- but the absolute
  numbers only mean something with a real program loaded.
- **`dmem`** is a real 32768 x 32 writable array: about 1M flip-flops plus
  read muxes, since GPDK045 ships no SRAM macro. Expect long runtimes and
  high memory in Genus and especially Innovus.
- Exact GPDK045 file names, layer names, site name, filler cell names.
- CTS may need explicit clock buffer cells; Tempus reading per-corner SPEF;
  command-line flags differ between tool versions.

## Power caveat

Genus/Innovus power here is **vectorless** (default switching activity).
Your Vivado power table used SAIF activity from real benchmark runs, so the
two are not comparable. Area and timing compare fine. Comparable Cadence
power needs activity from simulation fed into the tools -- do that after
area/timing work.
