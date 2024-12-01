module data_path (
    input clk,
    input rst,
    input shift_left,
    input shift_right,
    input [15:0] x1,
    input [15:0] x2,
    input ld1,
    input ld2,
    input sel,
    output [31:0] out,
    output count_done,
    output zero
);
    wire LSB_out;
    wire [15:0] reg1_out;
    wire [15:0] reg2_out;
    wire shl_en1;
    wire shl_en2;
    wire msb_out1;
    wire msb_out2;
    wire [15:0] mux_out1;
    wire [15:0] mux_out2;
    wire [15:0] mul_out;

    wire zero1 , zero2;
    
    shift_reg_16bit reg1 (
        .clk(clk),
        .rst(rst),
        .ld(ld1),
        .shl_en(shl_en1),
        .shr_en(shift_right && ~zero),
        .par_in(mux_out1),
        .ser_in_l(1'b0),
        .par_out(reg1_out),
        .MSB_out(msb_out1),
        .LSB_out(LSB_out)
    );


    shift_reg_16bit reg2 (
        .clk(clk),
        .rst(rst),
        .ld(ld2),
        .shl_en(shl_en2),
        .shr_en(shift_right && ~zero),
        .par_in(mux_out2),
        .ser_in_l(LSB_out),
        .par_out(reg2_out),
        .MSB_out(msb_out2),
        .LSB_out()
    );

    mux_2_to_1_16bit mux1 (
        .a(x1),
        .b(mul_out),
        .sel(sel),
        .out(mux_out1)
    );

    mux_2_to_1_16bit mux2 (
        .a(x2),
        .b(16'b0),
        .sel(sel),
        .out(mux_out2)
    );

    array_mul_16bit mul (
        .a(reg1_out[15:8]),
        .b(reg2_out[15:8]),
        .mul(mul_out)
    );

    wire [3:0] cnt_out1;

    counter_4bit cnt1 (
        .clk(clk),
        .rst(rst),
        .up_cnt_en(shl_en1),
        .down_cnt_en(zero1 && shift_right),
        .par_out(cnt_out1), 
        .carry_out(co1)
    );

    wire [3:0] cnt_out2;

    counter_4bit cnt2 (
        .clk(clk),  
        .rst(rst),
        .up_cnt_en(shl_en2),
        .down_cnt_en(~zero1 && shift_right),
        .par_out(cnt_out2),
        .carry_out(co2)
    );

    nor_try_state nor1 (
        .en(shift_left),
        .a(co1),
        .b(msb_out1),
        .c(shl_en1)
    );

    nor_try_state nor2 (
        .en(shift_left),
        .a(co2),
        .b(msb_out2),
        .c(shl_en2)
    );

    nor_try_state nor3 (
        .en(1'b1),
        .a(shl_en1),
        .b(shl_en2),
        .c(count_done)
    );

    // nand_try_state nand1 (
    //     .en(shift_right),
    //     .a(co1),
    //     .b(co2),
    //     .c(shift_right)
    // );

    assign zero1 = |cnt_out1;
    assign zero2 = |cnt_out2;
    assign zero = ~(zero1 || zero2);    

    assign out = {reg1_out , reg2_out};
    
endmodule