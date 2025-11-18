`timescale 1ns/1ps

module parallel_to_serial_tb;

    reg [3:0] parallel_in;
    reg clk, rst, load;
    wire serial_out;
    reg [127:0] test_vector = 128'hDEADBEEFCAFEBABE0123456789ABCDEF;
    // Instantiate the Unit Under Test (UUT)
    parallel_to_serial uut (
        .parallel_in(parallel_in),
        .clk(clk),
        .rst(rst),
        .load(load),
        .serial_out(serial_out)
    );

    initial forever #5 clk = ~clk; // Clock generation
    integer i;
    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/parallel_to_serial.vcd");
        // Dump all variables in this testbench scope (top-level: parallel_to_serial_tb)
        $dumpvars(0, parallel_to_serial_tb);

        // Initialize inputs
        parallel_in = 4'b0000;
        clk = 0;
        rst = 1;
        load = 0; // ensure defined before load stimulus
        #7 rst = 0; // Assert reset
        #10 rst = 1; // Deassert reset


        // Apply test vectors
        for (i = 0; i < 128; i = i + 4) begin
            @(negedge clk);
            // Use variable part-select: take 4 bits starting at index i
            parallel_in = test_vector[i +: 4];
            #1; // allow propagation
            $display("T=%0t parallel_in=%b serial_out=%b", $time, parallel_in, serial_out);
        end

        // Test cases
        // No inputs: sample outputs over time
        #10;
        $finish;
    end
    initial begin
        #20 load = 1;
        #10 load = 0;
        #60 load = 1;
        #10 load = 0;
        #60 load = 1;
        #10 load = 0;
        #60 load = 1;
        #10 load = 0;
        #60 load = 1;
        #10 load = 0;
    end


endmodule
