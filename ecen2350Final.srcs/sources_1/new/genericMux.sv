`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2023 01:35:47 PM
// Design Name: 
// Module Name: genericMux
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

// Source: https://electronics.stackexchange.com/questions/552516/how-to-build-large-multiplexers-using-systemverilog
module genericMux #(parameter WIDTH = 1, 
                    parameter NUMBER = 2, 
                    localparam SELECT_W = $clog2(NUMBER)) 
 (input logic [SELECT_W-1:0] sel, 
  input logic [WIDTH-1:0] mux_in [NUMBER-1:0],                   
  output logic [WIDTH-1:0] out);
  
  assign out = mux_in[sel];
endmodule    