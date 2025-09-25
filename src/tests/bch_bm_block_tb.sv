`include "../src/bch/ibm_block.v"

module bch_bm_block_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [3:0] S1,S2,S3;

    // Outputs
    wire [3:0] lambda1, olambda1, lambda2, olambda2;

    logic flag1;

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
        .rst(!rst),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .lambda1(olambda1),
        .lambda2(olambda2)
    );

    // Clock generation
    always #5ns clk = ~clk;

    assign flag1 = ((lambda1==olambda1)&&(lambda2==olambda2)) ? 1'b1 : (1'b0);

    initial begin

        // Display output
        $display("╒══════════════╦═════════╦═════════╕");
        $display("│PARAMETERS    ║REF      ║DUT      │");
        $display("╞════╤════╤════╬════╤════╬════╤════╡");
        $display("│S1  │S2  │S3  ║l1  │l2  ║l1  │l2  │");

        // Initialize Inputs
        clk = 0;
        rst = 1;

        S1 = 4'b0;
        S2 = 4'b0;
        S3 = 4'b0;

        // Hold reset for 10 ns
        @(negedge clk);
        rst = 0;

        S1 = 4'b0011;// Syndrome de x^7+x^3
        S2 = 4'b0101;
        S3 = 4'b0110;

        @(negedge clk);
        $display("│%4b│%4b│%4b║%4b│%4b║%4b│%4b│", S1, S2, S3, lambda1, lambda2, olambda1, olambda2);

        S1 = 4'b1011;// Apply  Test vectors
        S2 = 4'b1001;
        S3 = 4'b0010;

        @(negedge clk);
        $display("│%4b│%4b│%4b║%4b│%4b║%4b│%4b│", S1, S2, S3, lambda1, lambda2, olambda1, olambda2);
        // @(negedge clk);

        S1 = 4'b1010;// Apply  Test vectors
        S2 = 4'b1001;
        S3 = 4'b0010;

        @(negedge clk);
        $display("│%4b│%4b│%4b║%4b│%4b║%4b│%4b│", S1, S2, S3, lambda1, lambda2, olambda1, olambda2);
        // @(negedge clk);
        
        S1 = 4'b1011;// Apply  Test vectors
        S2 = 4'b1011;
        S3 = 4'b0010;

        @(negedge clk);
        $display("│%4b│%4b│%4b║%4b│%4b║%4b│%4b│", S1, S2, S3, lambda1, lambda2, olambda1, olambda2);
        // @(negedge clk);
        S1 = 4'b1011;// Apply  Test vectors
        S2 = 4'b1001;
        S3 = 4'b0110;

        @(negedge clk);
        $display("│%4b│%4b│%4b║%4b│%4b║%4b│%4b│", S1, S2, S3, lambda1, lambda2, olambda1, olambda2);


        $display("╘══════════════╩═════════╩═════════╛");
        $finish();
    end

endmodule


// `include "../src/bch/ibm_block.v"

// module bch_bm_block_tb;

//     // Inputs
//     reg clk;
//     reg rst;
//     reg [3:0] S1,S2,S3;

//     // Outputs
//     wire [3:0] lambda1, olambda1, lambda2, olambda2;

//     logic flag1;

//     // Instantiate the Unit Under Test (UUT)
//     ibm_block REF (
//         .clk(clk),
//         .rst(rst),
//         .S1(S1),
//         .S2(S2),
//         .S3(S3),
//         .lambda1(lambda1),
//         .lambda2(lambda2)
//     );

//     bch_bm_block DUV (
//         .clk(clk),
//         .rst(!rst),
//         .S1(S1),
//         .S2(S2),
//         .S3(S3),
//         .lambda1(olambda1),
//         .lambda2(olambda2)
//     );

//     // Clock generation
//     always #5ns clk = ~clk;

//     assign flag1 = ((lambda1==olambda1)&&(lambda2==olambda2)) ? 1'b1 : (1'b0);

//     initial begin
//         // Initialize Inputs
//         clk = 0;
//         rst = 1;

//         S1 = 4'b0;
//         S2 = 4'b0;
//         S3 = 4'b0;

//         // Hold reset for 10 ns
//         @(negedge clk);
//         rst = 0;

//         for (int i=0; i<16; ++i) begin
//             for (int j=0; j<16; ++j) begin
//                 for (int k=0; k<16; ++k) begin
//                     S1 = i;
//                     S2 = j;
//                     S3 = k;
//                     @(negedge clk);
//                 end
//             end
            
//         end

//         $finish();
//     end

// endmodule
