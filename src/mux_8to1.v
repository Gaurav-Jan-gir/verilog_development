// Experiment 2a: 8:1 Multiplexer
module mux_8to1(
    input [7:0] i,    
    input [2:0] s,    
    output o         
);
    assign o = (i[0] & ~s[2] & ~s[1] & ~s[0]) |
               (i[1] & ~s[2] & ~s[1] &  s[0]) |
               (i[2] & ~s[2] &  s[1] & ~s[0]) |
               (i[3] & ~s[2] &  s[1] &  s[0]) |
               (i[4] &  s[2] & ~s[1] & ~s[0]) |
               (i[5] &  s[2] & ~s[1] &  s[0]) |
               (i[6] &  s[2] &  s[1] & ~s[0]) |
               (i[7] &  s[2] &  s[1] &  s[0]);
endmodule
