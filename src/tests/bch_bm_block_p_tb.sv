module bch_bm_block_p_tb;


logic clk, rst;

logic [3:0] S1, S2, S3;

logic [3:0] lambda1, lambda2;

bch_bm_block_p bm (
    .clk(clk),
    .rst(rst),
    .S1(S1),
    .S2(S2),
    .S3(S3),
    .lambda1(lambda1),
    .lambda2(lambda2)
);

always #20ns clk = ~clk;

initial begin
    clk = 0;
    rst = 0;
    
    S1 = 4'b0;
    S2 = 4'b0;
    S3 = 4'b0;

    @(posedge clk);
    rst = 1;

    @(posedge clk);
    S1 = 4'b0011;
    S2 = 4'b0101;
    S3 = 4'b0110;

    repeat(4) @(posedge clk);
    $display("%1d %1d", lambda1,lambda2);
    
    $finish;
end


endmodule