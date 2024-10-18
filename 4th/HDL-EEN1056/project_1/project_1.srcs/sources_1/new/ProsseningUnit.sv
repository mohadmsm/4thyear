
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
   input [15:0] Abus,
   input [15:0] Bbus,
   input [3:0] ctrl_in,
   output logic [15:0] Results 
    );
    logic ALUen, LUTen, ROTen;
    logic [15:0] ALUout, LUTout, ROTout;
    ControlLogic C (.ctrl(ctrl_in),.ALUen(ALUen),.LUTen(LUTen),.ROTen(ROTen));
    ALU A(.A(Abus),.B(Bbus),.ALUout(ALUout),.ALUctrl(ctrl_in[2:0]));
    LUT L(.LUT_in(Abus),.LUT_out(LUTout));
    Rotator R(.Rotator_in(Bbus),.Rotator_out(ROTout),.Rotctrl(ctrl_in[2:0]));
    always_comb begin
        if (ALUen)
            Results = ALUout;
        else if (ROTen)
            Results = ROTout;
        else if (LUTen)
            Results = LUTout;
        else
            Results = 16'b0;  // Default value if no enable signal is active
    end
endmodule
