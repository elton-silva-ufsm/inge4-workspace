`timescale 1ns / 1ps
module bch_top (
    input wire clk,
    input wire rst,
    input wire [6:0] message,  
    input wire [14:0] injected_error_vector,

    output reg [14:0] encoded_codeword,
    output reg [14:0] corrupted_codeword,
    output reg [14:0] corrected_codeword,
    output reg [3:0] S1_out,
    output reg [3:0] S2_out,
    output reg [3:0] S3_out,
    output reg [3:0] lambda1_out,
    output reg [3:0] lambda2_out,
    output reg [14:0] error_vector_out,
    output reg done,
    output reg error_flag
);

    // Internal wires
    wire [14:0] codeword;  // Encoded codeword from encoder
    wire [3:0] S1, S2, S3;
    wire [3:0] lambda1, lambda2;
    wire [14:0] error_vector;
    wire error_found;

    // Instantiate the encoder_15_7 module
    encoder_15_7 encoder_inst (
        .clk(clk),
        .reset(rst),
        .msg(message),
        .codeword(codeword)  // Get encoded codeword
    );

    // Submodule: syndrome_block
    syndrome_block uut1 (
        .clk(clk),
        .rst(rst),
        .codeword(corrupted_codeword),
        .S1(S1),
        .S2(S2),
        .S3(S3)
    );

    // Submodule: ibm_block
    ibm_block uut2 (
        .clk(clk),
        .rst(rst),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .lambda1(lambda1),
        .lambda2(lambda2)
    );

    // Submodule: chien_block
    chien_block uut3 (
        .clk(clk),
        .rst(rst),
        .lambda1(lambda1),
        .lambda2(lambda2),
        .error_vector(error_vector),
        .error_found(error_found)
    );

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            encoded_codeword <= 15'b0;
            corrupted_codeword <= 15'b0;
            corrected_codeword <= 15'b0;
            S1_out <= 4'b0;
            S2_out <= 4'b0;
            S3_out <= 4'b0;
            lambda1_out <= 4'b0;
            lambda2_out <= 4'b0;
            error_vector_out <= 15'b0;
            error_flag <= 0;
            done <= 0;
        end else begin
            encoded_codeword <= codeword;  // Encoded codeword from encoder
            corrupted_codeword <= codeword ^ injected_error_vector;  // Inject error
            corrected_codeword <= corrupted_codeword ^ error_vector;  // Correct errors

            S1_out <= S1;
            S2_out <= S2;
            S3_out <= S3;

            lambda1_out <= lambda1;
            lambda2_out <= lambda2;

            error_vector_out <= error_vector;
            error_flag <= error_found;

            done <= 1;
        end
    end

endmodule
