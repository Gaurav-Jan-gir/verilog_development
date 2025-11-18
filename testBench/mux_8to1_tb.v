// Testbench for 8:1 Multiplexer
`timescale 1ns/1ps

module mux_8to1_tb;
    reg [7:0] i;
    reg [2:0] s;
    wire o;
    
    mux_8to1 uut (
        .i(i),
        .s(s),
        .o(o)
    );
    
    initial begin
        $dumpfile("vcd/mux_8to1.vcd");
        $dumpvars(0, mux_8to1_tb);
        
        // Set inputs
        i = 8'b10101100;
        
        // Test all select combinations
        s = 3'b000; #10;
        s = 3'b001; #10;
        s = 3'b010; #10;
        s = 3'b011; #10;
        s = 3'b100; #10;
        s = 3'b101; #10;
        s = 3'b110; #10;
        s = 3'b111; #10;
        
        // Change inputs and test again
        i = 8'b01010011;
        s = 3'b000; #10;
        s = 3'b011; #10;
        s = 3'b111; #10;
        
        $display("8:1 Multiplexer Test Complete");
        $finish;
    end
    
    initial begin
        $monitor("Time=%0t i=%b s=%b o=%b", $time, i, s, o);
    end
endmodule
