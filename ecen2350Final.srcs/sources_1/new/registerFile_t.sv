`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ben Jacobsen, Peter Dessev
// 
// Create Date: 12/12/2023 03:53:09 PM
// Module Name: registerFile_t
// Description: A register file which takes the input of two register addresses for reading and one register address for writing, the clock, and the write enable. When write enable is high, the input 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module registerFile_t #(parameter BIT_WIDTH = 8, 
                        parameter REGISTER_COUNT = 4)(
    input [$clog2(REGISTER_COUNT):0]inAddrA,
    input [$clog2(REGISTER_COUNT):0]inAddrB,
    input [$clog2(REGISTER_COUNT):0]inAddrC,
    input [BIT_WIDTH - 1:0]inData,
    input writeEnable,
    input clk,
    output logic [BIT_WIDTH - 1:0]outDataA,
    output logic [BIT_WIDTH - 1:0]outDataB
    );
    // parameter int register
    // DFF flipFlopZero(.data(write[0]), .clk(clk), .Q(read[0]));

    logic [REGISTER_COUNT - 1: 0][BIT_WIDTH - 1 : 0]registerOutputLogic;
    logic [REGISTER_COUNT - 1: 0][BIT_WIDTH - 1 : 0]registerInputLogic;
    logic [REGISTER_COUNT - 1 : 0]registerWriteEnableLogic;

    genvar i;
    generate
        for (i = 0; i < REGISTER_COUNT - 1; i ++) begin
            register #(.BIT_WIDTH(BIT_WIDTH)) registerI(
                .writeEnable(registerWriteEnableLogic[i]),
                .clk(clk),
                .inData(registerInputLogic[i]),
                .outData(registerOutputLogic[i])
            );
        end
    endgenerate;

//    genericMux #(.WIDTH(BIT_WIDTH), .NUMBER(REGISTER_COUNT)) aMux(.sel(inAddrA), registerOutputLogic, outDataA);
//    genericMux #(.WIDTH(BIT_WIDTH), .NUMBER(REGISTER_COUNT)) bMux(.sel(inAddrB), registerOutputLogic, outDataB);

//    genericMux #(.WIDTH(BIT_WIDTH), .NUMBER(REGISTER_COUNT)) cMux(.sel(inAddrC), registerInputLogic, outDataA);
    assign outDataA = writeEnable == 0 ? registerOutputLogic[inAddrA] : {BIT_WIDTH{1'b0}};
    assign outDataB = writeEnable == 0 ? registerOutputLogic[inAddrB] : {BIT_WIDTH{1'b0}};
    genericDeMux #(.WIDTH(BIT_WIDTH), 
                   .NUMBER(REGISTER_COUNT)
                  ) writeDataDeMux(
                        .sel(inAddrC), 
                        .in(inData), 
                        .enable(1),
                        .deMuxOut(registerInputLogic)
                    );

    genericDeMux #(.WIDTH(1),
                   .NUMBER(REGISTER_COUNT)
                  ) writeEnableDeMux(
                        .sel(inAddrC), 
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
