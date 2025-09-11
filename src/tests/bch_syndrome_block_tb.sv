`timescale 1ns / 1ps

`include "../src/bch/syndrome_block.v"

module bch_syndrome_block_tb;

    reg clk;
    reg rst;
    reg [14:0] codeword;
    wire [3:0] S1, S2, S3, oS1, oS2, oS3;

    // Instantiate the module under test
    syndrome_block dut (
        .clk(clk),
        .rst(rst),
        .codeword(codeword),
        .S1(S1),
        .S2(S2),
        .S3(S3)
    );

    bch_syndrome_block DUV (
        .codeword(codeword),
        .S1(oS1),
        .S2(oS2),
        .S3(oS3)
    );

    // Clock generation (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        $display("Starting Test...");
        
        // Reset condition
        rst = 1;
        codeword = 15'b0;
        #10;
        
        // Test with the first codeword: 101010111100101
        rst = 0;
        codeword = 15'b101010111100101; // Original encoded word
        #20;

        // Display the result
        $display("|REF           ||DUT           |");
        $display("|S1  |S2  |S3  ||S1  |S2  |S3  |");
        $display("|%4b|%4b|%4b||%4b|%4b|%4b|", S1, S2, S3, oS1, oS2, oS3);

        // Test with the second codeword: 10110011100101
        codeword = 15'b101110011100101;
        #20;

        // Display the result
        $display("|%4b|%4b|%4b||%4b|%4b|%4b|", S1, S2, S3, oS1, oS2, oS3);

        // Test with the third codeword: 10110111100101
        codeword = 15'b10110111100101; // New codeword added
        #20;

        // Display the result
        $display("|%4b|%4b|%4b||%4b|%4b|%4b|", S1, S2, S3, oS1, oS2, oS3);

        #10;
        $finish;
    end

endmodule

