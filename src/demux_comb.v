module demux81_comb(
    input in,
    input [2:0] sel,
    output [7:0] out
);
    assign out = (in << sel); // Shift 'in' to the position indicated by 'sel'
endmodule