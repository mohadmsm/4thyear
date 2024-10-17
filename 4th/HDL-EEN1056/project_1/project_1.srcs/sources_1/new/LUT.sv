`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 03:12:47 PM
// Design Name: 
// Module Name: LUT
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


module LUT(
    input [15:0] LUT_in,
    output logic [15:0] LUT_out
    );
    S_box s4(.Sbox_in(LUT_in[15:12]),.Sbox_out(LUT_out[15:12]));
    S_box s3(.Sbox_in(LUT_in[11:8]),.Sbox_out(LUT_out[11:8]));
    S_box s2(.Sbox_in(LUT_in[7:4]),.Sbox_out(LUT_out[7:4]));
    S_box s1(.Sbox_in(LUT_in[3:0]),.Sbox_out(LUT_out[3:0]));  
endmodule
