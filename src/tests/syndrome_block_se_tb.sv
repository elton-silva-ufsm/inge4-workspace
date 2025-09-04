module syndrome_block_se_tb;

logic [14:0] CW;
logic [7:0] SY;

syndrome_block_se sb (.i_CodeWord(CW),.o_Syndrome(SY));

initial begin
    CW = 15'b101100100011110;
    #5ns;
    $display("REF | CW              |  SY ");
    $display("000 | %15b | %8b",CW,SY);
    for (int i=0; i<15; ++i) begin
        CW = (15'b101100100011110 ^ (1 << i));
        #5ns;
        $display("%2d  | %15b | %8b",i+1,CW,SY);
    end
    $display("    |    BIT FLIP 0   |");
    for (int i=0; i<15; ++i) begin
        CW = (15'b101100100011111 ^ (1 << i));
        #5ns;
        $display("%2d  | %15b | %8b",i+1,CW,SY);
    end
    $display("    |    BIT FLIP 1   |");
    for (int i=0; i<15; ++i) begin
        CW = (15'b101100100011100 ^ (1 << i));
        #5ns;
        $display("%2d  | %15b | %8b",i+1,CW,SY);
    end
    $display("    |    BIT FLIP 2   |");
    for (int i=0; i<15; ++i) begin
        CW = (15'b101100100011010 ^ (1 << i));
        #5ns;
        $display("%2d  | %15b | %8b",i+1,CW,SY);
    end
    $finish();
end

endmodule