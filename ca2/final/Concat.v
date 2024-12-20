module Concat 
#(
    parameter K  = 4,
    parameter SIZE = 16
)
(
    input [(K * $clog2(SIZE)) - 1 : 0] in,
    output [($clog2(SIZE) + $clog2(K)) * K - 1 : 0] out
);
    localparam IN_WIDTH = $clog2(SIZE);
    localparam OUT_WIDTH = $clog2(SIZE) + $clog2(K);

    genvar i;
    generate
        for (i = 0; i < K; i = i + 1) begin : gen_block
            if(K != 1) 
                assign out[OUT_WIDTH * (i + 1) - 1 : OUT_WIDTH * i] = 
                    {in[(IN_WIDTH * (i + 1)) - 1 : IN_WIDTH * i], i[$clog2(K) - 1 : 0]};
                
            else
                assign out[OUT_WIDTH * (i + 1) - 1 : OUT_WIDTH * i] = 
                    {in[(IN_WIDTH * (i + 1)) - 1 : IN_WIDTH * i], i};
        end
    endgenerate
endmodule
