`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2024 12:01:03 PM
// Design Name: 
// Module Name: Brach_Controller
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


module Brach_Controller(
    input [2:0] select,
    input V,Z,N,C,
    input jb,bc, //jump branch
    output pcsel
    );
   
    reg pcsel_temp;
    
    assign pcsel = (jb | (bc&pcsel_temp));
    always @(*)begin
        case(select) 
            3'b000 : begin
                pcsel_temp <= Z;          
            end
            3'b001 : begin
                pcsel_temp <= (~Z);  
            end
            3'b100 : begin
                pcsel_temp <= N^V;  
            end
            3'b101 : begin
                pcsel_temp <= ~(N^V);  
            end
            3'b110 : begin
                pcsel_temp <= ~C;  
            end
            3'b111 : begin
                pcsel_temp <= C;
            end
            
        endcase
    end
    
    
    
    
endmodule
