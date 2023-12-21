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
`define setZeros() \
    PCWrite = 1'b0; \
    memoryAddressSelect = 1'b0; \
    memoryWriteControl = 1'b0; \
    instructionRegWrite = 4'b0000; \
    memoryWriteControl = 1'b0; \
    regFileInputCSourceSelect = 1'b0; \
    regFileWriteDataSourceSelect = 1'b0; \
    registerFileWrite = 1'b0; \
    ALUSourceControlA = 1'b0; \
    ALUSourceControlB = 2'b00; \
    aluOpCode = {ALU_OP_CODE_WIDTH{1'b0}}; \
    programCounterSourceSelect = 2'b00; \
    branch = 1'b0; \
    memoryWriteDataSelect = 1'b0; \
    nextState = load0; 

module controlUnit_t #(
    parameter INSTRUCTION_WIDTH = 32, 
    parameter BUS_WIDTH = 8,
    parameter ALU_OP_CODE_WIDTH = 4,
    parameter ALU_STATUS_WIDTH = 4,
    localparam INST_REG_WIDTH = (INSTRUCTION_WIDTH / BUS_WIDTH)
    ) (
    input logic [7:0] InstructionCode,
    input logic [ALU_STATUS_WIDTH - 1:0] ALUStatus,
    input logic clk,
    input rst,

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
    output logic regFileWriteDataSourceSelect,
    output logic memoryWriteDataSelect
    );

    typedef enum {
        start,
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
        storeTrippleArgArith,
        storeSingleArgArith
    } states;
    states currentState = start;
    states nextState = start;
    
    logic PCWrite = 1'b0;
    logic branch = 1'b0;
    assign programCounterEnable = PCWrite || (branch && ALUStatus[1]);

    always @(posedge clk) begin // or posedge rst) begin
        currentState = rst ? load0 : nextState;
    end
    
    // initial begin
    // logic memoryAddressSelect = 1'b0;
    // logic memoryWriteControl = 1'b0;
    // logic [INST_REG_WIDTH - 1:0] instructionRegWrite = 4'b0001;
    // logic regFileInputCSourceSelect = 1'b1;
    // logic regFileWriteDataSourceSelect = 1'b0;
    // logic registerFileWrite = 1'b0;
    // logic ALUSourceControlA = 1'b0;
    // logic [1:0] ALUSourceControlB = 2'b01;
    // logic [ALU_OP_CODE_WIDTH - 1:0] aluOpCode = {ALU_OP_CODE_WIDTH{1'b0}};
    // logic [1:0] programCounterSourceSelect = 4'b0001;

    // assign memoryAddressSelect = memoryAddressSelect;
    // assign memoryWriteControl = memoryWriteControl;
    // assign instructionRegWrite = instructionRegWrite;
    // assign regFileInputCSourceSelect = regFileInputCSourceSelect;
    // assign regFileWriteDataSourceSelect = regFileWriteDataSourceSelect;
    // assign registerFileWrite = registerFileWrite;
    // assign ALUSourceControlA = ALUSourceControlA;
    // assign ALUSourceControlB = ALUSourceControlB;
    // assign aluOpCode = aluOpCode;
    // assign programCounterSourceSelect = programCounterSourceSelect;
    // end

    always @(*) begin
        case (currentState)
            start: begin
                `setZeros
            end

            load0: begin 
                `setZeros
                PCWrite = 1'b1; 
                instructionRegWrite = 4'b0001; 
                ALUSourceControlB = 2'b01; 
                programCounterSourceSelect = 2'b00; 
                nextState = load1;
            end

            load1: begin
                `setZeros
                PCWrite = 1'b1; 
                ALUSourceControlB = 2'b01; 
                programCounterSourceSelect = 2'b00;
                instructionRegWrite = 4'b0010;
                nextState = load2;
            end

            load2: begin
                `setZeros
                PCWrite = 1'b1; 
                ALUSourceControlB = 2'b01; 
                programCounterSourceSelect = 2'b00;
                instructionRegWrite = 4'b0100;
                nextState = load3;
            end

            load3: begin
                `setZeros
                PCWrite = 1'b1; 
                ALUSourceControlB = 2'b01; 
                programCounterSourceSelect = 2'b00;
                instructionRegWrite = 4'b1000;
                nextState = decode;
            end

            decode: begin
                `setZeros
                ALUSourceControlB = 2'b11;
                case(InstructionCode[7:5])
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
                `setZeros
                ALUSourceControlA = 1'b1;
                nextState = storeTrippleArgArith;
                case(InstructionCode[4:0])
                    5'b00000: begin // add
                        aluOpCode = 4'b0000;
                    end

                    5'b00001: begin // sub
                        aluOpCode = 4'b0001;
                    end

                    5'b00010: begin // and
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

            storeTrippleArgArith: begin
                `setZeros
                registerFileWrite = 1'b1;
                nextState = load0;
            end

            doubleArgInstOp: begin
                `setZeros
                ALUSourceControlA = 1'b1;
                aluOpCode = 4'b0001;
                branch = 1'b1;
                programCounterSourceSelect = 2'b10; 
                nextState = load0;
            end
            
            doubleArgMemOp: begin
                `setZeros
                ALUSourceControlA = 1'b1;
                ALUSourceControlB = 2'b10;
                case(InstructionCode[4:0])
                    5'b00000: begin // st
                        nextState = store;
                    end

                    5'b00001: begin // ld
                        nextState = load;
                    end

                    default: begin
                        nextState = load0;
                    end
                endcase
            end

            singleArgArithOp: begin
                `setZeros
                ALUSourceControlA = 1'b1;
                ALUSourceControlB = 2'b00;
                nextState = storeSingleArgArith;
                case(InstructionCode[4:0])
                    5'b00000: begin // inc
                        aluOpCode = 4'b0010;
                    end

                    5'b00001: begin // dec
                        aluOpCode = 4'b0011;
                    end

                    5'b00010: begin // not
                        aluOpCode = 4'b0110;
                    end

                    5'b00011: begin // shl
                        aluOpCode = 4'b1000;
                    end

                    5'b00100: begin // shr
                        aluOpCode = 4'b1001;
                    end
                    default: begin
                    end
                endcase
            end

            storeSingleArgArith: begin
                `setZeros
                regFileInputCSourceSelect = 1'b1;
                registerFileWrite = 1'b1;
                nextState = load0;
            end

            singleArgInstOp: begin
                `setZeros
                PCWrite = 1'b1;
                programCounterSourceSelect = 2'b10;
                nextState = load0;
            end

            singleArgMemOp: begin
                `setZeros
                case(InstructionCode[4:0])
                    5'b00000: begin // sti
                        ALUSourceControlA = 1'b1;
                        ALUSourceControlB = 2'b00;
                        nextState = store;
                    end

                    5'b00001: begin // ldi
                        ALUSourceControlA = 1'b1;
                        ALUSourceControlB = 2'b10;
                        nextState = writeToReg;
                    end

                    default: begin
                        nextState = load0;
                    end
                endcase
            end
                
            store: begin
                `setZeros
                memoryWriteControl = 1'b1;
                memoryAddressSelect = 1'b1;
                nextState = load0;
                case(InstructionCode[7:5])
                    3'b010: begin // register
                        nextState = load0;
                    end

                    3'b101: begin // immediate
                        memoryWriteDataSelect = 1'b1;
                        nextState = load0;
                    end

                    default: begin
                        nextState = load0;
                    end
                endcase
            end
                
            load: begin
                `setZeros
                memoryAddressSelect = 1'b1;
                nextState = writeToReg;
            end
                
            writeToReg: begin
                `setZeros
                registerFileWrite = 1'b1;
                regFileInputCSourceSelect = 1'b1;
                case(InstructionCode[7:5])
                    3'b101: // Single argument, load into register from ALU register
                        regFileWriteDataSourceSelect = 1'b0;

                    default:
                        regFileWriteDataSourceSelect = 1'b1;
                endcase
                nextState = load0;
            end

            default: begin
                `setZeros
                nextState = load0;
            end
        endcase
    end
endmodule

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