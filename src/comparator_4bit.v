// Experiment 4: 4-bit Comparator
module comparator_4bit(
    input [3:0] A, B,
    output greater, less, equal
);
    assign equal = (A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (A[1] ~^ B[1]) & (A[0] ~^ B[0]);
    
    assign greater = (A[3] & ~B[3]) |
                    ((A[3] ~^ B[3]) & (A[2] & ~B[2])) |
                    ((A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (A[1] & ~B[1])) |
                    ((A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (A[1] ~^ B[1]) & (A[0] & ~B[0]));

    assign less = (~A[3] & B[3]) |
                 ((A[3] ~^ B[3]) & (~A[2] & B[2])) |
                 ((A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (~A[1] & B[1])) |
                 ((A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (A[1] ~^ B[1]) & (~A[0] & B[0]));
endmodule
