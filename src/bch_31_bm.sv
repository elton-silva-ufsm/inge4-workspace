// `include "../src/bch_31_tables.sv"
// `include "../src/bch_31_modules.sv"

module bch_31_bm (
    input  wire       clk,
    input  wire       rst,
    input  wire [4:0] S1,
    input  wire [4:0] S2,
    input  wire [4:0] S3,
    input  wire [4:0] S4,
    output wire [4:0] lambda1,
    output wire [4:0] lambda2
);

logic [4:0] Q1, Q2, Q3, Q4, Q5, Q6;
logic [4:0] sum1, sum2;
logic [4:0] delta;
logic [4:0] D1, D2, D3;
logic [4:0] lambda1_ff, lambda2_ff;
logic [4:0] sum1_ff, sum2_ff, delta_ff, D1_ff;

gf_multiplier u_mult1 (.a(S2), .b(S2), .p(Q1)); // Q1 = S2^2
gf_multiplier u_mult2 (.a(S1), .b(S3), .p(Q2)); // Q2 = S1*S3
gf_multiplier u_mult3 (.a(S3), .b(S2), .p(Q3)); // Q3 = S3*S2
gf_multiplier u_mult4 (.a(S1), .b(S4), .p(Q4)); // Q4 = S1*S4
gf_multiplier u_mult5 (.a(S2), .b(S4), .p(Q5)); // Q5 = S2*S4
gf_multiplier u_mult6 (.a(S3), .b(S3), .p(Q6)); // Q6 = S3^2

gf_divider u_div1 (.a(S2), .b(S1), .q(D1));     // D1 = S2 / S1

xor_5 u_xor1 (.a(Q3), .b(Q4), .y(sum1));        // X1 = S3*S2 + S1*S4
xor_5 u_xor2 (.a(Q5), .b(Q6), .y(sum2));        // X2 = S2*S4 + S3^2
xor_5 u_xor3 (.a(Q1), .b(Q2), .y(delta));       // ∆  = S2^2 + S1*S3 


ff_5 u_ff1 (.clk(clk), .rst(rst), .a(sum1),  .q(sum1_ff));  // Temporal barriers
ff_5 u_ff2 (.clk(clk), .rst(rst), .a(sum2),  .q(sum2_ff));  // to align signals
ff_5 u_ff3 (.clk(clk), .rst(rst), .a(delta), .q(delta_ff)); // for next cycle
ff_5 u_ff4 (.clk(clk), .rst(rst), .a(D1),    .q(D1_ff));    // calculations

gf_divider u_div2 (.a(sum1_ff), .b(delta_ff), .q(D2)); // D2 = num λ2 / denom
gf_divider u_div3 (.a(sum2_ff), .b(delta_ff), .q(D3)); // D3 = num λ1 / denom


ff_5 u_ff5 (.clk(clk), .rst(rst), .a(lambda1_ff), .q(lambda1)); // Final output registers
ff_5 u_ff6 (.clk(clk), .rst(rst), .a(lambda2_ff), .q(lambda2)); // to meet timing

always_comb begin
    if (delta_ff == 5'd0) begin
        lambda1_ff = D1_ff;
        lambda2_ff = 5'd0;
    end else begin
        lambda1_ff = D2;
        lambda2_ff = D3;
    end
end

endmodule