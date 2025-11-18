`timescale 1ns/1ps

module s_counter_tb;

    reg clk;
    reg reset;
    wire [3:0] count;

    // Instantiate the Unit Under Test (UUT)
    s_counter uut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    always #5 clk = ~clk;
    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/s_counter.vcd");
        $dumpvars(0, s_counter_tb);

        // Initialize inputs
        clk = 0;
        reset = 1; // active-high reset asserted

        // Reset pulse
        #20;
        reset = 0; // deassert active-high reset

        // Test cases

        // Clocked stimulus
        // No data inputs: just run some cycles
        repeat (32) begin @(posedge clk); #1; $display("T=%0t count=%b", $time, count); end
        #10;
        $finish;
    end

endmodule
