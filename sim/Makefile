VERILATOR = verilator
RTL_DIR   = ../rtl
TOP       = core_top
EXE_ABS   = $(abspath ../sim_core)

all: sim

sim:
	$(VERILATOR) --cc $(RTL_DIR)/alu.sv $(RTL_DIR)/imm_gen.sv $(RTL_DIR)/regfile.sv \
	    $(RTL_DIR)/muldiv.sv $(RTL_DIR)/decoder.sv $(RTL_DIR)/core_top.sv \
	    --top-module $(TOP) -Wall -Wno-UNUSEDSIGNAL --exe tb_core.cpp \
	    -CFLAGS "-std=c++14" -o $(EXE_ABS)
	$(MAKE) -C obj_dir -f V$(TOP).mk

clean:
	rm -rf obj_dir ../sim_core

.PHONY: all sim clean
