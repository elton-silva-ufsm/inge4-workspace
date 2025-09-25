`timescale 1ns / 1ps

`include "../src/bch_bm_block.sv"
`include "../src/bch_chien_block.sv"
`include "../src/bch_syndrome_block.sv"
`include "../src/bch_corrector.sv"
`include "../src/bch_tables.sv"


module bch_toplevel (
    input logic clk,
    input logic rst,
    input logic [14:0] codeword,

    output logic [14:0] corrected_codeword,
    output logic error_flag
);

    // Internal wires
    wire [3:0] S1, S2, S3;
    wire [3:0] lambda1, lambda2;
    wire [14:0] error_vector, corrector_o;
    wire error_found;

    // Submodule: syndrome_block
    bch_syndrome_block sb (
        .codeword(codeword),
        .S1(S1),
        .S2(S2),
        .S3(S3)
    );

    // Submodule: bm_block
    bch_bm_block bm (
        .clk(clk),
        .rst(rst),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .lambda1(lambda1),
        .lambda2(lambda2)
    );

    // Submodule: chien_block
    bch_chien_block cb (
        .lambda1(lambda1),
        .lambda2(lambda2),
        .error_vector(error_vector),
        .error_found(error_found)
    );

    // Submodule: corrector
    bch_corrector cr (
        .corruptedWord(codeword),
        .errorVector(error_vector),
        .correctedWord(corrector_o)
    );



    assign error_flag = error_found;
    assign corrected_codeword = corrector_o;
    // Sequential logic
    // always_ff @(posedge clk or negedge rst) begin
    //     if (!rst) begin
    //         corrected_codeword <= 15'b0;
    //         error_flag <= 0;
    //     end else begin
    //         corrected_codeword <= corrector_o;  // Correct errors
    //         error_flag <= error_found;
    //     end
    // end

endmodule
