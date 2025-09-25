module bch_syndrome_block (
    input  logic [14:0] codeword,
    output logic [3:0]  S1,
    output logic [3:0]  S2,
    output logic [3:0]  S3
);
    always_comb begin
        S1 = 4'b0000;
        S2 = 4'b0000;
        S3 = 4'b0000;

        for (int i = 0; i < 15; i++) begin
            if (codeword[i]) begin
                S1 ^= alpha_pow(i);
                S2 ^= alpha_pow(2*i);
                S3 ^= alpha_pow(3*i);
            end
        end
    end

endmodule
