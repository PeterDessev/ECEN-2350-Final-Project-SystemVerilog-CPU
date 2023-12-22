`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ben Jacobsen, Peter Dessev
// 
// Create Date: 12/15/2023 10:40:54 AM
// Description: Memory module for the BP1 processor. Writing is clocked and write 
//              protected, reading is asynchronous.
//////////////////////////////////////////////////////////////////////////////////


module memory_t #(parameter BUS_WIDTH=8,
                  parameter NUM_BYTES=(2 ** BUS_WIDTH - 1),
                  parameter MEM_INIT_FILE = "") (
    input [BUS_WIDTH - 1:0] address,
    input [BUS_WIDTH - 1:0] writeData,
    // input [BUS_WIDTH - 1:0] debugAddress,
    input writeEnable,
    input clk,
    output logic [BUS_WIDTH - 1:0] readData
    // output logic [BUS_WIDTH - 1:0] debugOut
    );

    logic [7:0]memoryCell[NUM_BYTES : 0];

    initial begin
        if (MEM_INIT_FILE != "") begin
            $readmemh(MEM_INIT_FILE, memoryCell);
        end
    end

    assign readData = memoryCell[address];
    // assign debugOut = memoryCell[debugAddress];
    always @(posedge(clk)) begin
        memoryCell[address] <= writeEnable ? writeData : memoryCell[address];
        if(writeEnable) begin
            $display("Memory: Writing %h to address %h", writeData, address);
        end
    end
endmodule
