// `include "../src/bch_31_modules.sv"

module bch_31_syndrome(
    input  logic [30:0] codeword,
    output logic [ 4:0] S1,
    output logic [ 4:0] S2,
    output logic [ 4:0] S3,
    output logic [ 4:0] S4
);

    always_comb begin
        S1 = 5'b00000;
        S2 = 5'b00000;
        S3 = 5'b00000;
        S4 = 5'b00000;

        for (int i = 0; i < 31; i++) begin
            if (codeword[i]) begin
                S1 ^= gf_pow(i);
                S2 ^= gf_pow(2*i);
                S3 ^= gf_pow(3*i);
                S4 ^= gf_pow(4*i);
            end
        end
    end
endmodule
