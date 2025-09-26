`include "../src/bch_syndrome_block.sv"

module sy_stage_1 (
    input logic clk,
    input logic rst,
    input  logic [14:0] codeword,
    output logic [3:0]  S1,
    output logic [3:0]  S2,
    output logic [3:0]  S3
);

wire [3:0] oS1, oS2, oS3;

bch_syndrome_block sy (
    .codeword(codeword),
    .S1(oS1),
    .S2(oS2),
    .S3(oS3)
);

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        S1 <= 0;
        S2 <= 0;
        S3 <= 0;
    end else begin
        S1 <= oS1;
        S2 <= oS2;
        S3 <= oS3;
    end
end

endmodule