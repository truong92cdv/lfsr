#!/bin/bash
exec > ../log/synth.log 2>&1
yosys -s ./synth.ys
