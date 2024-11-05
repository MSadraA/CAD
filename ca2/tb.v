`timescale 1ns/1ps

module tb();

    // Parameters
    parameter K = 4;
    parameter J = 8;
    parameter SIZE = 16;
    parameter WIDTH = 8;
    parameter BIT = $clog2(K);

    reg [$clog2(SIZE) - 1 : 0] in =  4'd14;

    wire [($clog2(SIZE) * K) - 1:0] num_out;
    wire [($clog2(SIZE) + $clog2(K)) * K - 1 : 0] out;
    wire [(SIZE * $clog2(K)) - 1:0] results;
    wire [SIZE - 1:0] decoder_out;


    Buffer #(
    .SIZE(SIZE),    // Buffer size
    .WIDTH(WIDTH),    // Data width
    .K(K),        // Input parallel factor
    .J(J),        // Output parallel factor
    ) 
    (
    input wire clk,
    input wire ld,
    input wire rst,
    input wire [BIT-1:0] write_add,
    input wire [BIT-1:0] read_add,
    input wire [(WIDTH*K)-1:0] par_in,
    output wire [(WIDTH*J)-1:0] par_out
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

    initial #10 $stop;
    

endmodule
