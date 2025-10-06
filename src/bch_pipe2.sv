// `include "../src/bch_tables.sv"

module bch_pipe2 (
    input logic [3:0] S1,
    input logic [3:0] S2,
    input logic [3:0] S3,

    output logic [3:0] l1,
    output logic [3:0] l2
);

logic [3:0] D1, D2;
logic [3:0] X1;
logic [3:0] sum;

logic [3:0] D1_1, D2_1;


gf_divider  u_div1 (.a(S2),  .b(S1), .q(D1)); // D1 = S2 / S1
gf_divider  u_div2 (.a(S3),  .b(S1), .q(D2)); // D2 = S3 / S1

gf_multiplier u_mult1 (.a(D1),.b(D1), .p(X1)); // X1 = (S2/S1)^2

xor_4 u_xor1 (.a(X1), .b(D2), .y(sum)); // sum = (S2/S1)^2 + (S3/S1)

assign l1 = D1;
assign l2 = sum;

endmodule