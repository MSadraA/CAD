module Ram 
#(
    parameter SIZE = 16,
    parameter WIDTH = 8
)
(
    input clk,
    input rst,
    input ld,
    input [(WIDTH*SIZE)-1:0] par_in,      // Flattened input bus
    output reg [(WIDTH*SIZE)-1:0] par_out // Flattened output bus
);

    // Define the internal register block array
    reg [SIZE-1:0] regblock [0:WIDTH-1]; // Array to hold WIDTH entries of SIZE width

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            // Reset all elements in regblock to 0
            for (i = 0; i < WIDTH; i = i + 1) begin
                regblock[i] <= {SIZE{1'b0}};
            end
        end else if (ld) begin
            // Load values from par_in to regblock
            for (i = 0; i < WIDTH; i = i + 1) begin
                regblock[i] <= par_in[i*SIZE +: SIZE];
            end
        end
    end

    // Assign regblock to the flattened par_out bus
    always @(*) begin
        for (i = 0; i < WIDTH; i = i + 1) begin
            par_out[i*SIZE +: SIZE] = regblock[i];
        end
    end

endmodule

