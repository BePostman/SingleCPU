module branch_judge(
  input 	wire	beq,
  input 	wire	bne,
  input 	wire	blt,
  input 	wire	bge,
  input 	wire	bltu,
  input 	wire	bgeu,
  input 	wire	jal,
  input 	wire	jalr,
  input 	wire	zero,
  input 	wire	ALU_result_sig,
  
  output jump_flag
);
	
  assign jump_flag = 	jal | jalr |
						(beq && zero)|
						(bne && (!zero))|
						(blt && ALU_result_sig)|
						(bge && (!ALU_result_sig))|
						(bltu && ALU_result_sig)|
						(bgeu && (!ALU_result_sig));

endmodule
