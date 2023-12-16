`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ben Jacobsen, Peter Dessev
// Create Date: 12/07/2023 02:11:28 PM
// Description: Variable length register with high empidance disabled output 
//              and write protected input. All actions are rising edge clock enabled
// Dependencies: DFF.sv
//////////////////////////////////////////////////////////////////////////////////


module register #(parameter BIT_WIDTH=8) 
    (input writeEnable,
     input clk,
     input [BIT_WIDTH-1:0] inData,
     output [BIT_WIDTH-1:0] outData);

    logic [BIT_WIDTH-1:0] write;
    logic [BIT_WIDTH-1:0] read;
    DFF flipFlopZero(.D(write[0]), .clk(clk), .Q(read[0]));
    
    genvar i;
    generate
        for (i = 0; i < BIT_WIDTH - 1; i ++) begin
            DFF flipFlopI(.D(write[i + 1]), .clk(clk), .Q(read[i + 1]));
        end
    endgenerate ;
    
    assign outData = read;
    always @(posedge(clk)) begin
        write = writeEnable ? inData : read;
    end
endmodule

