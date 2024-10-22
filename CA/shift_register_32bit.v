module shift_register_32bit (
    input wire clk,              // Clock input
    input wire rst,              // Reset input (active high)
    input wire load,             // Load enable signal (active high)
    input wire shiftrighten,     // Shift right enable signal (active high)
    input wire [15:0] data_in,   // 16-bit input data
    output reg [31:0] q          // 32-bit shift register output
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 32'b0;          // Reset the register to all zeros
        end
        else if (load) begin
            q <= {data_in, 16'b0}; // Load 16-bit input into bits 16 to 31, set bits 0 to 15 to 0
        end
        else if (shiftrighten) begin
            q <= {1'b0, q[31:1]};  // Shift right and insert 0 in the most significant bit
        end
    end

endmodule
