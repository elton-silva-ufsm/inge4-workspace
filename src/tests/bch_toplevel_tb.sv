`timescale 1ns / 1ps

`include "../src/bch_tables.sv"
`include "../src/bch/chien_block.v"
`include "../src/bch/ibm_block.v"
`include "../src/bch/syndrome_block.v"
`include "../src/decoder_ref.sv"

module bch_toplevel_tb;

    parameter INPUT_FILE   = "../src/input/o_data_bch_15_7.hex";
    parameter COMPARE_FILE = "../src/input/i_data_7.hex";
    parameter ERROR_FILE = "../src/input/errors.bin";
    parameter ERROR5_FILE = "../src/input/until_5_errors.bin";

    logic [14:0] r_x [0:127];
    logic [6:0]  d_x [0:127]; 
    logic [14:0]  e_x [0:120]; 
    logic [14:0]  e_x5 [0:4943]; 

    int e1,e2,e3,e4,e5;

    logic clk;
    logic rst;
    logic [14:0] codeword, corrupted;

    wire [14:0] corrected_codeword;
    wire [14:0] error_vector_out;
    wire [3:0]  S1_out, S2_out, S3_out, lambda1_out, lambda2_out;
    wire        error_flag;

    int Ntests,CorrectedWords,Wordswithnoerrors,Detectederrors,ProgramFails;

    bch_toplevel DUV (
        .clk(clk),
        .rst(rst),
        .codeword(codeword),
        .corrected_codeword(corrected_codeword),
        .S1_out(S1_out),
        .S2_out(S2_out),
        .S3_out(S3_out),
        .lambda1_out(lambda1_out),
        .lambda2_out(lambda2_out),
        .error_vector_out(error_vector_out),
        .error_flag(error_flag)
    );

    wire [14:0] corrected_codeword_ref;
    wire [14:0] error_vector_out_ref;
    wire [3:0]  S1_out_ref, S2_out_ref, lambda1_out_ref, lambda2_out_ref;
    wire        error_flag_ref;

    decoder_ref REF (
        .clk(clk),
        .rst(rst),
        .codeword(codeword),

        .corrected_codeword(corrected_codeword_ref),
        .S1_out(S1_out_ref),
        .S2_out(S2_out_ref),
        .S3_out(S3_out_ref),
        .lambda1_out(lambda1_out_ref),
        .lambda2_out(lambda2_out_ref),
        .error_vector_out(error_vector_out_ref),
        .error_flag(error_flag_ref)
    );


    // Clock generation
    initial begin
        clk = 0;
        forever #7 clk = ~clk; //71,428 MHz
    end

    // Main stimulus
    initial begin
        $readmemh(INPUT_FILE,   r_x);
        $readmemh(COMPARE_FILE, d_x);
        $readmemb(ERROR_FILE, e_x);
        $readmemb(ERROR5_FILE, e_x5);

        $display("╒═══════════════════════════════════════════════════════════════════════════════════════╕");
        $display("│Test n.1 - Double error correcting in every position of a encoded Word                 │");
        $display("╞═══╤═══════════════╤═══════════════╤═══════════════╤═══════════════╤═══════════════╤═╤═╡");
        $display("│i  │codeword_rx    │corrected_DUT  │corrected_REF  │err_vec_DUT    │err_vec_REF    │e│f│");
        $display("╞═══╪═══════════════╪═══════════════╪═══════════════╪═══════════════╪═══════════════╪═╪═╡");

        rst = 1;
        codeword = 0;
        Ntests = 0;
        CorrectedWords = 0; 
        Wordswithnoerrors = 0;
        Detectederrors = 0;
        ProgramFails = 0;

        e1 = 0;
        e2 = 0;
        e3 = 0;
        e4 = 0;
        e5 = 0;

        repeat (2) @(negedge clk);
        rst = 0;

        for (int i = 0; i < 120; i++) begin
            corrupted = (r_x[1] ^ e_x[i]);
            // corrupted = r_x[i]; 
            codeword =  corrupted;
            repeat (4) @(negedge clk);
            $display("│%3d│%15b│%15b│%15b│%15b│%15b│%1b│%1b│", 
                     i+1, codeword, corrected_codeword,
                     corrected_codeword_ref, error_vector_out, error_vector_out_ref, error_flag, error_flag_ref);

            Ntests = i+1;
            CorrectedWords =    ((corrected_codeword == r_x[1]) && error_flag)  ? (++CorrectedWords)    : (CorrectedWords); 
            Wordswithnoerrors = ((corrected_codeword == r_x[1]) && !error_flag) ? (++Wordswithnoerrors) : (Wordswithnoerrors);
            Detectederrors =    ((corrected_codeword != r_x[1]) && error_flag)  ? (++Detectederrors)    : (Detectederrors);
            ProgramFails =      ((corrected_codeword != r_x[1]) && !error_flag) ? (++ProgramFails)      : (ProgramFails);

            e1 += ($countones(e_x[i]) == 1);
            e2 += ($countones(e_x[i]) == 2);
            e3 += ($countones(e_x[i]) == 3);
            e4 += ($countones(e_x[i]) == 4);
            e5 += ($countones(e_x[i]) == 5);


        end

        $display("╞═══╧══════╤════════╧═══════╤═══════╧═════════════╤═╧══════════════╤╧═══════════════╧═╧═╡");
        $display("│N.o tests │Corrected Words │Words with no errors │Detected errors │Program Fails       │");
        $display("│       %3d│             %3d│                  %3d│             %3d│                 %3d│", Ntests,CorrectedWords,Wordswithnoerrors,Detectederrors,ProgramFails);
        $display("╘══════════╧════════════════╧═════════════════════╧════════════════╧════════════════════╛");

        $display("╒═══════════════════════════════════════════════════════════════════════════════════════╕");
        $display("│Test n.2 - Until 5 errors in the encoded word, exploring Hamming Distance              │");

        repeat (4) @(negedge clk);

        codeword = 0;
        Ntests = 0;
        CorrectedWords = 0; 
        Wordswithnoerrors = 0;
        Detectederrors = 0;
        ProgramFails = 0;

        e1 = 0;
        e2 = 0;
        e3 = 0;
        e4 = 0;
        e5 = 0;

        for (int i = 0; i < 4943; i++) begin
            corrupted = (r_x[1] ^ e_x5[i]);
            // corrupted = r_x[i]; 
            codeword =  corrupted;
            repeat (4) @(negedge clk);
            Ntests = i+1;
            CorrectedWords =    ((corrected_codeword == r_x[1]) && error_flag)  ? (++CorrectedWords)    : (CorrectedWords); 
            Wordswithnoerrors = ((corrected_codeword == r_x[1]) && !error_flag) ? (++Wordswithnoerrors) : (Wordswithnoerrors);
            Detectederrors =    ((corrected_codeword != r_x[1]) && error_flag)  ? (++Detectederrors)    : (Detectederrors);
            ProgramFails =      ((corrected_codeword != r_x[1]) && !error_flag) ? (++ProgramFails)      : (ProgramFails);

            e1 += ($countones(e_x5[i]) == 1);
            e2 += ($countones(e_x5[i]) == 2);
            e3 += ($countones(e_x5[i]) == 3);
            e4 += ($countones(e_x5[i]) == 4);
            e5 += ($countones(e_x5[i]) == 5);
        end

        $display("╞══════════════╤════════════════╤══════════════════╤═════════════════╤══════════════════╡");
        $display("│One Error     │Two Errors      │Three Errors      │Four Errors      │Five Errors       │");        
        $display("│%14d│%16d│%18d│%17d│%18d│",e1,e2,e3,e4,e5);
        $display("╞══════════════╧════════════════╧══════════════════╧═════════════════╧══════════════════╡");
        $display("╞══════════╤════════════════╤═════════════════════╤════════════════╤════════════════════╡");
        $display("│N.o tests │Corrected Words │Words with no errors │Detected errors │Program Fails       │");
        $display("│%10d│%16d│%21d│%16d│%20d│", Ntests,CorrectedWords,Wordswithnoerrors,Detectederrors,ProgramFails);
        $display("╘══════════╧════════════════╧═════════════════════╧════════════════╧════════════════════╛");
        $finish;
    end

endmodule
