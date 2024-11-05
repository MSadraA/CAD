module Decoder 
#(
    parameter SIZE = 8, 
    parameter K = 4,
    parameter BIT = $clog2(SIZE)
) 
(
    input [(K * BIT) - 1:0] generated_addr,     // Concatenated input generated_addr of K chunks, each of BIT width
    output reg [SIZE - 1:0] out   // Concatenated one-hot encoded outputs for each chunk
);

    integer i; // Loop index

    always @(*) begin
        out = {SIZE{1'b0}}; // Corrected to properly initialize out with SIZE zeros
        // Loop through each chunk of the input generated_addr
        for (i = 0; i < K; i = i + 1) begin
            out[generated_addr[BIT * (i + 1) - 1 : BIT * i]] = 1'b1;
        end
    end
endmodule
