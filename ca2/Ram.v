module Ram 
#(
    parameter BIT_SIZE = 16,
    parameter RAM_SIZE = 8
)
(
    input clk,
    input rst,
    input ld,
    input [BIT_SIZE-1:0] par_in [0:RAM_SIZE-1],   // Input array of size RAM_SIZE, each element BIT_SIZE bits wide
    output reg [BIT_SIZE-1:0] par_out [0:RAM_SIZE-1] // Output array of size RAM_SIZE, each element BIT_SIZE bits wide
);

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            // Reset all outputs to 0
            for (i = 0; i < RAM_SIZE; i = i + 1) begin
                par_out[i] <= {BIT_SIZE{1'b0}};
            end
        end else if (ld) begin
            // Load values from par_in to par_out
            for (i = 0; i < RAM_SIZE; i = i + 1) begin
                par_out[i] <= par_in[i];
            end
        end
    end
endmodule
