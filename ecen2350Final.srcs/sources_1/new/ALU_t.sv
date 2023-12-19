`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 02:11:28 PM
// Design Name: 
// Module Name: ALU_t
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      ALU status:|  |  | zero | carry |
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_t #(parameter BIT_WIDTH=8,
               parameter OP_CODE_WIDTH=4,
               parameter STATUS_WIDTH=4)(
        input [BIT_WIDTH - 1:0]a,
        input [BIT_WIDTH - 1:0]b,
        input [OP_CODE_WIDTH - 1:0] op,
        output logic [BIT_WIDTH - 1:0]q,
        output logic [STATUS_WIDTH - 1:0]status
    );

    // logic [BIT_WIDTH-1:0]additionOut;
    // logic additionCarry;

    // rca #(.BIT_WIDTH(BIT_WIDTH)) adder(.a(a), .b(b), .cin(1'b0), .q(additionOut), .cout(additionCarry));

    always_comb
        case (op)
            4'b0000: begin  // add
                q = a + b;
                status = a + b == 0 ? 4'b0001 : 4'b0000;
            end
            4'b0001: begin // sub
                q = a - b;
                status = a - b == 0 ? 4'b0010 : 4'b0000;
            end
            4'b0010: begin // inc
                q = b + 1;
                status = b + 1 == 0 ? 4'b0001 : 4'b0000;
            end
            4'b0011: begin // dec
                q = b - 1;
                status = b - 1 == 0 ? 4'b0010 : 4'b0000;
            end
            4'b0100: // and
                q = a & b;
            4'b0101: // or
                q = a | b;
            4'b0110: // not
                q = ~b;
            4'b0111: // xor
                q = a ^ b;
            4'b1000: // shl
                q = {b[BIT_WIDTH - 2:0], 1'b0};
                // q <= a << b;
            4'b1001: // shr
                // q <= a >> b;
                q = {1'b0, b[BIT_WIDTH - 1:1]};
            default: begin
            end
        endcase
endmodule
