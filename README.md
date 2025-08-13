# LFSR - Linear Feedback Shift Register

## 0. Introduction

## 1. RTL Design

```sh
cd ~
mkdir lfsr
cd lfsr
mkdir src
cd src
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/src/lfsr.v
```

### source code lfsr.v
```v
module mux(q, control, a, b);
    output q;
    reg q;
    input control, a, b;
    wire notcontrol;

    always @(control or notcontrol or a or b)
        q = (control & a) | (notcontrol & b);

    not (notcontrol, control);
endmodule

module flipflop(q, clk, rst, d);
    input clk;
    input rst;
    input d;
    output q;
    reg q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q = 0;
        else
            q = d;
    end
endmodule

module lfsr(q, clk, rst, seed, load);
    output q;
    input [3:0] seed;
    input load;
    input rst;
    input clk;

    wire [3:0] state_out;
    wire [3:0] state_in;
    wire nextbit;

    flipflop F[3:0] (state_out, clk, rst, state_in);
    mux M1[3:0] (
        state_in,
        load,
        seed,
        {state_out[2], state_out[1], state_out[0], nextbit}
    );
    xor G1(nextbit, state_out[2], state_out[3]);
    assign q = nextbit;
endmodule
```

## 2. RTL Simulation

```sh
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/src/lfsr_tb.v
cd ..
mkdir sim
mkdir script
cd script
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/script/sim.sh
chmod +x sim.sh
./sim.sh
```

### Verilog testbench
```v
module lfsr_tb;
  reg clk;
  reg rst;
  reg [3:0] seed;
  reg load;
  wire q;

  lfsr L(q, clk, rst, seed, load);

  // initialization & apply reset pulse
  initial begin
    $dumpfile("../sim/lfsr.vcd");
    $dumpvars(0, lfsr_tb);

    clk = 0;
    load = 0;
    seed = 0;
    rst = 0;
    #10 rst = 1;
    #10 rst = 0;
  end

  // drive clock
  always #50 clk = !clk;

  // program lfsr
  initial begin
    #100 seed = 4'b0001;
    load = 1;
    #100 load = 0;
    #500 $finish;
  end
endmodule
```

### sim.sh
```sh
#!/bin/bash
exec > ../log/sim.log 2>&1
iverilog ../src/lfsr.v ../src/lfsr_tb.v -o ../sim/lfsr
vvp ../sim/lfsr
gtkwave ../sim/lfsr.vcd
```

### RTL simulation with gtkwave
![RTL simulation](./images/2_rtl_sim.png)

## 3. Synthesis

```sh
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/src/lfsr_tb.v
cd ..
mkdir sim
mkdir script
cd script
wget https://raw.githubusercontent.com/truong92cdv/lfsr/refs/heads/main/script/sim.sh
chmod +x sim.sh
./sim.sh
```