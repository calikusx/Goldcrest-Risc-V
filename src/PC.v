`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2024 04:58:54 PM
// Design Name: 
// Module Name: PC
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


module PC(
    input clk, rst_ni,
    input [31:0] pc, imm, register_value_ex,
    input [2:0] select,
    input V,Z,C,N,jb,bc,rf_select,
    output reg [31:0] pc_o,
    output [31:0] pc_plus4,
    output [31:0] pc_branch,
    output pcSrcE,
    input flushD,flushE,stallD,stallF
    );
    wire [31:0] pc_4,pc_b;
    wire pcsel;
    wire [31:0] to_branchadder;
    reg [31:0] pc_id;
    reg [31:0] pc_ex;
    reg rf_select_ex;
    assign pcSrcE = pcsel;
    assign pc_plus4 = pc_4;
    assign pc_branch = pc_b;
    Brach_Controller branch_c(.select(select),.V(V),.Z(Z),.C(C),.N(N),.jb(jb),.bc(bc),.pcsel(pcsel));
    
    always @(posedge clk) begin /////////IF-ID
        if((~rst_ni)|flushD) begin
            pc_id <=0;
        end
        else begin
        if(~stallD)
            pc_id <= pc;
        end
    end
    
    always @(posedge clk) begin /////////ID-EX
        if((~rst_ni)|flushE) begin
            pc_ex <=0;
            rf_select_ex <= 0;
        end
        else begin
            pc_ex <= pc_id;
            rf_select_ex <= rf_select;
        end
    end
    
    
    
    
    mux_2 branch_input_select(.i0(pc_ex),.i1(register_value_ex),.sel(1'b0),.o(to_branchadder));
     
    CLA_32 add4(.A(pc),.B(1),.cin(1'b0),.cout(),.sum(pc_4),.V());
    
    CLA_32 branchadder(.A(to_branchadder),.B({imm>>2}),.cin(1'b0),.cout(),.sum(pc_b),.V());
    
    
    always @(posedge clk) begin
        if(~rst_ni) begin
            pc_o <= 0;
        end
        else begin
        if(~stallF)
            pc_o <= pcsel ? pc_b : pc_4;
        end
    end
endmodule
