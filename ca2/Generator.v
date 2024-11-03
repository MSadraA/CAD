module Generator 
#(
    parameter SIZE = 16                // Maximum value range (0 to SIZE-1)
)
(
    input [$clog2(SIZE)-1:0] num_in,   // Input number with log(SIZE) bits
    output reg [$clog2(SIZE)-1:0] num_out[0:3] // Array to store the 4 consecutive numbers
);

    integer i;

    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            num_out[i] = (num_in + i) % SIZE; // Wrap around using modulo SIZE
        end
    end

endmodule
