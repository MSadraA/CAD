module shift_reg_16bit (
    input clk,
    input rst,
    input ld,
    input ser_in,
    input [15:0] par_in,
    input shen,
    output reg [15:0] par_out,
    output MSB_out
);
    always @(posedge clk , posedge rst) begin
        if(rst) par_out <= 16'b0;
        else begin
            if(ld) par_out <= par_in;
            else if(shen) par_out <= {par_out[14:0], ser_in};
        end
    end

    assign MSB_out = par_out[15];
endmodule