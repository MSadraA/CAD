module Decoder 
#(
    parameter SIZE = 8, 
    parameter K = 4,
    parameter BIT = $clog2(SIZE)
) 
(
    input [(K * BIT) - 1:0] generated_addr,    
    output reg [SIZE - 1:0] out  
);
<<<<<<< HEAD
=======

    integer i;
    always @(*) begin
        out = {SIZE{1'b0}};  // Initialize output to zero
        // Decode only the first valid address in generated_addr
        for (i = 0; i < K; i = i + 1) begin
            if (generated_addr[BIT * (i + 1) - 1 -: BIT] < SIZE)
                out[generated_addr[BIT * (i + 1) - 1 -: BIT]] = 1'b1;
        end
    end
>>>>>>> 56946ad50539f4b247cb2c52e9fab359074b7b59

    integer i;
    always @(*) begin
        out = {SIZE{1'b0}};  // Initialize output to zero
        // Decode only the first valid address in generated_addr
        for (i = 0; i < K; i = i + 1) begin
            if (generated_addr[BIT * (i + 1) - 1 -: BIT] < SIZE)
                out[generated_addr[BIT * (i + 1) - 1 -: BIT]] = 1'b1;
        end
    end

endmodule
