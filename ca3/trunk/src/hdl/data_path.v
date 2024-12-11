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
    input sel2,
    output [31:0] out,
    output count_done,
    output zero
);
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
    
    wire ser_in_wire;
    // assign ser_in_wire = (sel2) ? msb_out2 : 1'b0;

    mux_2_to_1_1bit mux3 (
        .a(1'b0),
        .b(msb_out2),
        .sel(sel2),
        .out(ser_in_wire)
    );

    wire and_not1_wire;

    And_not and_not1(
        .a(shift_right),
        .b(zero),
        .y(and_not1_wire)
    );

    wire shen1_wire;

    Or or1 (
        .a(and_not1_wire),
        .b(shl_en1),
        .y(shen1_wire)
    );

    shift_reg #(16) reg1 (
        .clk(clk),
        .rst(rst),
        .ld(ld1),
        .shen(shen1_wire),
        .par_in(mux_out1),
        .ser_in(ser_in_wire),
        .par_out(reg1_out),
        .MSB_out(msb_out1)
    );

    wire shen2_wire;

    Or or2 (
        .a(and_not1_wire),
        .b(shl_en2),
        .y(shen2_wire)
    );

    shift_reg #(16) reg2 (
        .clk(clk),
        .rst(rst),
        .ld(ld2),
        .shen(shen2_wire),
        .ser_in(1'b0),
        .par_in(mux_out2),
        .par_out(reg2_out),
        .MSB_out(msb_out2)
    );

    mux_2_to_1 #(16) mux1 (
        .a(x1),
        .b(16'b0),
        .sel(sel),
        .out(mux_out1)
    );

    wire [15:0] rev_out;

    reverse_bits #(16) rev1 (
        .in(mul_out),
        .out(rev_out)
    );

    mux_2_to_1 #(16) mux2 (
        .a(x2),
        .b(rev_out),
        .sel(sel),
        .out(mux_out2)
    );

    array_mul mul (
        .a(reg1_out[15:8]),
        .b(reg2_out[15:8]),
        .mul(mul_out)
    );

    wire [3:0] cnt_out1;
    wire down_cnt_en1_wire;

    And and1 (
        .a(zero1),
        .b(shift_right),
        .y(down_cnt_en1_wire)
    );

    counter_4bit cnt1 (
        .clk(clk),
        .rst(rst),
        .up_cnt_en(shl_en1),
        .down_cnt_en(down_cnt_en1_wire),
        .par_out(cnt_out1), 
        .carry_out(co1)
    );

    wire [3:0] cnt_out2;
    wire down_cnt_en2_wire;

    And_not and2 (
        .a(shift_right),
        .b(zero1),
        .y(down_cnt_en2_wire)
    );

    counter_4bit cnt2 (
        .clk(clk),  
        .rst(rst),
        .up_cnt_en(shl_en2),
        .down_cnt_en(down_cnt_en2_wire),
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

    // assign zero1 = |cnt_out1;

    or_4bit or_zero1 (
        .a(cnt_out1),
        .y(zero1)
    );

    // assign zero2 = |cnt_out2;

    or_4bit or_zero2 (
        .a(cnt_out2),
        .y(zero2)
    );

    // assign zero = ~(zero1 || zero2); 

    nor_try_state nor4 (
        .en(1'b1),
        .a(zero1),
        .b(zero2),
        .c(zero)
    );

    reverse_bits #(32) rev2 (
        .in({reg1_out , reg2_out}),
        .out(out)
    );
    
endmodule