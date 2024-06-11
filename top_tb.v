`timescale 1ns / 1ps

module top_tb;

	reg clk;
	reg rst_n;

	wire [7:0] rom_addr;

	top top (
		.clk(clk), 
		.rst_n(rst_n), 
		.rom_addr(rom_addr)
	);
	always #10 clk= ~clk;
	initial begin
		clk = 1;
		rst_n = 0;
		
		#20;
		rst_n=1;
	end
      
endmodule

