`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2024 02:26:47 PM
// Design Name: 
// Module Name: core
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


module core(
    input clk,rst_ni,
    input [31:0] instr,
    input [31:0] data_in,
    output [31:0] out_FU_me,
    output mw_o,
    output [31:0] pc_o,write_data_M
    );
    ////////////////
    wire V,Z,C,N;
    wire mw,we,mb,md,mf;
    wire [4:0] rs1,rs2,rd;
    wire [2:0] func3;
    wire func7;
    wire [31:0] imm;
    wire [31:0] pc_plus4;
    wire pc_write;
    wire [31:0] pc_branch;
    //wire [31:0] pc_rs1_sel;
    wire pc_rs1_sel;
    wire pcSrcE;
    //////////////////
    
    wire flushD,flushE,stallD,stallF; 
    //////////////////
    
    
    
    // pipe if_id
        wire [31:0] pc_plus4_id;
        wire [31:0] pc_id;
        reg [31:0] instr_id;
    //
    always @(posedge clk) begin//////////IF-ID
        if((~rst_ni)|flushD) begin
            instr_id <= 0;
        end
        else begin
        if(~stallD)
            instr_id <= instr;
        end
    end
    
    
    
    /*pipe_if_id pipeline_1(
    .clk(clk),.rst_ni(rst_ni),.flushD(0),.stallD(0),
    .instr_if(instr),
    .instr_id(instr_id),
    .pc_if(pc_o),
    .pc_id(pc_id),
    .pc_plus4_if(pc_plus4),
    .pc_plus4_id(pc_plus4_id)
    );*/


    CU control_unit(
    .clk(clk),
    .rst_ni(rst_ni),
    .instr(instr_id),
    .V(V),.Z(Z),.C(C),.N(N),
    .pc_o(pc_o),
    .mw(mw),.we(we),.mb(mb),.md(md),.mf(mf),
    .func3(func3),
    .func7(func7),
   // .rs1(rs1),.rs2(rs2),.rd(rd),
   .imm(imm),
   .pc_plus4(pc_plus4),
   .pc_write(pc_write),
   .pc_branch(pc_branch),
   .PC_rs1_sel(pc_rs1_sel),
   .pcSrcE(pcSrcE),
   .stallD(stallD),.stallF(stallF),
   .flushD(flushD),.flushE(flushE)
    );
    
    Datapath datapath(
    .clk(clk),.rst_ni(rst_ni),
    //.rs1(rs1),.rs2(rs2),.rd(rd),
    .instr(instr_id),
    .mw(mw),.we(we), ///memory_write,rf_we
    .mb(mb), ////B_data_select; RF or imm
    .func3(func3),
    .select_2(func7),///func3_extension func7
    .md(md),///// mem_out or FU out
    .data_in(data_in), .imm_extend(imm), /// memory data in, immediate
    .mf(mf), // fu out sel
    .out_FU(),
    .out_FU_me_o(out_FU_me),
    .pc_write(pc_write),
    .V(V),.C(C),.Z(Z),.N(N),  ///flags for status
    .pc_plus4(pc_plus4),
    .pc_branch(pc_branch),
    .PC(pc_o),
    .PC_rs1_sel(pc_rs1_sel),
    .pcSrcE(pcSrcE),
    .flushD(flushD),.flushE(flushE),
    .write_data_M_o(write_data_M),
    .mw_me_o(mw_o),
    .stallD(stallD),.stallF(stallF)
    );
    
    
endmodule
