module mux_p21(in, sel, out);
    input [1:0] in;
    input sel;
    output reg out;
    always @(*) begin
        if(sel)
            out = in[1];
        else
            out = in[0];
    end
endmodule