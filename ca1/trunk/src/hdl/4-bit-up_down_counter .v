module up_down_counter_4_bit    (
 out      ,  // Output of the counter
 up_down  ,  // up_down control for counter
 clk      ,  // clock input
 data     ,  // Data to load
 reset       // reset input
 );
 //----------Output Ports--------------
 output [3:0] out;
 //------------Input Ports-------------- 
 input [3:0] data;
 input up_down, clk, reset;
 //------------Internal Variables--------
 reg [3:0] out;
 //-------------Code Starts Here-------
 always @(posedge clk)
 if (reset) begin // active high reset
   out <= 4'b0 ;
 end else if (up_down) begin
   out <= out + 1;
 end else begin
   out <= out - 1;
 end

endmodule