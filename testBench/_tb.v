module _tb;
    reg A, B;
    wire C;
     uut(.A(A), .B(B), .C(C));
    initial begin
        ("../vcd/.vcd");
        (0, uut);
        A = 0; B = 0;
        #10; A = 1;
        #10; B = 1;
        #10; A = 0;
        #10; ;
    end
endmodule
