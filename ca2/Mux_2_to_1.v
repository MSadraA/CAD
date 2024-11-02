module Mux_2_to_1 
#(parameter SIZE = 16)
(
    input sel,
    input [SIZE:0] a,
    input [SIZE:0] b,
    output [SIZE:0] out,
);
    out = (sel) ? b:a;
endmodule