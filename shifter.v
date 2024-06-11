module Shifter(
    input wire [31:0] ALU_DA,
    input wire [4:0] ALU_SHIFT,
    input wire [1:0] Shiftctr,
    output reg [31:0] shift_result
);
    wire [5:0] shift_n = 6'd32 - ALU_SHIFT;
    always @(*) begin
        case(Shiftctr)
            2'b00: shift_result = ALU_DA << ALU_SHIFT; // Logical left shift
            2'b01: shift_result = ALU_DA >> ALU_SHIFT; // Logical right shift
            2'b10: shift_result = ({32{ALU_DA[31]}} << shift_n) | (ALU_DA >> ALU_SHIFT); // Arithmetic right shift
            default: shift_result = ALU_DA;
        endcase
    end
endmodule
