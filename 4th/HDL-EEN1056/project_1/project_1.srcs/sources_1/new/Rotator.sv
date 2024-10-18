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
    input [15:0] Rotator_in,      // 16-bit input for rotation
    input [2:0] Rotctrl,          // 3-bit control signal for rotation direction and amount
    output logic [15:0] Rotator_out // 16-bit rotated output
);

    // Combinational logic for rotation
    always_comb begin
        case(Rotctrl)
            3'b000: Rotator_out = {Rotator_in[14:0], Rotator_in[15]};      // Rotate left by 1 bit
            3'b001: Rotator_out = {Rotator_in[13:0], Rotator_in[15:14]};   // Rotate left by 2 bits
            3'b010: Rotator_out = {Rotator_in[12:0], Rotator_in[15:13]};   // Rotate left by 3 bits
            3'b011: Rotator_out = {Rotator_in[11:0], Rotator_in[15:12]};   // Rotate left by 4 bits
            3'b100: Rotator_out = {Rotator_in[7:0], Rotator_in[15:8]};     // Rotate left by 8 bits
            3'b101: Rotator_out = {Rotator_in[3:0], Rotator_in[15:4]};     // Rotate right by 4 bits
            3'b110: Rotator_out = {Rotator_in[7:0], Rotator_in[15:8]};     // Rotate right by 8 bits
            default: Rotator_out = Rotator_in;                             // Default case: no rotation
        endcase
    end

endmodule
