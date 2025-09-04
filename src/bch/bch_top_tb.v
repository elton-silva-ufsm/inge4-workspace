`timescale 1ns / 1ps

module bch_top_tb;

    reg clk;
    reg rst;
    reg [6:0] message;
    reg [14:0] injected_error_vector;

    wire [14:0] encoded_codeword;
    wire [14:0] corrupted_codeword;
    wire [14:0] error_vector_out;
    wire [14:0] corrected_codeword;
    wire [3:0] S1_out, S2_out, lambda1_out, lambda2_out;
    wire done;
    wire error_flag;

    // Instantiate the top-level BCH module
    bch_top uut (
        .clk(clk),
        .rst(rst),
        .message(message),
        .injected_error_vector(injected_error_vector),
        .encoded_codeword(encoded_codeword),
        .corrupted_codeword(corrupted_codeword),
        .error_vector_out(error_vector_out),
        .corrected_codeword(corrected_codeword),
        .S1_out(S1_out),
        .S2_out(S2_out),
        .lambda1_out(lambda1_out),
        .lambda2_out(lambda2_out),
        .done(done),
        .error_flag(error_flag)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Main stimulus
    initial begin
        rst = 1;
        message = 7'b0000000;
        injected_error_vector = 15'b0;
        #20;

        rst = 0;
        message = 7'b1010101;
        injected_error_vector = 15'b000100100000000;  // Error at bits 3 and 6

        #100; // Wait for logic to process

        // Print results
        $display("Encoded Codeword     : %b", encoded_codeword);
        $display("Corrupted Codeword   : %b", corrupted_codeword);
        $display("Injected Error Vector: %b", injected_error_vector);
        $display("Error Vector Out     : %b", error_vector_out);  // Corrected line
        $display("Corrected Codeword   : %b", corrected_codeword);
        $display("S1_out: %b, S2_out: %b", S1_out, S2_out);
        $display("Lambda1: %b, Lambda2: %b", lambda1_out, lambda2_out);
        $display("Error Flag: %b, Done: %b", error_flag, done);

        $stop;
    end

endmodule
