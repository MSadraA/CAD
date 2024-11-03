module Selector
#(
    parameter SIZE = 16,                          // Maximum value range (determines address width)
    parameter K = 8                           // Number of inputs
)
(
    input [$clog2(SIZE)-1:0] N,                   // Address input
    input [(K + $clog2(SIZE)) * K - 1:0] inputs, // Concatenated K inputs
    output [K-1:0] final_result          // Final OR-ed result
);

    // Intermediate wires for each comparison result
    wire [K-1:0] result [0:K-1];

    genvar i;
    generate
        for (i = 0; i < K; i = i + 1) begin : match_check
            // Extract address and data parts for each input
            wire [$clog2(SIZE)-1:0] addr_part = inputs[(i+1) * (K + $clog2(SIZE)) - 1 -: $clog2(SIZE)];
            wire [K-1:0] data_part = inputs[i * (K + $clog2(SIZE)) +: K];

            // Compare address part with N; if match, output data part; otherwise, output zero
            assign result[i] = (addr_part == N) ? data_part : {K{1'b0}};
        end
    endgenerate

    // OR all results to produce the final output
    assign final_result = result[0] | result[1] | result[2] | result[3]; // Update for K > 4 if needed

endmodule
