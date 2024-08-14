`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2024 03:47:40 PM
// Design Name: 
// Module Name: add_sub
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


module add_sub(
    input [31:0] A,B,
    input add_sub_sel, 
    output [31:0] add_res,
    output V,C,Z,S
    );
    wire [31:0] cla_res;
    CLA_32   cla_32(.A(A),.B(B),
              .cin(add_sub_sel),
              .cout(cout),
              .sum(cla_res),
              .V(V));
              
    assign add_res = cla_res;
    assign Z = ~(|cla_res);
    assign S = cla_res[31];
    assign C = cout;
    
    endmodule
//////////////////////////////
module CLA_32(input [31:0] A,B,
              input cin,
              output cout,
              output [31:0] sum,
              output V);
    wire [31:0] B_one_comp;
    
    assign B_one_comp = B^{32{cin}};
    assign cout = carry_vector[6];
    wire [7:0] carry_vector;
    CLA_4 add0(.x(A[3:0]  ),.y(B_one_comp[3:0]  ),.c0(cin),.sum(sum[3:0]),.V(),.cout(carry_vector[0]));
    CLA_4 add1(.x(A[7:4]  ),.y(B_one_comp[7:4]  ),.c0(carry_vector[0]),.sum(sum[7:4]),.V(),.cout(carry_vector[1]));
    CLA_4 add2(.x(A[11:8] ),.y(B_one_comp[11:8] ),.c0(carry_vector[1]),.sum(sum[11:8]),.V(),.cout(carry_vector[2]));
    CLA_4 add3(.x(A[15:12]),.y(B_one_comp[15:12]),.c0(carry_vector[2]),.sum(sum[15:12]),.V(),.cout(carry_vector[3]));
    CLA_4 add4(.x(A[19:16]),.y(B_one_comp[19:16]),.c0(carry_vector[3]),.sum(sum[19:16]),.V(),.cout(carry_vector[4]));
    CLA_4 add5(.x(A[23:20]),.y(B_one_comp[23:20]),.c0(carry_vector[4]),.sum(sum[23:20]),.V(),.cout(carry_vector[5]));
    CLA_4 add6(.x(A[27:24]),.y(B_one_comp[27:24]),.c0(carry_vector[5]),.sum(sum[27:24]),.V(),.cout(carry_vector[6]));
    CLA_4 add7(.x(A[31:28]),.y(B_one_comp[31:28]),.c0(carry_vector[6]),.sum(sum[31:28]),.V(V),.cout(carry_vector[7]));
    
endmodule
       
//////////////////////////////
module CLA_4(input [3:0] x,y,
        input c0,
        output cout,
        output [3:0] sum,
        output V);
        wire [4:0] c_values;
        
        assign V = c_values[4] ^ c_values[3];  
        assign c_values[0] = c0;
        assign cout = c_values[4];
        genvar i;
        generate
            for (i=0;i<4;i=i+1)begin
                assign c_values[i+1] = (x[i]&y[i])|((x[i]^y[i])&c_values[i]);
                assign sum[i]=x[i]^y[i]^c_values[i];
            end
        endgenerate
endmodule

    /////////////////////////
module HA(input x,y,
          output cout,s);
    assign s = x^y;
    assign c = x&y;
endmodule
    /////////////////////////
module FA(input x,y,ci,
          output cout,s);
    wire c1;
    wire c2;
    wire s1;
    HA ha1(.x(x),.y(y),.cout(c1),.s(s1));
    HA ha2(.x(s1),.y(ci),.cout(c2),.s(s));
    assign cout = c1|c2;
    
endmodule