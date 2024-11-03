module multi_decoder #(parameter SIZE = 8, parameter BIT = $clog2(SIZE), parameter K = 4) (
    input [(K * BIT) - 1:0] string,    // Concatenated input string of K chunks, each of BIT width
    output reg [SIZE-1:0] out [K-1:0]  // Array of one-hot encoded outputs for each chunk
);

    integer i, j; // Loop indices

    always @(*) begin
        // Loop through each chunk of the input string
        for (i = 0; i < K; i = i + 1) begin
            // Clear the current output to all 0's
            out[i] = {SIZE{1'b0}};
            
            // Extract the i-th chunk from the input string
            // and decode it into one-hot format
            if (string[i * BIT +: BIT] < SIZE) begin
                out[i][string[i * BIT +: BIT]] = 1'b1;
            end
        end
    end
endmodule
