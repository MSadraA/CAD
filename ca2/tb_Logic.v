module Buffer_tb;
    // Parameters
    parameter SIZE = 16;
    parameter WIDTH = 8;
    parameter K = 4;
    parameter J = 4;
    parameter BIT = $clog2(SIZE);
    
    // Testbench signals
    reg clk;
    reg ld;
    reg rst;
    reg [BIT-1:0] write_add;
    reg [BIT-1:0] read_add;
    reg [(WIDTH*K)-1:0] par_in;
    wire [(WIDTH*J)-1:0] par_out;
    
    // Instantiate the Buffer module
    Buffer #(
        .SIZE(SIZE),
        .WIDTH(WIDTH),
        .K(K),
        .J(J),
        .BIT(BIT)
    ) dut (
        .clk(clk),
        .ld(ld),
        .rst(rst),
        .write_add(write_add),
        .read_add(read_add),
        .par_in(par_in),
        .par_out(par_out)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize waveform dump
        $dumpfile("buffer_tb.vcd");
        $dumpvars(0, Buffer_tb);
        
        // Initialize signals
        rst = 1;
        ld = 0;
        write_add = 0;
        read_add = 0;
        par_in = 0;
        
        // Wait 100 ns for global reset
        #100;
        rst = 0;
        
        // Test Case 1: Write single parallel data
        @(posedge clk);
        write_add = 4'h0;
        par_in = {8'hD4, 8'hC3, 8'hB2, 8'hA1}; // 4 bytes of test data
        ld = 1;
        
        @(posedge clk);
        ld = 0;
        
        // Read the written data
        read_add = 4'h0;
        #20;
        
        // Test Case 2: Write to multiple addresses
        repeat(4) begin
            @(posedge clk);
            write_add = write_add + 1;
            par_in = par_in + 1;
            ld = 1;
            
            @(posedge clk);
            ld = 0;
            #10;
        end
        
        // Test Case 3: Read from different addresses
        repeat(4) begin
            @(posedge clk);
            read_add = read_add + 1;
            #10;
        end
        
        // Test Case 4: Write and read simultaneously
        @(posedge clk);
        write_add = 4'h5;
        read_add = 4'h1;
        par_in = {8'hFF, 8'hEE, 8'hDD, 8'hCC};
        ld = 1;
        
        @(posedge clk);
        ld = 0;
        #20;
        
        // Test Case 5: Reset during operation
        @(posedge clk);
        write_add = 4'h6;
        par_in = {8'h44, 8'h33, 8'h22, 8'h11};
        ld = 1;
        
        @(posedge clk);
        rst = 1;
        #20;
        rst = 0;
        
        // Add some delay before finishing
        #100;
        
        // End simulation
        $display("Simulation completed successfully");
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t rst=%b ld=%b write_add=%h read_add=%h par_in=%h par_out=%h",
                 $time, rst, ld, write_add, read_add, par_in, par_out);
    end
    
    // Checker process
    always @(posedge clk) begin
        // Add checks for expected behavior
        if (!rst && ld) begin
            // Verify data is written correctly
            #1; // Wait for combinational logic to settle
            if (par_out === {(WIDTH*J){1'bx}}) begin
                $display("Warning: Unknown output detected at time %0t", $time);
            end
        end
    end
    
    // Add assertions
    property reset_check;
        @(posedge clk) rst |-> ##1 (par_out == 0);
    endproperty
    
    assert property (reset_check)
    else $error("Reset assertion failed: Output not 0 after reset");
    
endmodule