
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
    logic [15:0] Abus_tb, Bbus_tb, expected, Results_tb; // 16-bit buses and expected result
    logic [3:0] ctrl_in_tb;                             // 4-bit control signal
    int vectornum;                                      // Counter for test vectors
    logic [51:0] testvectors [18:0];                    // Array to store test vectors (52-bit per vector)
                                                        // Format: 16'hAbus 16'hBbus 4'hctrl 16'hexpected
    integer result_file;                                // File handle for writing results

    // Instantiate the DUT (Device Under Test)
    ProsseningUnit dut (
        .Abus(Abus_tb),
        .Bbus(Bbus_tb),
        .ctrl_in(ctrl_in_tb),
        .Results(Results_tb)
    );

    // Testbench initialization
    initial begin
        // Open the file for writing results
        result_file = $fopen("test_results.txt", "w");
        if (result_file == 0) begin
            $display("Error: Unable to open test_results.txt");
            $finish;
        end

        // Read test vectors from file (in hexadecimal format)
        $readmemh("test_vector.mem", testvectors);

        // Loop through the test vectors
        for (vectornum = 0; vectornum < 19; vectornum = vectornum + 1) begin
            #1; // Wait for 1 time unit to apply inputs
            // Load inputs (Abus, Bbus, ctrl_in) and expected result from the current test vector
            {Abus_tb, Bbus_tb, ctrl_in_tb, expected} = testvectors[vectornum];

            #1; // Wait for 1 time unit for the operation to complete

            // Compare results and check for mismatches
            if (Results_tb !== expected) begin
                // Test failed, log to display and file
                $display("Test failed for vector %0d: Expected %h, Got %h", vectornum, expected, Results_tb);
                $fwrite(result_file, "Test failed for vector %0d: Expected %h, Got %h\n", vectornum, expected, Results_tb);
                $fwrite(result_file, "Inputs: Abus = %h, Bbus = %h, ctrl_in = %b\n", Abus_tb, Bbus_tb, ctrl_in_tb);
            end else begin
                // Test passed, log to display and file
                $display("Test passed for vector %0d", vectornum);
                $fwrite(result_file, "Test passed for vector %0d\n", vectornum);
            end
        end

        // Close the result file
        $fclose(result_file);
    end

endmodule

