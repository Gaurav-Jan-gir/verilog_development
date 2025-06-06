`timescale 1ns/1ps

module fun1_tb;

    reg a;
    reg b;
    reg c;
    reg d;
    wire f_wire;
    wire f_tri;
    wire f_wor;
    wire f_wand;
    wire f_supply0;
    wire f_supply1;

    // Instantiate the Unit Under Test (UUT)
    fun1 uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .f_wire(f_wire),
        .f_tri(f_tri),
        .f_wor(f_wor),
        .f_wand(f_wand),
        .f_supply0(f_supply0),
        .f_supply1(f_supply1)
    );

    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/net_variables.vcd");
        $dumpvars(0, fun1_tb);

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
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 1;
        b = 0;
        c = 0;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 0;
        b = 1;
        c = 0;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 1;
        b = 1;
        c = 0;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 0;
        b = 0;
        c = 1;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 1;
        b = 0;
        c = 1;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 0;
        b = 1;
        c = 1;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 1;
        b = 1;
        c = 1;
        d = 0;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 0;
        b = 0;
        c = 0;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 1;
        b = 0;
        c = 0;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 0;
        b = 1;
        c = 0;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 1;
        b = 1;
        c = 0;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 0;
        b = 0;
        c = 1;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 1;
        b = 0;
        c = 1;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 0;
        b = 1;
        c = 1;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        a = 1;
        b = 1;
        c = 1;
        d = 1;
        #10;
        $display("Time=%0t: a=%b b=%b c=%b d=%b f_wire=%b f_tri=%b f_wor=%b f_wand=%b f_supply0=%b f_supply1=%b ", $time, a, b, c, d, f_wire, f_tri, f_wor, f_wand, f_supply0, f_supply1);

        #10;
        $finish;
    end

endmodule
