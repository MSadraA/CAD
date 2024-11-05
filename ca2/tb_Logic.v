// Test stimulus
initial begin
    // Initialize waveform dump
    $dumpfile("buffer_tb.vcd");
    $dumpvars(0, Buffer_tb);
    
    // Initialize signals
    rst = 1;       // Start with reset active
    ld = 0;       // Load signal
    write_add = 0; // Initial write address
    read_add = 0;  // Initial read address
    par_in = 0;    // Input data
    
    // Wait for global reset
    #10;
    rst = 0;  // Deactivate reset

    // Test case 1: Load value 1 (00000001)
    par_in = 8'b00000001; // Input binary 1
    write_add = 0;        // Write address
    ld = 1;               // Activate load
    #10;                  // Wait for one clock cycle
    ld = 0;               // Deactivate load
    #10;                  // Wait for stability

    // Test case 2: Load value 2 (00000010)
    par_in = 8'b00000010; // Input binary 2
    write_add = 1;        // Write address for the second input
    ld = 1;               // Activate load
    #10;                  // Wait for one clock cycle
    ld = 0;               // Deactivate load
    #10;                  // Wait for stability

    // Test case 3: Load value 3 (00000011)
    par_in = 8'b00000011; // Input binary 3
    write_add = 2;        // Write address for the third input
    ld = 1;               // Activate load
    #10;                  // Wait for one clock cycle
    ld = 0;               // Deactivate load
    #10;                  // Wait for stability

    // Test case 4: Load value 4 (00000100)
    par_in = 8'b00000100; // Input binary 4
    write_add = 3;        // Write address for the fourth input
    ld = 1;               // Activate load
    #10;                  // Wait for one clock cycle
    ld = 0;               // Deactivate load
    #10;                  // Wait for stability

    // Optionally read values back to check if they were stored correctly
    read_add = 0;         // Read from address 0
    #10;                  // Wait for one clock cycle
    // Add code to check the output par_out here if needed

    read_add = 1;         // Read from address 1
    #10;                  // Wait for one clock cycle
    // Add code to check the output par_out here if needed

    read_add = 2;         // Read from address 2
    #10;                  // Wait for one clock cycle
    // Add code to check the output par_out here if needed

    read_add = 3;         // Read from address 3
    #10;                  // Wait for one clock cycle
    // Add code to check the output par_out here if needed

    // Finish the simulation
    $finish;
end
