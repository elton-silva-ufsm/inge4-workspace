// `include "../src/bch_31_modules.sv"

module bch_31_chien (
    input  logic [4:0] lambda1,
    input  logic [4:0] lambda2, 
    output logic [30:0] error_vector,  
    output logic        error_found
);

    logic [4:0] alpha_neg_i, alpha_neg_i_sq;
    logic [4:0] eval1, eval2, sum;

    always_comb begin
        error_vector = 31'b0;

        for (int i = 0; i < 31; i++) begin
            alpha_neg_i    = gf_pow((31 - i) % 31);   // α^(-i)
            alpha_neg_i_sq = gf_mult(alpha_neg_i, alpha_neg_i); // (α^(-i))²

            eval1 = gf_mult(lambda1, alpha_neg_i);
            eval2 = gf_mult(lambda2, alpha_neg_i_sq);

            sum = 5'd1 ^ eval1 ^ eval2; // Λ(α^(-i)) = 1 + λ₁·α^(-i) + λ₂·(α^(-i))²

            error_vector[i] = (sum == 5'd0);
        end
    end

    assign error_found = |error_vector;

endmodule
