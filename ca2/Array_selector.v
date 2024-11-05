module MultiSelector #(
    parameter SIZE = 16,                    // Maximum value range for address
    parameter K = 4                         // Number of Selector instances
) (
    input [$clog2(SIZE)*SIZE-1:0] address_array,     // Flattened address inputs
    input [($clog2(K) + $clog2(SIZE)) * K * SIZE - 1:0] inputs,  
    output [$clog2(k) * SIZE -1:0] sel_array    // Flattened outputs - no array declaration
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