
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 01:27:53 PM
// Design Name: 
// Module Name: RAM
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

module RAM #(parameter N = 16, M = 4) ( // N-bit word, M-bit address
    input clk,
    input [M-1:0] Raddra, // read address A, M
    output [N-1:0] Doa,// data A out
    input [M-1:0] Raddrb, // read address B
    output [N-1:0] Dob,// data B out
    input [M-1:0] Waddr, // write address
    input wen,// write enable
    input [N-1:0] Di// data in
);
// Add your RAM functionality here
// Define a memory array
reg [N-1:0] RAM [0:(2**M)-1];
// Initialize the RAM array with specific values
// Asynchronous read for ports A and B

   assign   Doa = RAM[Raddra]; // Read data for port A
   assign   Dob = RAM[Raddrb]; // Read data for port B

    // Falling-edge synchronous write
    always @(negedge clk) begin
        if (wen) begin
            RAM[Waddr] <= Di; // Write data if write enable is high
        end
    end
   initial begin
    RAM[0] = 16'h0001;
    RAM[1] = 16'hc505;
    RAM[2] = 16'h3c07;
    RAM[3] = 16'hd405;
    RAM[4] = 16'h1186;
    RAM[5] = 16'hf407;
    RAM[6] = 16'h1086;
    RAM[7] = 16'h4706;
    RAM[8] = 16'h6808;
    RAM[9] = 16'hbaa0;
    RAM[10] = 16'hc902;
    RAM[11] = 16'h100b;
    RAM[12] = 16'hc000;
    RAM[13] = 16'hc902;
    RAM[14] = 16'h100b;
    RAM[15] = 16'hb000;
end
endmodule