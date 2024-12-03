`timescale 1ns / 1ps

module tb;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [15:0] x1;
    reg [15:0] x2;

    // Outputs
    wire [31:0] out;
    wire done;

    // File handle for logging results
    integer file;

    // Instantiate the top_module
    top_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .x1(x1),
        .x2(x2),
        .out(out),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test sequence
    initial begin
        // Open a file to log results in the project directory
        file = $fopen("simulation_results.txt", "w");
        if (file == 0) begin
            $display("Error: Could not open file.");
            $finish;
        end

        // Initialize inputs
        rst = 1;
        start = 0;
        x1 = 0;
        x2 = 0;

        // Apply reset
        #20;
        rst = 0;

        // Test case 1: Both inputs are zero
        x1 = 16'h0000;
        x2 = 16'h0000;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 1: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 2: One input is zero
        x1 = 16'h0000;
        x2 = 16'hFFFF;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 2: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 3: Maximum positive and negative values
        x1 = 16'h7FFF;
        x2 = 16'h8000;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 3: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 4: Alternating bits
        x1 = 16'hAAAA;
        x2 = 16'h5555;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 4: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 5: Both inputs are maximum
        x1 = 16'hFFFF;
        x2 = 16'hFFFF;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 5: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 6: Random values
        x1 = 16'h1234;
        x2 = 16'hABCD;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 6: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 7: Large difference between inputs
        x1 = 16'hFFFF;
        x2 = 16'h0001;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 7: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 8: Both inputs are small
        x1 = 16'h0001;
        x2 = 16'h0002;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 8: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 9: Inputs are complements
        x1 = 16'hAAAA;
        x2 = ~x1;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 9: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 10: Input with high MSB
        x1 = 16'h8000;
        x2 = 16'h0001;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 10: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 11: All bits set except LSB
        x1 = 16'hFFFE;
        x2 = 16'h0001;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 11: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Test case 12: Overflow check
        x1 = 16'h7FFF;
        x2 = 16'h7FFF;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $fdisplay(file, "Test 12: x1=%h, x2=%h, out=%h", x1, x2, out);
        rst = 1; #20; rst = 0;

        // Finish simulation
        $fclose(file);
        $display("Simulation completed. Results written to simulation_results.txt");
        $finish;
    end

endmodule
