`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2023 07:43:07 PM
// Design Name: 
// Module Name: controlUnitSim
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


module controlUnitSim(

    );
    parameter INSTRUCTION_WIDTH = 32; 
    parameter BUS_WIDTH = 8;
    parameter ALU_OP_CODE_WIDTH = 4;
    parameter ALU_STATUS_WIDTH = 4;
    localparam INST_REG_WIDTH = INSTRUCTION_WIDTH / BUS_WIDTH;

    logic [7:0] InstructionCode;
    logic [ALU_STATUS_WIDTH - 1:0] ALUStatus;
    logic clk;

     logic registerFileWrite;
     logic programCounterEnable;
     logic ALUSourceControlA;
     logic memoryWriteControl;
     logic [INST_REG_WIDTH - 1:0] instructionRegWrite;
     logic [1:0]ALUSourceControlB;
     logic [ALU_OP_CODE_WIDTH - 1:0] aluOpCode;
     logic memoryAddressSelect;
     logic [1:0] programCounterSourceSelect;
     logic regFileInputCSourceSelect;
     logic regFileWriteDataSourceSelect;

    controlUnit_t dut(.*);

    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

    initial begin
        // add
        InstructionCode = 8'b00000000;
        #70;
        
        // sub 
        InstructionCode = 8'b00000001;
        #70;
        
        // and
        InstructionCode = 8'b00000010;
        #70;
        
        // or 
        InstructionCode = 8'b00000011;
        #70;
        
        // xor
        InstructionCode = 8'b00000100;
        #70;
        


        
        // beq
        
        // st 
        // ld 
        
        // inc
        // dec
        // not
        // shl
        // shr
        
        // jmp
        
        // sti
        // ldi
    end
endmodule
