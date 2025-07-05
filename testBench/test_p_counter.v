`timescale 1ns/1ps

module test_p_counter;
    // Parameters
    parameter WIDTH = 8;
    parameter PERIOD = 10; // 10ns clock period
    
    // Testbench signals
    reg clear;
    reg clk;
    wire [WIDTH-1:0] count;
    
    // Instantiate the Unit Under Test (UUT)
    p_counter #(.WIDTH(WIDTH)) uut (
        .clear(clear),
        .clk(clk),
        .count(count)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(PERIOD/2) clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        clear = 1;
        
        // Wait for global reset
        #20;
        
        $display("Starting p_counter testbench");
        $display("Time\tClear\tClk\tCount");
        $monitor("%4t\t%b\t%b\t%d", $time, clear, clk, count);
        
        // Test 1: Release clear and let counter run
        clear = 0;
        #100;
        
        // Test 2: Apply clear during counting
        clear = 1;
        #20;
        clear = 0;
        #80;
        
        // Test 3: Test overflow (count to maximum and beyond)
        clear = 1;
        #10;
        clear = 0;
        #(PERIOD * (2**WIDTH + 5)); // Count beyond overflow
        
        // Test 4: Multiple clear pulses
        clear = 1;
        #15;
        clear = 0;
        #50;
        clear = 1;
        #10;
        clear = 0;
        #30;
        
        $display("Testbench completed");
        $finish;
    end
    
    // Dump waveforms
    initial begin
        $dumpfile("test_p_counter.vcd");
        $dumpvars(0, test_p_counter);
    end
    
endmodule