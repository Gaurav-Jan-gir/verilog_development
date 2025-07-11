`timescale 10ps/1ps

module mux_p_tb;
    reg [1:0] in;
    reg sel;
    wire out;
    mux_p21 uut(.in(in), .sel(sel), .out(out));
    initial begin
        $dumpfile("vcd/mux_p.vcd");
        $dumpvars(0, mux_p_tb);
        $monitor("Time=%0t: in=%b sel=%b out=%b", $time, in, sel, out);
        repeat (10) begin
            in = $random;
            sel = $random % 2;
            #10;
        end
    end
endmodule