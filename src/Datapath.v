`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 03:00:17 PM
// Design Name: 
// Module Name: Datapath
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


module Datapath(
    input clk,rst_ni,
    input [31:0] instr,
    //input [4:0] rs1,rs2,rd,
    input mw,we, ///memory_write,rf_we
    input mb, ////B_data_select; RF or imm
    input [2:0] func3,
    input select_2,///func3_extension func7
    input md,///// mem_out or FU out
    input [31:0] data_in, imm_extend, /// memory data in, immediate
    input mf, // fu out sel
    input pc_write,
    input [31:0] pc_plus4,
    input [31:0] PC,////////////
    input [31:0] pc_branch,
    input PC_rs1_sel,
    input pcSrcE,
    output mw_me_o,
    output [31:0] out_FU,write_data_M_o,
    output [31:0] out_FU_me_o,
    output V,C,Z,N,  ///flags for status
    output flushD,flushE,stallD,stallF
    );
    wire [31:0] rf_data_A, rf_data_B;
    wire [31:0] rf_data_in;
    
    ///////////////////////////////ID-EX
    reg [31:0] rf_data_A_ex,rf_data_B_ex,imm_ex; 
    reg [4:0] RF_wr_addr_ex;
    reg mw_ex,we_ex,mb_ex,md_ex,mf_ex,pc_write_ex,PC_rs1_sel_ex;
    reg [31:0] pc_plus4_ex,PC_ex,pc_branch_ex;
    reg [2:0] func3_ex;
    reg select_2_ex;
   
    ///////////////////////////////
assign write_data_M_o=write_data_M;
assign mw_me_o = mw_me;
//////////hazard_unit//////////////

   // wire flushD,flushE;
   // wire stallF,stallD;
    hazard_unit hu(
    .pcsrcE(pcSrcE),.regwriteW(we_wb),.regwriteM(we_me),
    .resultsrcE0(md_ex),
    .Rs1D(instr[19:15]),.Rs2D(instr[24:20]),.RdE(RF_wr_addr_ex),.Rs2E(RS2E),.Rs1E(RS1E),.RdM(RF_wr_addr_me),.pcplusW(),.RdW(RF_wr_addr_wb),
    .stallF(stallF),.stallD(stallD),.flushD(flushD),.flushE(flushE),
    .forwardAE(forwardAE),.forwardBE(forwardBE)
    );

///////////////////////////////////
wire [31:0] alu_i0_temp,alu_i1_temp;
mux_4 forwardA(.i0(rf_data_A_ex),.i1(rf_data_in),.i2(out_FU_me),.i3(),.sel(forwardAE),.o(alu_i0_temp));
mux_4 forwardB(.i0(rf_data_B_ex),.i1(rf_data_in),.i2(out_FU_me),.i3(),.sel(forwardBE),.o(alu_i1_temp));

///////////////////////////////////
reg [4:0] RS1E,RS2E,RS1D,RS2D,RDE,RDM,RDW;
wire [1:0] forwardAE,forwardBE;
///////////////////////////////////

    always @(posedge clk) begin
        if((~rst_ni)|flushE) begin
            mw_ex <= 0;
            we_ex <= 0;
            mb_ex <= 0;
            md_ex <= 0;
            mf_ex <= 0;
            pc_write_ex <= 0;
            pc_plus4_ex <= 0;
            PC_ex <= 0;
            pc_branch_ex <= 0;
            PC_rs1_sel_ex <= 0; 
            func3_ex <= 0;
            select_2_ex <= 0;
            rf_data_A_ex <= 0;
            rf_data_B_ex <= 0;
            imm_ex<=0;
            RF_wr_addr_ex<=0;
            RS1E <= 0;
            RS2E <= 0;
        end
        else begin
            mw_ex <= mw;
            we_ex <= we;
            mb_ex <= mb;
            md_ex <= md;
            mf_ex <= mf;
            pc_write_ex <= pc_write;
            pc_plus4_ex <= pc_plus4;
            PC_ex <= PC;
            pc_branch_ex <= pc_branch;
            PC_rs1_sel_ex <= PC_rs1_sel;
            func3_ex <= func3;
            select_2_ex <= select_2;
            rf_data_A_ex <= rf_data_A;
            rf_data_B_ex <= rf_data_B;
            imm_ex <= imm_extend;
            RF_wr_addr_ex<= instr[11:7];
            RS1E <= instr[19:15];
            RS2E <= instr[24:20];
        end
    end
    //////////////////////////////////////////////
        
    //
    reg mw_me;
    reg we_me;
    reg pc_write_me;
    reg md_me;
    reg [31:0] out_FU_me;
    reg [31:0] pc_plus4_me;
    //reg [31:0] mem_write_data_me;
    reg [4:0] RF_wr_addr_me;
    reg [31:0] imm_me;
    reg [31:0] write_data_M;
    //
    always @(posedge clk) begin //control signals
        if(~rst_ni) begin
            we_me <= 0;
            pc_write_me <= 0;
            md_me <= 0;
            mw_me <= 0;
        end
        else begin
            we_me <= we_ex;
            pc_write_me <= pc_write_ex;
            md_me <= md_ex;
            mw_me <= mw_ex;
        end
    end
    
    always @(posedge clk) begin //data
        if(~rst_ni) begin
            out_FU_me <= 0;
            pc_plus4_me <= 0;
            RF_wr_addr_me <= 0;
            imm_me<=0;
            write_data_M<=0;
        end
        else begin
            out_FU_me <= out_FU;
            pc_plus4_me <= pc_plus4_ex;
            RF_wr_addr_me <= RF_wr_addr_ex;
            imm_me <= imm_ex;
            write_data_M<= alu_i1_temp;
        end
    end
    //////////////
    assign out_FU_me_o = out_FU_me;
    
    //////////////
    reg [31:0] out_FU_wb;
    reg [31:0] mem_read_data_wb;
    reg [31:0] pc_plus4_wb;
    reg we_wb;
    reg pc_write_wb;
    reg [4:0] RF_wr_addr_wb;
    reg md_wb;
    reg [31:0] data_in_wb;
    reg [31:0] imm_wb;
    //////////////
    always @(posedge clk) begin
        if(~rst_ni) begin
            we_wb <= 0;
            md_wb <= 0;
            pc_write_wb <= 0;
            out_FU_wb <= 0;
            mem_read_data_wb <= 0;
            RF_wr_addr_wb <= 0;
            pc_plus4_wb <= 0;
            data_in_wb <= 0;
            imm_wb <= 0;
        end
        else begin
            we_wb <= we_me;
            md_wb <= md_me;
            pc_write_wb <= pc_write_me;
            out_FU_wb <= out_FU_me;
            //mem_read_data_wb <= mem_write_data_me;
            RF_wr_addr_wb <= RF_wr_addr_me;
            pc_plus4_wb <= pc_plus4_me;
            data_in_wb <= data_in;
            imm_wb <= imm_ex;
        end
    end
    //////////////
    
    
    
    RF#(.DEPTH(32),.WIDTH(32)) RF(
    .clk(clk),
    .rst_ni(rst_ni),
    .rd_addr0(instr[19:15]),
    .wr_addr0(RF_wr_addr_wb),
    .rd_addr1(instr[24:20]),
    .wr_din0(rf_data_in),
    .rd_out0(rf_data_A),
    .rd_out1(rf_data_B),
    .we(we_wb)
    );
    
    wire [31:0] B_fu;
    wire [31:0] A_fu;
    mux_2 mux_PC_rd1(.i0(alu_i0_temp),.i1(PC_ex),.sel(PC_rs1_sel_ex),.o(A_fu));
    mux_2 mux_MB(.i0(alu_i1_temp),.i1(imm_ex),.sel(mb_ex),.o(B_fu));
    
    //wire [31:0] out_FU;
    FU FU(
    .A(A_fu),
    .B(B_fu),
    .select(func3_ex),
    .select_2(select_2_ex),
    .select_ALU_Shifter(mf_ex),
    .out_FU(out_FU),
    .V(V),.C(C),.N(N),.Z(Z)
    );
    
    mux_4 mux_MD(.i0(out_FU_wb),.i1(data_in_wb),.i2(pc_plus4_wb),.i3(/*pc_branch_ex*/imm_wb),.sel({pc_write_wb,md_wb}),.o(rf_data_in));
    //mux_2 mux_MD(.i0(out_FU),.i1(data_in),.sel(md),.o(rf_data_in));
    
    
endmodule
