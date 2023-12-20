`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ben Jacobsen
// 
// Create Date: 12/19/2023 01:44:48 PM
// Design Name: 
// Module Name: ALUSim
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


module ALUSim(

    );
    
    parameter int bitWidth = 8;
    parameter int opCodeWidth = 4;
    parameter int statusWidth = 4;
    
    logic[bitWidth-1:0] a, b, q;
    logic[opCodeWidth-1:0] op;
    logic[statusWidth-1:0] status;
    
    ALU_t #(.BIT_WIDTH(bitWidth), .OP_CODE_WIDTH(opCodeWidth), .STATUS_WIDTH(statusWidth)) dut(.*);
    
    initial begin
    
        a=0; b=0; op=0; // add
        #5;
        
        a=3; b=2; op=1; // sub
        #5;

        a=10; b=12; op=2; // inc
        #5;   

        a=10; b={bitWidth{1'b1}}; op=2; // inc (overflow)
        #5;  

        a=10; b=12; op=3; // dec
        #5;   
        
        a=10; b=1; op=3; // dec (zero)
        #5;   

        a=10; b=0; op=3; // dec (uderflow)
        #5;   

        a=8'b00001111; b=8'b10101010; op=4; // and
        #5;

        a=8'b00001111; b=8'b10101010; op=5; // or
        #5;

        a=8'b00001111; b=8'b10101010; op=6; // not
        #5;

        a=8'b00001111; b=8'b10101010; op=7; // xor
        #5;

        a=8'b00001111; b=8'b10101010; op=8; // shl
        #5;

        a=8'b00001111; b=8'b10101010; op=9; // shr
        #5;
    
        a=8'b00001111; b=8'b10101010; op=10; // pass b
        #5;
        //Most of origonal test cases seen in TD were lost in a previoud file.
    
    end
endmodule
