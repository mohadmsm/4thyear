
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
    logic [15:0] Doa, Dob; // Data output A and B from RAM

    // Instantiate the RAM
    RAM R(
        .Raddra(instruction[11:8]), // Read address A
        .Raddrb(instruction[7:4]),  // Read address B
        .Waddr(instruction[3:0]),   // Write address
        .Doa(Doa),                   // Data output A
        .Dob(Dob),                   // Data output B
        .clk(clock),                 // Clock input
        .Di(Results),                // Data input for write
        .wen(1'b1)                   // Always write enabled
    );

    // Instantiate the Processing Unit
    ProsseningUnit P(
        .Abus(Doa),                   // A bus input
        .Bbus(Dob),                   // B bus input
        .ctrl_in(instruction[15:12]), // Control input
        .Results(Results)             // Results output
    );

endmodule

