module Out_of_buff #(
    parameter SIZE = 16,   // Maximum value range (0 to SIZE-1)
    parameter J = 4        // Number of multiplexer outputs desired
) (
    input [$clog2(SIZE)-1:0] N,                // Input number
    input [J*$clog2(4)-1:0] sel_flat,          // Flattened select signals
    output [J*SIZE-1:0] final_outputs_flat     // Flattened outputs
);
    // First generate 4 consecutive numbers using Generator
    wire [($clog2(SIZE) * 4) - 1:0] generated_nums;
    
    Generator #(
        .SIZE(SIZE)
    ) gen_inst (
        .num_in(N),
        .num_out(generated_nums)
    );

    // Create J multiplexers to select from the generated numbers
    genvar j;
    generate
        for (j = 0; j < J; j = j + 1) begin : mux_instances
            Mux_k_to_1 #(
                .K(4),          // 4 inputs from Generator
                .SIZE($clog2(SIZE))  // Each number is log2(SIZE) bits
            ) mux_inst (
                .in_bus(generated_nums),
                .sel(sel_flat[j*$clog2(4) +: $clog2(4)]),
                .out(final_outputs_flat[j*SIZE +: SIZE])
            );
        end
    endgenerate
endmodule