module Mux_k_to_1 
#(parameter K = 4 ,
parameter SIZE = 16,
parameter BIT = $clog2(K))
(
    sel ,
    in,
    out 
);
    input [(SIZE-1):0] in [0:(K-1)];
    input [BIT - 1:0] sel;
    output [SIZE - 1:0] out;

    assign out = in[sel];
endmodule