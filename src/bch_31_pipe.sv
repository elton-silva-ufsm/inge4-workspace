`include "../src/bch_31_modules.sv"
`include "../src/bch_31_syndrome.sv"
`include "../src/bch_31_bm.sv"
`include "../src/bch_31_chien.sv"

module bch_31_pipe (
    input  logic clk,
    input  logic rst,
    input  logic [30:0] codeword,
    output logic [30:0] corrected_codeword_o,
    output logic        error_detected
);

logic [4:0] S1, S2, S3, S4;
logic [4:0] S1_ff, S2_ff, S3_ff, S4_ff;
logic [4:0] lambda1, lambda2;
logic [30:0] error_vector;
logic [30:0] codeword_ff, codeword_ff2, codeword_ff3;

bch_31_syndrome u_syndrome (
    .codeword(codeword),
    .S1(S1),
    .S2(S2),
    .S3(S3),
    .S4(S4)
);

ff_5 u_ff_s1 (.clk(clk), .rst(rst), .a(S1), .q(S1_ff));
ff_5 u_ff_s2 (.clk(clk), .rst(rst), .a(S2), .q(S2_ff));
ff_5 u_ff_s3 (.clk(clk), .rst(rst), .a(S3), .q(S3_ff));
ff_5 u_ff_s4 (.clk(clk), .rst(rst), .a(S4), .q(S4_ff));
ff_31 u_ff_cw (.clk(clk), .rst(rst), .a(codeword), .q(codeword_ff));

bch_31_bm u_bm (
    .clk(clk),
    .rst(rst),
    .S1(S1_ff),
    .S2(S2_ff),
    .S3(S3_ff),
    .S4(S4_ff),
    .lambda1(lambda1),
    .lambda2(lambda2)
);

ff_31 u_ff_cw2 (.clk(clk), .rst(rst), .a(codeword_ff), .q(codeword_ff2));
ff_31 u_ff_cw3 (.clk(clk), .rst(rst), .a(codeword_ff2), .q(codeword_ff3));

bch_31_chien u_chien (
    .lambda1(lambda1),
    .lambda2(lambda2),
    .error_vector(error_vector),
    .error_found(error_detected)
);

bch_31_corrector u_corrector (
    .corruptedWord(codeword_ff3),
    .errorVector(error_vector),
    .correctedWord(corrected_codeword_o)
);

endmodule