`timescale 1ns / 1ps

module errorcorr_block (
    input wire clk,
    input wire rst,
    input wire [14:0] corrupted_codeword,
    input wire [14:0] injected_error_vector,
    output wire [14:0] corrected_codeword
);
assign corrected_codeword = corrupted_codeword ^ injected_error_vector;
endmodule
