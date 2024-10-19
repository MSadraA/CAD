module shift_register_16bit (
    input wire clk,             // Clock input
    input wire rst,             // Reset input (active high)
    input wire load,            // Load signal (active high)
    input wire shift_left,      // Shift left signal (active high)
    input wire [15:0] data_in,  // Parallel data input (16-bit)
    output reg [15:0] q         // Output register
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 16'b0;         // Reset the register to zero
        end
        else if (load) begin
            q <= data_in;       // Load the data into the register
        end
        else if (shift_left) begin
            q <= {q[14:0], 1'b0}; // Shift left and insert 0 in the least significant bit
        end
    end

endmodule
