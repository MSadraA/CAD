`timescale 1ns/1ns

module tb;

    // Testbench Parameters
    parameter SIZE = 16;
    parameter WIDTH = 8;  // Define width (adjust as needed)
    parameter K = 4;      // Number of parallel inputs
    parameter J = 4;      // Number of parallel outputs

    // Inputs to DUT (Device Under Test)
    reg clk;
    reg rst;
    reg w_en;
    reg r_en;
    reg [(WIDTH*K)-1:0] par_in;

    // Outputs from DUT
    wire [(WIDTH*J)-1:0] par_out;
    wire empty;
    wire ready;
    wire full;
    wire valid;

    // Instantiate the TopModule
    TopModule #(
        .SIZE(SIZE),
        .WIDTH(WIDTH),
        .K(K),
        .J(J)
    ) uut (
        .clk(clk),
        .rst(rst),
        .w_en(w_en),
        .r_en(r_en),
        .par_in(par_in),
        .par_out(par_out),
        .empty(empty),
        .ready(ready),
        .full(full),
        .valid(valid)
    );

    // Clock generation
    always #5 clk = ~clk;  // 100MHz clock (10ns period)

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        w_en = 0;
        r_en = 0;
        par_in = 0;

        #10;
        rst =0;


        // Write Operation
        // Generate some data to write into the buffer
        w_en = 1;
        par_in = {8'd10, 8'd15, 8'd25, 8'd12}; // Parallel input data (example)
        
        #100;  // Wait for 20ns


        w_en = 0; // Disable write

        // Wait a few cycles
        #50;

        // Read Operation
        r_en = 1;
        
        // Wait for read to complete
        #20;

        r_en = 0;

        #20
        r_en = 1;

        #20 
        r_en = 0;

        // End simulation
        #300;
        $stop;
    end
endmodule
