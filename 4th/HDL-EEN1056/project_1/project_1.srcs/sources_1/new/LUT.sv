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
    input [15:0] LUT_in,          // 16-bit input to the LUT (Look-Up Table)
    output logic [15:0] LUT_out   // 16-bit output from the LUT
);

    // Four instances of the S_box module, each handling 4 bits of the input
    S_box s4(
        .Sbox_in(LUT_in[15:12]),   // Upper 4 bits of LUT_in
        .Sbox_out(LUT_out[15:12])  // Upper 4 bits of LUT_out
    );
    
    S_box s3(
        .Sbox_in(LUT_in[11:8]),    // Bits 11 to 8 of LUT_in
        .Sbox_out(LUT_out[11:8])   // Bits 11 to 8 of LUT_out
    );
    
    S_box s2(
        .Sbox_in(LUT_in[7:4]),     // Bits 7 to 4 of LUT_in
        .Sbox_out(LUT_out[7:4])    // Bits 7 to 4 of LUT_out
    );
    
    S_box s1(
        .Sbox_in(LUT_in[3:0]),     // Lower 4 bits of LUT_in
        .Sbox_out(LUT_out[3:0])    // Lower 4 bits of LUT_out
    );

endmodule

