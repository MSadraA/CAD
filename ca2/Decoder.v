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
        out = {SIZE{1'b0}}; // Initialize out
        
        // Unroll the loop with constant bounds
        // K=4 chunks
        addr_chunk = generated_addr[BIT * 1 - 1 : BIT * 0];
        if (addr_chunk < SIZE) out[addr_chunk] = 1'b1;
        
        addr_chunk = generated_addr[BIT * 2 - 1 : BIT * 1];
        if (addr_chunk < SIZE) out[addr_chunk] = 1'b1;
        
        addr_chunk = generated_addr[BIT * 3 - 1 : BIT * 2];
        if (addr_chunk < SIZE) out[addr_chunk] = 1'b1;
        
        addr_chunk = generated_addr[BIT * 4 - 1 : BIT * 3];
        if (addr_chunk < SIZE) out[addr_chunk] = 1'b1;
    end
endmodule