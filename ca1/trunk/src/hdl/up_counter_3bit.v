module up_counter_3bit(
 out,  // Output of the counter
 carry,
 ld,    //load signal
 inc,   // up_down control for counter
 clk,   // clock input
 data,  // Data to load
 reset  // reset input
);
 //----------Output Ports--------------
  output reg [2:0] out;
  output reg carry;
  //------------Input Ports-------------- 
  input [2:0] data;
  input inc, clk, reset , ld;
  //-------------Code Starts Here-------
  always @(posedge clk)
  begin
    if (reset) begin // active high reset
      out <= 3'b0;
    end
    else if (ld) begin  // Load data
      out <= data;
    end
    else if (inc) begin
      out <= out + 1'b1;
      end
  end
  
  assign carry = (out == 3'b111) ? 1'b1 : 1'b0;
endmodule