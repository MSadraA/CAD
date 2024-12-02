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

s2 reg_ins ( 
        .D({par_out, par_in, {par_out[14:0], 1'b0}, {ser_in_l, par_out[15:1]}})     
        .A1(ld),                                  // Select load
        .B1(shl_en | shr_en),                     // Select shift (left or right)
        .A0(shl_en),                              // Differentiate left shift
        .B0(shr_en),                              // Differentiate right shift
        .clr(rst),                                // Reset
        .clk(clk),                                // Clock
        .out(next_par_out)                        // Output next state
    );

    assign out = next_par_out;
    assign MSB_out = par_out[15];
    assign LSB_out = par_out[0];

endmodule