`timescale 1ns/1ps

module andGate_tb;

    reg A;
    reg B;
    wire C;

    // Instantiate the Unit Under Test (UUT)
    andGate uut (
        .A(A),
        .B(B),
        .C(C)
    );

    initial begin
        // Initialize VCD dump
        $dumpfile("vcd\and.vcd");
        $dumpvars(0, andGate_tb);

        // Initialize inputs
        A = 0;
        B = 0;

        // Test cases
        #10;
        A = 0;
        B = 0;
        #10;
        $display("Time=%0t: A=%b B=%b C=%b ", $time, A, B, C);

        #10;
        A = 1;
        B = 0;
        #10;
        $display("Time=%0t: A=%b B=%b C=%b ", $time, A, B, C);

        #10;
        A = 0;
        B = 1;
        #10;
        $display("Time=%0t: A=%b B=%b C=%b ", $time, A, B, C);

        #10;
        A = 1;
        B = 1;
        #10;
        $display("Time=%0t: A=%b B=%b C=%b ", $time, A, B, C);

        #10;
        $finish;
    end

endmodule
