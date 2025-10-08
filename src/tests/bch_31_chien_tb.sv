`timescale 1ns / 1ps

// `include "../src/bch/chien_block.v"
// `include "../src/bch_tables.sv"

module bch_31_chien_tb;

    reg [4:0] lambda1;
    reg [4:0] lambda2;
    wire [30:0] oError_vector;
    wire oerror;

    bch_31_chien DUV (
        .lambda1(lambda1),
        .lambda2(lambda2),
        .error_vector(oError_vector),
        .error_found(oerror)
    );

    initial begin
        // Test 1: lambda(x) = 1 + 0*x + 12*x^2
        lambda1 = 5'd0;
        lambda2 = 5'd12;
        #10;

        $display("╒═══════════╤╤═════════════════════════════════╕");
        $display("│PARAMETER  ││DUT                              │");
        $display("│l1   │l2   ││error_out                      │e│");
        $display("│%5b│%5b││%31b│%1b│", lambda1, lambda2, oError_vector, oerror);

        // Test 2: lambda(x) = 1 + 11*x + 3*x^2
        lambda1 = 5'd11;
        lambda2 = 5'd3;
        #10;
        $display("│%5b│%5b││%31b│%1b│", lambda1, lambda2, oError_vector, oerror);


        lambda1 = 5'd25;
        lambda2 = 5'd31;
        #10;
        $display("│%5b│%5b││%31b│%1b│", lambda1, lambda2, oError_vector, oerror);
                  
        $display("╘═══════════╧╧═════════════════════════════════╛");
        $finish;
    end

endmodule
