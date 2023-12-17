`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2023 01:40:50 PM
// Design Name: 
// Module Name: genericDeMux
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

// Based On: https://electronics.stackexchange.com/questions/552516/how-to-build-large-multiplexers-using-systemverilog
// And: https://www.edaboard.com/threads/parameterized-demultiplexer-in-verilog.244364/
module genericDeMux #(parameter WIDTH = 8, 
                    parameter NUMBER = 4, 
                    localparam SELECT_W = $clog2(NUMBER)) 
    (input logic [SELECT_W-1:0] sel, 
     input logic [WIDTH-1:0] in,
     input enable,
     output logic [NUMBER-1:0][WIDTH-1:0] deMuxOut);                   
    
    genvar i;

    generate 
    for (i = 0; i < NUMBER; i++)  begin 
        assign deMuxOut[i] = (sel == i && enable) ? in : {WIDTH{1'b0}};
    end
    endgenerate

endmodule