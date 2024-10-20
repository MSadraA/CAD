module datapath(
    input clk, 
    input rst, 
    input ld1, 
    input ld2, 
    input ld3, 
    input ld4, 
    input ld5, 
    input Inc1, 
    input Inc2,
    input Inc3, 
    input Inc4, 
    input Countrst1,
    input Countrst2, 
    input Countrst3,
    input Countrst4, 
    input Shle1, 
    input Shle2, 
    input Shre, 
    input We,  
    output countdone1, 
    output countdone2, 
    output carry2, 
    output carry3, 
    output carry4
);

    //in_ram_address 
    wire [3:0] in_add;
    up_counter_4bit upcounter1
    (
        .out(in_add),
        .inc(Inc1), 
        .clk(clk),
        .reset(Countrst1)
    );

    //input_ram
    wire in_ram_out;
    in_ram input_ram
    (
        .clk(clk),
        .address(in_add),
        .data_out(in_ram_out)
    );

    //shift_register_1
    wire [15:0] shreg1_out;
    shift_register_16bit Shreg1
    (
        .clk(clk),
        .rst(rst), 
        .load(ld1), 
        .shift_left(Shle1), 
        .data_in(in_ram_out), 
        .q(shreg1_out)
    );

    //shift_register_2
    wire [15:0] shreg2_out;
    shift_register_16bit Shreg2
    (
    .clk(clk), 
    .rst(rst), 
    .load(ld2), 
    .shift_left(Shle2), 
    .data_in(in_ram_out), 
    .q(shreg2_out)
    );

    //worthless_bits_counter1
    wire [2:0] Pout2;
    wire [2:0] sub_out1;
    subtractor_3bit Sub1
    (
        .a(Pout2), 
        .b(3'b111), 
        .diff(sub_out1)
    );

    up_counter_3_bit upcounter2
    (
    .out(Pout2),
    .ld(ld5), 
    .inc(Inc2), 
    .clk(clk),
    .data(sub_out1),
    .reset(Countrst2),
    .carry(carry2)
    );

    //count_done_1
    assign countdone1 = carry2 | shreg1_out[15];
    
    //worthless_bits_counter2
    wire [2:0] sub_out2;
    wire [2:0] Pout1;
    subtractor_3bit Sub2
    (
        .a(Pout1) , 
        .b(3'b111) , 
        .diff(sub_out2)
    );

    up_counter_3_bit upcounter3
    (
        .out(Pout1), 
        .ld(ld3), 
        .inc(Inc3) , 
        .clk(clk) ,
        .data(sub_out2) ,
        .reset(Countrst3),
        .carry(carry3)
    );

    //multiplication of effective bits
    wire [15:0] mult_out;
    Mult_8_bit Mult
    (
        .a(shreg1_out[15:8]) , 
        .b(shreg2_out[15:8]) , 
        .mul(mult_out));
    
    //output_shift_register
    wire [31:0] out_ram_in;
    shift_register_32bit Shreg3
    (
        .clk(clk) , 
        .rst(rst) , 
        .load(ld4) , 
        .shiftrighten(Shre) , 
        .data_in(mult_out) , 
        .q(out_ram_in)
    );

    //out_ram_address
    wire out_add;
    up_counter_3_bit upcounter4
    (
        .out(out_add), 
        .ld(1'b0), 
        .inc(Inc4) , 
        .clk(clk) ,
        .data() ,
        .reset(Countrst4)
    );

    //output_ram
    out_ram output_ram
    (
        .clk(clk),
        .address(out_add),
        .data_in(out_ram_in),
        .wren(We)
    );
   
endmodule