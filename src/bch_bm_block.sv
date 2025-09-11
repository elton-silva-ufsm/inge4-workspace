// Berlekamp-Massey

module bch_bm_block (
    input wire clk,
    input wire rst,
    input wire [3:0] S1,
    input wire [3:0] S2,
    input wire [3:0] S3,
    output reg [3:0] lambda1,
    output reg [3:0] lambda2
);

`include "../src/bch_tables.sv"


    // Temporary variables
    reg [3:0] D1, D2;
    reg [3:0] lambda1_next, lambda2_next;

    always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        lambda1 <= 4'd0;
        lambda2 <= 4'd0;
    end else begin
        // Compute D1 = S2 + lambda1 * S1
        D1 = S2 ^ gf_mult(lambda1, S1);

        // Compute D2 = S3 + lambda1 * S2 + lambda2 * S1
        D2 = S3 ^ gf_mult(lambda1, S2) ^ gf_mult(lambda2, S1);

        // Update lambda1 and lambda2 using corrected BM logic
        if (S1 != 0) begin
            lambda1_next = gf_div(D1, S1);  // ?1 = D1 / S1
            lambda2_next = gf_div(D2 ^ gf_mult(lambda1_next, S2), S1); // ?2 = (D2 + ?1*S2) / S1
        end else begin
            lambda1_next = 4'd0;
            lambda2_next = 4'd0;
        end

        lambda1 <= lambda1_next;
        lambda2 <= lambda2_next;
    end
end


endmodule
