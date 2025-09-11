`include "../src/bch/ibm_block.v"

module bch_bm_block_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [3:0] S1,S2,S3;

    // Outputs
    wire [3:0] lambda1, olambda1, lambda2, olambda2;

    // Instantiate the Unit Under Test (UUT)
    ibm_block REF (
        .clk(clk),
        .rst(rst),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .lambda1(lambda1),
        .lambda2(lambda2)
    );

    bch_bm_block DUV (
        .clk(clk),
        .rst(rst),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .lambda1(olambda1),
        .lambda2(olambda2)
    );

    // Clock generation
    always #5ns clk = ~clk;

    initial begin


        // Display output
        $display("|PARAMETERS    ||REF      ||DUT      |");
        $display("|S1  |S2  |S3  ||l1  |l2  ||l1  |l2  |");

        // Initialize Inputs
        clk = 0;
        rst = 1;

        S1 = 0;
        S2 = 0;
        S3 = 0;

        // Hold reset for 10 ns
        repeat(2) @(negedge clk);
        rst = 0;

        S1 = 1011;// Apply  Test vectors
        S2 = 1001;
        S3 = 0010;

        repeat(5) @(negedge clk);
        $display("|%4b|%4b|%4b||%4b|%4b||%4b|%4b|", S1, S2, S3, lambda1, lambda2, olambda1, olambda2);

        S1 = 1010;// Apply  Test vectors
        S2 = 1001;
        S3 = 0010;

        repeat(5) @(negedge clk);
        $display("|%4b|%4b|%4b||%4b|%4b||%4b|%4b|", S1, S2, S3, lambda1, lambda2, olambda1, olambda2);
        
        S1 = 1011;// Apply  Test vectors
        S2 = 1011;
        S3 = 0010;

        repeat(5) @(negedge clk);
        $display("|%4b|%4b|%4b||%4b|%4b||%4b|%4b|", S1, S2, S3, lambda1, lambda2, olambda1, olambda2);
        S1 = 1011;// Apply  Test vectors
        S2 = 1001;
        S3 = 0110;

        repeat(5) @(negedge clk);
        $display("|%4b|%4b|%4b||%4b|%4b||%4b|%4b|", S1, S2, S3, lambda1, lambda2, olambda1, olambda2);

        $finish();
    end

endmodule
