
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 10:45:56 PM
// Design Name: 
// Module Name: TestBenchForTheProcessingUnit
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


module ProsseningUnit_tb();

    // Testbench signals
    logic [15:0] Abus_tb, Bbus_tb, expected, Results_tb;
    logic [3:0] ctrl_in_tb;
    int vectornum;
    logic [51:0] testvectors [18:0];//4 52-bits ie. 16'h1111 4'h0 16'h1111 16'h2222
    integer result_file;
    // Instantiate the DUT (Device Under Test)
    ProsseningUnit dut (
        .Abus(Abus_tb),
        .Bbus(Bbus_tb),
        .ctrl_in(ctrl_in_tb),
        .Results(Results_tb)
    );
    initial begin
    // Open the file for writing
        result_file = $fopen("test_results.txt", "w");
        if (result_file == 0) begin
            $display("Error: Unable to open test_results.txt");
            $finish;
        end

        $readmemh("test_vector.mem",testvectors);// read hexodecimal values
        for (vectornum = 0; vectornum < 19; vectornum = vectornum + 1) begin
            #1; 
            {Abus_tb, Bbus_tb, ctrl_in_tb, expected} = testvectors[vectornum]; // Load inputs from test vector
            #1; // Wait for 1 time unit for the operation to complete           
            // Compare results and display test status
            if (Results_tb !== expected) begin
                $display("Test failed for vector %0d: Expected %h, Got %h", vectornum, expected, Results_tb);
                $fwrite(result_file, "Test failed for vector %0d: Expected %h, Got %h\n", vectornum, expected, Results_tb);
                $fwrite(result_file, "Inputs: Abus = %h, Bbus = %h, ctrl_in = %b\n", Abus_tb, Bbus_tb, ctrl_in_tb);              
            end else begin
                $display("Test passed for vector %0d", vectornum);
                $fwrite(result_file, "Test passed for vector %0d\n", vectornum);
                end
        end
        $fclose(result_file);
  
    end
endmodule
