`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2024 12:48:55 PM
// Design Name: 
// Module Name: CU
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


module CU( input clk,
    input rst_ni,
    input [31:0] instr,
    input V,Z,C,N,
    input flushD,flushE,stallD,stallF,
    output [31:0] pc_o,
    output pc_write,
    output mw,we,mb,md,mf,
    output [2:0] func3,
    output func7,
    //output [4:0] rs1,rs2,rd,
    output [31:0] imm,
    output [31:0] pc_plus4,
    output [31:0] pc_branch,
    output PC_rs1_sel,
    output pcSrcE
    );
    
    //////////////////////
    wire [31:0] pc;
    wire [2:0] select;
    wire jb,bc;
    wire rf_select;
    //////////////////////
    
    //////////////////////
    //wire [31:0] instr;
    //wire mw,we,mb,md,mf;
    wire select2;
    //////////////////////
    
    //////////////////////
    reg [31:0] imm_ex;
    reg jb_ex,bc_ex;
    reg [2:0] branch_sel_ex;
    //////////////////////
    
    //////////////////////
    always @(posedge clk) begin
        if((~rst_ni)|flushE) begin
            imm_ex <= 0;
            jb_ex <= 0;
            bc_ex <= 0;
            branch_sel_ex <= 0;    
        end
        else begin
            imm_ex <= imm;
            jb_ex <= jb;
            bc_ex <= bc;
            branch_sel_ex <= instr[14:12];
        end
    end
    //////////////////////
    
    assign func3 = select;
    assign func7 = select2;
    assign pc_o = pc;
    
    PC program_count(.clk(clk),
    .rst_ni(rst_ni),
    .pc(pc),
    .imm(imm_ex),
    .select(branch_sel_ex),
    .V(V),
    .Z(Z),
    .C(C),
    .N(N),
    .jb(jb_ex),.bc(bc_ex),.rf_select(rf_select),
    .pcSrcE(pcSrcE),
    .pc_o(pc),
    .pc_plus4(pc_plus4),
    .pc_branch(pc_branch),
    .flushD(flushD),.flushE(flushE),.stallD(stallD),.stallF(stallF));
    
    
    
    ID instr_decode(.rst_ni(rst_ni),
    .instr(instr),
    .mw(mw),.we(we),.mb(mb),.md(md),.mf(mf),.bc(bc),.jb(jb),.rf_select(rf_select),
    .select(select),
    .select2(select2),
    //.rs1(rs1),
    //.rs2(rs2),
    //.rd(rd),
    .imm(imm),
    .pc_write(pc_write),
    .PC_rs1_sel(PC_rs1_sel));
    
    
endmodule
