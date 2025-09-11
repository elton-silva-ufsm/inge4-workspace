// Combinacional Berlekamp-Massey
`include "../src/bch_tables.sv"

module bch_cbm_block (
    input logic [3:0] S1,
    input logic [3:0] S2,
    input logic [3:0] S3,
    output logic [3:0] lambda1,
    output logic [3:0] lambda2
);
    // Temporary variables
    logic [3:0] d1, d2;

    always_comb begin
 
        if (S1 != 4'b0000) begin
            lambda1 = gf_div(d1, S1);  // ?1 = d1 / S1
            lambda2 = gf_div(d2 ^ gf_mult(lambda1, S2), S1); // ?2 = (d2 + ?1*S2) / S1
        end else begin
            lambda1 = 4'b0000;
            lambda2 = 4'b0000;
        end
    end
    
    assign d1 = S2 ^ gf_mult(lambda1, S1);
    assign d2 = S3 ^ gf_mult(lambda1, S2) ^ gf_mult(lambda2, S1);

endmodule

