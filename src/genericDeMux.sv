`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ben Jacobsen, Peter Dessev
// 
// Create Date: 12/14/2023 01:40:50 PM
// Description: De-multiplexor for the BP1 processor. Global enable pulls all outputs 
//              to zero when low. Width is the number of bus lanes per output, and 
//              number is the number of outputs
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