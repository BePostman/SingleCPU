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
    
    // �����������
    assign ADD_zero = ~(|ADD_result); // ���ӷ�����Ƿ�Ϊ�㣬������㣬ADD_zeroΪ1������Ϊ0

    // �����⣬���ݲ�ͬ��ALU�����ź�ALU_CTL�����
    assign ADD_OverFlow = 
                            ((ALU_CTL == 4'b0001) & ~A[31] & ~B[31] & ADD_result[31])  // ��ALU_CTLΪ0001���ӷ�ָ�ʱ�����A��B��������������Ǹ��������ʾ���
                            | ((ALU_CTL == 4'b0001) & A[31] & B[31] & ~ADD_result[31]) // ��ALU_CTLΪ0001���ӷ�ָ�ʱ�����A��B���Ǹ�������������������ʾ���
                            | ((ALU_CTL == 4'b0011) & A[31] & ~B[31] & ~ADD_result[31]) // ��ALU_CTLΪ0011������ָ�ʱ�����A�Ǹ�����B������������������������ʾ���
                            | ((ALU_CTL == 4'b0011) & ~A[31] & B[31] & ADD_result[31]); // ��ALU_CTLΪ0011������ָ�ʱ�����A��������B�Ǹ�����������Ǹ��������ʾ���
endmodule