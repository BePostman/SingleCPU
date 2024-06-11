module instr_memory(
	input	wire	[7:0]	addr,
	output	wire	[31:0]	instr
);
	
	reg[31:0] rom[31:0];
	
    initial begin
        $readmemh("E:/Xilinx_FPGA/SingleCPU/one16.txt", rom);
    end
	
    assign instr = rom[addr];

endmodule
	
	
	
	