module Selector
#(
    parameter SIZE = 16,                     // Range of the address
    parameter K = 8                          // Width of the initial data part
)
(
    input [$clog2(SIZE)-1:0] N,              // Address input
    input [(K + $clog2(SIZE))-1:0] input0,   // Concatenated input with address and initial data part
    input [(K + $clog2(SIZE))-1:0] input1,   // Concatenated input with address and initial data part
    input [(K + $clog2(SIZE))-1:0] input2,   // Concatenated input with address and initial data part
    input [(K + $clog2(SIZE))-1:0] input3,   // Concatenated input with address and initial data part
    output [K-1:0] final_result              // Final output after OR-ing all matches
);

    // Intermediate wires for each input comparison result
    wire [K-1:0] result0;
    wire [K-1:0] result1;
    wire [K-1:0] result2;
    wire [K-1:0] result3;

    // Extract and compare the address parts
    assign result0 = (input0[(K + $clog2(SIZE)) - 1 : K] == N) ? input0[K-1:0] : {K{1'b0}};
    assign result1 = (input1[(K + $clog2(SIZE)) - 1 : K] == N) ? input1[K-1:0] : {K{1'b0}};
    assign result2 = (input2[(K + $clog2(SIZE)) - 1 : K] == N) ? input2[K-1:0] : {K{1'b0}};
    assign result3 = (input3[(K + $clog2(SIZE)) - 1 : K] == N) ? input3[K-1:0] : {K{1'b0}};

    // OR all intermediate results to get the final result
    assign final_result = result0 | result1 | result2 | result3;

endmodule
