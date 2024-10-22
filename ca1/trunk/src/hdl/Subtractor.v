module subtractor_3bit (
    input wire [2:0] a,    // 3-bit input A
    input wire [2:0] b,    // 3-bit input B
    output wire [2:0] diff // 3-bit mul output
);

    // Perform subtraction
    assign diff = (a) - (b);

endmodule
