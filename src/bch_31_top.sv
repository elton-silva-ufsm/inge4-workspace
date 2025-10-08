
// `include "../src/bch_31_tables.sv"
`include "../src/bch_31_modules.sv"
`include "../src/bch_31_syndrome.sv"
`include "../src/bch_31_bm_comb.sv"
`include "../src/bch_31_chien.sv"

module bch_31_top (
    input  logic [30:0] codeword,
    output logic [30:0] corrected_codeword_o,
    output logic        error_detected
);

logic [4:0] S1, S2, S3, S4;
logic [4:0] lambda1, lambda2;
logic [30:0] error_vector;


bch_31_syndrome u_syndrome (
    .codeword(codeword),
    .S1(S1),
    .S2(S2),
    .S3(S3),
    .S4(S4)
);

bch_31_bm_comb u_bm (
    .S1(S1),
    .S2(S2),
    .S3(S3),
    .S4(S4),
    .lambda1(lambda1),
    .lambda2(lambda2)
);

bch_31_chien u_chien (
    .lambda1(lambda1),
    .lambda2(lambda2),
    .error_vector(error_vector),
    .error_found(error_detected)
);

assign corrected_codeword_o = codeword ^ error_vector;

endmodule