module test_decoder_bch;

    parameter INPUT_FILE   = "../src/input/o_data_bch_15_7.hex";
    parameter COMPARE_FILE = "../src/input/i_data_7.hex";
    parameter logic [8:0] GeneratorPolinomial = 9'b111010001;

    logic [14:0] r_x [0:127]; // Polinômio Recebido
    // logic [6:0]  d_x [0:127]; // Polinômio de Dados

    logic [14:0] CW, CW2;
    logic [7:0]  SY, SY2;

    initial begin
        $readmemh(INPUT_FILE, r_x);
        // $readmemh(COMPARE_FILE, d_x);

        for (int i = 0; i < 15; ++i) begin
            CW = (r_x[5] ^ (1 << i));  // injeta erro em cada bit
            CW2 = (r_x[45] ^ (1 << i));  // injeta erro em cada bit
            SY = calc_syndrome(CW);    // chama função
            SY2 = calc_syndrome(CW2);    // chama função
            #5ns;
            $display("%4h|%8b|%8b|%4h", CW, SY, SY2, CW2);
        end

        $finish();
    end

    function automatic logic [7:0] calc_syndrome(input logic [14:0] i_CodeWord);
        logic [14:0] Op6, Op5, Op4, Op3, Op2, Op1;
        logic [7:0]  Synd;

        Op6   = (i_CodeWord[14]) ? (i_CodeWord ^ (GeneratorPolinomial << 6)) : i_CodeWord;
        Op5   = (Op6[13])        ? (Op6 ^ (GeneratorPolinomial << 5))        : Op6;
        Op4   = (Op5[12])        ? (Op5 ^ (GeneratorPolinomial << 4))        : Op5;
        Op3   = (Op4[11])        ? (Op4 ^ (GeneratorPolinomial << 3))        : Op4;
        Op2   = (Op3[10])        ? (Op3 ^ (GeneratorPolinomial << 2))        : Op3;
        Op1   = (Op2[9])         ? (Op2 ^ (GeneratorPolinomial << 1))        : Op2;
        Synd  = (Op1[8])         ? (Op1 ^ GeneratorPolinomial)               : Op1;

        return Synd;
    endfunction

endmodule
