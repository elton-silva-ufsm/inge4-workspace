module bch_cbm_block_tb;

    // Inputs
    logic [3:0] S1, S2, S3;

    // Outputs
    logic [3:0] olambda1, olambda2;

    bch_cbm_block DUV (
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .lambda1(olambda1),
        .lambda2(olambda2)
    );

    initial begin
        // Apply  Test vectors
        S1 = 4'b1011;
        S2 = 4'b1001;
        S3 = 4'b0010;

        #10ns; // espera propagação

        // Display output
        $display("|PARAMETERS    ||DUT      |");
        $display("|S1  |S2  |S3  ||l1  |l2  |");
        $display("|%4b|%4b|%4b||%4b|%4b|", S1, S2, S3, olambda1, olambda2);

        #10ns;
        $finish;
    end
endmodule


