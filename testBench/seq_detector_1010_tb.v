// Testbench for 1010 Sequence Detector
`timescale 1ns/1ps

module seq_detector_1010_tb;
    reg clk, rst, x;
    wire y;
    
    seq_detector_1010 uut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("vcd/seq_detector_1010.vcd");
        $dumpvars(0, seq_detector_1010_tb);
        
        // Reset
        rst = 0; x = 0;
        #10 rst = 1;
        
        // Test sequence: 11011011011 (should detect at positions where 1010 occurs)
        // Modified to actual 1010 pattern
        #10 x = 1; // 1
        #10 x = 0; // 10
        #10 x = 1; // 101
        #10 x = 0; // 1010 - DETECTED
        #10 x = 1; // 10101
        #10 x = 0; // 101010 - DETECTED again (overlapping)
        #10 x = 0; // 1010100
        #10 x = 1; // 10101001
        #10 x = 1; // 101010011
        #10 x = 0; // 1010100110
        #10 x = 1; // 10101001101
        #10 x = 0; // 101010011010 - DETECTED
        #10 x = 0;
        #10 x = 1;
        #10 x = 0;
        
        #20;
        $display("1010 Sequence Detector Test Complete");
        $finish;
    end
    
    initial begin
        $monitor("Time=%0t rst=%b clk=%b x=%b y=%b", $time, rst, clk, x, y);
    end
endmodule
