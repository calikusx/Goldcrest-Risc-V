`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2024 02:37:35 PM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
    input pcsrcE,regwriteW,regwriteM,
    input resultsrcE0,
    input [4:0] Rs1D,Rs2D,RdE,Rs2E,Rs1E,RdM,pcplusW,RdW,
    output wire stallF,stallD,flushD,flushE,
    output reg [1:0] forwardAE,forwardBE
    );
    
    
    always @(*) begin 
        if((Rs1E == RdM) & (regwriteM) & (Rs1E != 0)) begin
            forwardAE <= 2'b10;
        end
        else if((Rs1E == RdW) & (regwriteW) & (Rs1E != 0))begin
            forwardAE <= 2'b01;
        end
        else begin
            forwardAE<=0;
        end
        if ((Rs2E == RdM) & (regwriteM) & (Rs2E != 0)) begin
            forwardBE <= 2'b10; // for forwarding ALU Result in Memory Stage
        end
        else if ((Rs2E == RdW) & (regwriteW) & (Rs2E != 0)) begin
            forwardBE <= 2'b01; // for forwarding WriteBack Stage Result
        end
        else begin
            forwardBE <=0;
        end
    end
    
    wire lwst;
    assign lwst =  ((RdE == Rs1D) | (RdE == Rs2D)) & (resultsrcE0 == 1);
    
    assign stallF = lwst;
	assign stallD = lwst;
	
	assign flushE = 0;//lwst | pcsrcE;
	assign flushD = 0;//pcsrcE;
endmodule