
module h_decoder_64_57 (
    input  logic [63:0] i_CodeWord,
    output logic [57:0]  o_DecodWord,
    output logic        o_ErrorC,
    output logic        o_ErrorD
);

    logic [6:0]  paridade, paridade_in, paridade_err;
    logic [63:0] corrigido;

    assign paridade_in = {i_CodeWord[32], i_CodeWord[16], i_CodeWord[8], i_CodeWord[4], i_CodeWord[2], i_CodeWord[1], i_CodeWord[0]};

    always_comb begin
        // P0
        paridade[0] = ^{i_CodeWord[63:1]};
        // P1        3		 5		 7
        // 9		11		13		15
        // 17		19		21		23
        // 25		27		29		31
        // 33		35		37		39
        // 41		43		45		47
        // 49		51		53		55
        // 57		59		61		63
        paridade[1] =   i_CodeWord[3]  ^ i_CodeWord[5]  ^ i_CodeWord[7]  ^ i_CodeWord[9]  ^ i_CodeWord[11] ^ i_CodeWord[13] ^ 
                        i_CodeWord[15] ^ i_CodeWord[17] ^ i_CodeWord[19] ^ i_CodeWord[21] ^ i_CodeWord[23] ^ i_CodeWord[25] ^
                        i_CodeWord[27] ^ i_CodeWord[29] ^ i_CodeWord[31] ^ i_CodeWord[33] ^ i_CodeWord[35] ^ i_CodeWord[37] ^
                        i_CodeWord[39] ^ i_CodeWord[41] ^ i_CodeWord[43] ^ i_CodeWord[45] ^ i_CodeWord[47] ^ i_CodeWord[49] ^
                        i_CodeWord[51] ^ i_CodeWord[53] ^ i_CodeWord[55] ^ i_CodeWord[57] ^ i_CodeWord[59] ^ i_CodeWord[61] ^
                        i_CodeWord[63];
        // P2	 3			 6	 7
        // 10	11			14	15
        // 18	19			22	23
        // 26	27			30	31
        // 34	35			38	39
        // 42	43			46	47
        // 50	51			54	55
        // 58	59			62	63
        paridade[2] =   i_CodeWord[3]  ^ i_CodeWord[6]  ^ i_CodeWord[7]  ^ i_CodeWord[10] ^ i_CodeWord[11] ^ i_CodeWord[14] ^ 
                        i_CodeWord[15] ^ i_CodeWord[18] ^ i_CodeWord[19] ^ i_CodeWord[22] ^ i_CodeWord[23] ^ i_CodeWord[26] ^ 
                        i_CodeWord[27] ^ i_CodeWord[30] ^ i_CodeWord[31] ^ i_CodeWord[34] ^ i_CodeWord[35] ^ i_CodeWord[38] ^ 
                        i_CodeWord[39] ^ i_CodeWord[42] ^ i_CodeWord[43] ^ i_CodeWord[46] ^ i_CodeWord[47] ^ i_CodeWord[50] ^ 
                        i_CodeWord[51] ^ i_CodeWord[54] ^ i_CodeWord[55] ^ i_CodeWord[58] ^ i_CodeWord[59] ^ i_CodeWord[62] ^
                        i_CodeWord[63];
        // P4	5	6	7
        // 12	13	14	15
        // 20	21	22	23
        // 28	29	30	31
        // 36	37	38	39
        // 44	45	46	47
        // 52	53	54	55
        // 60	61	62	63
        paridade[3] = i_CodeWord[5] ^ i_CodeWord[6] ^ i_CodeWord[7] ^ i_CodeWord[12] ^ i_CodeWord[13] ^ i_CodeWord[14] ^ 
                      i_CodeWord[15] ^ i_CodeWord[20] ^ i_CodeWord[21] ^ i_CodeWord[22] ^ i_CodeWord[23] ^ i_CodeWord[28] ^
                      i_CodeWord[29] ^ i_CodeWord[30] ^ i_CodeWord[31] ^ i_CodeWord[36] ^ i_CodeWord[37] ^ i_CodeWord[38] ^
                      i_CodeWord[39] ^ i_CodeWord[44] ^ i_CodeWord[45] ^ i_CodeWord[46] ^ i_CodeWord[47] ^ i_CodeWord[52] ^
                      i_CodeWord[53] ^ i_CodeWord[54] ^ i_CodeWord[55] ^ i_CodeWord[60] ^ i_CodeWord[61] ^ i_CodeWord[62] ^
                      i_CodeWord[63];
        // P8	9	10	11	12	13	14	15
        // 24	25	26	27	28	29	30	31
        // 40	41	42	43	44	45	46	47
        // 56	57	58	59	60	61	62	63
        paridade[4] = i_CodeWord[9]  ^ i_CodeWord[10] ^ i_CodeWord[11] ^ i_CodeWord[12] ^ i_CodeWord[13] ^ i_CodeWord[14] ^ 
                      i_CodeWord[15] ^ i_CodeWord[24] ^ i_CodeWord[25] ^ i_CodeWord[26] ^ i_CodeWord[27] ^ i_CodeWord[28] ^
                      i_CodeWord[29] ^ i_CodeWord[30] ^ i_CodeWord[31] ^ i_CodeWord[40] ^ i_CodeWord[41] ^ i_CodeWord[42] ^
                      i_CodeWord[43] ^ i_CodeWord[44] ^ i_CodeWord[45] ^ i_CodeWord[46] ^ i_CodeWord[47] ^ i_CodeWord[56] ^
                      i_CodeWord[57] ^ i_CodeWord[58] ^ i_CodeWord[59] ^ i_CodeWord[60] ^ i_CodeWord[61] ^ i_CodeWord[62] ^
                      i_CodeWord[63];
        // P16	17	18	19	20	21	22	23
        // 24	25	26	27	28	29	30	31
        // 48	49	50	51	52	53	54	55
        // 56	57	58	59	60	61	62	63
        paridade[5] = i_CodeWord[17] ^ i_CodeWord[18] ^ i_CodeWord[19] ^ i_CodeWord[20] ^ i_CodeWord[21] ^ i_CodeWord[22] ^ 
                      i_CodeWord[23] ^ i_CodeWord[24] ^ i_CodeWord[25] ^ i_CodeWord[26] ^ i_CodeWord[27] ^ i_CodeWord[28] ^
                      i_CodeWord[29] ^ i_CodeWord[30] ^ i_CodeWord[31] ^ i_CodeWord[48] ^ i_CodeWord[49] ^ i_CodeWord[50] ^
                      i_CodeWord[51] ^ i_CodeWord[52] ^ i_CodeWord[53] ^ i_CodeWord[54] ^ i_CodeWord[55] ^ i_CodeWord[56] ^
                      i_CodeWord[57] ^ i_CodeWord[58] ^ i_CodeWord[59] ^ i_CodeWord[60] ^ i_CodeWord[61] ^ i_CodeWord[62] ^
                      i_CodeWord[63];
        // P32	33	34	35	36	37	38	39
        // 40	41	42	43	44	45	46	47
        // 48	49	50	51	52	53	54	55
        // 56	57	58	59	60	61	62	63
        paridade[6] = i_CodeWord[33] ^ i_CodeWord[34] ^ i_CodeWord[35] ^ i_CodeWord[36] ^ i_CodeWord[37] ^ i_CodeWord[38] ^ 
                      i_CodeWord[39] ^ i_CodeWord[40] ^ i_CodeWord[41] ^ i_CodeWord[42] ^ i_CodeWord[43] ^ i_CodeWord[44] ^
                      i_CodeWord[45] ^ i_CodeWord[46] ^ i_CodeWord[47] ^ i_CodeWord[48] ^ i_CodeWord[49] ^ i_CodeWord[50] ^
                      i_CodeWord[51] ^ i_CodeWord[52] ^ i_CodeWord[53] ^ i_CodeWord[54] ^ i_CodeWord[55] ^ i_CodeWord[56] ^
                      i_CodeWord[57] ^ i_CodeWord[58] ^ i_CodeWord[59] ^ i_CodeWord[60] ^ i_CodeWord[61] ^ i_CodeWord[62] ^
                      i_CodeWord[63];

        // Compare the calculated parity with the received parity
        paridade_err = paridade_in ^ paridade;
    end

    always_comb begin
        if (paridade_err == 7'b00000) begin
            o_ErrorC = 1'b0;   // nada a corrigir
            o_ErrorD = 1'b0;   // nada detectado
            corrigido = i_CodeWord;
        end else if ((paridade_err[6:1] < 64) && (paridade_err[0] == 1)) begin
            o_ErrorC = 1'b1;   // corrigiu
            o_ErrorD = 1'b0;   // não é apenas detectado
            corrigido = i_CodeWord ^ (1 << (paridade_err[6:1]));
        end else  begin
            o_ErrorC = 1'b0;   // não corrigiu
            o_ErrorD = 1'b1;   // mas detectou
            corrigido = i_CodeWord;
        end 

    end

    always_comb begin
        o_DecodWord = {corrigido[63:33], corrigido[31:17], corrigido[15:9], corrigido[7:5], corrigido[3]};
    end

endmodule
