`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 03:03:37 PM
// Design Name: 
// Module Name: S_box
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


module S_box(
    input [3:0] Sbox_in,
    output logic [3:0] Sbox_out
    );
    always_comb
        begin 
            case(Sbox_in)
                4'h0: Sbox_out = 4'hC;
                4'h1: Sbox_out = 4'h5;
                4'h2: Sbox_out = 4'h6;
                4'h3: Sbox_out = 4'hB;
                4'h4: Sbox_out = 4'h9;
                4'h5: Sbox_out = 4'h0;
                4'h6: Sbox_out = 4'hA;
                4'h7: Sbox_out = 4'hD;
                4'h8: Sbox_out = 4'h3;
                4'h9: Sbox_out = 4'hE;
                4'hA: Sbox_out = 4'hF;
                4'hB: Sbox_out = 4'h8;
                4'hC: Sbox_out = 4'h4;
                4'hD: Sbox_out = 4'h7;
                4'hE: Sbox_out = 4'h1;
                4'hF: Sbox_out = 4'h2;
             endcase 
         end
endmodule
