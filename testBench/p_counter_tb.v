`timescale 1ns/1ps

module p_counter_tb;

    reg clear;
    reg clk;
    wire count;

    // Instantiate the Unit Under Test (UUT)
    p_counter uut (
        .clear(clear),
        .clk(clk),
        .count(count)
    );

    always #5 clk = ~clk;
    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/p_counter.vcd");
        $dumpvars(0, p_counter_tb);

        // Initialize inputs
        clear = 0;
        clk = 0;

        // Test cases

        // Clocked stimulus
        integer vec;
        for (vec = 0; vec < 2; vec = vec + 1) begin
            @(posedge clk);
            clear = (vec >> 0) & 1;
            #1; // allow propagation
            $display("T=%0t clear=%b count=%b", $time, clear, count);
        end
        #10;
        $finish;
    end

endmodule
