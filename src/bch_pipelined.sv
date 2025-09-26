`timescale 1ns / 1ps

`include "../src/bch_tables.sv"

`include "../src/sy_stage_1.sv"

`include "../src/bm_stage_1.sv"
`include "../src/bm_stage_2.sv"
`include "../src/bm_stage_3.sv"

`include "../src/cb_stage_1.sv"

`include "../src/fifo.sv"

`include "../src/bch_corrector.sv"

module bch_pipelined (
    input logic clk,
    input logic rst,
    input logic [14:0] codeword,

    output logic [14:0] corrected_codeword,
    output logic error_flag
);

reg error_flag_reg;

wire [3:0] S1, S2, S3;  
wire [3:0] l1_1, l1_2, l2_2, S1_o, S2_o, S3_o, S1_o2;
wire [3:0] lambda1, lambda2;
wire [14:0] error_vector;
wire [14:0] corruptedWord;

    fifo fi(
        .clk(clk),
        .rst(rst),
        .d_in(codeword),
        .d_out(corruptedWord)
    );

    sy_stage_1 sb (
        .clk(clk),
        .rst(rst),
        .codeword(codeword),
        .S1(S1),
        .S2(S2),
        .S3(S3)
    );

    // Submodule: bm_block
    bm_stage_1 b1 (
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

    bm_stage_2 b2 (
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

    bm_stage_3 b3 (
        .clk(clk),
        .rst(rst),
        .S1(S1_o2),
        .l1_2(l1_2),
        .l2_2(l2_2),
        .l1(lambda1),
        .l2(lambda2)
    );

    // Submodule: chien_block
    cb_stage_1 cb (
        .clk(clk),
        .rst(rst),
        .lambda1(lambda1),
        .lambda2(lambda2),
        .error_vector(error_vector),
        .error_found(error_flag_reg)
    );

    // Submodule: corrector
    bch_corrector cr (
        .corruptedWord(corruptedWord),
        .errorVector(error_vector),
        .correctedWord(corrected_codeword)
    );


    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            error_flag     <= 0;
        end else begin
            error_flag     <= error_flag_reg;
        end
    end

endmodule
