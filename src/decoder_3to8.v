// Experiment 1: 3:8 Decoder
module decoder_3to8(
    input [2:0] S,    
    output [7:0] D    
);
    assign D[0] = ~S[2] & ~S[1] & ~S[0];
    assign D[1] = ~S[2] & ~S[1] &  S[0];
    assign D[2] = ~S[2] &  S[1] & ~S[0];
    assign D[3] = ~S[2] &  S[1] &  S[0];
    assign D[4] =  S[2] & ~S[1] & ~S[0];
    assign D[5] =  S[2] & ~S[1] &  S[0];
    assign D[6] =  S[2] &  S[1] & ~S[0];
    assign D[7] =  S[2] &  S[1] &  S[0];
endmodule
