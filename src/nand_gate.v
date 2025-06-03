module nand_gate(A, B, C);
    input A, B;
    output C;

    assign C = ~(A & B); // NAND operation
endmodule