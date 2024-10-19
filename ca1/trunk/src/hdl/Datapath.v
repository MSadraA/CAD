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
    input [1:0] ;
    output countdone1 , countdone2 , carry2 , carry3 , carry4;

    up_down_counter_3_bit upcounter1();
    shift_register_16bit Shreg1(.clk(clk) , .rst(rst) , .load(ld1) , .shift_left(Shle1) , .data_in() , .q());
    up_down_counter_3_bit upcounter2();
    subtractor_3bit Sub1(.() , .() , .());
    shift_register_16bit Shreg2(.(clk) , .(rst) , .(ld2) , .(Shle2) , .() , .());
    up_down_counter_4_bit upcounter3();
    subtractor_3bit Sub2(.() , .() , .());
    Mult_8_bit Mult(.() , .() , .());
    shift_register_32bit Shreg3(.(clk) , .(rst) , .(ld4) , .(Shle1) , .() , .());
    up_down_counter_3_bit upcounter4();
    
    

   
endmodule