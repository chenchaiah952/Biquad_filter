`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.05.2022 16:16:17
// Design Name: 
// Module Name: mux4to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux4to1(in,out,sel);  // defining mux
input[1:0] sel;
input[3:0] in;
output out;
assign out=in[sel];
endmodule
module mux(inA,inB,inC,inD,out,sel); // instantiation of mux
input[31:0] inA,inB,inC,inD;
output[31:0] out;
input[1:0] sel;
genvar i;
generate
for(i=0;i<32;i=i+1)begin
mux4to1 M({inD[i],inC[i],inB[i],inA[i]},out[i],sel);
end
endgenerate
endmodule
module adder(A,B,sum); // defining adder
parameter N=32;
input[N-1:0] A;
input[N-1:0] B;
output[N-1:0] sum;
assign sum=A+B;
endmodule

module multiplier(A,B,sum); //defining  multiplier
parameter  N=32;
input[N-1:0] A;
input[N-1:0] B;
output[N-1:0] sum;
assign sum=A*B;
endmodule

module Delay(in,out,clk,clr); // defining D flipflop(delay element)
input clk,clr;
input[31:0] in;
output reg[31:0] out;
always @(posedge clk) begin
    if(clr)out<=32'b0;
    else out<=in;
end
endmodule
module counter(clk,clr,out); // defining counter
input clk,clr;
output reg[1:0] out;
always @(posedge clk) begin
    if(clr)out<=0;
    else out<=out+1;
end
endmodule
module assigne(in,out,sel,clk); //At count 2 output is visible
input[31:0] in;
input[1:0] sel;
input clk;
output reg[31:0] out;
always @(posedge clk) begin
    if(sel==2'b10)out<=in;
end
endmodule
module DSP_BQF(A,B,C,D,Xin,out,clk,clr); // defining of biquad filter
input[31:0] A,B,C,D,Xin;
input clk,clr;
output [31:0] out;
wire[31:0] Adder_in1,Adder_in2,Adder_out,AD1_out,AD2_out,AD3_out,AD4_out,AD5_out,AD6_out;
wire[31:0] Mul_in1,Mul_in2,Mul_out,MD1_out,MD2_out,MD3_out;
wire[1:0] count;
adder Add(Adder_in1,Adder_in2,Adder_out);
Delay AD1(Adder_out,AD1_out,clk,clr); // instantiation of adder delays
Delay AD2(AD1_out,AD2_out,clk,clr);
Delay AD3(AD2_out,AD3_out,clk,clr);
Delay AD4(AD3_out,AD4_out,clk,clr);
Delay AD5(AD4_out,AD5_out,clk,clr);
Delay AD6(AD5_out,AD6_out,clk,clr);
multiplier M(Mul_in1,Mul_in2,Mul_out);
Delay MD1(Mul_out,MD1_out,clk,clr);  // instantiation of multiplier delays
Delay MD2(MD1_out,MD2_out,clk,clr);
Delay MD3(MD2_out,MD3_out,clk,clr);
counter Cou(clk,clr,count);
mux AM1(MD3_out,AD2_out,MD3_out,Xin,Adder_in1,count); // instantiation of adder mux
mux AM2(MD2_out,AD1_out,MD2_out,AD1_out,Adder_in2,count);
mux MM1(A,D,B,C,Mul_in1,count);                     // instantiation of multiplier mux                     
mux MM2(AD1_out,AD6_out,AD3_out,AD4_out,Mul_in2,count);
assigne AS(AD1_out,out,count,clk);
endmodule
