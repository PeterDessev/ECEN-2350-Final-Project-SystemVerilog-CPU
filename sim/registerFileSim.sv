`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2023 02:44:42 PM
// Design Name: 
// Module Name: registerFileSim
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


module registerFileSim(

    );
    parameter int registerCount = 4;
    parameter int registerAddressWidth = 8;
    parameter int regWidth = 8;

    logic [registerAddressWidth - 1:0]inAddrA;
    logic [registerAddressWidth - 1:0]inAddrB;
    logic [registerAddressWidth - 1:0]inAddrC;
    logic [regWidth - 1:0]inData;
    logic writeEnable;
    logic clk;
    logic rst;
    logic [regWidth - 1:0]outDataA;
    logic [regWidth - 1:0]outDataB;
    logic [7:0] inputSwitches;
    logic [4:0] buttons;
    logic [6:0] segment;
    logic [3:0] segSelect;
    logic [7:0] LEDs;

    registerFile_t #(.BIT_WIDTH(regWidth), .REGISTER_COUNT(registerCount)) dut(.*);

    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

    initial begin
//        #5;
        inAddrA = 0;
        inAddrB = 0;
        inAddrC = 0;
        inData = 1;
        writeEnable = 1;
        inputSwitches = 0;
        buttons = 0;
        #10;
        
        inAddrA = 0;
        inAddrB = 0;
        inAddrC = 1;
        inData = 2;
        writeEnable = 1;
        inputSwitches = 0;
        buttons = 0;
        #10;

        
        inAddrA = 0;
        inAddrB = 0;
        inAddrC = 2;
        inData = 3;
        writeEnable = 1;
        inputSwitches = 0;
        buttons = 0;
        #10;


        inAddrA = 0;
        inAddrB = 0;
        inAddrC = 3;
        inData = 4;
        writeEnable = 1;
        inputSwitches = 0;
        buttons = 0;
        #10;

        
        inAddrA = 1;
        inAddrB = 2;
        inAddrC = 1;
        inData = 5;
        writeEnable = 0;
        inputSwitches = 0;
        buttons = 0;
        #10;

        
        inAddrA = 3;
        inAddrB = 4;
        inAddrC = 2;
        inData = 6;
        writeEnable = 0;
        inputSwitches = 1;
        buttons = 2;
        #10;
    end
endmodule
