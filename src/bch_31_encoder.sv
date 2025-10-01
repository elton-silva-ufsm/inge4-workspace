module bch_31_encoder(
    input  [19:0] msg,          // 20-bit input message           
    output reg [30:0] codeword  // 31-bit output codeword
);

    // m1(x) = x⁵ + x² + 1
    // m3(x) = x⁵ + x³ + x² + x + 1
    // g(x) = m1(x) * m3(x) = x¹⁰ + x⁹ + x⁸ + x⁵ + x + 1
    parameter [10:0] GEN = 11'b11100100011;

    reg [30:0] temp;
    reg [10:0] remainder;
    integer i;

    always_comb begin
        // Shift msg left by 11 bits (msg * x^11)
        temp = {msg, 11'b0};

        // Polynomial division
        for (i = 30; i >= 20; i = i - 1) begin
            if (temp[i]) begin
                temp[i -: 11] = temp[i -: 11] ^ GEN;
            end
        end

        remainder = temp[10:0]; // remainder is the parity bits

        // Final codeword = {message[19:0], parity[10:0]}
        codeword = {msg ,remainder}; // message in MSBs, parity in LSBs
    end

endmodule