module h_decoder_11_7_tb;

logic [11:0] CW;
logic [6:0]  DW;
logic [4:0]  SY;
logic    ED, EC;

parameter testWord = 12'b000000000000;

h_decoder_11_7  DUV (.i_CodeWord(CW),.o_Syndrome(SY),.o_DecodWord(DW), .o_ErrorC(EC), .o_ErrorD(ED));

initial begin
    CW = testWord;
    #5ns;
    $display("  |CW          |SY   |DW     |EC|ED");
    $display(" 0|%12b|%5b|%7b|%1b |%1b",CW,SY,DW,EC,ED);
    for (int i=0; i<12; ++i) begin
        CW = (testWord ^ (1 << i));
        #5ns;
        $display("%2d|%12b|%5b|%7b|%1b |%1b",i+1,CW,SY,DW,EC,ED);
        CW = testWord;
        #5ns;
    end
    $finish();
end

endmodule

