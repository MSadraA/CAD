`timescale 1ns/1ps

module Mux_k_to_1_tb;

    // Parameters
    parameter K = 4;
    parameter SIZE = 16;
    parameter BIT = $clog2(K);

    // Testbench signals
    reg [SIZE-1:0] in [0:K-1];
    reg [BIT-1:0] sel;
    wire [SIZE-1:0] out;

    // Instantiate the Mux_k_to_1 module
    Mux_k_to_1 #(.K(K), .SIZE(SIZE)) uut (
        .sel(sel),
        .in(in),
        .out(out)
    );

    initial begin
        // Initialize input signals
        in[0] = 16'hAAAA;
        in[1] = 16'hBBBB;
        in[2] = 16'hCCCC;
        in[3] = 16'hDDDD;

        // Test different values of 'sel' to check if output matches the selected input
        $display("Testing Mux_k_to_1 with K=%0d, SIZE=%0d, BIT=%0d", K, SIZE, BIT);
        
        sel = 0;
        #10;
        $display("sel = %0d, out = %h (expected: %h)", sel, out, in[0]);

        sel = 1;
        #10;
        $display("sel = %0d, out = %h (expected: %h)", sel, out, in[1]);

        sel = 2;
        #10;
        $display("sel = %0d, out = %h (expected: %h)", sel, out, in[2]);

        sel = 3;
        #10;
        $display("sel = %0d, out = %h (expected: %h)", sel, out, in[3]);

        // End simulation
        $stop;
    end

endmodule
