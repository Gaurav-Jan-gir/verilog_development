`timescale 1ps/1ps

module counter_tb;
    reg clock = 0;
    reg reset = 1;
    wire [3:0] count;
    
    // Instantiate the counter module
    counter uut (
        .clk(clock),
        .reset(reset),
        .count(count)
    );
    
    // Generate clock signal
    always #5 clock = ~clock;  // Clock period of 10 time units
    
    initial begin
        $dumpfile("vcd/counter.vcd");
        $dumpvars(0, counter_tb);
        
        // Monitor the signals
        $monitor("Time=%0t: clock=%b reset=%b count=%b", $time, clock, reset, count);
        
        // Reset the counter
        #10 reset = 0;  // Release reset after 10 time units
        
        // Run for a while to observe counting
        #100; reset = 1;  // Assert reset again
        #10 reset = 0;  // Release reset again
        #200;  // Let the counter run for a while
        
        // Finish simulation
        $finish;
    end
endmodule