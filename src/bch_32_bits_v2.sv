`include "../src/bch_comb_top.sv"
// 5 blocos de 15 bits cada
// Cada bloco: 7 bits dados + 8 bits paridade

module bch_32_bits_v2 (
    input  logic [71:0] data_in, // 40 + 32
    output logic [31:0] codeword_out,
    output logic        error_detected
);

    logic e_1, e_2, e_3, e_4, e_5;
    logic [14:0] out_1, out_2, out_3, out_4, out_5;

    bch_comb_top u_bch1 ( // 7 bits dados 
        .codeword(data_in[14:0]),
        .corrected_codeword(out_1),
        .error_flag(e_1)
    );

    bch_comb_top u_bch2 (  // 7 bits dados
        .codeword(data_in[29:15]),
        .corrected_codeword(out_2),
        .error_flag(e_2)
    );

    bch_comb_top u_bch3 ( // 7 bits dados
        .codeword(data_in[44:30]),
        .corrected_codeword(out_3),
        .error_flag(e_3)
    );

    bch_comb_top u_bch4 ( // 7 bits dados
        .codeword(data_in[59:45]),
        .corrected_codeword(out_4),
        .error_flag(e_4)
    );

    bch_comb_top u_bch5 ( // 4 bits dados
        .codeword(data_in[71:60]),
        .corrected_codeword(out_5),
        .error_flag(e_5)
    );

    assign error_detected = e_1 | e_2 | e_3 | e_4 | e_5;
    assign codeword_out = {out_5[11:8], out_4[14:8], out_3[14:8], out_2[14:8], out_1[14:8]}; // 4+7+7+7+7 = 32 bits

endmodule