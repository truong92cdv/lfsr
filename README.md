# LFSR - Linear Feedback Shift Register

## 0. Prepare Project

run the below commands
```sh
cd ~
mkdir lfsr
cd lfsr
mkdir src lib script sim netlist log
cd src
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/src/lfsr.v
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/src/lfsr_tb.v
cd ../lib
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/lib/primitives.v
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/lib/sky130_fd_sc_hd.v
cd ../script
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/script/sim.sh
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/script/synth.sh
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/script/synth.ys
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/script/sim_gatelevel.sh
chmod +x *
```

### project hiearchy

![project hiearchy](./images/0_prepare_proj.png)

## 1. RTL Design

[lfsr.v](./src/lfsr.v)

Verilog code implements a 4-bit Linear Feedback Shift Register (LFSR) to generate a pseudo-random bit sequence. It consists of three modules: mux (2-to-1 multiplexer), flipflop (D-type flip-flop with reset), and lfsr (main module). The LFSR shifts a 4-bit state, with feedback via XOR of bits 2 and 3, and supports seed loading or shifting based on a control signal.

## 2. RTL Simulation

### Verilog testbench

[lfsr_tb.v](./src/lfsr_tb.v)

### sim.sh
```sh
#!/bin/bash
exec > ../log/sim.log 2>&1
iverilog ../src/lfsr.v ../src/lfsr_tb.v -o ../sim/lfsr
vvp ../sim/lfsr
gtkwave ../sim/lfsr.vcd
```

### RTL simulation with gtkwave

```sh
./sim.sh
```

![RTL simulation](./images/2_rtl_sim.png)

## 3. Synthesis

### yosys run script (synth.ys)

```sh
read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog ../src/lfsr.v
synth -top lfsr
dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
clean
flatten
write_verilog -noattr ../netlist/lfsr_synth.v
stat
show -format dot -prefix ../netlist/lfsr_synth
```

### run synth.sh
```sh
./synth.sh
```

