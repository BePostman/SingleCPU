`include "define.v"
module alu_control(
	input 	wire	[1:0]	ALUop,
	input 	wire	[2:0]	func3,
	input 	wire			func7, //function7µÄÅÐ¶ÏÎ»
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
