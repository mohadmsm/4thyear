`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 02:15:18 PM
// Design Name: 
// Module Name: CryptoProcessor_tb
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


module CryptoProcessor_tb();
    int vectornum;
    logic [15:0] test_instrection, Results_tb;
    logic [15:0] instrections [16:0];
    integer RAM_file,i;
    logic clk;
    reg [15:0] RAM [0:15];
    CryptoProcessor dut(.instruction(test_instrection),
                        .Results(Results_tb), .clock(clk));
     initial begin
        clk =0;
        forever #1 clk = ~clk;
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
      initial begin
    // Open the file for writing
        RAM_file = $fopen("RAM_final_contents.txt", "w");
        if (RAM_file == 0) begin
            $display("Error: Unable to open test_results.txt");
            $finish;
        end
        $readmemh("test_program.mem",instrections);// read hexodecimal values
        for (vectornum = 0; vectornum < 17; vectornum = vectornum + 1) begin
            #1;
            test_instrection = instrections[vectornum];
            #1;
            $display("Testfor vector %0d for %h is %h", vectornum,test_instrection, Results_tb);
            RAM[test_instrection[3:0]]= Results_tb;
            end
             // Write the contents of the RAM array to the file
        for (i = 0; i < 16; i = i + 1) begin
            $fwrite(RAM_file, "RAM[%0d] = %h\n", i, RAM[i]);
        end
            $fclose(RAM_file);
        end

    
endmodule
