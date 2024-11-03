module MultiSelector
#(
    parameter SIZE = 16,                     // Maximum value range for address
    parameter DATA_WIDTH = 8,                // Width of the initial data part
    parameter K = 4                          // Number of Selector instances
)
(
    input [$clog2(SIZE)-1:0] N [0:K-1],      // Array of address inputs
    input [(DATA_WIDTH + $clog2(SIZE)) * K - 1:0] inputs, // Concatenated inputs for all Selectors
    output [DATA_WIDTH-1:0] outputs [0:K-1]  // Array of outputs from each Selector
);

    // Instantiate K Selector modules
    genvar i;
    generate
        for (i = 0; i < K; i = i + 1) begin : selector_instance
            Selector #(
                .SIZE(SIZE),
                .DATA_WIDTH(DATA_WIDTH),
                .K(1)  // Each instance operates independently
            ) selector_inst (
                .N(N[i]),                      // Pass the ith address input
                .inputs(inputs),              // Share the concatenated inputs
                .final_result(outputs[i])     // Capture the output
            );
        end
    endgenerate

endmodule
