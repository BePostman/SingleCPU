module alu(
    input wire [31:0] ALU_DA,
    input wire [31:0] ALU_DB,
    input wire [3:0] ALU_CTL,
    output wire ALU_ZERO,
    output wire ALU_OverFlow,
    output wire [31:0] ALU_DC
);
    // Intermediate signals
    wire SUBctr = (~ALU_CTL[3] & ~ALU_CTL[2] & ALU_CTL[1]) | (ALU_CTL[3] & ~ALU_CTL[2]);
    wire [1:0] Opctr = ALU_CTL[3:2];
    wire Ovctr = ALU_CTL[0] & ~ALU_CTL[3] & ~ALU_CTL[2];
    wire SIGctr = ALU_CTL[0];
    wire [1:0] Logicctr = ALU_CTL[1:0];
    wire [1:0] Shiftctr = ALU_CTL[1:0];

    wire [31:0] logic_result;
    wire [31:0] shift_result;
    wire ADD_carry, ADD_OverFlow;
    wire [31:0] ADD_result;

    // Instantiate logic unit
    logic_unit logic_u (
        .ALU_DA(ALU_DA),
        .ALU_DB(ALU_DB),
        .Logicctr(Logicctr),
        .logic_result(logic_result)
    );

    // Instantiate shifter
    Shifter shifter (
        .ALU_DA(ALU_DA),
        .ALU_SHIFT(ALU_DB[4:0]),
        .Shiftctr(Shiftctr),
        .shift_result(shift_result)
    );

    // Instantiate adder
    Adder adder (
        .A(ALU_DA),
        .B(SUBctr ? ~ALU_DB : ALU_DB),
        .Cin(SUBctr),
        .ALU_CTL(ALU_CTL),
        .ADD_carry(ADD_carry),
        .ADD_OverFlow(ADD_OverFlow),
        .ADD_zero(ALU_ZERO),
        .ADD_result(ADD_result)
    );

    // Overflow detection
    assign ALU_OverFlow = ADD_OverFlow & Ovctr;

    // Less than comparison
    wire LESS_M1 = ADD_carry ^ SUBctr;
    wire LESS_M2 = ADD_OverFlow ^ ADD_result[31];
    wire LESS_S = (SIGctr == 1'b0) ? LESS_M1 : LESS_M2;
    wire [31:0] SLT_result = (LESS_S) ? 32'h00000001 : 32'h00000000;

    // Select final result based on operation type
    reg [31:0] ALU_DC_internal;
    always @(*) begin
        case(Opctr)
            2'b00: ALU_DC_internal = ADD_result;
            2'b01: ALU_DC_internal = logic_result;
            2'b10: ALU_DC_internal = SLT_result;
            2'b11: ALU_DC_internal = shift_result; 
        endcase
    end

    assign ALU_DC = ALU_DC_internal;

endmodule
