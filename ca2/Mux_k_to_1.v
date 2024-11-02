module Mux_k_to_1 
#(
    parameter K = 4,          // Number of inputs
    parameter SIZE = 16       // Width of each input
)
(
    input [SIZE-1:0] in [0:K-1],   // K inputs, each SIZE bits wide
    input [$clog2(K)-1:0] sel,     // Select signal, log2(K) bits wide
    output reg [SIZE-1:0] out      // Output, SIZE bits wide
);

    always @(*) begin
        out = in[sel];
    end

endmodule
