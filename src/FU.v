`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 02:33:49 AM
// Design Name: 
// Module Name: FU
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


module FU(
    input [31:0] A,B,
    input [2:0] select,
    input select_2,
    input select_ALU_Shifter,
    output  [31:0] out_FU,
    output V,C,N,Z
    );
    
    
    wire [31:0] result_ALU,result_Shifter;
    ALU ALU(
    .A(A),
    .B(B),
    .select(select),
    .func_7(select_2),
    .result_ALU(result_ALU),
    .V(V),.C(C),.Z(Z),.S(N)
    );
    
    Shifter Shifter(
    .A(A),
    .B(B),
    .select(select),
    .select_2(select_2),
    .shifter_Res(result_Shifter)
    );
    
    assign out_FU = select_ALU_Shifter ? result_Shifter:result_ALU;
    
endmodule
