// 2 bit ALU with 4 arthematic and 4 logic operations

module alu(
    input [1:0] A, B,
    input [2:0] sel,
    output reg [4:0] out
);
always @(*) begin
    case (sel)
    // Arithmetic operations
    3'b000: out = A + B; // Addition
    3'b001: out = A - B; // Subtraction
    3'b010: out = A * B; // Multiplication
    3'b011: begin
        case(B)
            2'b00: out = 5'b00001; // A ^ 0 = 1 (undefined, but avoid division by zero)
            2'b01: out = A;    // A ^ 1 = A
            2'b10: out = A * A; // A ^ 2 
            2'b11: out = A * A * A; // A ^ 3 
        endcase
    end
    // Logic operations
    3'b100: out = A & B; // AND
    3'b101: out = A | B; // OR
    3'b110: out = A ^ B; // XOR
    3'b111: out = ~(A | B); // NOR
    endcase
end
endmodule