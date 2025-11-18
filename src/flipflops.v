// Experiment 5: SR, D, JK, and T Flip-flops

module sr_flipflop(
    input S, R, clk,
    output reg Q, Qn
);
    always @(posedge clk) begin
        case ({S, R})
            2'b00: ; 
            2'b01: begin
                Q <= 1'b0;
                Qn <= 1'b1;
            end
            2'b10: begin
                Q <= 1'b1;
                Qn <= 1'b0;
            end
            2'b11: begin
                Q <= 1'bx;
                Qn <= 1'bx;
            end
        endcase
    end
endmodule

module d_flipflop(
    input D, clk,
    output reg Q, Qn
);
    always @(posedge clk) begin
        Q <= D;
        Qn <= ~D;
    end
endmodule

module jk_flipflop(
    input J, K, clk,
    output reg Q, Qn
);
    always @(posedge clk) begin
        case ({J, K})
            2'b00: ; 
            2'b01: begin
                Q <= 1'b0;
                Qn <= 1'b1;
            end
            2'b10: begin
                Q <= 1'b1;
                Qn <= 1'b0;
            end
            2'b11: begin
                Q <= ~Q;
                Qn <= ~Qn;
            end
        endcase
    end
endmodule

module t_flipflop(
    input T, clk,
    output reg Q, Qn
);
    initial begin
        Q = 1'b0;
        Qn = 1'b1;
    end
    
    always @(posedge clk) begin
        if (T) begin
            Q <= ~Q;
            Qn <= ~Qn;
        end
    end
endmodule
