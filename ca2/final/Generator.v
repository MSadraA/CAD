module Generator 
#(
    parameter SIZE = 16 , // Maximum value range (0 to SIZE-1)
    parameter K = 4
)
(
    input [$clog2(SIZE)-1:0] num_in, // Input number with log(SIZE) bits
    output reg [($clog2(SIZE) * K) - 1:0] num_out // Concatenated output for 4 consecutive numbers
);

    integer i;

    always @(*) begin
        // Initialize output to zero
        num_out = 0;
        
        // Generate four consecutive numbers wrapping around using modulo SIZE
        for (i = 0; i < K; i = i + 1) begin
            num_out[($clog2(SIZE) * (i + 1)) - 1 -: $clog2(SIZE)] = (num_in + i) % SIZE; // Wrap around using modulo SIZE
        end
    end

endmodule

