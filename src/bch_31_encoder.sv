module bch_31_encoder(
    input  [20:0] msg,          // 21-bit input message           
    output reg [30:0] codeword  // 31-bit output codeword
);

    // g(x) = (x⁵ + x² + 1)·(x⁵ + x⁴ + x³ + x² + 1)
    // g(x) = (x¹⁰ + x⁹ + x⁸ + x⁶ + x⁵ + x³ + 1).
    parameter [10:0] GEN = 11'b11101101001; // Polinômio gerador

    logic [30:0] temp;
    logic [9:0] remainder;  
    integer i;

    always_comb begin
        temp = {msg, 10'b0};  // msg * x^10

        for (i = 30; i >= 10; i = i - 1) begin
            if (temp[i]) begin
                temp[i -: 11] ^= GEN;
            end
        end

        remainder = temp[9:0];
        
        codeword = {msg, remainder};
    end


endmodule