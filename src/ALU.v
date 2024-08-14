`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2024 03:27:51 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] select,
    input func_7,
    output reg [31:0] result_ALU,
    output V,C,Z,S
    );
    wire [31:0] add_sub_res;

    wire co;
    add_sub as(.A(A),.B(B),.add_sub_sel(func_7),.add_res(add_sub_res),.V(V),.Z(Z),.C(co),.S(S));
    assign C = co;
    
    always @ * begin
        case (select) 
            'b000: begin
                result_ALU <= add_sub_res;
            end
            'b100: begin
                result_ALU <= A ^ B;
            end
            'b110: begin
                result_ALU <= A | B;
            end
            'b111: begin
                result_ALU <= A & B;
            end
            'b010: begin
                if(A[31]!=B[31]) result_ALU <= A[31]; 
                else result_ALU <= {S};
            end
            'b011: begin
                if(A[31]!=B[31]) result_ALU <= ~A[31];
                else result_ALU <= {~co};
            end
        endcase 
    end
    

endmodule
