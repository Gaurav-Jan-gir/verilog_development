// Experiment 7: 1010 Sequence Detector (Overlapping)
module seq_detector_1010(
    input clk, rst, x,
    output reg y
);
    // State definitions
    parameter S0 = 3'd0; 
    parameter S1 = 3'd1; 
    parameter S2 = 3'd2; 
    parameter S3 = 3'd3; 
    parameter S4 = 3'd4; 
    
    reg [2:0] state, n_state;
    
    // State register
    always @(posedge clk or negedge rst) begin
        if (!rst)
            state <= S0;
        else
            state <= n_state;
    end
    
    // Next state and output logic
    always @(*) begin
        n_state = state;
        y = 0;
        case (state)
            S0: begin
                if (x == 1) n_state = S1;
                else n_state = S0;
            end
            S1: begin
                if (x == 1) n_state = S1;
                else n_state = S2;
            end
            S2: begin
                if (x == 1) n_state = S3;
                else n_state = S0;
            end
            S3: begin
                if (x == 1) n_state = S1;
                else n_state = S4;
            end
            S4: begin
                y = 1; // Sequence detected
                if (x == 1) n_state = S3; // Overlapping
                else n_state = S0;
            end
            default: n_state = S0;
        endcase
    end
endmodule
