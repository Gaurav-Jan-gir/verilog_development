// Experiment 3: 4-bit Adder/Subtractor
module full_adder (
    input a, b, c,
    output d, bout
);
    assign d = a ^ b ^ c;
    assign bout = (a & b) | (b & c) | (c & a);
endmodule

module adder_subtractor_4bit(
    input [3:0] a, b,
    input M,           // M=0 => +, M=1 => -
    output [3:0] d,
    output bout
);
    wire [2:0] bl;
    wire [3:0] b2;
    
    // XOR gates for 2's complement (controlled by M)
    assign b2[0] = b[0] ^ M;
    assign b2[1] = b[1] ^ M;
    assign b2[2] = b[2] ^ M;
    assign b2[3] = b[3] ^ M;
    
    // Full adders in cascade
    full_adder f1(a[0], b2[0], M, d[0], bl[0]);
    full_adder f2(a[1], b2[1], bl[0], d[1], bl[1]);
    full_adder f3(a[2], b2[2], bl[1], d[2], bl[2]);
    full_adder f4(a[3], b2[3], bl[2], d[3], bout);
endmodule
