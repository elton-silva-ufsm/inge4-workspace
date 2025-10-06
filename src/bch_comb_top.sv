`include "../src/bch_syndrome_block.sv"
`include "../src/bch_pipe2.sv"
`include "../src/bch_chien_block.sv"
`include "../src/bch_corrector.sv"
// `include "../src/bch_tables.sv"

module bch_comb_top (
    input logic [14:0] codeword,
    output logic [14:0] corrected_codeword,
    output logic error_flag
);
    wire [3:0] S1, S2, S3;
    wire [3:0] lambda1, lambda2;
    wire [14:0] error_vector, corrector_o;
    wire error_found;

    bch_syndrome_block sb (
        .codeword(codeword),
        .S1(S1),
        .S2(S2),
        .S3(S3)
    );

    bch_pipe2 bm (
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .l1(lambda1),
        .l2(lambda2)
    );

    bch_chien_block cb (
        .lambda1(lambda1),
        .lambda2(lambda2),
        .error_vector(error_vector),
        .error_found(error_found)
    );

    bch_corrector cr (
        .corruptedWord(codeword),
        .errorVector(error_vector),
        .correctedWord(corrector_o)
    );

    assign corrected_codeword = corrector_o;
    assign error_flag = error_found;

endmodule