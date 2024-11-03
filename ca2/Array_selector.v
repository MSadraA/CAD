module MultiSelector #(
    parameter SIZE = 16,                    // Maximum value range for address
    parameter K = 4                         // Number of Selector instances
) (
    input [$clog2(SIZE)*K-1:0] N_flat,     // Flattened address inputs
    input [(K + $clog2(SIZE)) * K - 1:0] inputs,  
    output [K*K-1:0] outputs_flat    // Flattened outputs - no array declaration
);
    // Generate K instances
    genvar i;
    generate
        for (i = 0; i < K; i = i + 1) begin : selector_instance
            Selector #(
                .SIZE(SIZE),
                .K(K)
            ) selector_inst (
                .N(N_flat[i*$clog2(SIZE) +: $clog2(SIZE)]),
                .inputs(inputs),
                .final_result(outputs_flat[i*K +: K])
            );
        end
    endgenerate

endmodule