`timescale 1ns/1ps

module nand_gate_tb;

    reg A;
    reg B;
    wire C;

    // Instantiate the Unit Under Test (UUT)
    nand_gate uut (
        .A(A),
        .B(B),
        .C(C)
    );

    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/nand_gate.vcd");
        $dumpvars(0, nand_gate_tb);

        // Initialize inputs
        A = 0;
        B = 0;

        // Test cases

        integer vec;
        for (vec = 0; vec < 4; vec = vec + 1) begin
            #10;
            A = (vec >> 0) & 1;
            B = (vec >> 1) & 1;
            #1;
            $display("T=%0t A=%b B=%b C=%b", $time, A, B, C);
        end
        #10;
        $finish;
    end

endmodule
