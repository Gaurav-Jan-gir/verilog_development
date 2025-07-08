module adder_b(sum,a,b,sign,zero,parity,overflow,carry);
    parameter n = 16;
    input [n-1:0] a;
    input [n-1:0] b;
    output [n-1:0] sum;
    output sign, zero, parity, overflow, carry;

    assign {carry,sum} = a+b;

    assign sign = sum[n-1];
    assign zero = ~|sum;
    assign parity = ^sum;
    assign overflow = (a[n-1] & b[n-1] & ~sum[n-1]) | (~a[n-1] & ~b[n-1] & sum[n-1]);
endmodule