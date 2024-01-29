`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2023 07:21:44 PM
// Design Name: 
// Module Name: clockDiv
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


module clockDiv #(parameter DIV_COUNT = 20)(
    input clk,
    input rst,
    output logic cout);
    
    logic [DIV_COUNT:0] data;
    logic [DIV_COUNT:0] clkOut;

    flipflop flipFlopZero(.data(data[0]), .clk(clk), .rst(rst), .Q(clkOut[0]));

    genvar i;
    generate
        for(i = 1; i <= DIV_COUNT; i++) begin
           flipflop flipFlop(.data(data[i]), .clk(clkOut[i - 1]), .rst(rst), .Q(clkOut[i]));
        end
    endgenerate;

    assign data = ~clkOut;
    assign cout = clkOut[DIV_COUNT];
endmodule
