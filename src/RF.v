`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 01:24:55 AM
// Design Name: 
// Module Name: RF
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


module RF#(parameter DEPTH=32,WIDTH=32,initFile="")(
    input clk,rst_ni,
    input [$clog2(WIDTH)-1:0] rd_addr0,wr_addr0,rd_addr1,
    input [WIDTH-1:0]wr_din0,
    output [WIDTH-1:0] rd_out0,rd_out1,
    input we
    );
    reg [WIDTH-1:0] mem [DEPTH-1:0];

/*assign rd_out0 = (rd_addr0==wr_addr0) ? wr_din0:mem[rd_addr0];
assign rd_out1 = (rd_addr1==wr_addr0) ? wr_din0:mem[rd_addr1];*/
assign rd_out0 = mem[rd_addr0];
assign rd_out1 = mem[rd_addr1];
    integer i;
    always @(posedge clk or negedge rst_ni) begin
        if(~rst_ni) begin
            for (i=0;i<=DEPTH;i=i+1) begin
                mem[i]<=0;
            end
        end
        else begin
            if((we==1) & (|wr_addr0)!=0) begin
                mem[wr_addr0] <= wr_din0; 
            end
        end
    end
endmodule
