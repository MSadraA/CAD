module Selector
#(
    parameter SIZE = 16,                          // Maximum value range (determines address width)
    parameter K = 8                           // Number of inputs
)
(
    input [$clog2(SIZE)-1:0] N,                   // Address input
    input [($clog2(K) + $clog2(SIZE)) * K - 1:0] inputs, // Concatenated K inputs
    output reg [$clog2(K)-1:0] final_result          // Final OR-ed result
);

    // Intermediate wires for each comparison result
    wire [$clog2(K)-1:0] result [0:K-1];

    genvar i;
    generate
        for (i = 0; i < K; i = i + 1) begin : match_check
            // Extract address and data parts for each input
            wire [$clog2(SIZE)-1:0] addr_part = inputs[(i+1) * ($clog2(K) + $clog2(SIZE)) - 1 -: $clog2(SIZE)];
            wire [$clog2(K)-1:0] data_part = inputs[i * ($clog2(K) + $clog2(SIZE)) +: $clog2(K)];

            // Compare address part with N; if match, output data part; otherwise, output zero
            assign result[i] = (addr_part == N) ? data_part : {K{1'b0}};
        end
    endgenerate

    // OR all results to produce the final output

    assign final_result = 0;
    generate
        for (i = 0; i < K; i = i + 1) begin : 
            assign final_result = final_result|result[i];
        end
    endgenerate

endmodule
