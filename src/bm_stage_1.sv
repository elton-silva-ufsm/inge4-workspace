// `include "../src/bch_tables.sv"

module bm_stage_1 (
    input logic clk,
    input logic rst,
    input logic [3:0] S1,
    input logic [3:0] S2,
    input logic [3:0] S3,

    output logic [3:0] l1_1,
    output logic [3:0] S1_o,
    output logic [3:0] S2_o,
    output logic [3:0] S3_o
);

logic [3:0] div1;

gf_divider  u_div1 (.a(S2),  .b(S1), .q(div1));

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        l1_1 <= 0;
        S1_o <= 0;
        S2_o <= 0;
        S3_o <= 0;
    end else begin
        l1_1 <= div1;
        S1_o <= S1;
        S2_o <= S2;
        S3_o <= S3;
    end
end

endmodule