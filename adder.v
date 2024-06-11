module Adder(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire Cin,
    input wire [3:0] ALU_CTL,
    output wire ADD_carry,
    output wire ADD_OverFlow,
    output wire ADD_zero,
    output wire [31:0] ADD_result
);

    cla_adder32 cla_adder32_inst1(
        .A(A),
        .B(B),
        .cin(Cin),
        .cout(ADD_carry),
        .result(ADD_result)
    );  
    
    // 零检测和溢出检测
    assign ADD_zero = ~(|ADD_result); // 检测加法结果是否为零，如果是零，ADD_zero为1，否则为0

    // 溢出检测，根据不同的ALU控制信号ALU_CTL来检测
    assign ADD_OverFlow = 
                            ((ALU_CTL == 4'b0001) & ~A[31] & ~B[31] & ADD_result[31])  // 当ALU_CTL为0001（加法指令）时，如果A和B都是正数但结果是负数，则表示溢出
                            | ((ALU_CTL == 4'b0001) & A[31] & B[31] & ~ADD_result[31]) // 当ALU_CTL为0001（加法指令）时，如果A和B都是负数但结果是正数，则表示溢出
                            | ((ALU_CTL == 4'b0011) & A[31] & ~B[31] & ~ADD_result[31]) // 当ALU_CTL为0011（减法指令）时，如果A是负数且B是正数，但结果是正数，则表示溢出
                            | ((ALU_CTL == 4'b0011) & ~A[31] & B[31] & ADD_result[31]); // 当ALU_CTL为0011（减法指令）时，如果A是正数且B是负数，但结果是负数，则表示溢出
endmodule