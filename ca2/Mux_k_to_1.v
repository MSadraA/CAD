module Mux_k_to_1 
#(
    parameter K = 4,          // Number of inputs
    parameter SIZE = 16       // Width of each input
)
(
    input [(K*SIZE)-1:0] in_bus,    // Flattened bus for inputs
    input [$clog2(K)-1:0] sel,      // Select signal
    output reg [SIZE-1:0] out       // Output, SIZE bits wide
);

    // Internal signal for the selected input
    wire [SIZE-1:0] in [0:K-1];

    // Unpacking the flattened input bus into an array
    genvar i;
    generate
        for (i = 0; i < K; i = i + 1) begin : unpack_in
            assign in[i] = in_bus[i*SIZE +: SIZE];
        end
    endgenerate

    // Multiplexer logic
    always @(*) begin
        out = in[sel];
    end

endmodule
