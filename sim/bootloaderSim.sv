`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// 
// Create Date: 12/21/2023 10:31:44 AM
// Description: 
//////////////////////////////////////////////////////////////////////////////////
// `define inputInstruction(ZERO, ONE, TWO, THREE) \ 
//    inputSwitches = ZERO;
//     buttons = 5'b01000;
//     #(28 * halfClk);
//     inputSwitches = ONE;
//     #(28 * halfClk);
//     inputSwitches = TWO;
//     #(28 * halfClk);
//     inputSwitches = THREE;
//     #(28 * halfClk); 

module bootloaderSim(

    );
    parameter halfClk = 0.1;

    logic [7:0] inputSwitches = 0;
    logic [4:0] buttons = 0;
    logic clkIn;
    logic rst = 1;
    logic clkEnable = 1;
    logic manualClk = 0;

    logic [6:0] segment;
    logic [3:0] segSelect;
    logic [7:0] LEDs;
    logic [7:0] DEBUG;
    
    Top #(.MEMORY_FILE_LOC("bootloader.dat")) dut(.*);

    always begin
        clkIn = 0;
        #halfClk;
        // $display("Clock\n");
        clkIn = 1;
        #halfClk;
    end

    initial begin
        #1;
        rst = 0;
    
        // Wait
        #(129 * halfClk);

        // inputInstruction(2'hA1, 2'h01, 2'h00, 2'h01); // ldi $1 1           | 11
        inputSwitches = 'hA1;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest
        
        inputSwitches = 'h01; 
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest
        
        inputSwitches = 'h00;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest
        
        inputSwitches = 'h01;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest

        // inputInstruction(2'hA1, 2'h02, 2'h00, 2'h02); // ldi $2 2        | 
        // inputInstruction(2'h00, 2'h15, 2'h90, 2'h00); // add $9 $1 $5       | 12
        inputSwitches = 'h00;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest
        
        inputSwitches = 'h15;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest
        
        inputSwitches = 'h90;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest
        
        inputSwitches = 'h00;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest

        // inputInstruction(2'h80, 2'h00, 2'h00, 2'h0B); // jmp 11             | 13
        inputSwitches = 'h80;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest
        
        inputSwitches = 'h00;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest
        
        inputSwitches = 'h00;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest
        
        inputSwitches = 'h0B;
        buttons = 5'b01000;
        #(12 * halfClk); // Hit beq
        buttons = 5'b00000;
        #(64 * halfClk); // Do the rest
        
        buttons = 5'b00100;
        #(20 * halfClk);

        for(;;) begin
            for (int i = 0; i < 'hFF; i++) begin
                inputSwitches = i;
                #(64 * halfClk);
            end
        end
    end
endmodule
