module tb_Logic;

    // Parameters
    parameter SIZE = 16;
    parameter K = 8;

    // Inputs
    reg [$clog2(SIZE)-1:0] address_in;

    // Outputs
    wire [($clog2(SIZE) * K) - 1:0] generated_nums;
    wire [(SIZE * $clog2(K)) - 1:0] final_result;

    // Instantiate the Logic module
    Logic #(
        .SIZE(SIZE),
        .K(K)
    ) logic_inst (
        .address_in(address_in),                // Address input to the Logic module
        .generated_nums(generated_nums),        // Output of consecutive numbers from the Generator
        .final_result(final_result)             // Output result from the Array_selector
    );

    // Initial block to provide input stimuli
    initial begin
        // Initialize inputs
        address_in = 0;

        // Monitor outputs
        $monitor("Time: %0t | address_in = %0d | generated_nums = %0h | final_result = %0h", 
                 $time, address_in, generated_nums, final_result);
        
        // Test Case 1: Start with address 0
        address_in = 0;
        #50;

        // Test Case 2: Check address 4
        address_in = 4;
        #50;

        // Test Case 3: Check address 10
        address_in = 10;
        #50;

        // Test Case 4: Check address 15 (Wrapping around)
        address_in = 15;
        #50;

        // Finish the simulation
        $finish;
    end

endmodule
