module Datapath(
    input clk, 
    input rst, 
    input start, 
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
    input Countrst1,
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

    input clk, rst, start , ld1 , ld2 , ld3 , ld4 , ld5, Inc1 , Inc2 , Inc3 , Inc4 , Countrst1 ,Countrst2 , Countrst1, Countrst4 , Shle1 , Shle2 , Shre , We ;
    wire [3:0] sub_out1 , Pout2 , sub_out2 , Pout1 ;
    output countdone1 , countdone2 , carry2 , carry3 , carry4;

    up_counter_4_bit upcounter1( .out(), .ld(), .inc(Inc1) , .clk(clk) ,.data() ,.reset(Countrst1));
    shift_register_16bit Shreg1(.clk(clk) , .rst(rst) , .load(ld1) , .shift_left(Shle1) , .data_in() , .q());
    up_counter_3_bit upcounter2(.out(Pout2), .ld(ld5), .inc(Inc2) , .clk(clk) ,.data(sub_out1) ,.reset(countdone2));
    subtractor_3bit Sub1(.a(Pout2) , .b(3'b110) , .diff(sub_out1));
    shift_register_16bit Shreg2(.clk(clk) , .rst(rst) , .load(ld2) , .shift_left(Shle2) , .data_in() , .q());
    up_counter_3_bit upcounter3(.out(Pout1), .ld(ld3), .inc(Inc3) , .clk(clk) ,.data(sub_out2) ,.reset(countdone3));
    subtractor_3bit Sub2(.a(Pout1) , .b(3'b110) , .diff(sub_out2));
    Mult_8_bit Mult(.a() , .b() , .diff());
    shift_register_32bit Shreg3(.clk(clk) , .rst(rst) , .load(ld4) , .shiftrighten(Shle1) , .data_in() , .q());
    up_counter_3_bit upcounter4(.out(OutAdd), .ld(), .inc(Inc4) , .clk(clk) ,.data() ,.reset(Countrst4));
    
    

   
endmodule