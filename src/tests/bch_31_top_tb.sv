`timescale 1ns / 1ps

// `include "../src/bch/chien_block.v"
// `include "../src/bch_tables.sv"
`include "../src/bch_31_encoder.sv"

module bch_31_top_tb;

    reg [20:0] msg;
    wire [30:0] codeword;
    logic [30:0] corrupt;
    wire [30:0] corrected_codeword_o;
    wire error_detected;

    bch_31_encoder u_encoder (
    .msg(msg),
    .codeword(codeword)
    );

    bch_31_top DUV (
        .codeword(codeword ^ corrupt),
        .corrected_codeword_o(corrected_codeword_o),
        .error_detected(error_detected)
    );

    initial begin
        msg = 21'b000000000000000000000;
        corrupt = 31'd0;
        #10;

        $display("╒═════════════════════╤═══════════════════════════════╤═══════════════════════════════╤═══════════════════════════════╤═╕");
        $display("│msg                  │codeword                       │error vector                   │corrected                      │e│");
        $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt, corrected_codeword_o, error_detected);

        msg = 21'b101010101010101010101;
        corrupt = 31'd1;
        #10;
        $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt, corrected_codeword_o, error_detected);

        msg = 21'b111111111111111111111;
        corrupt = 31'd6;
        #10;
        $display("│%21b│%31b│%31b│%31b│%1b│", msg, codeword, corrupt, corrected_codeword_o, error_detected);

                
        $display("╘═════════════════════╧═══════════════════════════════╧═══════════════════════════════╧═══════════════════════════════╧═╛");
        $finish;
    end

endmodule
