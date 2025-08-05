// Impliment an n-bit adder using generate in verilog

module full_adder(
    input a, input b, input cin,
    output sum, output cout
);
    assign sum = a ^ b ^ cin; // Sum is the XOR of inputs and carry-in
    assign cout = (a & b) | (cin & (a ^ b)); // Carry-out is generated if any two inputs are high
endmodule

module adder_gen #(
    parameter N = 8
)(
    input [N-1:0] a, input [N-1:0] b,
    output [N-1:0] sum, output cout
);
genvar i;
wire [N:0] carry;
assign carry[0] = 1'b0; // Initial carry-in
generate
    for (i=0; i<N; i=i+1) begin : subadders
        full_adder fa (
            .a(a[i]),
            .b(b[i]),
            .cin(carry[i]),
            .sum(sum[i]),
            .cout(carry[i+1])
        );
    end
endgenerate
// To access any intermedate sum or carry, you can use:
// wire middle_sum = subadders[4].fa.sum; // Example for accessing the 5th full adder's sum
// wire middle_cout = subadders[4].fa.cout; // Example for accessing the 5th full adder's carry-out
// You can also access inputs of the 5th full adder:
// wire middle_a = subadders[4].fa.a; // A input of the 5th full adder
// wire middle_b = subadders[4].fa.b; // B input of the 5th full adder
// wire middle_cin = subadders[4].fa.cin; // Carry input of the 5th full adder
assign cout = carry[N]; // Final carry-out
endmodule