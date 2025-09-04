module encoder_15_7 (
    input        clk,           // Clock input
    input        reset,         // Reset input
    input  [6:0] msg,           // 7-bit message (LSB aligned)
    output reg [14:0] codeword  // 15-bit encoded output
);
    parameter [8:0] GEN = 9'b111010001;

    reg [14:0] temp;
    reg [7:0] remainder;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the outputs to default values on reset
            codeword <= 15'b0;
        end else begin
            // Shift msg left by 8 bits (msg * x^8)
            temp = {msg, 8'b0};

            // Polynomial division
            for (i = 14; i >= 8; i = i - 1) begin
                if (temp[i]) begin
                    temp[i -: 9] = temp[i -: 9] ^ GEN;
                end
            end

            remainder = temp[7:0]; // remainder is the parity bits

            // Final codeword = {parity[7:0], message[6:0]}
            codeword <= {msg ,remainder}; // parity in MSBs, message in LSBs

        end
    end

endmodule
