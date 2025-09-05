// module syndrome_block_se_tb;

// logic [14:0] CW;
// logic [7:0] SY;

// syndrome_block_se DUV (.i_CodeWord(CW),.o_Syndrome(SY));

// initial begin
//     CW = 15'b101100100011110;
//     #5ns;
//     $display("REF | CW              |  SY ");
//     $display("000 | %15b | %8b",CW,SY);
//     for (int i=0; i<15; ++i) begin
//         CW = (15'b101100100011110 ^ (1 << i));
//         #5ns;
//         $display("%2d  | %15b | %8b",i+1,CW,SY);
//     end
//     $display("    |    BIT FLIP 0   |");
//     for (int i=0; i<15; ++i) begin
//         CW = (15'b101100100011111 ^ (1 << i));
//         #5ns;
//         $display("%2d  | %15b | %8b",i+1,CW,SY);
//     end
//     $display("    |    BIT FLIP 1   |");
//     for (int i=0; i<15; ++i) begin
//         CW = (15'b101100100011100 ^ (1 << i));
//         #5ns;
//         $display("%2d  | %15b | %8b",i+1,CW,SY);
//     end
//     $display("    |    BIT FLIP 2   |");
//     for (int i=0; i<15; ++i) begin
//         CW = (15'b101100100011010 ^ (1 << i));
//         #5ns;
//         $display("%2d  | %15b | %8b",i+1,CW,SY);
//     end
//     $finish();
// end

// endmodule


module syndrome_block_se_tb;

parameter INPUT_FILE   = "../src/input/o_data_bch_15_7.hex";
parameter COMPARE_FILE   = "../src/input/i_data_7.hex";

logic [14:0] CW;
logic [7:0]  SY;
logic [6:0]  DW;
logic    EC, ED;

logic [14:0] r_x [0:127]; // Polinomio Recebido
logic [6:0]  d_x [0:127]; // Polinomio de Dados

int corrigido, detectado, s_erros, n_detectado;

syndrome_block_se DUV (.i_CodeWord(CW),.o_Syndrome(SY),.o_DecodWord(DW), .o_ErrorC(EC), .o_ErrorD(ED));

initial begin

    $readmemh(INPUT_FILE,   r_x);
    $readmemh(COMPARE_FILE, d_x);

    CW = 15'b0;
    corrigido   = 0;
    detectado   = 0;
    s_erros     = 0;
    n_detectado = 0;

    #5ns;

    for (int i=0; i<15; ++i) begin
        CW = (r_x[1] ^ (1 << i)); // 0000001 11010001
        #5ns;
        $display("%15b|%7b|%7b|%8b|%1b|%1b",CW, DW, d_x[1],SY,ED,EC);
        CW = 15'b000000000000000;
    end
    
    for (int j = 0; j < 128; ++j) begin
        CW = r_x[j];
        #5ns

        if ((DW == d_x[j]) && (EC == 1'b1)) ++corrigido;
        if ((DW == d_x[j]) && (EC == 1'b0)) ++s_erros;
        if ((DW != d_x[j]) && (ED == 1'b1)) ++detectado;
        if ((DW != d_x[j]) && (ED == 1'b0)) ++n_detectado;
        
        for (int i = 0; i < 15; ++i) begin
            CW = (r_x[j] ^ (1 << i));
            #5ns;

            if ((DW == d_x[j]) && (EC == 1'b1)) ++corrigido;
            if ((DW == d_x[j]) && (EC == 1'b0)) ++s_erros;
            if ((DW != d_x[j]) && (ED == 1'b1)) ++detectado;
            if ((DW != d_x[j]) && (ED == 1'b0)) ++n_detectado;
        end
    end


    $display("Testes Concluídos");
    $display("%3d Erros Corrigidos",    corrigido);
    $display("%3d Erros Detectados",    detectado);
    $display("%3d Erros não detectados",n_detectado);
    $display("%3d Testes sem erros",    s_erros);

    $finish();
end

endmodule