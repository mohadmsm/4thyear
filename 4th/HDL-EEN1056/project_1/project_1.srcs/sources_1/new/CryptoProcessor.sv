
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 01:54:45 PM
// Design Name: 
// Module Name: CryptoProcessor
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


module CryptoProcessor(
    input [15:0] instruction,
    input clock,
    output [15:0] Results
    );
    logic [15:0] Doa,Dob;
    RAM R(.Raddra(instruction[11:8]),
          .Raddrb(instruction[7:4]),
          .Waddr(instruction[3:0]),
          .Doa(Doa),
          .Dob(Dob),
          .clk(clock),
          .Di(Results),
          .wen(1'b1));
    ProsseningUnit P(.Abus(Doa),
                     .Bbus(Dob),
                     .ctrl_in(instruction[15:12]),
                     .Results(Results));
    
endmodule
