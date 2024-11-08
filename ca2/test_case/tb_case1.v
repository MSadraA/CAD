`timescale 1ns/1ns

module tb_case1();

    // Testbench Parameters
    parameter SIZE = 4;
    parameter WIDTH = 8;  // Define width (adjust as needed)
    parameter K = 1;      // Number of parallel inputs
    parameter J = 1;      // Number of parallel outputs

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
    always #5 clk = ~clk; 

    initial begin
        clk = 0;
        rst = 1;
        w_en = 0;
        r_en = 0;
        par_in = 0;

        #10;
        rst =0;
        #5

        #20;//clk1
        w_en = 1;
        r_en = 0;
        par_in = 8'd8;
        
        #20;//clk2
        w_en = 0;
        r_en = 1;

        #20//clk3
        w_en = 0;
        r_en = 1;

        #20//clk4
        w_en = 1;
        r_en = 1;
        par_in = 8'd12;

        #20//clk5
        w_en = 1;
        r_en = 1;
        par_in = 8'd5;

        #20//clk6
        w_en = 1;
        r_en = 1;
        par_in = 8'd7;
        
        #20//clk7
        w_en = 0;
        r_en = 1;

        #20//clk8
        w_en = 0;
        r_en = 1;

        #20//clk9
        w_en = 0;
        r_en = 1;

        #300;
        $stop;
    end
endmodule
