`timescale 1ns / 1ps

`include "../src/bch/syndrome_block.v"

// Resposta obtida:
// xcelium> run
// Starting Test...
// ╒══════════════╦══════════════╕
// │REF           ║DUT           │
// ╞══════════════╬══════════════╡
// │S1  │S2  │S3  ║S1  │S2  │S3  │
// │0000│0000│0000║0000│0000│0000│
// │0011│0101│0110║0011│0101│0110│
// │1011│1001│1100║1011│1001│1100│
// │1011│1001│0010║1011│1001│0010│
// │0101│0010│0001║0101│0010│0001│
// │0000│0000│0000║0000│0000│0000│
// ╘══════════════╩══════════════╛

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

        // Display the result
        $display("╒══════════════╦══════════════╕");
        $display("│REF           ║DUT           │");
        $display("╞══════════════╬══════════════╡");
        $display("│S1  │S2  │S3  ║S1  │S2  │S3  │");
        
        // Reset condition
        rst = 1;
        codeword = 15'b0;
        #10;
        
        // Test with the first codeword: 101010111100101
        rst = 0;
        codeword = 15'b000000000000000; // Original encoded word
        #20;

        $display("│%4b│%4b│%4b║%4b│%4b│%4b│", S1, S2, S3, oS1, oS2, oS3);

        // Test with the second codeword: 10110011100101
        codeword = 15'b000000010001000;
        #20;

        // Display the result
        $display("│%4b│%4b│%4b║%4b│%4b│%4b│", S1, S2, S3, oS1, oS2, oS3);

        // Test with the second codeword: 10110011100101
        codeword = 15'b000000010000000;
        #20;

        // Display the result
        $display("│%4b│%4b│%4b║%4b│%4b│%4b│", S1, S2, S3, oS1, oS2, oS3);

        // Test with the second codeword: 10110011100101
        codeword = 15'b101110011100101;
        #20;

        // Display the result
        $display("│%4b│%4b│%4b║%4b│%4b│%4b│", S1, S2, S3, oS1, oS2, oS3);

        // Test with the third codeword: 10110111100101
        codeword = 15'b10110111100101; // New codeword added
        #20;

        // Display the result
        $display("│%4b│%4b│%4b║%4b│%4b│%4b│", S1, S2, S3, oS1, oS2, oS3);

        codeword = 15'b101010111100101;

        #10;
        $display("│%4b│%4b│%4b║%4b│%4b│%4b│", S1, S2, S3, oS1, oS2, oS3);


        $display("╘══════════════╩══════════════╛");
        $finish;
    end

endmodule

