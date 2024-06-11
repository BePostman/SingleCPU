实验2 处理器设计
一、	实验目标
设计并实现一个基于RISC-V的37条指令的单周期非流水线CPU，基于vivado2022.2用verilog语言进行硬件描述实现。
二、	实验要求
1.自行选取RV32I指令子集，满足如下要求：
（1）包含所有六种指令格式；
（2）指令数量要求：能够满足基本程序设计的需要、能够正确实现实验1的汇编程序功能；
（3）至少支持32位数据的算术、逻辑和移位运算； 
（4）所用运算类指令均可以不支持溢出； 
（5）给出自选的RV32I指令的清单和对应的RTL描述。
2.处理器由Datapath(数据通路)和Controller(控制器)组成，要求如下： 
（1）数据通路（功能模块及连接方式）自行决定；
（2）控制器实现方案不限；
（3）指令周期可以选择单周期、多周期或流水线。 
3.CPU功能测试要求如下：
（1）所有指令都应被测试充分；
（2）选用实验1的汇编程序机器码作为样例代码验证处理器的功能；
（3）自选指令子集的每条指令在样例代码中至少出现1次以上；
（4）实验1的代码可以正确运行，并能够用硬件输出或软件查看方式正确显示样例代码的结果； 
（5）必须有子程序调用，并至少1次函数调用； 
（6）应明确说明测试程序的测试期望，即应该得到怎样的运行结果；
（7）可以正确运行样例程序以外的大多数通用程序。


三、	实验过程
1.	指令选取
1.1  U型指令
imm[31:12]	rd	opcode	指令名
imm[31:12]	rd	0110111	LUI
imm[31:12]	rd	0010111	AUIPC
1.2  J型指令
imm[20]	imm[10:1]	imm[11]	imm[19:12]	rd	opcode	指令名
imm[20]	imm[10:1]	imm[11]	imm[19:12]	rd	1101111	JAL
1.3  B型指令
imm[12,10:5]	rs2	rs1	func3	imm[4:1,11]	opcode	指令名
imm[12,10:5]	rs2	rs1	000	imm[4:1,11]	1100011	BEQ
imm[12,10:5]	rs2	rs1	001	imm[4:1,11]	1100011	BNE
imm[12,10:5]	rs2	rs1	100	imm[4:1,11]	1100011	BLT
imm[12,10:5]	rs2	rs1	101	imm[4:1,11]	1100011	BGE
imm[12,10:5]	rs2	rs1	110	imm[4:1,11]	1100011	BLTU
imm[12,10:5]	rs2	rs1	111	imm[4:1,11]	1100011	BGEU
1.4  I型指令
imm[1:10]	rs1	func3	rd	opcode	指令名
imm[1:10]	rs1	010	rd	1100111	JALR
imm[1:10]	rs1	000	rd	0000011	LB
imm[1:10]	rs1	001	rd	0000011	LH
imm[1:10]	rs1	010	rd	0000011	LW
imm[1:10]	rs1	100	rd	0000011	LBU
imm[1:10]	rs1	101	rd	0000011	LHU
imm[1:10]	rs1	000	rd	0010011	ADDI
imm[1:10]	rs1	010	rd	0010011	SLTI
imm[1:10]	rs1	011	rd	0010011	SLTIU
imm[1:10]	rs1	100	rd	0010011	XORI
imm[1:10]	rs1	110	rd	0010011	ORI
imm[1:10]	rs1	111	rd	0010011	SLLI
imm[1:10]	rs1	001	rd	0010011	SRLI
imm[1:10]	rs1	101	rd	0010011	SRAI
1.5  S型指令
imm[11:5]	rs2	rs1	func3	imm[4:0]	opcode	指令名
imm[11:5]	rs2	rs1	000	imm[4:0]	0100011	SB
imm[11:5]	rs2	rs1	001	imm[4:0]	0100011	SH
imm[11:5]	rs2	rs1	010	imm[4:0]	0100011	SW
1.6  R型指令
fun7	rs2	rs1	fun3	rd	opcode	指令名
0000000	rs2	rs1	000	rd	0110011	ADD
0100000	rs2	rs1	000	rd	0110011	SUB
0000000	rs2	rs1	001	rd	0110011	SLL
0000000	rs2	rs1	010	rd	0110011	SLT
0000000	rs2	rs1	011	rd	0110011	SLTU
0000000	rs2	rs1	100	rd	0110011	XOR
0000000	rs2	rs1	101	rd	0110011	SRL
0100000	rs2	rs1	101	rd	0110011	SRA
0000000	rs2	rs1	110	rd	0110011	OR
0000000	rs2	rs1	111	rd	0110011	AND
2.	各部件功能设计
2.1 指令存储器
指令存储器主要用来存放此次设计所采用的实验一的指令，实现方式有调用IP核实现以及编写硬件描述语言（hdl）实现，在此次设计中我们采用hdl语言实现。
 
2.2数据存储器
	数据存储器主要是通过对地址和读写类型信号的处理，实现对数据的字节、半字和字的读写操作，实现方式与指令存储器类似，这里我们采用hdl语言实现。
 
2.3 数据通路
	数据通路包含对pc地址的操作、指令译码的操作、寄存器堆的操作、alu运算操作、分支跳转判断操作、写回操作、多路选择器模块等，对以上几个关键部件进行连接就形成了完整的数据通路。
 
2.4控制器
	控制器包含主控制器和子控制器，主控制器产生大部分的控制信号，子控制器是ALU控制器，产生控制ALU进行正确运算的信号，将以上两个模块进行连接就形成了控制器。
 
3.	数据通路设计
以下是我们组设计的单周期CPU的RTL视图：
1.	整体视图：
 
图1 CPU整体
2.	数据通路视图：
 
图2 数据通路
3.	控制器视图：
 
图3 控制器
四、	实验代码
1.	10进制转16进制模块汇编代码及指令
1.1 汇编代码
.data
buffer_hex: .space 32  # 用于存储转换后的十六进制字符串
.text
main:
    li a0, 70           # 要转换的十进制整数
convert_to_hex:
    la a7, buffer_hex   # 十六进制字符串的存储位置
    li t0, 0            # t0寄存器用于存储字符串索引
    li t1, 16           # t1寄存器用于存储除数16
    addi a4, a0, 0      # a4寄存器用于存储余数
convert_loop_hex:
    li t4, 0            # t4寄存器用于存储商
div_loop_hex:
    blt a4, t1, output_hex  # 如果余数a4 < 除数t1，则跳到输出余数
    sub a4, a4, t1          # 计算新的余数a4
    addi t4, t4, 1          # 递增商t4
    bge a4, t1, div_loop_hex # 如果新的余数a4 >= 除数t1，则继续循环
output_hex:
    addi a4,a4,0
    li a7, 10     # 退出程序
ecall
1.2	汇编指令
04600513、0fc10897、ffc88893、00000293、01000313、00050713、00900f13、00a00f93、00000e93、00674863、40670733、001e8e93、fe675ae3、00070713、00000073。
2.	10进制转8进制模块汇编代码
2.1 汇编代码
.data
buffer_oct: .space 32  # 用于存储转换后的八进制字符串
.text
main:
    li a0, 70           # 要转换的十进制整数 
convert_to_oct:
    la a7, buffer_oct   # 八进制字符串的存储位置
    li t0, 0            # t0寄存器用于存储字符串索引
    li t1, 8            # t1寄存器用于存储除数8
    addi a4, a0, 0      # a4寄存器用于存储余数
convert_loop_oct:
    li t4, 0            # t4寄存器用于存储商
div_loop_oct:
    blt a4, t1, output_oct  # 如果余数a4 < 除数t1，则跳到输出余数
    sub a4, a4, t1          # 计算新的余数a4
    addi t4, t4, 1          # 递增商t4
    bge a4, t1, div_loop_oct# 如果新的余数a4 >= 除数t1，则继续循环
output_oct:
    addi a4,a4,0
li a7, 10     # 退出程序
ecall
2.2 汇编指令
04600513、0fc10897、ffc88893、00000293、00800313、00050713、00000e93、00674863、40670733、001e8e93、fe675ae3、00070713、00a00893、00000073。
3.	测试进制转换未使用到的指令代码
3.1 测试汇编代码
.text
start:
    lui t0, 123          # 将立即数123的高20位加载到寄存器t0中
    auipc t1, 123        # 将PC加上立即数123的高20位加载到寄存器t1中
label1:
    addi t1, t1, 0                # 确保t1中是一个有效的地址              
    # 条件分支指令
    beq t0, t1, label2            # 如果t0 == t1，则跳转到label2
    bne t0, t1, label3            # 如果 t0 != t1，则跳转到label3   
label2:
    blt t0, t1, label3            # 如果t0 < t1，则跳转到label3
    bge t0, t1, label4            # 如果t0 >= t1，则跳转到label4 
label3:
    bltu t0, t1, label4           # 如果t0 < t1（无符号），则跳转到label4
    bgeu t0, t1, end              # 如果t0 >= t1（无符号），则跳转到end 
    # 立即数指令
label4:
    addi t2, t0, 10               # t2 = t0 + 10
    slti t3, t1, 5                # t3 = (t1 < 5) ? 1 : 0
    xori t4, t2, 1                # t4 = t2 ^ 1
    ori t5, t3, 1                 # t5 = t3 | 1
    andi t6, t4, 1                # t6 = t4 & 1  
    # 寄存器指令
    add t0, t1, t2                # t0 = t1 + t2
    sub t1, t2, t3                # t1 = t2 - t3
    sll t2, t3, t4                # t2 = t3 << t4
    slt t3, t4, t5                # t3 = (t4 < t5) ? 1 : 0
    sltu t4, t5, t6               # t4 = (t5 < t6) ? 1 : 0（无符号）
    xor t5, t6, t0                # t5 = t6 ^ t0
    srl t6, t0, t1                # t6 = t0 >> t1
    sra t0, t1, t2                # t0 = t1 >> t2（算术右移）
    or t1, t2, t3                 # t1 = t2 | t3
    and t2, t3, t4                # t2 = t3 & t4
    # 程序结束
end:
    li a7, 10                     # 设置退出系统调用号
ecall                         # 执行系统调用退出程序
3.2	测试汇编指令
0007b2b7、0007b317、00030313、00628463、00629663、0062c463、0062d663、0062e463、0462f063、00a28393、00532e13、0013ce93、001e6f13、001eff93、007302b3、41c38333、01de13b3、01eeae33、01ff3eb3、005fcf33、0062dfb3、407352b3、01c3e333、01de73b3、05d00893、00000073。
五、	实验结果
1.	十进制转十六进制仿真图
 
上图中，主要列出了pc地址的变换，操作数以及结果，其中红色圈出来的分别70的商和余数的十六进制。
2.	十进制转八进制仿真图
 
上图中，主要列出了pc地址的变换，操作数以及结果，其中红色圈出来的分别70的商和余数的八进制。
3.	测试仿真图
 
可以看出，这里的仿真波形图与上述测试指令是对应的，因此这里的测试指令执行成功。

六、	实验总结
经过本次实验，使我进一步理解了RISC-V架构的CPU的数据通路，以及各类控制信号，还有基于RISC-V架构的CPU指令的含义，但是这次实验还是有些遗憾的，比如没有像真正设计CPU一样，把寄存器地址进行划分，而是做了通用处理，也没有能够实现流水线的设计。