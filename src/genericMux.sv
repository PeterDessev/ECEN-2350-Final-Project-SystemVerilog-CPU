`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ben Jacobsen, Peter Dessev
// 
// Create Date: 12/14/2023 01:35:47 PM
// Description: Multiplexor for the BP1 processor. Width is the number of 
//              bus lanes per input and number is the number of inputs
//////////////////////////////////////////////////////////////////////////////////

// Based on: https://electronics.stackexchange.com/questions/552516/how-to-build-large-multiplexers-using-systemverilog
module genericMux #(parameter WIDTH = 1, 
                    parameter NUMBER = 2, 
                    localparam SELECT_W = $clog2(NUMBER)) 
 (input logic [SELECT_W-1:0] sel, 
  input logic [WIDTH-1:0] mux_in [NUMBER-1:0],                   
  output logic [WIDTH-1:0] out);
  
  assign out = mux_in[sel];
endmodule    