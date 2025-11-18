`timescale 1ns/1ps

module adder4b_tb;
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] Sum;
    wire Cout;

    adder4b uut (
        .a(A),
        .b(B),
        .cin(Cin),
        .sum(Sum),
        .cout(Cout)
    );

    initial begin
        // Test case 1
        A = 4'b0001; B = 4'b0010; Cin = 0;
        #10;
        
        // Test case 2
        A = 4'b1111; B = 4'b0001; Cin = 0;
        #10;
        
        // Test case 3
        A = 4'b1010; B = 4'b0101; Cin = 1;
        #10;
        
        // Test case 4
        A = 4'b1111; B = 4'b1111; Cin = 1;
        #10;

        $finish;
    end
endmodule