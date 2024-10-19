module up_counter_3_bit(
 out      ,  // Output of the counter
 carry ,
 ld,     //load signal
 inc  ,  // up_down control for counter
 clk      ,  // clock input
 data     ,  // Data to load
 reset       // reset input
);
 //----------Output Ports--------------
  output [2:0] out;
  output carry;
  //------------Input Ports-------------- 
  input [2:0] data;
  input inc, clk, reset ,  ld;
  //------------Internal Variables--------
  reg [2:0] out;
  reg carry;
  //-------------Code Starts Here-------
  always @(posedge clk)
  begin
    if (reset) begin // active high reset
      out <= 3'b0;
      carry <= 1'b0;
    end
    else if (ld) begin  // Load data
      out <= data;
      carry <= 1'b0;
    end
    else if (inc) begin
      if (out == 3'b111) begin
        out <= 3'b000;   // Reset counter after it reaches max value
        carry <= 1'b1;   // Set carry when overflow happens
      end
      else begin
        out <= out + 1;
        carry <= 1'b0;
      end
    end
  end
endmodule