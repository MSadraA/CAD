`timescale 1ns/1ns
module buffer_tb();
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
    reg [(WIDTH*K)-1:0] par_in;
    wire [(WIDTH*J)-1:0] par_out;
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