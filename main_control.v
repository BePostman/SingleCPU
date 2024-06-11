module main_control(
	input 	wire	[6:0]	opcode,
	input 	wire	[2:0]	func3,
	        
	output  wire	 		MemRead,
	output  wire 			MemtoReg,
	output  wire 	[1:0]	ALUop,
	output  wire 			MemWrite,
	output  wire 			ALUSrc,
	output  wire 			RegWrite,
	output  wire 			lui,
	output  wire 			U_type,
	output  wire			jal,
	output  wire 			jalr,
	output  wire 			beq,
	output  wire 			bne,
	output  wire 			blt,
	output  wire 			bge,
	output  wire 			bltu,
	output  wire 			bgeu,
	output  wire 	[2:0]	RW_type
);
	
	
	wire branch;
	wire R_type;
	wire I_type;
	wire load;
	wire store;
	wire auipc;

	assign branch=(opcode==`B_type)?1'b1:1'b0;
	assign R_type=(opcode==`R_type)?1'b1:1'b0;
	assign I_type=(opcode==`I_type)?1'b1:1'b0;
	assign U_type=(lui | auipc)? 1'b1:1'b0;
	assign load=(opcode==`load)?1'b1:1'b0;
	assign store=(opcode==`store)?1'b1:1'b0;
	
	assign jal=(opcode==`jal)?1'b1:1'b0;
	assign jalr=(opcode==`jalr)?1'b1:1'b0;
	assign lui=(opcode==`lui)?1'b1:1'b0;
	assign auipc=(opcode==`auipc)?1'b1:1'b0;
	assign beq= branch & (func3==3'b000);
	assign bne= branch & (func3==3'b001);
	assign blt= branch & (func3==3'b100);
	assign bge= branch & (func3==3'b101);
	assign bltu= branch & (func3==3'b110);
	assign bgeu= branch & (func3==3'b111);
	assign RW_type=func3;
	
	assign MemRead= load;
	assign MemWrite= store;
	assign RegWrite= jal| jalr | load | I_type |R_type | U_type;
	
	assign ALUSrc=load | store |I_type | jalr;
	assign MemtoReg= load;
	
	assign ALUop[1]= R_type|branch;
	assign ALUop[0]= I_type|branch;
	
endmodule
