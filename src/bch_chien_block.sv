`timescale 1ns / 1ps

module bch_chien_block (
    input wire [3:0] lambda1,    // lambda1 input
    input wire [3:0] lambda2,    // lambda2 input
    output reg [14:0] error_vector,  // Change to reg type to assign inside always block
    output wire error_found
);

`include "../src/bch_tables.sv"

    always_comb begin
        error_vector = 15'b0;

        for (int i = 0; i < 15; i++) begin
            logic [3:0] alpha_neg_i, alpha_neg_i_sq;
            logic [3:0] eval1, eval2, sum;

            alpha_neg_i    = gf_pow(15 - i);// ?^(-i) ? ?^(15 - i) mod 15
            alpha_neg_i_sq = gf_mult(alpha_neg_i, alpha_neg_i);// (?^(-i))²

            eval1 = gf_mult(lambda1, alpha_neg_i);
            eval2 = gf_mult(lambda2, alpha_neg_i_sq);
            // Evaluate ?(?^(-i)) = 1 + ?1*?^(-i) + ?2*(?^(-i))^2
            sum = 4'd1 ^ eval1 ^ eval2;

            error_vector[i] = (sum == 4'd0);
        end
    end

    // Check if error found
    assign error_found = (error_vector != 15'b0);  // Set error_found if any bit is set in error_vector

endmodule

