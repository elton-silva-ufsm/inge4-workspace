// `include "../src/bch_31_tables.sv"

module bch_31_bm_comb (
    input  logic [4:0] S1,
    input  logic [4:0] S2,
    input  logic [4:0] S3,
    input  logic [4:0] S4,
    output logic [4:0] lambda1,
    output logic [4:0] lambda2
);

logic [4:0] Q1, Q2, Q3, Q4, Q5, Q6;
logic [4:0] sum1, sum2;
logic [4:0] delta;
logic [4:0] D1, D2, D3;

gf_multiplier u_mult1 (.a(S2), .b(S2), .p(Q1)); // S2^2
gf_multiplier u_mult2 (.a(S1), .b(S3), .p(Q2)); // S1*S3
gf_multiplier u_mult3 (.a(S3), .b(S2), .p(Q3)); // S3*S2
gf_multiplier u_mult4 (.a(S1), .b(S4), .p(Q4)); // S1*S4
gf_multiplier u_mult5 (.a(S2), .b(S4), .p(Q5)); // S2*S4
gf_multiplier u_mult6 (.a(S3), .b(S3), .p(Q6)); // S3^2

gf_divider u_div1 (.a(S2), .b(S1), .q(D1)); // D1 = S2 / S1
gf_divider u_div2 (.a(sum1), .b(delta), .q(D2)); // D2 = num λ2 / denom
gf_divider u_div3 (.a(sum2), .b(delta), .q(D3)); // D3 = num λ1 / denom

xor_5 u_xor1 (.a(Q3), .b(Q4), .y(sum1)); // num λ1 = S3*S2 + S1*S4
xor_5 u_xor2 (.a(Q5), .b(Q6), .y(sum2)); // num λ2 = S2*S4 + S3^2
xor_5 u_xor3 (.a(Q1), .b(Q2), .y(delta)); // denom = S2^2 + S1*S3

always_comb begin
    if (delta == 5'd0) begin
        lambda1 = D1;
        lambda2 = 5'd0;
        // D1 = gf_div(S2, S1);
        // D2 = 5'd0;
    end else begin
        lambda1 = D2;
        lambda2 = D3;
        // D1 = gf_div(sum1, delta);
        // D2 = gf_div(sum2, delta);
    end
end

// assign lambda1 = D1;
// assign lambda2 = D2;

endmodule
