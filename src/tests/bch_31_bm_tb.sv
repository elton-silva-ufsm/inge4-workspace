`include "../src/bch_31_tables.sv"
`include "../src/bch_31_modules.sv"

module bch_31_bm_tb;

    logic clk;
    logic rst;
    logic [4:0] S1;
    logic [4:0] S2;
    logic [4:0] S3;
    logic [4:0] S4;
    wire [4:0] lambda1;
    wire [4:0] lambda2;

    bch_31_bm DUV (
        .clk(clk),
        .rst(rst),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .S4(S4),
        .lambda1(lambda1),
        .lambda2(lambda2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 0;
        S1 = 4'd0;
        S2 = 4'd0;
        S3 = 4'd0;
        S4 = 4'd0;

        @(negedge clk);
        rst = 1;

        @(negedge clk);
        S1 = 4'd5; S2 = 4'd7; S3 = 4'd3; S4 = 4'd2;

        @(negedge clk);
        S1 = 4'd0; S2 = 4'd0; S3 = 4'd0; S4 = 4'd0;
        
        @(negedge clk);
        S1 = 4'd2; S2 = 4'd4; S3 = 4'd6; S4 = 4'd8;
        
        @(negedge clk);
        S1 = 4'd1; S2 = 4'd8; S3 = 4'd9; S4 = 4'd3;

        repeat (10) @(negedge clk);
        $finish;
    end

    initial begin
        $display("╒═════╤═════╤═════╤═════╤═════╤═════╕");
        $display("│S1   │S2   │S3   │S4   │l1   │l2   │");
        $monitor("│%5b│%5b│%5b│%5b│%5b│%5b│", S1, S2, S3, S4, lambda1, lambda2);
    end

    endmodule