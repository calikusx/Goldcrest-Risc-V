`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2024 04:46:01 PM
// Design Name: 
// Module Name: mux_4
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


module mux_4(
    input [31:0] i0,i1,i2,i3,
    input [1:0] sel,
    output [31:0] o
    );
    
    assign o = sel[1] ? (sel[0] ? i3:i2):(sel[0] ? i1:i0);
endmodule
