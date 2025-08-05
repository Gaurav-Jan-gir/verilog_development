module demux81_tb;

    reg in;
    reg [2:0] sel;
    wire [7:0] out;

    // Instantiate the Unit Under Test (UUT)
    demux81 uut (
        .in(in),
        .sel(sel),
        .out(out)
    );

    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/demux81.vcd");
        $dumpvars(0, demux81_tb);

        // Test cases
        in = 1'b1; sel = 3'b000; #10;
        $display("Time=%0t: in=%b sel=%b out=%b", $time, in, sel, out);

        sel = 3'b001; #10;
        $display("Time=%0t: in=%b sel=%b out=%b", $time, in, sel, out);

        sel = 3'b010; #10;
        $display("Time=%0t: in=%b sel=%b out=%b", $time, in, sel, out);

        sel = 3'b011; #10;
        $display("Time=%0t: in=%b sel=%b out=%b", $time, in, sel, out);

        sel = 3'b100; #10;
        $display("Time=%0t: in=%b sel=%b out=%b", $time, in, sel, out);

        sel = 3'b101; #10;
        $display("Time=%0t: in=%b sel=%b out=%b", $time, in, sel, out);

        sel = 3'b110; #10;
        $display("Time=%0t: in=%b sel=%b out=%b", $time, in, sel, out);

        sel = 3'b111; #10;
        $display("Time=%0t: in=%b sel=%b out=%b", $time, in, sel, out);

        #10;
        $finish;
    end
endmodule