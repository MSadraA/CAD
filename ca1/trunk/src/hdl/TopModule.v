module TopModule(
    input start, clk, rst , 
    output done
    );
    

    wire ld1, ld2, ld3, ld4, ld5, Inc1, Inc2,Inc3, Inc4, Countrst1,Countrst2, Countrst3,Countrst4, Shle1, Shle2, Shre, We,  
     countdone1, countdone2, carry2, carry3, carry4;
   wire count_done1, count_done2, carry2, carry3, carry4, Countrst1, Countrst2, Countrst3, Countrst4, ld1, ld2,
    ld3, ld4, ld5, Inc1, Inc2, Inc3, Inc4, Shle1, Shle2, Shre, We, done;

    Controller co(clk , rst, start, count_done1, count_done2, carry2, carry3, carry4, Countrst1, Countrst2, Countrst3, Countrst4, ld1, ld2,
    ld3, ld4, ld5, Inc1, Inc2, Inc3, Inc4, Shle1, Shle2, Shre, We, done);

    Datapath dp(clk, rst, start , ld1, ld2, ld3, ld4, ld5, Inc1, Inc2,Inc3, Inc4, Countrst1,Countrst2,
     Countrst3,Countrst4, Shle1, Shle2, Shre, We, countdone1, countdone2, carry2, carry3, carry4);

    


endmodule