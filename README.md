# MIPS Datapath Project

## Overview
This project implements a MIPS datapath in Verilog, which simulates the basic operations of a MIPS processor. The datapath includes components such as the Program Counter (PC), ALU, Register File, Data Memory, and control logic to handle various MIPS instructions.

## Features
- **32-bit Instruction Input**: The datapath accepts 32-bit MIPS instructions.
- **Clock and Reset Signals**: Supports synchronous operation with a clock signal and an asynchronous reset.
- **Control Signals**: Includes control signals for register writing, memory reading/writing, and branching.
- **ALU Operations**: Supports basic arithmetic and logical operations (ADD, SUB, AND, OR).
- **Memory Operations**: Implements load (LW) and store (SW) instructions.
- **Branching**: Supports conditional branching based on the zero flag.

## Components
1. **MIPS_Datapath**: The main module that integrates all components.
2. **SignExtender**: Extends a 16-bit immediate value to 32 bits.
3. **RegisterFile**: Contains 32 registers and handles read/write operations.
4. **Mux2to1**: A 2-to-1 multiplexer used for selecting ALU inputs.
5. **ALU**: Performs arithmetic and logical operations.
6. **DataMemory**: Simulates a simple memory for load and store operations.

## Testbench
The project includes a testbench (`MIPS_Datapath_tb`) that verifies the functionality of the datapath. It initializes inputs, applies various MIPS instructions, and checks the outputs against expected results.

## Usage
1. **Simulation**: The project can be simulated using Icarus Verilog or any other compatible Verilog simulator.
2. **Waveform Generation**: The testbench generates a waveform file (`waveform.vcd`) for visualizing signal changes during simulation.

## Instructions to Run
1. Ensure you have Icarus Verilog installed.
2. Compile the Verilog files:
   ```bash
   iverilog -o mips_datapath.vvp MIPS_Datapath.v MIPS_Datapath_tb.v
3. Run the simulation:
   ```bash
   vvp mips_datapath.vvp
4. View the waveform using a waveform viewer (e.g., GTKWave):
   ```bash
   gtkwave waveform.vcd

##Conclusion

This MIPS datapath project serves as a foundational implementation of a MIPS processor, demonstrating key concepts in digital design and computer architecture. It can be extended with additional features such as more complex instructions, pipelining, and hazard detection for further learning and experimentation.
   
   
   
