module Logic
#(
    parameter SIZE = 16,                          // Maximum value range (determines address width)
    parameter K = 8                               // Number of inputs per Selector
)
(
    input [$clog2(SIZE)-1:0] address_in,  
    output [($clog2(SIZE) * K) - 1:0] generated_nums,          // Input address
    output [(SIZE * $clog2(K)) - 1:0] final_result  // Final concatenated result from the array selector
);

    wire [($clog2(K) + $clog2(SIZE)) * K - 1:0] inputs_to_array; // Concatenated inputs for Array_selector

    // Instantiate the Generator module
    Generator #(
        .SIZE(SIZE),
        .K(K)
    ) generator_inst (
        .num_in(address_in),                    // Address input to Generator
        .num_out(generated_nums)                // Generated consecutive numbers output
    );

    // Use the Concat module to handle concatenation of inputs from Generator
    Concat #(
        .SIZE(SIZE),
        .K(K)
    ) concat_inst (
        .in(generated_nums),                    // Input from the Generator
        .out(inputs_to_array)                   // Concatenated output used as input for Array_selector
    );

    // Instantiate the Array_selector module
    Array_selector #(
        .SIZE(SIZE),
        .K(K)
    ) array_selector_inst (
        .inputs(inputs_to_array),               // Inputs from Concat module to Array_selector
        .results(final_result)                  // Final result output from Array_selector
    );



endmodule
