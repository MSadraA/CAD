module Mult_8_bit (
    input wire [7:0] a,    
    input wire [7:0] b,    
    output wire [15:0] diff 
);

    assign diff = a * b;

endmodule
