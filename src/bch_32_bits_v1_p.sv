`include "../src/bch_31_pipe.sv"

// Organização da entrada:
// Bloco 1: bits [25:0] 
//          16 bits dados(25:10)
//          10 bits paridade (9:0)
// Bloco 2: bits [51:26]
//          16 bits dados(51:36)
//          10 bits paridade (35:26)
// Saída: 32 bits dados (16 bits de cada bloco)

module bch_32_bits_v1_p (
    input logic clk,
    input logic rst,
    input  logic [51:0] data_in,  
    output logic [31:0] word_out,
    output logic        error_detected
);

    logic error_detected_1, error_detected_2;
    logic [25:0] out_1, out_2;

    bch_31_pipe u_bch1 (
        .clk(clk),
        .rst(rst),
        .codeword(data_in[25:0]),
        .corrected_codeword_o(out_1),
        .error_detected(error_detected_1)
    );
    bch_31_pipe u_bch2 (
        .clk(clk),
        .rst(rst),
        .codeword(data_in[51:26]),
        .corrected_codeword_o(out_2),
        .error_detected(error_detected_2)
    );

    assign error_detected = error_detected_1 | error_detected_2;
    assign word_out = {out_2[25:10], out_1[25:10]}; 

endmodule