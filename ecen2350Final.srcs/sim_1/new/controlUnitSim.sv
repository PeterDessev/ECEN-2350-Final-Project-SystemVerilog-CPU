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
    localparam halfClkTime = 1;

    logic [7:0] InstructionCode;
    logic [ALU_STATUS_WIDTH - 1:0] ALUStatus = {ALU_STATUS_WIDTH{1'b0}};
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
        #halfClkTime;
        clk = 1;
        #halfClkTime;
    end

    initial begin
        #halfClkTime;
        // add
        InstructionCode = 8'b00000000;
        #(14 * halfClkTime);
        
        // sub 
        InstructionCode = 8'b00000001;
        #(14 * halfClkTime);
        
        // and
        InstructionCode = 8'b00000010;
        #(14 * halfClkTime);
        
        // or 
        InstructionCode = 8'b00000011;
        #(14 * halfClkTime);
        
        // xor
        InstructionCode = 8'b00000100;
        #(14 * halfClkTime);
                
        
        // beq
        InstructionCode = 8'b00100000;
        #(12 * halfClkTime);
        

        // st 
        InstructionCode = 8'b01000000;
        #(14 * halfClkTime);

        // ld
        InstructionCode = 8'b01000001;
        #(12 * halfClkTime); 
        
       
        // inc
        InstructionCode = 8'b01100000;
        #(14 * halfClkTime); 

        // dec
        InstructionCode = 8'b01100001;
        #(14 * halfClkTime); 

        // not
        InstructionCode = 8'b01100010;
        #(14 * halfClkTime); 

        // shl
        InstructionCode = 8'b01100011;
        #(14 * halfClkTime); 

        // shr
        InstructionCode = 8'b01100100;
        #(14 * halfClkTime); 

        
        // jmp
        InstructionCode = 8'b10000000;
        #(12 * halfClkTime); 
        

        // sti
        InstructionCode = 8'b10100000;
        #(12 * halfClkTime); 

        // ldi
        InstructionCode = 8'b10100001;
        #(12 * halfClkTime); 

        InstructionCode = 8'b11111111;
    end
endmodule
