
module h_decoder_16_11 (
    input  logic [15:0] i_CodeWord,
    output logic [10:0]  o_DecodWord,
    output logic        o_ErrorC,
    output logic        o_ErrorD
);

    logic [4:0]  paridade, paridade_in, paridade_err;
    logic [15:0] corrigido;

    assign paridade_in = {i_CodeWord[8], i_CodeWord[4], i_CodeWord[2], i_CodeWord[1], i_CodeWord[0]};

    always_comb begin
        // P0
        paridade[0] = ^{i_CodeWord[15:1]};
        // P1
        paridade[1] =   i_CodeWord[3]  ^ i_CodeWord[5]  ^ i_CodeWord[7]  ^ i_CodeWord[9]  ^ i_CodeWord[11] ^ i_CodeWord[13] ^ 
                        i_CodeWord[15];
        // P2
        paridade[2] =   i_CodeWord[3]  ^ i_CodeWord[6]  ^ i_CodeWord[7]  ^ i_CodeWord[10] ^ i_CodeWord[11] ^ i_CodeWord[14] ^ 
                        i_CodeWord[15] ;
        // P4
        paridade[3] = ^{i_CodeWord[15:12], i_CodeWord[7:5]};
        // P8
        paridade[4] = ^{i_CodeWord[15:9]};

        // Compare the calculated parity with the received parity
        paridade_err = paridade_in ^ paridade;
    end

    always_comb begin
        if (paridade_err == 5'b00000) begin
            o_ErrorC = 1'b0;   // nada a corrigir
            o_ErrorD = 1'b0;   // nada detectado
            corrigido = i_CodeWord;
        end else if ((paridade_err[4:1] < 39) && (paridade_err[0] == 1)) begin
            o_ErrorC = 1'b1;   // corrigiu
            o_ErrorD = 1'b0;   // não é apenas detectado
            corrigido = i_CodeWord ^ (1 << (paridade_err[4:1]));
        end else  begin
            o_ErrorC = 1'b0;   // não corrigiu
            o_ErrorD = 1'b1;   // mas detectou
            corrigido = i_CodeWord;
        end 

    end

    always_comb begin
        o_DecodWord = {corrigido[15:9], corrigido[7:5], corrigido[3]};
    end

endmodule