module datapath
#(parameter k = 4, parameter j = 4 )
(
    input clk, 
    input rst, 
    input ld1, 
    input ld2, 
    input ld3, 
    output full,
    output empty,
    output out
);

    //in_buffer
    wire [3:0] in_add;
    buffer buff
    (
        .out(in_add),
        .inc(Inc1), 
        .clk(clk),
        .reset(Countrst1)
    );

    //write register
    wire [15:0] in_ram_out;
    register w_pointer
    (
        .clk(clk),
        .ld(ld2),
        .pIn(),
        .pOut()
    );

    //read register
    wire [15:0] in_ram_out;
    register r_pointer
    (
        .clk(clk),
        .ld(ld3),
        .pIn(),
        .pOut()
    );

   
    assign MSB_reg_out1 = shreg1_out[15];
    assign MSB_reg_out2 = shreg2_out[15];

    always @(Pout2 , Pout1) begin
        shift_r_valid1 = (Pout2 == 3'b110)? 1:0;
        shift_r_valid2 = (Pout1 == 3'b110)? 1:0;
    end
endmodule