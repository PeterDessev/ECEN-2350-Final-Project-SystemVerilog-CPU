`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 02:11:28 PM
// Design Name: 
// Module Name: controlUnit_t
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


module controlUnit_t #(
    parameter INSTRUCTION_WIDTH = 32, 
    parameter BUS_WIDTH = 8,
    parameter ALU_OP_CODE_WIDTH = 4,
    parameter ALU_STATUS_WIDTH = 4,
    localparam INST_REG_WIDTH = $clog2(INSTRUCTION_WIDTH / BUS_WIDTH)
    ) (
    input logic [7:0] InstructionCode,
    input logic [ALU_STATUS_WIDTH - 1:0] ALUStatus,
    input logic clk,
    output logic registerFileWrite,
    output logic programCounterEnable,
    output logic ALUSourceControlA,
    output logic memoryWriteControl,
    output logic [INST_REG_WIDTH - 1:0] instructionRegWrite,
    output logic [1:0]ALUSourceControlB,
    output logic [ALU_OP_CODE_WIDTH - 1:0] aluOpCode,
    output logic memoryAddressSelect,
    output logic [1:0] programCounterSourceSelect,
    output logic regFileInputCSourceSelect,
    output logic regFileWriteDataSourceSelect
    );

    typedef enum {
        load0,
        load1,
        load2,
        load3,
        decode,
        singleArgArithOp,
        singleArgMemOp,
        singleArgInstOp,
        doubleArgMemOp,
        doubleArgInstOp,
        store,
        load,
        writeToReg,
        trippleArgArithOp,
        storeTrippleArg,
        writeAluToRegister
    } states;
    states currentState = load0;
    states nextState = load0;
    
    
    
    logic PCWrite = 1'b0;
    logic branch = 1'b0;
    assign programCounterEnable = PCWrite || (branch && ALUStatus[1]);

    always @(posedge(clk)) begin
        currentState = nextState;
    end
    
    always_comb begin
        PCWrite = 1'b1;
        memoryAddressSelect = 1'b0;
        memoryWriteControl = 1'b0;
        instructionRegWrite = 4'b0001;
        memoryWriteControl = 1'b0;
        regFileInputCSourceSelect = 1'b1;
        regFileWriteDataSourceSelect = 1'b0;
        registerFileWrite = 1'b0;
        ALUSourceControlA = 1'b0;
        ALUSourceControlB = 2'b01;
        aluOpCode = {ALU_OP_CODE_WIDTH{1'b0}};
        programCounterSourceSelect = 4'b0001;
        nextState = load1;
        branch = 1'b0;
    
        case (currentState)
            load0: begin 
                PCWrite = 1'b1;
                memoryAddressSelect = 1'b0;
                memoryWriteControl = 1'b0;
                instructionRegWrite = 4'b0001;
                memoryWriteControl = 1'b0;
                regFileInputCSourceSelect = 1'b1;
                regFileWriteDataSourceSelect = 1'b0;
                registerFileWrite = 1'b0;
                ALUSourceControlA = 1'b0;
                ALUSourceControlB = 2'b01;
                aluOpCode = {ALU_OP_CODE_WIDTH{1'b0}};
                programCounterSourceSelect = 4'b0001;
                nextState = load1;
                branch = 1'b0;
            end

            load1: begin
                instructionRegWrite = 4'b0010;
                nextState = load2;
            end

            load2: begin
                instructionRegWrite = 4'b0100;
                nextState = load3;
            end

            load3: begin
                instructionRegWrite = 4'b1000;
                nextState = decode;
            end

            decode: begin
                PCWrite = 1'b0;
                instructionRegWrite = 4'b0000;
                ALUSourceControlB = 2'b11;
                aluOpCode = 2'b00;
                case(InstructionCode[7-:3])
                    3'b000: begin // trippleArgArithOp
                        // ALUSourceControlA = 1'b1;
                        // ALUSourceControlB = 2'b10;
                        // aluOpCode = 2'b00;
                        nextState = trippleArgArithOp;
                    end

                    3'b001: begin // doubleArgInstOp (beq)
                        // ALUSourceControlA = 1'b1;
                        // ALUSourceControlB = 2'b00;
                        // aluOpCode = 2'b01;
                        // branch = 1;
                        // PCSrc = 2'b01;
                        nextState = doubleArgInstOp;
                    end

                    3'b010: begin // doubleArgMemOp
                        // ALUSourceControlA = 1'b1;
                        // ALUSourceControlB = 2'b10;
                        // aluOpCode = 2'b00;
                        nextState = doubleArgMemOp;
                    end

                    3'b011: begin // singleArgArithOp
                        nextState = singleArgArithOp;
                    end

                    3'b100: begin // singleArgInstOp
                        nextState = singleArgInstOp;
                    end

                    3'b101: begin // singleArgMemOp
                        nextState = singleArgMemOp;
                    end

                    default: begin
                        nextState = load0;
                    end
                endcase
            end

            trippleArgArithOp: begin
                ALUSourceControlA = 1'b1;
                ALUSourceControlB = 2'b00;
                nextState = storeTrippleArg;
                case(InstructionCode[5:0])
                    6'b000000: begin // add
                        aluOpCode = 4'b0000;
                    end

                    6'b000001: begin // sub
                        aluOpCode = 4'b0001;
                    end

                    6'b000010: begin // and
                        aluOpCode = 4'b0100;
                    end

                    6'b000011: begin // or
                        aluOpCode = 4'b0101;
                    end

                    6'b000100: begin // xor
                        aluOpCode = 4'b0111;
                    end

                    default: begin
                        nextState = load0;
                    end
                endcase
            end

            storeTrippleArg: begin
                regFileInputCSourceSelect = 1'b0;
                registerFileWrite = 1'b1;
                regFileWriteDataSourceSelect = 1'b0;
                nextState = load0;
            end

            doubleArgInstOp: begin
                ALUSourceControlA = 1'b1;
                ALUSourceControlB = 2'b00;
                aluOpCode = 4'b0001;
                branch = 1'b1;
                programCounterSourceSelect = 2'b01; 
                nextState = load0;
            end
            
            doubleArgMemOp: begin
                ALUSourceControlA = 1'b1;
                ALUSourceControlB = 2'b10;
                aluOpCode = 4'b0000;
                case(InstructionCode[5:0])
                    6'b000000: begin // st
                        nextState = store;
                    end

                    6'b000001: begin // ld
                        nextState = load;
                    end

                    default: begin
                        nextState = load0;
                    end
                endcase
            end

            singleArgArithOp: begin
                ALUSourceControlA = 1'b1;
                ALUSourceControlB = 2'b00;
                nextState = writeAluToRegister;
            end

            writeAluToRegister: begin
                regFileInputCSourceSelect = 1'b1;
                regFileWriteDataSourceSelect = 1'b1;
                nextState = load0;
            end

            singleArgInstOp: begin
                PCWrite = 1'b1;
                programCounterSourceSelect = 2'b10;
            end

            singleArgMemOp: begin
                ALUSourceControlA = 1'b1;
                ALUSourceControlB = 2'b10;
                aluOpCode = 4'b0000;
                case(InstructionCode[5:0])
                    6'b000000: begin // st
                        nextState = store;
                    end

                    6'b000001: begin // ld
                        nextState = load;
                    end

                    default: begin
                        nextState = load0;
                    end
                endcase
            end
            // singleArg: begin
            //     if (InstructionCode[5] == 1'b1) begin // Single argument non arithmetic operation
            //         case(InstructionCode[5:0])
            //             6'b100110: begin // jmp
            //                 PCWrite = 1'b1;
            //                 programCounterSourceSelect = 2'b10;
            //                 nextState = load0;
            //             end

            //             6'b100111: begin // sti
            //                 programCounterSourceSelect = 2'b10;
            //                 nextState = load0;
            //             end

            //             6'b101000: begin // ldi
            //                 PCWrite = 1'b1;
            //                 programCounterSourceSelect = 2'b10;
            //                 nextState = load0;
            //             end
            //         endcase
                    
            //     else // Single argument arithmetic operation
            //         ALUSourceControlA = 1'b1;
            //         ALUSourceControlB = 2'b00;
            //         nextState = storeSingleArithmatic;
            //         case (InstructionCode[5:0])
            //             6'b000001: // inc
            //                 aluOpCode = 4'b0010;

            //             6'b000010: // dec
            //                 aluOpCode = 4'b0011;

            //             6'b000011: // not
            //                 aluOpCode = 4'b0110;

            //             6'b000100: // shl
            //                 aluOpCode = 4'b1000;

            //             6'b000101: // shr
            //                 aluOpCode = 4'b1001;
            //         endcase
            //     end
            // end

            // storeSingleArithmatic: begin
            //     regFileWriteDataSourceSelect = 2'b00;
            //     registerFileWrite = 1'b1;
            //     nextState = load0;
            // end

            // doubleArg: begin
            //     ALUSourceControlA = 1'b1;
            //     aluOpCode = 4'b0000;
            //     case (InstructionCode[5:0])
            //         6'b000000: begin // beq
            //             ALUSourceControlB = 2'b00;
            //             aluOpCode = 4'b0001;
            //             branch = 1'b1;
            //             programCounterSourceSelect = 2'b01; 
            //             nextState = load0;
            //         end

            //         6'b000001: begin // st
            //             ALUSourceControlB = 2'b10;
            //             nextState = store;
            //         end

            //         6'b000010: begin // ld
            //             ALUSourceControlB = 2'b10;
            //             nextState = load;
            //         end
            //     endcase 
            // end
                
            store: begin
                memoryWriteControl = 1'b1;
                memoryAddressSelect = 1'b1;
                nextState = load0;
            end
                
            load: begin
                memoryAddressSelect = 1'b1;
                nextState = writeToReg;
            end
                
            writeToReg: begin
                regFileWriteDataSourceSelect = 1'b1;
                registerFileWrite = 1'b1;
                regFileInputCSourceSelect = 1'b1;
                nextState = load0;
            end

            default: begin
                nextState = load0;
            end
        endcase
    end
endmodule
