`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ben Jacobsen, Peter Dessev
// 
// Create Date: 12/12/2023 03:53:09 PM
// Module Name: registerFile_t
// Description: A register file which takes the input of two register addresses for 
//              reading and one register address for writing, the clock, and the write enable. 
//////////////////////////////////////////////////////////////////////////////////

module registerFile_t #(parameter BIT_WIDTH = 8, 
                        parameter REGISTER_COUNT = 4,
                        parameter registerAddressWidth = $clog2(REGISTER_COUNT + 5))(
    input [registerAddressWidth - 1:0]inAddrA,
    input [registerAddressWidth - 1:0]inAddrB,
    input [registerAddressWidth - 1:0]inAddrC,
    input [BIT_WIDTH - 1:0]inData,
    input writeEnable,
    input clk,
    input rst,
    output logic [BIT_WIDTH - 1:0]outDataA,
    output logic [BIT_WIDTH - 1:0]outDataB,
    input [7:0] inputSwitches,
    input [4:0] buttons,
    output logic [6:0] segment,
    output logic [3:0] segSelect,
    output logic [7:0] LEDs,
    output logic [BIT_WIDTH - 1 : 0] debugOut [REGISTER_COUNT - 1 + 5 : 0]
    );
    // parameter int register
    // DFF flipFlopZero(.data(write[0]), .clk(clk), .Q(read[0]));

    logic [REGISTER_COUNT - 1 + 5 : 0][BIT_WIDTH - 1 : 0]registerOutputLogic;
    logic [REGISTER_COUNT - 1 + 5 : 0][BIT_WIDTH - 1 : 0]registerInputLogic;
    logic [REGISTER_COUNT - 1 + 5 : 0]registerWriteEnableLogic;

    assign debugOut[0] = registerOutputLogic[0];
    assign debugOut[1] = registerOutputLogic[1];
    assign debugOut[2] = registerOutputLogic[2];
    assign debugOut[3] = registerOutputLogic[3];
    assign debugOut[4] = registerOutputLogic[4];
    assign debugOut[5] = registerOutputLogic[5];
    assign debugOut[6] = registerOutputLogic[6];
    assign debugOut[7] = registerOutputLogic[7];
    assign debugOut[8] = registerOutputLogic[8];
    // assign debugOut[9] = registerOutputLogic[9];

    genvar i;
    generate
        for (i = 0; i < REGISTER_COUNT; i++) begin
            register #(.BIT_WIDTH(BIT_WIDTH)) registerI(
                .writeEnable(registerWriteEnableLogic[i]),
                .clk(clk),
                .rst(rst),
                .inData(registerInputLogic[i]),
                .outData(registerOutputLogic[i])
            );
        end
    endgenerate;


    // Input registers
    // assign registerInputLogic[REGISTER_COUNT + 0] = inputSwitches;
    register #(.BIT_WIDTH(BIT_WIDTH)) switchRegister(
        .writeEnable(1'b1),
        .clk(clk),
        .rst(rst),
        .inData(inputSwitches),
        .outData(registerOutputLogic[REGISTER_COUNT + 0])
    );

    // assign registerInputLogic[REGISTER_COUNT + 1] = {3'bz, buttons};
    register #(.BIT_WIDTH(BIT_WIDTH)) buttonRegister(
        .writeEnable(1'b1),
        .clk(clk),
        .rst(rst),
        .inData({3'b0, buttons}),
        .outData(registerOutputLogic[REGISTER_COUNT + 1])
    );


    // Output registers
    register #(.BIT_WIDTH(BIT_WIDTH)) segmentRegister(
        .writeEnable(registerWriteEnableLogic[REGISTER_COUNT + 2]),
        .clk(clk),
        .rst(rst),
        .inData(registerInputLogic[REGISTER_COUNT + 2]),
        .outData(registerOutputLogic[REGISTER_COUNT + 2])
    );
    assign segment = registerOutputLogic[REGISTER_COUNT + 2][6:0];

    register #(.BIT_WIDTH(BIT_WIDTH)) segmentSelectionRegister(
        .writeEnable(registerWriteEnableLogic[REGISTER_COUNT + 3]),
        .clk(clk),
        .rst(rst),
        .inData(registerInputLogic[REGISTER_COUNT + 3]),
        .outData(registerOutputLogic[REGISTER_COUNT + 3])
    );
    assign segSelect = registerOutputLogic[REGISTER_COUNT + 3][3:0];

    register #(.BIT_WIDTH(BIT_WIDTH)) ledRegister(    
        .writeEnable(registerWriteEnableLogic[REGISTER_COUNT + 4]),
        .clk(clk),
        .rst(rst),
        .inData(registerInputLogic[REGISTER_COUNT + 4]),
        .outData(registerOutputLogic[REGISTER_COUNT + 4])
    );
    assign LEDs = registerOutputLogic[REGISTER_COUNT + 4];

//    genericMux #(.WIDTH(BIT_WIDTH), .NUMBER(REGISTER_COUNT)) aMux(.sel(inAddrA), registerOutputLogic, outDataA);
//    genericMux #(.WIDTH(BIT_WIDTH), .NUMBER(REGISTER_COUNT)) bMux(.sel(inAddrB), registerOutputLogic, outDataB);

//    genericMux #(.WIDTH(BIT_WIDTH), .NUMBER(REGISTER_COUNT)) cMux(.sel(inAddrC), registerInputLogic, outDataA);
    assign outDataA = !writeEnable && inAddrA > 0 ? registerOutputLogic[inAddrA - 1] : {BIT_WIDTH{1'b0}};
    assign outDataB = !writeEnable && inAddrB > 0 ? registerOutputLogic[inAddrB - 1] : {BIT_WIDTH{1'b0}};

    // Subtracting one allows to have 8 registers and a 0 register without requiring 5 bits
    genericDeMux #(.WIDTH(BIT_WIDTH), 
                   .NUMBER(REGISTER_COUNT + 5)
                  ) writeDataDeMux(
                        .sel(inAddrC - 1'b1), 
                        .in(inData), 
                        .enable(writeEnable),
                        .deMuxOut(registerInputLogic)
                    );

    genericDeMux #(.WIDTH(1),
                   .NUMBER(REGISTER_COUNT + 5)
                  ) writeEnableDeMux(
                        .sel(inAddrC - 1'b1), 
                        .in(writeEnable),
                        .enable(writeEnable),
                        .deMuxOut(registerWriteEnableLogic) 
                    );
                    
//    assign registerInputLogic[inAddrC] = inData;
    always @(posedge(clk)) begin
        
//         for(int i = 0; i < REGISTER_COUNT; i++) begin
//             if (i == inAddrA) 
//                 outDataA <= registerOutputLogic[i * BIT_WIDTH + (BIT_WIDTH - 1) : i * BIT_WIDTH];
//         end

//         outDataA <= {>>{registerOutputLogic with [inAddrA * BIT_WIDTH + (BIT_WIDTH - 1) : inAddrA * BIT_WIDTH]}};
//         outDataA <= registerOutputLogic[inAddrA * BIT_WIDTH + (BIT_WIDTH - 1) : inAddrA * BIT_WIDTH];
//         outDataB <= registerOutputLogic[inAddrB * BIT_WIDTH + (BIT_WIDTH - 1) : inAddrB * BIT_WIDTH];

//         if (writeEnable) begin
//             registerInputLogic[inAddrC * BIT_WIDTH + (BIT_WIDTH - 1) : inAddrC * BIT_WIDTH] <= inData;
//         end
    end
endmodule
