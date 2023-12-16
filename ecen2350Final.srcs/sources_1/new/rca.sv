`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2023 02:09:28 PM
// Design Name: 
// Module Name: halfAdder
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

module rca #(parameter BIT_WIDTH=8) (
    input [BIT_WIDTH-1:0]a,
    input [BIT_WIDTH-1:0]b,
    input cin,
    output [BIT_WIDTH-1:0]q,
    output cout
    );

    // logic [BIT_WIDTH-1:0] sum;
    logic [BIT_WIDTH-1:0] caries;
    fullAdder fa(.a(a[0]), .b(b[0]), .cin(cin), .q(q[0]), .c(caries[0]));
    
    genvar i;
    generate
        for (i = 0; i < BIT_WIDTH - 1; i ++) begin
            fullAdder faI(
                .a(a[i + 1]), 
                .b(b[i + 1]), 
                .cin(caries[i]), 
                .q(q[i + 1]), 
                .cout(caries[i + 1])
            );
        end
    endgenerate;

    assign cout = caries[BIT_WIDTH - 1];
endmodule