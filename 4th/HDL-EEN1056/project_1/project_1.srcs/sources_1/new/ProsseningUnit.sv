
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 04:31:40 PM
// Design Name: 
// Module Name: ProsseningUnit
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


module ProsseningUnit(
    input [15:0] Abus,           // 16-bit input bus A
    input [15:0] Bbus,           // 16-bit input bus B
    input [3:0] ctrl_in,         // 4-bit control input
    output logic [15:0] Results  // 16-bit output for results
);

    // Internal signals for enabling components and storing their outputs
    logic ALUen, LUTen, ROTen;        // Enable signals for ALU, LUT, and Rotator
    logic [15:0] ALUout, LUTout, ROTout; // Outputs from ALU, LUT, and Rotator

    // Instantiate Control Logic to determine which unit is enabled
    ControlLogic C (
        .ctrl(ctrl_in), 
        .ALUen(ALUen), 
        .LUTen(LUTen), 
        .ROTen(ROTen)
    );

    // Instantiate the ALU with Abus and Bbus as inputs
    ALU A (
        .A(Abus), 
        .B(Bbus), 
        .ALUout(ALUout), 
        .ALUctrl(ctrl_in[2:0])  // Lower 3 bits of ctrl_in used for ALU control
    );

    // Instantiate the LUT with Abus as input
    LUT L (
        .LUT_in(Abus), 
        .LUT_out(LUTout)
    );

    // Instantiate the Rotator with Bbus as input
    Rotator R (
        .Rotator_in(Bbus), 
        .Rotator_out(ROTout), 
        .Rotctrl(ctrl_in[2:0])  // Lower 3 bits of ctrl_in used for Rotator control
    );

    // Combinational logic to select the output based on enabled unit
    always_comb begin
        if (ALUen)
            Results = ALUout;    // Use ALU output if ALU is enabled
        else if (ROTen)
            Results = ROTout;    // Use Rotator output if Rotator is enabled
        else if (LUTen)
            Results = LUTout;    // Use LUT output if LUT is enabled
        else
            Results = 16'b0;     // Default to 0 if no unit is enabled
    end

endmodule

