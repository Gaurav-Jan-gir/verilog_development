`timescale 1ns/1ps

module orGate_tb;

    reg A;
    reg B;
    wire Y;

    // Instantiate the Unit Under Test (UUT)
    orGate uut (
        .A(A),
        .B(B),
        .Y(Y)
    );

    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/or_gate.vcd");
        $dumpvars(0, orGate_tb);

        // Initialize inputs
        A = 0;
        B = 0;

        // Test cases
        #10;
        A = 0;
        B = 0;
        #10;
        $display("Time=%0t: A=%b B=%b Y=%b ", $time, A, B, Y);

        #10;
        A = 1;
        B = 0;
        #10;
        $display("Time=%0t: A=%b B=%b Y=%b ", $time, A, B, Y);

        #10;
        A = 0;
        B = 1;
        #10;
        $display("Time=%0t: A=%b B=%b Y=%b ", $time, A, B, Y);

        #10;
        A = 1;
        B = 1;
        #10;
        $display("Time=%0t: A=%b B=%b Y=%b ", $time, A, B, Y);

        #10;
        $finish;
    end

endmodule
