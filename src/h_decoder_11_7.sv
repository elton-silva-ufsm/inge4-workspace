// module h_decoder_11_7 (
//   input  logic [11:0] i_CodeWord,
//   output logic [6:0]  o_DecodWord,
//   output logic [4:0]  o_ErrorAdress,
//   output logic        o_ErrorFlag
// );

//   logic [4:0] parity_chk, o_Syndrome;

//   assign parity_chk[1] = ^{i_CodeWord[3], i_CodeWord[5], i_CodeWord[7], i_CodeWord[9], i_CodeWord[11]};       
//   assign parity_chk[2] = ^{i_CodeWord[3], i_CodeWord[7:6], i_CodeWord[11]};
//   assign parity_chk[3] = ^{i_CodeWord[7:5]};
//   assign parity_chk[4] = ^{i_CodeWord[11:9]};
//   assign parity_chk[0] = ^{i_CodeWord[11:1]};

//   assign o_Syndrome = parity_chk[4:1] ^ {i_CodeWord[16], i_CodeWord[8], i_CodeWord[4], i_CodeWord[2], i_CodeWord[1]};

//   assign o_ErrorFlag = |(o_Syndrome);
//   assign o_ErrorAdress = (parity_chk[0] == i_CodeWord[0] && o_ErrorFlag) ? 5'b00000 : o_Syndrome;

//   assign o_DecodWord = i_CodeWord ^ (1 << o_ErrorAdress);
  
// endmodule


module h_decoder_11_7 (
    input  logic [11:0] i_CodeWord,
    output logic [6:0]  o_DecodWord,
    output logic [3:0]  o_Syndrome,
    output logic        o_ErrorFlag
);

    logic p1_chk, p2_chk, p4_chk, p8_chk, po_chk;
    logic [11:0] correctedWord, temp_input;

    always_comb begin

    p1_chk = ^{i_CodeWord[3], i_CodeWord[5], i_CodeWord[7], i_CodeWord[9], i_CodeWord[11]};
    p2_chk = ^{i_CodeWord[3], i_CodeWord[6], i_CodeWord[7], i_CodeWord[10], i_CodeWord[11]};
    p4_chk = ^{i_CodeWord[5], i_CodeWord[6], i_CodeWord[7]};
    p8_chk = ^{i_CodeWord[8], i_CodeWord[9], i_CodeWord[10], i_CodeWord[11]};
    po_chk = ^{i_CodeWord[11:0]};

    o_Syndrome = {p8_chk, p4_chk, p2_chk, p1_chk};
    o_ErrorFlag = |o_Syndrome || (po_chk != i_CodeWord[0]);
 
    case(o_Syndrome)
        4'd1 : correctedWord = i_CodeWord ^ (1 <<  0);
        4'd2 : correctedWord = i_CodeWord ^ (1 <<  1);
        4'd3 : correctedWord = i_CodeWord ^ (1 <<  2);
        4'd4 : correctedWord = i_CodeWord ^ (1 <<  3);
        4'd5 : correctedWord = i_CodeWord ^ (1 <<  4);
        4'd6 : correctedWord = i_CodeWord ^ (1 <<  5);
        4'd7 : correctedWord = i_CodeWord ^ (1 <<  6);
        4'd8 : correctedWord = i_CodeWord ^ (1 <<  7);
        4'd9 : correctedWord = i_CodeWord ^ (1 <<  8);
        4'd10: correctedWord = i_CodeWord ^ (1 <<  9);
        4'd11: correctedWord = i_CodeWord ^ (1 << 10);
        default: correctedWord = i_CodeWord;
    endcase

    end

    assign o_DecodWord = { correctedWord[11], correctedWord[10], correctedWord[9],
                           correctedWord[7], correctedWord[6],  correctedWord[5], 
                           correctedWord[3]};

endmodule
