// Testbench for 4-bit Adder/Subtractor
`timescale 1ns/1ps

module adder_subtractor_4bit_tb;
    reg [3:0] a, b;
    reg M;
    wire [3:0] d;
    wire bout;
    
    adder_subtractor_4bit uut (
        .a(a),
        .b(b),
        .M(M),
        .d(d),
        .bout(bout)
    );
    
    initial begin
        $dumpfile("vcd/adder_subtractor_4bit.vcd");
        $dumpvars(0, adder_subtractor_4bit_tb);
        
        // Test Addition (M=0)
        M = 0;
        a = 4'b0101; b = 4'b0011; #10; // 5 + 3 = 8
        a = 4'b1001; b = 4'b0110; #10; // 9 + 6 = 15
        a = 4'b1111; b = 4'b0001; #10; // 15 + 1 = 0 (overflow)
        
        // Test Subtraction (M=1)
        M = 1;
        a = 4'b1000; b = 4'b0011; #10; // 8 - 3 = 5
        a = 4'b0110; b = 4'b0010; #10; // 6 - 2 = 4
        a = 4'b0011; b = 4'b0101; #10; // 3 - 5 = -2 (2's complement)
        a = 4'b1111; b = 4'b0001; #10; // 15 - 1 = 14
        
        $display("4-bit Adder/Subtractor Test Complete");
        $finish;
    end
    
    initial begin
        $monitor("Time=%0t M=%b a=%d b=%d Result=%d Carry/Borrow=%b", 
                 $time, M, a, b, d, bout);
    end
endmodule
