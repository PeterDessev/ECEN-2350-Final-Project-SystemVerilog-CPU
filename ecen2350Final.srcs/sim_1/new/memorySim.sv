Module memorySim(

	);

	parameter int busWidth = 4;
	parameter int numBytes = (2 ** busWidth - 1);

	logic [busWidth-1:0] address, writeData, readData;
	logic writeEnable, clk;

	memory_t #(.BUS_WIDTH(busWidth), .NUM_BYTES(nuBytes)) dut(.*);

	always begin
		clk = 0;
		#5;
		clk = 1;
		#5;
	end

	initial begin

	address=0; writeData=0; writeEnable=0;
	#5;
	
	address=0; writeData=13; writeEnable=0;
	#10;
	address=1; writeData=43; writeEnable=1;
	#10;
	address=2; writeData=22; writeEnable=1;
	#10;
	address=3; writeData=5; writeEnable=1;
	#10;	
	wrtieEnable=0;

	address = 0;
	#10;
	address = 1;
	#10;
	address = 2;
	#10;
	address = 3;

	end
endmodule
