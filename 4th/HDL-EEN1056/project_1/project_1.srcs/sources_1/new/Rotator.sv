`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 02:08:12 PM
// Design Name: 
// Module Name: Rotator
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


module Rotator(
input [15:0] Rotator_in,
input [2:0] Rotctrl,
output logic [15:0] Rotator_out
    );
    always_comb
        begin
            case(Rotctrl)
                3'b000: Rotator_out = {Rotator_in[14:0], Rotator_in[15]}; //rotate left one bit
                3'b001: Rotator_out = {Rotator_in[13:0], Rotator_in[15:14]}; //rotate left 2 bits
                3'b010: Rotator_out = {Rotator_in[12:0], Rotator_in[15:13]}; //rotate left 3 bits
                3'b011: Rotator_out = {Rotator_in[11:0], Rotator_in[15:12]}; //rotate left 4 bits
                3'b100: Rotator_out = {Rotator_in[7:0], Rotator_in[15:8]}; //rotate left 8 bits
                3'b101: Rotator_out = {Rotator_in[15:12], Rotator_in[11:0]}; //rotate right 4 bits
                3'b110: Rotator_out = {Rotator_in[15:8], Rotator_in[7:0]}; //rotate right 8 bits
                default: Rotator_out = Rotator_in ; //default case
             endcase
         end             
endmodule
