module Datapath(clk, rst, start , ld1 , ld2 , ld3 , ld4 , ld5, Inc1 , Inc2 , Inc3 , Inc4 , Countrst1 ,Countrst2 , Countrst1, Countrst4 , Shle1 , Shle2 , Shre , We,  countdone1 , countdone2 , carry2 , carry3 , carry4 );

    input clk, rst, start , ld1 , ld2 , ld3 , ld4 , ld5, Inc1 , Inc2 , Inc3 , Inc4 , Countrst1 ,Countrst2 , Countrst1, Countrst4 , Shle1 , Shle2 , Shre , We ;
    input [1:0] ;
    output countdone1 , countdone2 , carry2 , carry3 , carry4;

    up_down_counter_3_bit upcounter1();
    shift_register_16bit Shreg1();
    up_down_counter_3_bit upcounter2();
    subtractor_3bit Sub1();
    shift_register_16bit Shreg2();
    up_down_counter_4_bit upcounter3();
    subtractor_3bit Sub2();
    Mult_8_bit Mult();
    shift_register_32bit Shreg3();
    up_down_counter_3_bit upcounter4();
    
    

   
endmodule