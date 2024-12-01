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
    always @(posedge clk , posedge rst) begin
        if(rst) par_out <= 16'b0;
        else begin
            if(ld) par_out <= par_in;
            else if(shl_en) par_out <= {par_out[14:0], 1'b0};
            else if(shr_en) par_out  <= {ser_in_l, par_out[15:1]};
        end
    end

    assign MSB_out = par_out[15];
    assign LSB_out = par_out[0];
    
endmodule