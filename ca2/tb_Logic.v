`timescale 1ns/1ps

module tb();

    // Parameters
    parameter K = 4;
    parameter J = 8;
    parameter SIZE = 16;
    parameter WIDTH = 8;
    parameter BIT = $clog2(SIZE);

    reg [$clog2(SIZE) - 1 : 0] in =  4'd14;

    wire [($clog2(SIZE) * K) - 1:0] num_out;
    wire [($clog2(SIZE) + $clog2(K)) * K - 1 : 0] out;
    wire [(SIZE * $clog2(K)) - 1:0] results;
    wire [SIZE - 1:0] decoder_out;

    reg [BIT-1:0] write_add = 4'd14;
    reg [BIT-1:0] read_add = 4'd1;
    reg [(WIDTH*K)-1:0] par_in;
    wire [(WIDTH*J)-1:0] par_out;

    reg clk = 0, rst = 1, ld = 0; 

    // Array of 8-bit binary inputs
    reg [WIDTH-1:0] inputs [0:3]; // Array for 1, 2, 3, and 4

    // Clock generation
    always #10 clk = ~clk;
    initial #12 rst = 0;

    initial begin
        // Initialize the inputs array with values for 1, 2, 3, and 4
        inputs[0] = 8'b00000001; // 1
        inputs[1] = 8'b00000010; // 2
        inputs[2] = 8'b00000011; // 3
        inputs[3] = 8'b00000100; // 4

        // Sequentially load values from the inputs array
        integer i; // Declare an integer variable for the loop
        for (i = 0; i < 4; i++) begin
            par_in = inputs[i];    // Load value from the array
            #25 ld = 1;            // Assert load signal
            #10 ld = 0;            // De-assert load signal
        end

        // Stop the simulation after all inputs are processed
        #10 $stop;
    end

    Buffer #(
    .SIZE(SIZE),    // Buffer size
    .WIDTH(WIDTH),   // Data width
    .K(K),           // Input parallel factor
    .J(J)            // Output parallel factor
    ) 
    (
    .clk(clk),
    .ld(ld),
    rst(rst),
    .write_add(write_add),
    .read_add(read_add),
    .par_in(par_in),
    .par_out(par_out)
    );

    // Uncomment and complete the following instances as needed

    // Generator #(.SIZE(SIZE) , .K(K))
    // generator (
    //     .num_in(in),
    //     .num_out(num_out)
    // );

    // Decoder #(.SIZE(SIZE) , .K(K))
    // decoder
    // (
    //     .generated_addr(num_out) ,
    //     .out(decoder_out)
    // );

    // Concat #(.SIZE(SIZE) , .K(K))
    // concat 
    // (
    //     .in(num_out),
    //     .out(out)
    // );

    // Array_selector #(.SIZE(SIZE) , .K(K))
    // array_selector
    // (
    //     .inputs(out) ,
    //     .results(results)
    // );

endmodule

