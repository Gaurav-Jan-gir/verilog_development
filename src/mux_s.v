module mux_s(in, sel, out);
    input [15:0] in; // 16-bit input
    input [3:0] sel; // 4-bit selector
    output out;      // Output
    wire [1:0] mux_out; // Intermediate output for 8-bit muxes
    mux8 mux8_0(.in(in[7:0]), .sel(sel[2:0]), .out(mux_out[0]));
    mux8 mux8_1(.in(in[15:8]), .sel(sel[2:0]), .out(mux_out[1]));
    mux2 mux2_final(.in(mux_out), .sel(sel[3]), .out(out));
endmodule

module mux2(in, sel, out);
    input [1:0] in;
    input sel;
    output out;
    // wire w1, w2, sel_n;
    // not(sel_n, sel);
    // and(w1, in[0], sel_n);
    // and(w2, in[1], sel);
    // or(out, w1, w2);
    assign out = in[0]&~sel | in[1]&sel;
endmodule

module mux4(in, sel, out);
    input [3:0] in;
    input [1:0] sel;
    output out;
    wire [1:0] mux2_out;

    // First level of multiplexing
    mux2 mux2_0(.in(in[1:0]), .sel(sel[0]), .out(mux2_out[0]));
    mux2 mux2_1(.in(in[3:2]), .sel(sel[0]), .out(mux2_out[1]));

    // Second level of multiplexing
    mux2 mux2_final(.in(mux2_out), .sel(sel[1]), .out(out));
endmodule

module mux8(in, sel, out);
    input [7:0] in;
    input [2:0] sel;
    output out;
    wire [1:0] mux4_out;

    // First level of multiplexing
    mux4 mux4_0(.in(in[3:0]), .sel(sel[1:0]), .out(mux4_out[0]));
    mux4 mux4_1(.in(in[7:4]), .sel(sel[1:0]), .out(mux4_out[1]));

    // Second level of multiplexing
    mux2 mux2_final(.in(mux4_out), .sel(sel[2]), .out(out));
endmodule