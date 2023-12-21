`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 02:11:28 PM
// Design Name: 
// Module Name: Top
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


module Top #(parameter MEMORY_FILE_LOC = "") (
    input [7:0] inputSwitches,
    input [4:0] buttons,
    input clkIn,
    input rst,
    input clkEnable,
    input manualClk,
    output [6:0] segment,
    output [3:0] segSelect,
    output [7:0] LEDs
    );

    parameter int busWidth = 8;
    parameter int instructionWidth = 32;
    parameter int memoryBytes = 150;
    parameter int ALUOpCodeWidth = 4;
    parameter int ALUStatusWidth = 4;
    parameter int registerAddressWidth = 4;

    // Divided Clock
    logic clk;
    assign clk = clkEnable ? clkIn : manualClk;

    // Register enable logic
    logic programCounterEnable;
    logic registerFileWrite;

    // ALU
    logic [ALUStatusWidth - 1:0]ALUStatus;
          
    // Register input logic
    logic [busWidth - 1:0] pcNext;
    logic [busWidth - 1:0] memoryOut;
    logic [busWidth - 1:0] ALUout;
    
    // Register output logic
    logic [busWidth - 1:0] pcOut;
    logic [busWidth - 1:0] memDataRegOut;
    logic [busWidth - 1:0] RegFileADataOut;
    logic [busWidth - 1:0] RegFileBDataOut;
    logic [busWidth - 1:0] aluResultOut;
    logic [busWidth - 1:0] registerFileResultA;
    logic [busWidth - 1:0] registerFileResultB;

    // ALU inputs
    logic [busWidth - 1:0] aluInputA;
    logic [busWidth - 1:0] aluInputB;
    logic [ALUOpCodeWidth - 1:0] aluOpCode;
    logic ALUSourceControlA;
    logic [1:0]ALUSourceControlB;

    // Memory
    logic [busWidth - 1:0] memoryAddress;
    logic memoryWriteControl;
    logic memoryAddressSelect;
    logic [busWidth - 1:0]memoryWriteData;
    logic memoryWriteDataSelect;

    // PC
    logic [1:0]programCounterSourceSelect;

    // Register Multiplexors
    logic regFileInputCSourceSelect;
    logic regFileWriteDataSourceSelect;

    logic [registerAddressWidth - 1:0]regFileInputC;
    logic [busWidth - 1:0]regFileWriteData;
    
    // Non-register file registers
    register #(.BIT_WIDTH(busWidth)) programCounter(
        .writeEnable(programCounterEnable),
        .clk(clk),
        .inData(pcNext),
        .outData(pcOut)
    );

    // TODO COMPLETE
    // TODO: implement super-register for instructions
    // register #(.BIT_WIDTH(instructionWidth)) instructionReg(
    //     .writeEnable(instructionRegEnable),
    //     .clk(clk),
    //     .inData(memoryOut),
    //     .outData(instruction)
    // );

    // Instruction register(s)
    logic [(instructionWidth / busWidth) - 1:0] instructionRegWrite;
    logic [31:0] instruction;
    genvar i;
    generate 
        for(i = 0; i < (instructionWidth / busWidth); i++) begin
            register #(.BIT_WIDTH(busWidth)) instructionRegI(
                .writeEnable(instructionRegWrite[(instructionWidth / busWidth) - 1 - i]),
                .clk(clk),
                .inData(memoryOut),
                .outData(instruction[(i + 1) * busWidth - 1 : i * busWidth])
            );
        end
    endgenerate


    register #(.BIT_WIDTH(busWidth)) memDataReg(
        .writeEnable(1'b1),
        .clk(clk),
        .inData(memoryOut),
        .outData(memDataRegOut)
    );
    register #(.BIT_WIDTH(busWidth)) ALUResult(
        .writeEnable(1'b1),
        .clk(clk),
        .inData(ALUout),
        .outData(aluResultOut)
    );
    
    // Register file buffer registers
    register #(.BIT_WIDTH(busWidth)) registerFileOutA(
        .writeEnable(1'b1),
        .clk(clk),
        .inData(registerFileResultA),
        .outData(RegFileADataOut)
    );
    register #(.BIT_WIDTH(busWidth)) registerFileOutB(
        .writeEnable(1'b1),
        .clk(clk),
        .inData(registerFileResultB),
        .outData(RegFileBDataOut)
    );

    // Muxes
    // genericMux #(.WIDTH(busWidth), .NUMBER(2)) PCMux(
    //     .sel(ALUSourceControlA),
    //     .mux_in({aluResultOut, pcOut}),
    //     .out(memoryAddress)
    // );
    genericMux #(.WIDTH(busWidth), .NUMBER(2)) ALUSourceAMux(
        .sel(ALUSourceControlA),
        .mux_in({RegFileADataOut, pcOut}),
        .out(aluInputA)
    );
    genericMux #(.WIDTH(busWidth), .NUMBER(4)) ALUSourceBMux(
        .sel(ALUSourceControlB),
        .mux_in({{instruction[busWidth - 3 : 0], 2'b0}, instruction[busWidth - 1:0], {{(busWidth - 1){1'b0}}, 1'b1}, RegFileBDataOut}),
        .out(aluInputB)
    );
    genericMux #(.WIDTH(busWidth), .NUMBER(2)) memoryAddressMux(
        .sel(memoryAddressSelect),
        .mux_in({aluResultOut, pcOut}),
        .out(memoryAddress)
    );
    genericMux #(.WIDTH(busWidth), .NUMBER(4)) PCMux(
        .sel(programCounterSourceSelect),
        .mux_in({{busWidth{1'bz}}, {instruction[busWidth - 3 : 0], 2'b0}, aluResultOut, ALUout}),
        .out(pcNext)
    );
    genericMux #(.WIDTH(registerAddressWidth), .NUMBER(2)) regFileCInputMux(
        .sel(regFileInputCSourceSelect),
        .mux_in({instruction[19:16], instruction[15:12]}),
        .out(regFileInputC)
    );
    genericMux #(.WIDTH(busWidth), .NUMBER(2)) regFileDataWriteMux(
        .sel(regFileWriteDataSourceSelect),
        .mux_in({memDataRegOut, aluResultOut}),
        .out(regFileWriteData)
    );
    genericMux #(.WIDTH(busWidth), .NUMBER(2)) memoryWriteDataMux(
        .sel(memoryWriteDataSelect),
        .mux_in({instruction[busWidth - 1:0], RegFileBDataOut}),
        .out(memoryWriteData)
    );
    
    ALU_t #(.BIT_WIDTH(busWidth), 
            .OP_CODE_WIDTH(ALUOpCodeWidth),
            .STATUS_WIDTH(ALUStatusWidth)) alu(
        .a(aluInputA),
        .b(aluInputB),
        .op(aluOpCode),
        .q(ALUout),
        .status(ALUStatus)
    );

    registerFile_t #(.BIT_WIDTH(busWidth), .REGISTER_COUNT(4), .registerAddressWidth(registerAddressWidth)) registerFile(
            .inAddrA(instruction[23:20]),
            .inAddrB(instruction[19:16]),
            .inAddrC(regFileInputC),
            .inData(regFileWriteData),
            .writeEnable(registerFileWrite),
            .clk(clk),
            .outDataA(registerFileResultA),
            .outDataB(registerFileResultB),
            .inputSwitches(inputSwitches), 
            .buttons(buttons), 
            .segment(segment), 
            .segSelect(segSelect), 
            .LEDs(LEDs)
    );
    
    memory_t #(.BUS_WIDTH(busWidth), .MEM_INIT_FILE(MEMORY_FILE_LOC)) memory(
        .address(memoryAddress),
        .writeData(memoryWriteData),
        .writeEnable(memoryWriteControl),
        .clk(clk),
        .readData(memoryOut)
    );
    
    logic [7:0]InstructionCode;
    assign InstructionCode = instruction[31:24];
    controlUnit_t controlUnit(.*);
    always @(posedge(clk)) begin

    end
    // initial begin
        
    // $display("%d, %d", ((instructionWidth / busWidth)) * busWidth - 1 , (instructionWidth / busWidth - 1) * busWidth);
    // end
endmodule
