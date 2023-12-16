`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 02:11:28 PM
// Design Name: 
// Module Name: controlUnit_t
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controlUnit_t #(
    parameter INSTRUCTION_WIDTH = 32, 
    parameter BUS_WIDTH = 8,
    parameter ALU_OP_CODE_WIDTH = 4,
    parameter ALU_STATUS_WIDTH = 4) (
    input [7:0] InstructionCode,
    input [ALU_STATUS_WIDTH - 1:0] ALUStatus,
    output registerFileWrite,
    output programCounterEnable,
    output ALUSourceControlA,
    output memoryWriteControl,
    output [(INSTRUCTION_WIDTH / BUS_WIDTH) - 1:0] instructionRegWrite,
    output [3:0] ALUSourceControlB,
    output [ALU_OP_CODE_WIDTH - 1:0] aluOpCode,
    output memoryAddressSelect,
    output [1:0] programCounterSourceSelect
    );
endmodule
