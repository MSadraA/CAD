module multi_decoder #(parameter SIZE = 8, parameter BIT = $clog2(SIZE), parameter K = 4) (
    input [(K * BIT) - 1:0] string,     // Concatenated input string of K chunks, each of BIT width
    output reg [(K * SIZE) - 1:0] out   // Concatenated one-hot encoded outputs for each chunk
);

    integer i; // Loop index

    always @(*) begin
        // Loop through each chunk of the input string
        for (i = 0; i < K; i = i + 1) begin
            // Clear the current output segment to all 0's
            out[i * SIZE +: SIZE] = {SIZE{1'b0}};
            
            // Decode each BIT chunk from string and set the corresponding output bit
            if (string[i * BIT +: BIT] < SIZE) begin
                out[i * SIZE + string[i * BIT +: BIT]] = 1'b1;
            end
        end
    end
endmodule
