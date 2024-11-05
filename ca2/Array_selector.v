module SelectorArray
#(
    parameter SIZE = 16,                          // Maximum value range (determines address width)
    parameter K = 8                               // Number of inputs per Selector
)
(
    input [($clog2(K) + $clog2(SIZE)) * K - 1:0] inputs, // Common inputs for all selectors
    output reg [$clog2(K)-1:0] results [SIZE-1:0]        // Array of results from each Selector
);

    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : selector_inst
            // Instantiate a Selector for each N value from 0 to SIZE-1
            Selector #(
                .SIZE(SIZE),
                .K(K)
            ) selector_inst (
                .N(i),                 // Each Selector gets a unique N from 0 to SIZE-1
                .inputs(inputs),       // Shared inputs among all Selectors
                .final_result(results[i]) // Store each Selector's result in the results array
            );
        end
    endgenerate

endmodule
