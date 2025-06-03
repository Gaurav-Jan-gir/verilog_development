`timescale 1ns/1ps

module comb_two_tb;

    reg a;
    reg b;
    reg c;
    reg d;
    wire f;

    // Instantiate the Unit Under Test (UUT)
    comb_two uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .f(f)
    );

    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/comb_curcuit.vcd");
        $dumpvars(0, comb_two_tb);

        // Initialize inputs
        a = 0;
        b = 0;
        c = 0;
        d = 0;

        // Test cases
        #10;
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 1;
        b = 0;
        c = 0;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 0;
        b = 1;
        c = 0;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 1;
        b = 1;
        c = 0;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 0;
        b = 0;
        c = 1;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 1;
        b = 0;
        c = 1;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 0;
        b = 1;
        c = 1;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 1;
        b = 1;
        c = 1;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 0;
        b = 0;
        c = 0;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 1;
        b = 0;
        c = 0;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 0;
        b = 1;
        c = 0;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 1;
        b = 1;
        c = 0;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 0;
        b = 0;
        c = 1;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 1;
        b = 0;
        c = 1;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 0;
        b = 1;
        c = 1;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        a = 1;
        b = 1;
        c = 1;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f=%b ", $time, a, b, c, d, f);

        #10;
        $finish;
    end

endmodule
