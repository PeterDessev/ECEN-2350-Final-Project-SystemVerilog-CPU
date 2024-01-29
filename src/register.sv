`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ben Jacobsen, Peter Dessev
// Create Date: 12/07/2023 02:11:28 PM
// Description: Variable length register with asynchronous output 
//              and rising-edge clocked write protected input. 
//////////////////////////////////////////////////////////////////////////////////


module register #(parameter BIT_WIDTH=8) 
    (input writeEnable,
     input clk,
     input rst,
     input [BIT_WIDTH-1:0] inData,
     output logic [BIT_WIDTH-1:0] outData);

    initial begin
        outData <= {BIT_WIDTH{1'b0}};
    end

    always @(posedge(clk), posedge(rst)) begin
        if (rst) begin
            outData <= {BIT_WIDTH{1'b0}};
        end else if (writeEnable) begin
            outData <= inData;
            $display("%m: Writing %h", inData);
        end
    end
endmodule

