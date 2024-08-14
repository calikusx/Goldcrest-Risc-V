`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2024 05:08:31 PM
// Design Name: 
// Module Name: ID
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


module ID(
    input [31:0] instr,
    input rst_ni,
    output reg rf_select,
    output reg [31:0] imm,
    output reg mw,we,mb,md,mf,bc,jb,pc_write,
    output reg [2:0] select,
    //output reg [4:0] rs1,rs2,rd,
    output reg select2,
    output reg PC_rs1_sel
    );
    wire [6:0] opcode;
    wire [2:0] func3;
    wire func7;
    
    assign opcode = instr[6:0];
    assign func3 = instr[14:12];
    assign func7 = instr[30];
    
    always @(*) begin
        if(~rst_ni) begin
            bc <= 0;
            jb <= 0;
            select <= func3;
            select2 <= func7;
            mw <= 0;
            md <= 0;
            mf <= (~func3[1])&(func3[0]);
            mb <= 0;
            we <= 1;
            pc_write<=0;
            PC_rs1_sel<=0;
            rf_select <= 0;
        end
        else begin
        case(opcode) 
        7'b0110111: begin  ////LUI
            bc <= 0;
            jb <= 0;
            select <= 0;
            select2 <= 0;
            mw <= 0;
            md <= 1;
            mf <= 0;
            mb <= 1;
            we <= 1;
            imm <= instr[31:12]<<12;
            pc_write<=1;
            PC_rs1_sel<=1;
            rf_select <= 0;
        end
        7'b0010111: begin  ////AUIPC
            bc <= 0;
            jb <= 0;
            select <= 0;
            select2 <=0;
            mw <= 0;
            we <= 1;
            mb <= 1;
            //rd <= instr[11:7];
            imm <= instr[31:12]<<12;
            pc_write <= 0;
            md <= 0;
            PC_rs1_sel<=1;
            rf_select <= 0;
        end
        7'b1101111: begin  ////JAL
            bc <= 0;
            jb <= 1;
            select <= 0;
            select2 <= 0;
            mw <=0;
            we <=1;
            mb <=0;
            imm <= {{13{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
            pc_write <= 1;
            md <= 0;
            rf_select <= 0;
        end
        7'b1100111: begin  ////JALR
            bc <= 0;
            jb <= 1;
            select <= 0;
            select2 <= 0;
            mw <=0;
            we <=1;
            mb <=0;
            imm <= instr[31:20];
            pc_write <= 1;
            md <= 0;
            rf_select <= 1;
        end
        7'b1100011: begin  ////Branches
            bc <= 1;
            jb <= 0;
            select <=0;
            select2 <=1;
            mw <= 0;
            we <= 0;
            mb <= 0;
            imm <= {instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
            pc_write<=0;
            PC_rs1_sel<=0;
            rf_select <= 0;
        end
        7'b0000011: begin  ////Load
            bc <= 0;
            jb <= 0;
            mw <= 0;
            mb <= 1;
            mf <= 0;
            we <= 1;
            md <= 1;
            select <= 0;
            select2 <= 0;
            pc_write <= 0;
            PC_rs1_sel<=0;
            imm <= instr[31:20];
        end
        7'b0100011: begin  ////Store
            bc <= 0;
            jb <= 0;
            mw <= 1;
            we <= 0;
            mb <= 1;
            mf <= 0;
            select <= 0;
            select2 <= 0;
            md <= 0;
            pc_write <= 0;
            PC_rs1_sel<=0;
            imm <= {instr[31:25],instr[11:7]};
        end
        7'b0010011: begin  ////Immediate
            bc <= 0;
            jb <= 0;
            select <= func3;
            select2 <= func7;
            mw <= 0;
            md <= 0;
            mf <= (~func3[1])&(func3[0]);
            mb <= 1;
            we <= 1;
            imm <= instr[31:20];
            pc_write<=0;
            PC_rs1_sel<=0;
        end
        7'b0110011: begin  ////FU
            bc <= 0;
            jb <= 0;
            select <= func3;
            select2 <= func7;
            mw <= 0;
            md <= 0;
            mf <= (~func3[1])&(func3[0]);
            mb <= 0;
            we <= 1;
            pc_write<=0;
            PC_rs1_sel<=0;
        end
        endcase
        end
    end
    
    
    
endmodule
