module adder_16(sum, a, b, sign, parity, overflow, cout);
    input [15:0] a, b;
    output [15:0] sum;
    output sign, parity, overflow, cout;
    hybrid_adder_16 ha(sum, cout, a, b, 1'b0);
    assign sign = sum[15];
    assign parity = ~^sum;
    assign overflow = (a[15] == b[15]) && (sum[15] != a[15]);
endmodule

module hybrid_adder_16(sum, cout, a, b, cin);
    input [15:0] a,b;
    input cin;
    output [15:0] sum;
    output cout;
    wire [2:0] c;
    carry_look_ahead_adder_4 cla0(a[3:0], b[3:0], cin, sum[3:0], c[0]);
    carry_look_ahead_adder_4 cla1(a[7:4], b[7:4], c[0], sum[7:4], c[1]);
    carry_look_ahead_adder_4 cla2(a[11:8], b[11:8], c[1], sum[11:8], c[2]);
    carry_look_ahead_adder_4 cla3(a[15:12], b[15:12], c[2], sum[15:12], cout);
endmodule

module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

module ripple_carry_adder_4(a, b, cin, sum, cout);
    input [3:0] a,b;
    input cin;
    output [3:0] sum;
    output cout;

    wire [2:0] c;
    full_adder fa0(a[0], b[0], cin, sum[0], c[0]);
    full_adder fa1(a[1], b[1], c[0], sum[1], c[1]);
    full_adder fa2(a[2], b[2], c[1], sum[2], c[2]);
    full_adder fa3(a[3], b[3], c[2], sum[3], cout);
endmodule

module ripple_carry_adder_16(a, b, cin, sum, cout);
    input [15:0] a,b;
    input cin;
    output [15:0] sum;
    output cout;

    wire [2:0] c;
    ripple_carry_adder_4 rca0(a[3:0],b[3:0], cin, sum[3:0], c[0]);
    ripple_carry_adder_4 rca1(a[7:4],b[7:4], c[0], sum[7:4], c[1]);
    ripple_carry_adder_4 rca2(a[11:8],b[11:8], c[1], sum[11:8], c[2]);
    ripple_carry_adder_4 rca3(a[15:12],b[15:12], c[2], sum[15:12], cout);
endmodule

module carry_look_ahead_adder_4(a, b, cin, sum, cout);
    input [3:0] a,b;
    input cin;
    output [3:0] sum;
    output cout;
    
    wire [3:0] p, g, c;

    assign p = a ^ b; // propagate
    assign g = a & b; // generate

    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);

    assign sum = p ^ c;
    assign cout = g[3] | (p[3] & c[3]);
endmodule