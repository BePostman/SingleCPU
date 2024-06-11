module logic_unit(
    input wire [31:0] ALU_DA,
    input wire [31:0] ALU_DB,
    input wire [1:0] Logicctr,
    output reg [31:0] logic_result
);
    always @(*) begin
        case(Logicctr)
            2'b00: logic_result = ALU_DA & ALU_DB;  // AND
            2'b01: logic_result = ALU_DA | ALU_DB;  // OR
            2'b10: logic_result = ALU_DA ^ ALU_DB;  // XOR
            2'b11: logic_result = ~(ALU_DA | ALU_DB); // NOR
        endcase
    end
endmodule
