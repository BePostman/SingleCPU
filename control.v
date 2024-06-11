`include "define.v"

module control(
	input 	 wire	[6:0]	opcode,
	input 	 wire	[2:0]	func3,
	input 	 wire	func7,
	
	
	output   wire	MemRead,
	output   wire	MemtoReg,
	output   wire	MemWrite,
	output   wire	ALUSrc,
	output   wire	RegWrite,
	output   wire	lui,
	output   wire	U_type,
	output   wire	jal,
	output   wire	jalr,
	output   wire	beq,
	output   wire	bne,
	output   wire	blt,
	output   wire	bge,
	output   wire	bltu,
	output   wire	bgeu,
	output   wire	[2:0]	RW_type,
	output   wire	[3:0]	ALUctl

);

	wire [1:0]ALUop;
	
	main_control main_control_inst(
	.opcode(opcode),
	.func3(func3),
	.MemRead(MemRead),
	.MemtoReg(MemtoReg),
	.ALUop(ALUop),
	.MemWrite(MemWrite),
	.ALUSrc(ALUSrc),
	.RegWrite(RegWrite),
	.lui(lui),
	.U_type(U_type),
	.jal(jal),
	.jalr(jalr),
	.beq(beq),
	.bne(bne),
	.blt(blt),
	.bge(bge),
	.bltu(bltu),
	.bgeu(bgeu),
	.RW_type(RW_type)
    );
	
	alu_control alu_control_inst(
	.ALUop(ALUop),
	.func3(func3),
	.func7(func7),
	.ALUctl(ALUctl)
    );
	
endmodule

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

module alu_control(
	input 	wire	[1:0]	ALUop,
	input 	wire	[2:0]	func3,
	input 	wire			func7,
	output 	wire	[3:0]	ALUctl
	
    );
	
	wire [3:0]branchop;
	reg  [3:0]RIop;
	
	assign branchop=(func3[2] & func3[1])? `SLTU : (func3[2] ^ func3[1])? `SLT : `SUB;
	
	always@(*)
	begin
		case(func3)
			3'b000: if(ALUop[1] & func7)
					RIop=`SUB;
					else              
					RIop=`ADD;
			3'b001: RIop=`SLL;
			3'b010: RIop=`SLT;
			3'b011: RIop=`SLTU;
			3'b100: RIop=`XOR;
			3'b101: if(func7)
					RIop=`SRA;
					else
					RIop=`SRL;
			3'b110: RIop=`OR;
			3'b111: RIop=`AND;
			default:RIop=`ADD;
		endcase
	end
	
	assign ALUctl=(ALUop[1]^ALUop[0])? RIop:(ALUop[1]&ALUop[0])?branchop:`ADD;

endmodule
