// Testbench for Mod-10 Counter
`timescale 1ns/1ps

module mod10_counter_tb;
    reg clk;
    wire [3:0] q;
    
    mod10_counter uut (
        .clk(clk),
        .q(q)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("vcd/mod10_counter.vcd");
        $dumpvars(0, mod10_counter_tb);
        
        // Run for multiple cycles to see counting pattern
        #200;
        
        $display("Mod-10 Counter Test Complete");
        $finish;
    end
    
    initial begin
        $monitor("Time=%0t clk=%b Count=%d", $time, clk, q);
    end
endmodule
