module Array_selector
#(
    parameter SIZE = 16,                          // Maximum value range (determines address width)
    parameter K = 8                               // Number of inputs per Selector
)
(
    input [($clog2(K) + $clog2(SIZE)) * K - 1:0] inputs,  // Common inputs for all selectors
    output reg [(SIZE * $clog2(K)) - 1:0] results         // Concatenated results from each Selector
);

    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : selector_inst
            wire [$clog2(K)-1:0] final_result;

            // Instantiate a Selector for each N value from 0 to SIZE-1
            Selector #(
                .SIZE(SIZE),
                .K(K)
            ) selector_inst (
                .N(i[$clog2(SIZE) - 1 : 0]),                    // Each Selector gets a unique N from 0 to SIZE-1
                .inputs(inputs),          // Shared inputs among all Selectors
                .final_result(final_result)  // Result from each Selector
            );

            // Assign the result to the appropriate part of the concatenated results bus
            always @(*) begin
                results[(i+1) * $clog2(K) - 1 -: $clog2(K)] = final_result;
            end
        end
    endgenerate

endmodule
