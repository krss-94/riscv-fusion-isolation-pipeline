# ORFS run for the 5 configs (sky130hd)

NOT RUN by me: OpenROAD/ORFS only exist on your Mac. The RTL and wrapper were checked in yosys.

Why this exists: your earlier ORFS result had ~203 flops. I reproduced that in yosys by feeding an
all-zero `imem_init.hex`: the program folds away and takes the core with it. This bundle loads the
real `rtl/imem_init.hex` through an absolute path so it can't go missing.

Steps (Mac Terminal):
  cp -r orfs_run ~/Downloads/ooo-repo/ && cd ~/Downloads/ooo-repo/orfs_run
  open -a XQuartz; xhost +localhost         # only needed for the GUI
  docker run --rm -it -v "$PWD":/work openroad/orfs:latest bash
  bash /work/run_orfs_all.sh D_proposed     # one config first
  bash /work/run_orfs_all.sh                # then all five

Knobs: MEM=0000_1000 (4 KB dmem/imem), PERIOD=10.0 ns. Outputs land in orfs_run/results/<config>/.
It runs on emulated amd64 on your Apple-silicon Mac, so expect long runtimes, hours for 4 KB.
Check the flop count first: grep -c "sky130_fd_sc_hd__df" results/D_proposed/6_final.v  (should be ~35,000, not ~200).
