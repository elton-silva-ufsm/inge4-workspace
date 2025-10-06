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
logic [4:0] D1, D2;


logic [4:0] sum1_1, sum2_1;
logic [4:0] delta_1;
logic [4:0] D1_1, D2_1;

// Stage 1
gf_multiplier u_mult1 (.a(S2),.b(S2), .p(Q1));
gf_multiplier u_mult2 (.a(S1),.b(S3), .p(Q2));
gf_multiplier u_mult3 (.a(S3),.b(S2), .p(Q3));
gf_multiplier u_mult4 (.a(S1),.b(S4), .p(Q4));
gf_multiplier u_mult5 (.a(S2),.b(S4), .p(Q5));
gf_multiplier u_mult6 (.a(S3),.b(S3), .p(Q6));

xor_5 u_xor1 (.a(Q3), .b(Q4), .y(sum1));
xor_5 u_xor2 (.a(Q5), .b(Q6), .y(sum2));
xor_5 u_xor3 (.a(Q1), .b(Q2), .y(delta));

ff_5 u_ff1 (.clk(clk), .rst(rst), .a(sum1), .q(sum1_1));
ff_5 u_ff2 (.clk(clk), .rst(rst), .a(sum2), .q(sum2_1));
ff_5 u_ff3 (.clk(clk), .rst(rst), .a(delta), .q(delta_1));

// Stage 2
gf_divider u_div1 (.a(sum1_1), .b(delta_1), .q(D1));
gf_divider u_div2 (.a(sum2_1), .b(delta_1), .q(D2));

ff_5 u_ff4 (.clk(clk), .rst(rst), .a(D1), .q(D1_1));
ff_5 u_ff5 (.clk(clk), .rst(rst), .a(D2), .q(D2_1));

// Stage 3
assign lambda1 = D1_1;
assign lambda2 = D2_1;

endmodule