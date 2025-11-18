`timescale 10ps/1ps

module mux_s_tb;
    reg [15:0] in;
    reg [3:0] sel;
    wire out;

    mux_s uut (
        .in(in),
        .sel(sel),
        .out(out)
    );

    initial begin
        $dumpfile("vcd/mux_s.vcd");
        $dumpvars(0, mux_s_tb);
        $monitor("Time: %0t, in: %h, sel: %h, out: %b", $time, in, sel, out);
        
        // Test case 1
        #5 in = 16'h3f0a; sel = 4'h0; // Select first bit
        #5 sel = 4'h1; // Select second bit
        #5 sel = 4'h2; // Select third bit
        #5 sel = 4'h3; // Select fourth bit
        #5 $finish; // End simulation
    end
endmodule