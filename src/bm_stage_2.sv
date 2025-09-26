// `include "../src/bch_tables.sv"

module bm_stage_2 (
    input logic clk,
    input logic rst,
    input logic [3:0] S1,
    input logic [3:0] S2,
    input logic [3:0] S3,
    input logic [3:0] l1_1,

    output logic [3:0] l1_2,
    output logic [3:0] l2_2,
    output logic [3:0] S1_o
);

wire [3:0] mult1, mult2, xor1;

gf_multiplier   u_mult1 (.a(l1_1),  .b(S2),    .p(mult1));
xor_4           u_xor1  (.a(mult1),  .b(S3),    .y(xor1));

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        l1_2 <= 0;
        l2_2 <= 0;
        S1_o <= 0;
    end else begin
        l1_2 <= l1_1;
        l2_2 <= xor1;
        S1_o <= S1;
    end
end

endmodule