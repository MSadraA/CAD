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

    always #10 clk = ~clk;
    initial #12 rst = 0;

    initial begin
        // Initialize par_in with 8-bit binary values for 1, 2, 3, and 4
        par_in = 8'b00000001; // par_in = 1
        #25 ld = 1;          // Load par_in value
        #10 ld = 0;         // Reset load signal

        #10 par_in = 8'b00000010; // par_in = 2
        #25 ld = 1;          // Load par_in value
        #10 ld = 0;         // Reset load signal

        #10 par_in = 8'b00000011; // par_in = 3
        #25 ld = 1;          // Load par_in value
        #10 ld = 0;         // Reset load signal

        #10 par_in = 8'b00000100; // par_in = 4
        #25 ld = 1;          // Load par_in value
        #10 ld = 0;         // Reset load signal

        // Stop the simulation after a delay
        #10 $stop;
    end

    Buffer #(
    .SIZE(SIZE),    // Buffer size
    .WIDTH(WIDTH),    // Data width
    .K(K),        // Input parallel factor
    .J(J)         // Output parallel factor
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
