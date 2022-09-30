`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.05.2022 18:08:28
// Design Name: 
// Module Name: DSP_BQF_test
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


module DSP_BQF_test;
reg[31:0] A,B,C,D,Xin;
reg clk,clr;
wire[31:0] out;
DSP_BQF DUT(A,B,C,D,Xin,out,clk,clr);
initial begin
    clk=0;
    clr=0;
    A=1;B=2;C=3;D=4;
    #2  clr=1;
    #10 clr=0;
    #5 Xin=5;
    #1000 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("DSP_BQF_test.vcd");
    $dumpvars(0,DSP_BQF_test);
end
endmodule
