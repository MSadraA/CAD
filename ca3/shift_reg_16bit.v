module shift_reg_16bit (
    input clk,
    input rst,
    input ld,
    input shl_en,
    input shr_en,
    input [15:0] par_in,
    input ser_in_l,
    output reg [15:0] par_out,
    output MSB_out,
    output LSB_out
);

    wire [15:0] next_par_out;

    // Instantiate 16 S2 modules for each bit of the shift register
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_logic
            S2 reg_ins (
                .A1(ld),                      // Load enable
                .B1(shl_en | shr_en),         // Shift enable (either left or right)
                .A0(shl_en),                  // Differentiates left shift
                .B0(shr_en),                  // Differentiates right shift
                .D({
                    par_out[i],               // Hold
                    par_in[i],                // Load parallel input
                    (i == 0) ? ser_in_l : par_out[i-1], // Shift left
                    (i == 15) ? ser_in_l : par_out[i+1] // Shift right
                }),
                .clr(rst),                    // Reset
                .clk(clk),                    // Clock
                .out(next_par_out[i])         // Output next state
            );
        end
    endgenerate

    // Update state on clock edge
    always @(posedge clk or posedge rst) begin
        if (rst)
            par_out <= 16'b0;  // Reset the register
        else
            par_out <= next_par_out;  // Update state
    end

    // Assign outputs
    assign MSB_out = par_out[15];
    assign LSB_out = par_out[0];

endmodule

