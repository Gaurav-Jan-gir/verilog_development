`timescale 1ns/1ps

module serial_to_parallel_tb;

    reg serial_in, clk, rst;
    wire [3:0] parallel_out;
    reg [31:0] test_vector = 32'b11010011101101000101010101010101;
    // Instantiate the Unit Under Test (UUT)
    serial_to_parallel uut (
        .serial_in(serial_in),
        .clk(clk),
        .rst(rst),
        .parallel_out(parallel_out)
    );

    initial forever #5 clk = ~clk; // Clock generation
    integer i;
    initial begin
        // Initialize VCD dump
    $dumpfile("vcd/serial_to_parallel.vcd");
    // Dump all variables in this testbench scope (top-level: serial_to_parallel_tb)
    $dumpvars(0, serial_to_parallel_tb);

        // Initialize inputs
        serial_in = 0;
        clk = 0;
        rst = 1;
        #7 rst = 0; // Assert reset
        #10 rst = 1; // Deassert reset

        // Apply test vectors
        for (i = 0; i < 32; i = i + 1) begin
            @(negedge clk);
            serial_in = test_vector[i];
            #1; // allow propagation
            $display("T=%0t serial_in=%b parallel_out=%b", $time, serial_in, parallel_out);
        end

        // Test cases
        // No inputs: sample outputs over time
        #10;
        $finish;
    end

endmodule
