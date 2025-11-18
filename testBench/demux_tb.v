`timescale 1ns/1ps

module demux81_tb;
    reg in;
    reg [2:0] sel;
    wire [7:0] out;

    // Instantiate the Unit Under Test (UUT)
    demux81_comb uut (
        .in(in),
        .sel(sel),
        .out(out)
    );

    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/demux.vcd");
        $dumpvars(0, demux81_tb);

        // Initialize inputs
        in = 0;
        sel = 3'b000;
        
        // Test cases - Test all 8 outputs with input=1
        #10 in = 1; sel = 3'b000;  // Output Y0
        #10 sel = 3'b001;           // Output Y1
        #10 sel = 3'b010;           // Output Y2
        #10 sel = 3'b011;           // Output Y3
        #10 sel = 3'b100;           // Output Y4
        #10 sel = 3'b101;           // Output Y5
        #10 sel = 3'b110;           // Output Y6
        #10 sel = 3'b111;           // Output Y7
        
        // Test with input=0
        #10 in = 0; sel = 3'b000;
        #10 sel = 3'b101;
        
        #10 $finish;
    end

endmodule
