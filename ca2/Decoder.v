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
    reg [BIT-1:0] addr_chunk; // Temporary variable to hold each address chunk

    always @(*) begin
        out = {SIZE{1'b0}}; // Initialize out with SIZE zeros
        // Loop through each chunk of the input generated_addr
        for (i = 0; i < K; i = i + 1) begin
            addr_chunk = generated_addr[BIT * (i + 1) - 1 : BIT * i]; // Extract the chunk
            if (addr_chunk < SIZE) begin // Ensure addr_chunk is within bounds
                out[addr_chunk] = 1'b1; // Set the corresponding output bit
            end
        end
    end
endmodule
