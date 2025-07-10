`timescale 10ns/1ns
module mux_tb;
    reg [15:0] in;
    reg [3:0] sel;
    wire out;
    mux uut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    initial begin
        $dumpfile("vcd/mux_tb.vcd");
        $dumpvars(0, mux_tb);
        $monitor("Time: %0t, in: %h, sel: %h, out: %b", $time, in, sel, out);
        // Test case 1
        #5 in = 16'h3f0a; sel = 4'h0;
        #5 sel = 4'h1; // Select first bit
        #5 sel = 4'h6; // Select second bit
        #5 sel = 4'hc; // Select third bit
        #5 $finish; // End simulation
    end
endmodule