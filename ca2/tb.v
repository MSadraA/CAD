`timescale 1ns/1ps

module Mux_k_to_1_tb;

    // Parameters
    parameter K = 4;
    parameter SIZE = 16;
    parameter BIT = $clog2(K);

    // Testbench signals
    reg [(K*SIZE)-1:0] in_bus;
    reg [BIT-1:0] sel;
    wire [SIZE-1:0] out;

    // Instantiate the Mux_k_to_1 module
    Mux_k_to_1 #(.K(K), .SIZE(SIZE)) uut (
        .in_bus(in_bus),
        .sel(sel),
        .out(out)
    );

    initial begin
        // Initialize in_bus with distinct values for each input segment
        in_bus = {16'hAAAA, 16'hBBBB, 16'hCCCC, 16'hDDDD};

        // Test different values of 'sel' to check if output matches the selected input
        $display("Testing Mux_k_to_1 with K=%0d, SIZE=%0d", K, SIZE);
        
        sel = 0;
        #10;
        $display("sel = %0d, out = %h (expected: %h)", sel, out, in_bus[0*SIZE +: SIZE]);

        sel = 1;
        #10;
        $display("sel = %0d, out = %h (expected: %h)", sel, out, in_bus[1*SIZE +: SIZE]);

        sel = 2;
        #10;
        $display("sel = %0d, out = %h (expected: %h)", sel, out, in_bus[2*SIZE +: SIZE]);

        sel = 3;
        #10;
        $display("sel = %0d, out = %h (expected: %h)", sel, out, in_bus[3*SIZE +: SIZE]);

        // End simulation
        $stop;
    end

endmodule
