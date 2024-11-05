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
    
    // Combinational logic for output assignment
    always @(*) begin
        out = {SIZE{1'b0}}; 
    end

    // Generate block to create K separate combinational assignments
=======
    // Generate block to create K separate combinational assignments
    assign out = {SIZE{1'b0}};
>>>>>>> b37ef1e99fcdd8d5d2166a00de2e59d19aefd632
    genvar g;
    generate
        for (g = 0; g < K; g = g + 1) begin : addr_decode
            always @(*) begin
<<<<<<< HEAD
                // Each generate block adds its decoded bit to the output
                if (generated_addr[BIT * (g + 1) - 1 : BIT * g] < SIZE) begin
                    out[generated_addr[BIT * (g + 1) - 1 : BIT * g]] = 1'b1;
                end
=======
                out[generated_addr[BIT * (g + 1) - 1 : BIT * g]] = 1'b1;
>>>>>>> b37ef1e99fcdd8d5d2166a00de2e59d19aefd632
            end
        end
    endgenerate

endmodule