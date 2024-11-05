module Ram 
#(
    parameter WIDTH = 16,
    parameter SIZE = 8
)
(
    input clk,
    input rst,
    input ld,
    input [(SIZE*WIDTH)-1:0] par_in,      // Flattened input bus
    output reg [(SIZE*WIDTH)-1:0] par_out // Flattened output bus
);

    // Define the internal register block array
    reg [WIDTH-1:0] regblock [0:SIZE-1]; // Array to hold SIZE entries of WIDTH SIZE

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            // Reset all elements in regblock to 0
            for (i = 0; i < SIZE; i = i + 1) begin
                regblock[i] <= {WIDTH{1'b0}};
            end
        end else if (ld) begin
            // Load values from par_in to regblock
            for (i = 0; i < SIZE; i = i + 1) begin
                regblock[i] <= par_in[i*WIDTH +: WIDTH];
            end
        end
    end

    // Assign regblock to the flattened par_out bus
    always @(*) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            par_out[i*WIDTH +: WIDTH] = regblock[i];
        end
    end

endmodule

