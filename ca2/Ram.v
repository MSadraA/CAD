module Ram 
#(
    parameter BIT_SIZE = 16,
    parameter RAM_SIZE = 8
)
(
    input clk,
    input rst,
    input ld,
    input [(RAM_SIZE*BIT_SIZE)-1:0] par_in,      // Flattened input bus
    output reg [(RAM_SIZE*BIT_SIZE)-1:0] par_out // Flattened output bus
);

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            // Reset all outputs to 0
            for (i = 0; i < RAM_SIZE; i = i + 1) begin
                par_out[i*BIT_SIZE +: BIT_SIZE] <= {BIT_SIZE{1'b0}};
            end
        end else if (ld) begin
            // Load values from par_in to par_out
            for (i = 0; i < RAM_SIZE; i = i + 1) begin
                par_out[i*BIT_SIZE +: BIT_SIZE] <= par_in[i*BIT_SIZE +: BIT_SIZE];
            end
        end
    end
endmodule
