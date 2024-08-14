`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 08:31:36 PM
// Design Name: 
// Module Name: Shifter
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


module Shifter(
    input [31:0] A,
    input [31:0] B,
    input [2:0] select,
    input select_2,
    output reg [31:0] shifter_Res
    ); 
    always @ * begin
        case(select[2])
            'b0: begin
               shifter_Res <= A << B; 
            end
            'b1: begin
                if(select_2) begin
                    shifter_Res <= $signed(A)>>>B;
                end
                else begin
                    shifter_Res <= A>>B;
                end
            end
        endcase
    end    
endmodule
