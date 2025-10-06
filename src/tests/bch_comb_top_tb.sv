`timescale 1ns / 1ps

// `include "../src/bch_tables.sv"
`include "../src/bch/chien_block.v"
`include "../src/bch/ibm_block.v"
`include "../src/bch/syndrome_block.v"
`include "../src/decoder_ref.sv"

module bch_comb_top_tb;

    parameter INPUT_FILE   = "../src/input/o_data_bch_15_7.hex";
    parameter COMPARE_FILE = "../src/input/i_data_7.hex";
    parameter ERROR_FILE = "../src/input/errors.bin";
    parameter ERROR5_FILE = "../src/input/until_5_errors.bin";

    logic [14:0] r_x [0:127];
    logic [6:0]  d_x [0:127]; 
    logic [14:0]  e_x [0:120]; 
    logic [14:0]  e_x5 [0:4943]; 

    logic clk;
    logic [14:0] codeword, corrupted;

    wire [14:0] corrected_codeword;
    wire        error_flag;

    logic acerto_flag;

    bch_comb_top DUV (
        .codeword(codeword),
        .corrected_codeword(corrected_codeword),
        .error_flag(error_flag)
    );

    assign acerto_flag = (corrected_codeword == r_x[1]) ? 1'b1 : 1'b0;

    initial begin
        clk = 0;
        forever #15 clk = ~clk; //71,428 MHz
    end

    initial begin
        $readmemh(INPUT_FILE,   r_x);
        $readmemh(COMPARE_FILE, d_x);
        $readmemb(ERROR_FILE, e_x);
        $readmemb(ERROR5_FILE, e_x5);

        codeword = 0;
        @(negedge clk);

        for (int i = 0; i < 120; i++) begin
            corrupted = (r_x[1] ^ e_x[i]);
            codeword =  corrupted;
            @(negedge clk);
        end

        @(negedge clk);
        $finish;
    end

endmodule
