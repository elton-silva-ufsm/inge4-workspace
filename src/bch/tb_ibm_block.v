`timescale 1ns / 1ps

module tb_ibm_block;

    // Inputs
    reg clk;
    reg rst;
    reg [3:0] S1;
    reg [3:0] S2;
    reg [3:0] S3;

    // Outputs
    wire [3:0] lambda1;
    wire [3:0] lambda2;

    // Instantiate the Unit Under Test (UUT)
    ibm_block uut (
        .clk(clk),
        .rst(rst),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .lambda1(lambda1),
        .lambda2(lambda2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        S1 = 0;
        S2 = 0;
        S3 = 0;

        // Hold reset for 10 ns
        #10;
        rst = 0;

        S1 = 1011;// Apply  Test vectors
        S2 = 1001;
         S3 = 0010;

        #100;

        // Display output
        $display("S1 = %d, S2 = %d, S3 = %d", S1, S2, S3);
        $display("Computed lambda1 = %d, lambda2 = %d", lambda1, lambda2);

        $finish;
    end

endmodule
