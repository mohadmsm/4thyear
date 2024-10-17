`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 01:11:34 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [15:0] A,
    input [15:0] B,
    input [2:0] ALUctrl,
    output logic [15:0] ALUout
    );
    always_comb    
        case(ALUctrl)
        3'b000: ALUout = (A + B) & 16'hFFFF;
        3'b001: ALUout = (A - B) & 16'hFFFF;
        3'b010: ALUout = (A * B) & 16'hFFFF;
        3'b011: ALUout = A & B;
        3'b100: ALUout = A | B;
        3'b101: ALUout = A ^ B;
        3'b110: ALUout = ~ A;
        3'b111: ALUout = A ;
        endcase      
endmodule
