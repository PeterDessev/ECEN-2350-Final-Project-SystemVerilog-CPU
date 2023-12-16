`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2023 10:40:54 AM
// Design Name: 
// Module Name: memory_t
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


module memory_t #(parameter BUS_WIDTH=8,
                  parameter NUM_BYTES=(2 ** BUS_WIDTH - 1)) (
    input [BUS_WIDTH - 1:0] address,
    input [BUS_WIDTH - 1:0] writeData,
    input writeEnable,
    input clk,
    output logic [BUS_WIDTH - 1:0] readData
    );

    logic [7:0]memoryCell[NUM_BYTES : 0];

    always @(posedge(clk)) begin
        readData = writeEnable == 0 ? memoryCell[address] : {BUS_WIDTH{1'b0}};
        memoryCell[address] <= writeEnable ? writeData : memoryCell[address];
    end
endmodule
