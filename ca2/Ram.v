module Ram 
#(parameter BIT_SIZE = 16 ,
parameter RAM_SIZE = 8;)
(
    input clk,
    input rst,
    input ld,
    [BIT_SIZE -1:0] input [0:RAM_SIZE] par_in,
    [BIT_SIZE - 1:0] output [0:RAM_SIZE] par_out  
);

integer i;

    always @(posedge clk) begin
        if(rst)
            begin
                for (i = 0; i < RAM_SIZE ; i = i + 1) begin
                    par_out[i] <= BIT_SIZE'd0;
                end
            end
        else
            begin
                if(ld)
                    for (i = 0; i < RAM_SIZE ; i = i + 1) begin
                    par_out[i] <= par_in[i];
                end
            end
    end
endmodule