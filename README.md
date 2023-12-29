# BP1 Processor
The BP1 is an 8 bit MIPS-based processor implemented in System Verilog. The processor has 256 bits of writable memory and 4 scratch registers, along with several I/O registers. The processor is capable of performing several numerical operations, immediate and memory based data operations, and program control flow. Plans to expand both the instruction set as well as word size to 16 bits are under way.

# Architecture
The BP1 architecture is based on the MIPS processor outlined in Neil H. E. Weste and David Money Harris's "CMOS VLSI Design A Circuits and Systems Perspective, 4th Edition", however, all code is original to the project unless otherwise stated in the source file. Some minor modifications have been added in order to accomodate additional instructions originally not present in the textbook.

A block diagram of the archtecture can be found below

![Block Diagram](Figures/darkModeBlockDiagram.png)

# Control Unit FSM

# Instructions
The BP1 has many instructions, which are detailed in `instructions.md`. Each instruction is 32 bits long and little endian. Instructions are grouped roughly based on the number of arguments they take and which group of data they operate on. Those are 1, 2, and 3 argumnet instructions, and arithmetic, memory, and instruction data. 

# Next Steps
- Increase word size to 16 bits.
- Optimize fsm
- Implement stack
- Add instructions
  - bneq
  - bc
  - call
  - mult
  - div
- Add FPU
- Add Display Unit