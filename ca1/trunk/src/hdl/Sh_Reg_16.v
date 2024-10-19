module Shift_Register_16bit 
(
    input clk,
    input ld,
    input shle,
    input [15:0] par_in,
    output reg [15:0] par_out,
    output msb
);
    always @(posedge clk) begin
        if(clk) begin
            if(ld)
                par_out <= par_in;
            else if(shle)
                par_out <= {par_out[14:0] , 1'b0};
        end
    assign msb = par_out[15];
    end
endmodule