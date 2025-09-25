`include "../src/bch_tables.sv"

module bch_bm_block_p (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] S1,
    input  wire [3:0] S2,
    input  wire [3:0] S3,
    output reg  [3:0] lambda1,
    output reg  [3:0] lambda2
);

wire [3:0] l1_1, l2_1, l1_2, l2_2, S1_o, S2_o, S3_o, S1_o2;

bm_stage_1 s1 (
    .clk(clk),
    .rst(rst),
    .S1(S1),
    .S2(S2),
    .S3(S3),

    .l1_1(l1_1),
    .l2_1(l2_1),
    .S1_o(S1_o),
    .S2_o(S2_o),
    .S3_o(S3_o)
);

bm_stage_2 s2 (
    .clk(clk),
    .rst(rst),
    .S1(S1_o),
    .S2(S2_o),
    .S3(S3_o),
    .l1_1(l1_1),
    .l2_1(l2_1),
    .l1_2(l1_2),
    .l2_2(l2_2),
    .S1_o(S1_o2)
);

bm_stage_3 s3 (
    .clk(clk),
    .rst(rst),
    .S1(S1_o2),
    .l1_2(l1_2),
    .l2_2(l2_2),
    .l1(lambda1),
    .l2(lambda2)
);

endmodule

module bm_stage_1 (
    input logic clk,
    input logic rst,
    input logic [3:0] S1,
    input logic [3:0] S2,
    input logic [3:0] S3,

    output logic [3:0] l1_1,
    output logic [3:0] l2_1,
    output logic [3:0] S1_o,
    output logic [3:0] S2_o,
    output logic [3:0] S3_o
);

logic [3:0] xor1, div1, div2;

xor_4       u_xor1 (.a(S2),  .b(S3), .y(xor1));
gf_divider  u_div1 (.a(S2),  .b(S1), .q(div1));
gf_divider  u_div2 (.a(xor1), .b(S1), .q(div2));

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        l1_1 <= 0;
        l2_1 <= 0;
        S1_o <= 0;
        S2_o <= 0;
        S3_o <= 0;
    end else begin
        l1_1 <= div1;
        l2_1 <= div2;
        S1_o <= S1;
        S2_o <= S2;
        S3_o <= S3;
    end
end

endmodule

module bm_stage_2 (
    input logic clk,
    input logic rst,
    input logic [3:0] S1,
    input logic [3:0] S2,
    input logic [3:0] S3,
    input logic [3:0] l1_1,
    input logic [3:0] l2_1,

    output logic [3:0] l1_2,
    output logic [3:0] l2_2,
    output logic [3:0] S1_o
);

wire [3:0] mult1, mult2, xor1, xor2;

gf_multiplier   u_mult1 (.a(l1_1),  .b(S2),    .p(mult1));
gf_multiplier   u_mult2 (.a(l2_1),  .b(S1),    .p(mult2));
xor_4           u_xor1  (.a(mult1), .b(mult2), .y(xor1));
xor_4           u_xor2  (.a(xor1),  .b(S3),    .y(xor2));

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        l1_2 <= 0;
        l2_2 <= 0;
        S1_o <= 0;
    end else begin
        l1_2 <= l1_1;
        l2_2 <= xor2;
        S1_o <= S1;
    end
end

endmodule

module bm_stage_3 (
    input logic clk,
    input logic rst,
    input logic [3:0] S1,
    input logic [3:0] l1_2,
    input logic [3:0] l2_2,

    output logic [3:0] l1,
    output logic [3:0] l2
);

wire [3:0] div1;

gf_divider    u_div1  (.a(l2_2), .b(S1), .q(div1));

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        l1 <= 0;
        l2 <= 0;
    end else begin
        l1 <= l1_2;
        l2 <= div1;
    end
end

endmodule