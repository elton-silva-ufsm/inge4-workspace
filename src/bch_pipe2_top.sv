`include "../src/bch_syndrome_block.sv"
`include "../src/bch_pipe2.sv"
`include "../src/bch_chien_block.sv"
`include "../src/bch_corrector.sv"
// `include "../src/bch_tables.sv"

module bch_pipe2_top (
    input logic clk,
    input logic rst,
    input logic [14:0] codeword,
    output logic [14:0] corrected_codeword,
    output logic error_flag
);
    wire [3:0] S1, S2, S3;
    wire [3:0] lambda1, lambda2;
    wire [14:0] error_vector, corrector_o;
    wire error_found;
    reg [14:0] codeword_ff, codeword_fff;
    wire [3:0] lambda1_ff, lambda2_ff;


    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            codeword_ff <= 15'b0;
        else
            codeword_ff <= codeword;
    end

    bch_syndrome_block sb (
        .codeword(codeword_ff),
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

    ff_4 u_ff2 (.clk(clk), .rst(rst), .a(lambda1), .q(lambda1_ff));
    ff_4 u_ff3 (.clk(clk), .rst(rst), .a(lambda2), .q(lambda2_ff));

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            codeword_fff <= 15'b0;
        else
            codeword_fff <= codeword_ff;
    end

    bch_chien_block cb (
        .lambda1(lambda1_ff),
        .lambda2(lambda2_ff),
        .error_vector(error_vector),
        .error_found(error_found)
    );

    bch_corrector cr (
        .corruptedWord(codeword_fff),
        .errorVector(error_vector),
        .correctedWord(corrector_o)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            corrected_codeword <= 1'b0;
        else
            corrected_codeword <= corrector_o;
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            error_flag <= 1'b0;
        else
            error_flag <= error_found;
    end

endmodule