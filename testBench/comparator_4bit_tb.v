// Testbench for 4-bit Comparator
`timescale 1ns/1ps

module comparator_4bit_tb;
    reg [3:0] A, B;
    wire greater, less, equal;
    
    comparator_4bit uut (
        .A(A),
        .B(B),
        .greater(greater),
        .less(less),
        .equal(equal)
    );
    
    initial begin
        $dumpfile("vcd/comparator_4bit.vcd");
        $dumpvars(0, comparator_4bit_tb);
        
        // Test Equal
        A = 4'b0101; B = 4'b0101; #10;
        A = 4'b1111; B = 4'b1111; #10;
        
        // Test Greater
        A = 4'b1000; B = 4'b0111; #10;
        A = 4'b0110; B = 4'b0011; #10;
        A = 4'b1111; B = 4'b0000; #10;
        
        // Test Less
        A = 4'b0011; B = 4'b0110; #10;
        A = 4'b0000; B = 4'b1111; #10;
        A = 4'b0101; B = 4'b1010; #10;
        
        // Mixed tests
        A = 4'b0000; B = 4'b0000; #10;
        A = 4'b1010; B = 4'b1010; #10;
        
        $display("4-bit Comparator Test Complete");
        $finish;
    end
    
    initial begin
        $monitor("Time=%0t A=%d B=%d Equal=%b Greater=%b Less=%b", 
                 $time, A, B, equal, greater, less);
    end
endmodule
