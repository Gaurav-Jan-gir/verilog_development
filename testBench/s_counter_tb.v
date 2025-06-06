`timescale 1ns/1ps

module s_counter_tb;

    reg clk;
    reg reset;
    wire [3:0] count;

    // Instantiate the Unit Under Test (UUT)
    s_counter uut (
        .clk(clk),
        .reset(reset),
        .[3:0] count([3:0] count)
    );

    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/s_counter.vcd");
        $dumpvars(0, s_counter_tb);

        // Initialize inputs
        clk = 0;
        reset = 0;

        // Test cases
        #10;
        clk = 0;
        reset = 0;
        #10;
        $display("Time=%0t: clk=%b reset=%b [3:0] count=%b ", $time, clk, reset, [3:0] count);

        #10;
        clk = 1;
        reset = 0;
        #10;
        $display("Time=%0t: clk=%b reset=%b [3:0] count=%b ", $time, clk, reset, [3:0] count);

        #10;
        clk = 0;
        reset = 1;
        #10;
        $display("Time=%0t: clk=%b reset=%b [3:0] count=%b ", $time, clk, reset, [3:0] count);

        #10;
        clk = 1;
        reset = 1;
        #10;
        $display("Time=%0t: clk=%b reset=%b [3:0] count=%b ", $time, clk, reset, [3:0] count);

        #10;
        $finish;
    end

endmodule
