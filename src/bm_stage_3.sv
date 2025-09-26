// `include "../src/bch_tables.sv"

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