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

    // Define the internal register block array
    reg [BIT_SIZE-1:0] regblock [0:RAM_SIZE-1]; // Array to hold RAM_SIZE entries of BIT_SIZE width

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            // Reset all elements in regblock to 0
            for (i = 0; i < RAM_SIZE; i = i + 1) begin
                regblock[i] <= {BIT_SIZE{1'b0}};
            end
        end else if (ld) begin
            // Load values from par_in to regblock
            for (i = 0; i < RAM_SIZE; i = i + 1) begin
                regblock[i] <= par_in[i*BIT_SIZE +: BIT_SIZE];
            end
        end
    end

    // Assign regblock to the flattened par_out bus
    always @(*) begin
        for (i = 0; i < RAM_SIZE; i = i + 1) begin
            par_out[i*BIT_SIZE +: BIT_SIZE] = regblock[i];
        end
    end

endmodule

