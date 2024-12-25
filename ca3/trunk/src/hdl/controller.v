module controller (
    input clk,
    input rst,
    input start,
    input count_done,
    input zero,
    output  ld1,
    output  ld2,
    output  sel,
    output  sel2,
    output  shift_left,
    output  shift_right,
    output  done
);

    wire[5:0] in = 5'b00001;
    parameter [5:0] Idle = 000001 , Init = 000010 ,  Count = 000100 , Load = 001000 , 
    Shift = 010000 , Done = 100000;
    
    wire [5:0] s;

    wire sh_en;
    wire sh_en_n_1;
    wire sh_en_n_2;

    wire is_first;

    C1 start_transition (
        .A0(sh_en_n_1),
        .A1(1'b0),
        .SA(1'b0),
        .B0(s[1]),
        .B1(s[0]),
        .SB(start),
        .S0(s[1]),
        .S1(s[0]),
        .F(sh_en)
    );

    C1 count_done_transition (
        .A0(sh_en_n_2),
        .A1(1'b0),
        .SA(1'b0),
        .B0(1'b0),
        .B1(1'b1),
        .SB(count_done),
        .S0(s[2]),
        .S1(s[2]),
        .F(sh_en_n_1)  
    );

    C1 zero_transition (
        .A0(1'b0),
        .A1(s[4]),
        .SA(zero),
        .B0(1'b1),
        .B1(1'b1),
        .SB(1'b0),
        .S0(s[5]),
        .S1(s[3]),
        .F(sh_en_n_2)
    );

    wire or_out;
    or_4bit or1 (
        .a(s[3:0]),
        .y(or_out)
    );

    C2 is_first_inst (
        .A0(or_out),
        .A1(s[4]),
        .B0(or_out),
        .B1(s[5]),
        .D({1'b0, 1'b0, 1'b0, 1'b1}),
        .out(is_first)
    );

    shift_reg #(6) state_reg (
        .clk(clk),
        .rst(rst),
        .MSB_out(),
        .ld(is_first),
        .shen(sh_en),
        .par_in(Idle),
        .ser_in(s[5]),
        .par_out(s)
    );

    //output signals
    wire ld_out;
    Or or2(
        .a(s[1]),
        .b(s[3]),
        .y(ld_out)
    );
    
    assign ld1 = ld_out;
    assign ld2 = ld_out;

    assign shift_left = s[2];
    assign shift_right = s[4];
    assign sel = s[3];
    assign sel2 = s[4];
    assign done = s[5];

endmodule