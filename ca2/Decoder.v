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
    integer i;
    reg [BIT-1:0] addr_chunk;
    
    always @(*) begin
        out = {SIZE{1'b0}};
        for (i = 0; i < K; i = i + 1) begin
            // First extract the chunk into a fixed-width register
            addr_chunk = generated_addr[BIT * (i + 1) - 1 : BIT * i];
            // Then use that register as the array index
            out[addr_chunk] = 1'b1;
        end
    end
endmodule