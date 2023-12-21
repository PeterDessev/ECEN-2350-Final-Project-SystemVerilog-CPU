`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2023 06:56:10 PM
// Design Name: 
// Module Name: TopSim
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


module TopSim(

    );
    parameter int halfClk = 1;

    logic [7:0] inputSwitches = 0;
    logic [4:0] buttons = 0;
    logic clkIn;
    logic rst = 0;
    logic clkEnable = 1;
    logic manualClk = 0;

    logic [6:0] segment;
    logic [3:0] segSelect;
    logic [7:0] LEDs;
    
    Top #(.MEMORY_FILE_LOC("allinstructionsSim.dat")) dut(.*);

    always begin
        clkIn = 0;
        #halfClk;
        $display("Clock\n");
        clkIn = 1;
        #halfClk;
    end
    initial begin
        // Instruction test
        #(halfClk * 349);
        
        // IO test
        inputSwitches = 8'b00000000;
        #(halfClk * 10);
        inputSwitches = 8'b00000001;
        #(halfClk * 10);
        inputSwitches = 8'b11111111;
        #(halfClk * 10);

        // Reset test
        rst = 1;
        #(halfClk * 20);
        rst = 0;

        // Manual clock test
        clkEnable = 0;
        for (int i = 0; i < 20; i++) begin
            manualClk = 1;
            #halfClk;
            manualClk = 0;
            #halfClk;
        end

    end
endmodule
