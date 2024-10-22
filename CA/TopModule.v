module TopModule(
    input start,
    input clk,
    input rst , 
    output done
);

  wire ld1; 
  wire ld2; 
  wire ld3; 
  wire ld4; 
  wire ld5; 
  wire Inc1; 
  wire Inc2;
  wire Inc3; 
  wire Inc4; 
  wire Countrst1;
  wire Countrst2; 
  wire Countrst3;
  wire Countrst4; 
  wire Shle1; 
  wire Shle2; 
  wire Shre;
  wire We;  
  wire countdone1; 
  wire countdone2; 
  wire carry2; 
  wire carry3; 
  wire carry4;

  controller Controller
  (
    .clk(clk),
    .rst(rst),
    .start(start),
    .count_done1(countdone1),
    .count_done2(countdone2),
    .carry2(carry2),
    .carry3(carry3),
    .carry4(carry4),
    .Countrst1(Countrst1),
    .Countrst2(Countrst2),
    .Countrst3(Countrst3),
    .Countrst4(Countrst4),
    .ld1(ld1),
    .ld2(ld2),
    .ld3(ld3),
    .ld4(ld4),
    .ld5(ld5),
    .Inc1(Inc1),
    .Inc2(Inc2),
    .Inc3(Inc3),
    .Inc4(Inc4),
    .Shle1(Shle1),
    .Shle2(Shle2),
    .Shre(Shre),
    .We(We),
    .done(done)
  );

  datapath Datapath
  (
    .clk(clk), 
    .rst(rst),  
    .ld1(ld1), 
    .ld2(ld2), 
    .ld3(ld3), 
    .ld4(ld4), 
    .ld5(ld5), 
    .Inc1(Inc1), 
    .Inc2(Inc2),
    .Inc3(Inc3), 
    .Inc4(Inc4), 
    .Countrst1(Countrst1),
    .Countrst2(Countrst2), 
    .Countrst3(Countrst3),
    .Countrst4(Countrst4), 
    .Shle1(Shle1), 
    .Shle2(Shle2), 
    .Shre(Shre), 
    .We(We),  
    .countdone1(countdone1), 
    .countdone2(countdone2), 
    .carry2(carry2), 
    .carry3(carry3), 
    .carry4(carry4)
  );
endmodule