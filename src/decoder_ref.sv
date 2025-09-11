module decoder_ref (
    input logic clk,
    input logic rst,
    input logic [14:0] codeword,

    output logic [14:0] corrected_codeword,
    output logic [3:0] S1_out,
    output logic [3:0] S2_out,
    output logic [3:0] S3_out,
    output logic [3:0] lambda1_out,
    output logic [3:0] lambda2_out,
    output logic [14:0] error_vector_out,
    output logic error_flag
);

    // Internal wires
    wire [3:0] S1, S2, S3;
    wire [3:0] lambda1, lambda2;
    wire [14:0] error_vector;
    wire error_found;

    // Submodule: syndrome_block
    syndrome_block sb (
        .codeword(codeword),
        .S1(S1),
        .S2(S2),
        .S3(S3)
    );

    // Submodule: bm_block
    ibm_block bm (
        .clk(clk),
        .rst(rst),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .lambda1(lambda1),
        .lambda2(lambda2)
    );

    // Submodule: chien_block
    chien_block cb (
        .lambda1(lambda1),
        .lambda2(lambda2),
        .error_vector(error_vector),
        .error_found(error_found)
    );

    // Sequential logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            corrected_codeword <= 15'b0;
            S1_out <= 4'b0;
            S2_out <= 4'b0;
            S3_out <= 4'b0;
            lambda1_out <= 4'b0;
            lambda2_out <= 4'b0;
            error_vector_out <= 15'b0;
            error_flag <= 0;
        end else begin
            corrected_codeword <= codeword ^ error_vector;  // Correct errors

            S1_out <= S1;
            S2_out <= S2;
            S3_out <= S3;

            lambda1_out <= lambda1;
            lambda2_out <= lambda2;

            error_vector_out <= error_vector;
            error_flag <= error_found;
        end
    end

endmodule
