#!/bin/bash
exec > ../log/sim_gatelevel.log 2>&1
iverilog ../lib/primitives.v ../lib/sky130_fd_sc_hd.v ../netlist/lfsr_synth.v ../src/lfsr_tb.v -o ../sim/lfsr_gatelevel
vvp ../sim/lfsr_gatelevel
gtkwave ../sim/lfsr.vcd