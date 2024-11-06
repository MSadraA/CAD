<<<<<<< HEAD
`timescale 1ns/1ps

module tb;

    // Testbench Parameters
    parameter WIDTH = 8;  // Define width (adjust as needed)
    parameter K = 4;      // Number of parallel inputs
    parameter J = 4;      // Number of parallel outputs

    // Inputs to DUT (Device Under Test)
    reg clk;
    reg rst;
    reg w_en;
    reg r_en;
=======
`timescale 1ns/1ns
module tb();
    // Parameters
    parameter K = 8;
    parameter J = 4;
    parameter SIZE = 16;
    parameter WIDTH = 4;
    parameter BIT = $clog2(SIZE);
    // reg [$clog2(SIZE) - 1 : 0] in =  4'd14;
    // wire [($clog2(SIZE) * K) - 1:0] num_out;
    // wire [($clog2(SIZE) + $clog2(K)) * K - 1 : 0] out;
    // wire [(SIZE * $clog2(K)) - 1:0] results;
    // wire [SIZE - 1:0] decoder_out;

    reg [BIT-1:0] write_add = 4'd14;
    reg [BIT-1:0] read_add = 4'd1;
>>>>>>> d16a19a6242336fbd48c3eea4e375fc78a6b85f9
    reg [(WIDTH*K)-1:0] par_in;

    // Outputs from DUT
    wire [(WIDTH*J)-1:0] par_out;
<<<<<<< HEAD
    wire empty;
    wire ready;
    wire full;
    wire valid;

    // Instantiate the TopModule
    TopModule #(
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
        
        // Check if ready is asserted and then load data
        if (ready) begin
            $display("Write enabled, buffer is ready.");
        end else begin
            $display("Buffer not ready for write.");
        end

        w_en = 0; // Disable write

        // Wait a few cycles
        #50;

        // Read Operation
        r_en = 1;
        
        // Wait for read to complete
        #20;

        // Check valid signal for read operation
        if (valid) begin
            $display("Read valid, data: %h", par_out);
        end else begin
            $display("Read not valid.");
        end

        r_en = 0;

        // Test full and empty flags
        #50;
        if (full) begin
            $display("Buffer is full.");
        end else if (empty) begin
            $display("Buffer is empty.");
        end

        // End simulation
        #100;
        $stop;
    end
endmodule
=======
    reg clk = 0 , rst = 1 , ld = 0;

    // Initialize par_in with values 1,2,3,4 (each 8 bits)
    initial begin
        par_in = {4'h04, 4'h03, 4'h02, 4'h01 ,4'h01,4'h01,4'h01,4'h01};  // Concatenated in reverse order due to Verilog bit ordering
    end

    always #10 clk = ~clk;
    
    initial #12 rst = 0;
    
    initial begin
        #25 ld = 1;
        #10 ld = 0;
    end

    Buffer #(
        .SIZE(SIZE),    // Buffer size
        .WIDTH(WIDTH),  // Data width
        .K(K),         // Input parallel factor
        .J(J)          // Output parallel factor
    ) buffer (
        .clk(clk),
        .ld(ld),
        .rst(rst),
        .write_add(write_add),
        .read_add(read_add),
        .par_in(par_in),
        .par_out(par_out)
    );

    initial #40 $stop;
   
endmodule
>>>>>>> d16a19a6242336fbd48c3eea4e375fc78a6b85f9
