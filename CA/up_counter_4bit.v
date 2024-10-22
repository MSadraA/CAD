module up_counter_4bit(
 out,  // Output of the counter
 inc,  // up_down control for counter
 clk,  // clock input
 reset  // reset input
);
 //----------Output Ports--------------
  output reg [3:0] out;
  //------------Input Ports-------------- 
  input inc, clk, reset;
  //-------------Code Starts Here-------
  always @(posedge clk)
  begin
    if (reset) begin // active high reset
      out <= 4'b0 ;
    end
    else if (inc) begin
      out <= out + 1;
    end
  end
endmodule
