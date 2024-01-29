`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2023 07:21:44 PM
// Design Name: 
// Module Name: flipflop
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


module flipflop(
    input data,
    input clk,
    input rst,
    output logic Q);
    
    always @ (posedge clk, posedge rst) begin
        Q <= rst ? 1'b0 : data;
    end
endmodule

