module cla_4(
    input wire [3:0] p,
    input wire [3:0] g,
    input wire c_in,
    output [4:1] c,
    output gx,
    output px
);

    assign c[1] = p[0] & c_in | g[0];
    assign c[2] = p[1] & p[0] & c_in | p[1] & g[0] | g[1];
    assign c[3] = p[2] & p[1] & p[0] & c_in | p[2] & p[1] & g[0] | p[2] & g[1] | g[2];
    assign c[4] = gx | px & c_in;
    
    //计算整个4位块的生成信号和传播信号
    assign px = p[3] & p[2] & p[1] & p[0];
    assign gx = g[3] | p[3] & g[2] | p[3] & p[2] & g[1] | p[3] & p[2] & p[1] & g[0];
endmodule
