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
    input [15:0] A,                // First 16-bit input operand
    input [15:0] B,                // Second 16-bit input operand
    input [2:0] ALUctrl,           // 3-bit ALU control signal
    output logic [15:0] ALUout     // 16-bit ALU output
);

    // Combinational logic for ALU operations
    always_comb begin
        case(ALUctrl)
            3'b000: ALUout = (A + B) & 16'hFFFF;  // Addition, mask result to 16 bits
            3'b001: ALUout = (A - B) & 16'hFFFF;  // Subtraction, mask result to 16 bits
            3'b010: ALUout = (A * B) & 16'hFFFF;  // Multiplication, mask result to 16 bits
            3'b011: ALUout = A & B;               // Bitwise AND
            3'b100: ALUout = A | B;               // Bitwise OR
            3'b101: ALUout = A ^ B;               // Bitwise XOR
            3'b110: ALUout = ~A;                  // Bitwise NOT (A)
            3'b111: ALUout = A;                   // Pass-through (A)
        endcase
    end
    
endmodule

