`include "../src/bch_tables.sv"

`include "../src/bm_stage_1.sv"
`include "../src/bm_stage_2.sv"
`include "../src/bm_stage_3.sv"

module bch_bm_block_p (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] S1,
    input  wire [3:0] S2,
    input  wire [3:0] S3,
    output reg  [3:0] lambda1,
    output reg  [3:0] lambda2
);

wire [3:0] l1_1, l1_2, l2_2, S1_o, S2_o, S3_o, S1_o2;

bm_stage_1 s1 (
    .clk(clk),
    .rst(rst),
    .S1(S1),
    .S2(S2),
    .S3(S3),

    .l1_1(l1_1),
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