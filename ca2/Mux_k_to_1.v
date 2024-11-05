module Mux_k_to_1 
#(
    parameter K = 4,          // Number of inputs
    parameter WIDTH = 16       // Width of each input
)
(
    input [(K*WIDTH)-1:0] in_bus,    // Flattened bus for inputs
    input [$clog2(K)-1:0] sel,      // Select signal
    output reg [WIDTH-1:0] out       // Output, WIDTH bits wide
);

    // Internal signal for the selected input
    wire [WIDTH-1:0] in [0:K-1];

    // Unpacking the flattened input bus into an array
    genvar i;
    generate
        for (i = 0; i < K; i = i + 1) begin : unpack_in
            assign in[i] = in_bus[i*WIDTH +: WIDTH];
        end
    endgenerate

    // Multiplexer logic
    always @(*) begin
        out = in[sel];
    end

endmodule
