`timescale 1ns / 1ps

`include "../src/bch/chien_block.v"

module bch_chien_block_tb;

    reg [3:0] lambda1;
    reg [3:0] lambda2;
    wire [14:0] Error_vector, oError_vector;
    wire error, oerror;

    // Instantiate the chien_block_12 module
    chien_block REF (
        .lambda1(lambda1),
        .lambda2(lambda2),
        .error_vector(Error_vector),
        .error_found(error)
    );

    bch_chien_block DUV (
        .lambda1(lambda1),
        .lambda2(lambda2),
        .error_vector(oError_vector),
        .error_found(oerror)
    );

    initial begin
        $display("Starting BCH Chien Search Test...");

        // Test 1: lambda(x) = 1 + 0*x + 12*x^2
        lambda1 = 4'd0;
        lambda2 = 4'd12;
        #10;
        $display("|PARAMETER||REF              ||DUT              |");
        $display("|l1  |l2  ||error_ref      |e||error_out      |e|");
        $display("|%4b|%4b||%15b|%1b||%15b|%1b|", lambda1, lambda2, Error_vector, error, oError_vector, oerror);

        // Test 2: lambda(x) = 1 + 11*x + 3*x^2
        lambda1 = 4'd11;
        lambda2 = 4'd3;
        #10;
        $display("|%4b|%4b||%15b|%1b||%15b|%1b|", lambda1, lambda2, Error_vector, error, oError_vector, oerror);

        $finish;
    end

endmodule
