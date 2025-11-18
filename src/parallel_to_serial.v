module parallel_to_serial(
    input [3:0] parallel_in,
    input clk,
    input rst,
    input load,
    output wire serial_out
);
    wire [3:0] dff_out;
    wire [2:0] q;
    assign q[0] = load ? parallel_in[1] : dff_out[0];
    assign q[1] = load ? parallel_in[2] : dff_out[1];
    assign q[2] = load ? parallel_in[3] : dff_out[2];
    DFF dff0 (.D(parallel_in[0]), .clk(clk), .rst(rst), .Q(dff_out[0]));
    DFF dff1 (.D(q[0]), .clk(clk), .rst(rst), .Q(dff_out[1]));
    DFF dff2 (.D(q[1]), .clk(clk), .rst(rst), .Q(dff_out[2]));
    DFF dff3 (.D(q[2]), .clk(clk), .rst(rst), .Q(dff_out[3]));

    assign serial_out = dff_out[3];
endmodule

module DFF (
    input wire D,clk,rst,
    output reg Q
);
    always @(negedge clk or negedge rst) begin
        if (~rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule