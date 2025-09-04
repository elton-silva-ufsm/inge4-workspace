`timescale 1ns / 1ps
module corrupted_codeword_gen (
    input [14:0] codeword,
    input wire [14:0] injected_error_vector,
    output [14:0] corrupted_codeword
);
    assign corrupted_codeword = codeword ^ injected_error_vector;
endmodule
