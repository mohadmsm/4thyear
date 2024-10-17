`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 03:48:59 PM
// Design Name: 
// Module Name: ControlLogic
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


module ControlLogic(
    input [3:0] ctrl,
    output logic ALUen,
    output logic LUTen,
    output logic ROTen
    );
    always_comb
    begin
    ALUen = ~ctrl[3];
    ROTen = ctrl[3] & ~(ctrl[2] & ctrl[1] & ctrl[0]);
    LUTen = ctrl[3] & ctrl[2] & ctrl[1] & ctrl[0];
    end
endmodule
