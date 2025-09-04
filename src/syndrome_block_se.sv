module syndrome_block_se (
    input logic [14:0] i_CodeWord,
    output logic [7:0] o_Syndrome,
    output logic [6:0] o_DecodWord,
    output logic o_ErrorFlag
);

parameter logic [8:0] GeneratorPolinomial = 9'b111010001;

logic [14:0] Op6, Op5, Op4, Op3, Op2, Op1;
logic [7:0] Syndrome;

always_comb begin
    Op6        = (i_CodeWord[14]) ? (i_CodeWord ^ (GeneratorPolinomial << 6)) : i_CodeWord;
    Op5        = (Op6[13])        ? (Op6 ^ (GeneratorPolinomial << 5))        : Op6;
    Op4        = (Op5[12])        ? (Op5 ^ (GeneratorPolinomial << 4))        : Op5;
    Op3        = (Op4[11])        ? (Op4 ^ (GeneratorPolinomial << 3))        : Op4;
    Op2        = (Op3[10])        ? (Op3 ^ (GeneratorPolinomial << 2))        : Op3;
    Op1        = (Op2[9])         ? (Op2 ^ (GeneratorPolinomial << 1))        : Op2;
    Syndrome   = (Op1[8])         ? (Op1 ^ GeneratorPolinomial)               : Op1;
end

assign o_Syndrome  = Syndrome;

always_comb begin
    case (Syndrome)
        default     : begin o_DecodWord = i_CodeWord[14:8];                     o_ErrorFlag = 1'b1; end
        8'b00000000 : begin o_DecodWord = i_CodeWord[14:8];                     o_ErrorFlag = 1'b0; end     
        8'b10000000 : begin o_DecodWord = (i_CodeWord[14:8] ^ 7'b00000001);     o_ErrorFlag = 1'b0; end     
        8'b11010001 : begin o_DecodWord = (i_CodeWord[14:8] ^ 7'b00000010);     o_ErrorFlag = 1'b0; end     
        8'b01110011 : begin o_DecodWord = (i_CodeWord[14:8] ^ 7'b00000100);     o_ErrorFlag = 1'b0; end     
        8'b11100110 : begin o_DecodWord = (i_CodeWord[14:8] ^ 7'b00001000);     o_ErrorFlag = 1'b0; end     
        8'b00011101 : begin o_DecodWord = (i_CodeWord[14:8] ^ 7'b00010000);     o_ErrorFlag = 1'b0; end     
        8'b00111010 : begin o_DecodWord = (i_CodeWord[14:8] ^ 7'b00100000);     o_ErrorFlag = 1'b0; end     
        8'b01110100 : begin o_DecodWord = (i_CodeWord[14:8] ^ 7'b01000000);     o_ErrorFlag = 1'b0; end     
        8'b11101000 : begin o_DecodWord = (i_CodeWord[14:8] ^ 7'b10000000);     o_ErrorFlag = 1'b0; end
    endcase
end

endmodule