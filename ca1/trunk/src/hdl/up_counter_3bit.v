module up_counter_3_bit(
 out      ,  // Output of the counter
 ld,     //load signal
 inc  ,  // up_down control for counter
 clk      ,  // clock input
 data     ,  // Data to load
 reset       // reset input
);
 //----------Output Ports--------------
  output [2:0] out;
  //------------Input Ports-------------- 
  input [2:0] data;
  input inc, clk, reset ,  ld;
  //------------Internal Variables--------
  reg [2:0] out;
  //-------------Code Starts Here-------
  always @(posedge clk)
  begin
    if (reset) begin // active high reset
      out <= 3'b0 ;
    end 
    else if (inc) begin
      out <= out + 1;
    end
  end
endmodule