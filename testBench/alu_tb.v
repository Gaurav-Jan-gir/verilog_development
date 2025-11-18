`timescale 1ns/1ps

module alu_tb;
    reg [1:0] A,B;
    reg [2:0] sel;
    wire [4:0] out2;
    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .A(A),
        .B(B),
        .sel(sel),
        .out(out2)
    );
    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/alu.vcd");
        $dumpvars(0, alu_tb);

        // Initialize inputs
        A = 2'b00;
        B = 2'b00;
        sel = 3'b000;

        // Test cases
        #5 A = 2'b01; B = 2'b01; sel = 3'b000; // 1 + 1 = 2
        #5 A = 2'b10; B = 2'b01; sel = 3'b001; // 2 - 1 = 1
        #5 A = 2'b11; B = 2'b10; sel = 3'b010; // 3 * 2 = 6
        #5 A = 2'b10; B = 2'b11; sel = 3'b011; // 2 ^ 3 = 8
        #5 A = 2'b11; B = 2'b01; sel = 3'b100; // 3 & 1 = 1
        #5 A = 2'b10; B = 2'b01; sel = 3'b101; // 2 | 1 = 3
        #5 A = 2'b11; B = 2'b01; sel = 3'b110; // 3 ^ 1 = 2
        #5 A = 2'b10; B = 2'b01; sel = 3'b111; // ~(2 | 1) = 0
        #10;
        
        $finish;
    end
endmodule