module reverse_bits #(parameter N = 8) 
( 
    input  [N-1:0] in,   
    output [N-1:0] out   
);
    genvar i;  
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N-1-i];
        end
    endgenerate
endmodule
